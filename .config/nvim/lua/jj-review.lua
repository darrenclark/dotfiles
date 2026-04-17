-- jj-review.lua
-- Single-pane diff navigator with live-following editable buffer, inline
-- review notes, and a telescope-based revset picker.
--
-- Usage:
--   :lua require('jj-review').start()                    -- diff of @
--   :lua require('jj-review').start('-r abc')            -- a single revision
--   :lua require('jj-review').start('-r abc..def')       -- a range
--   :lua require('jj-review').start('--from abc --to def')
--
-- In the left (diff) pane:
--   <CR>         jump right pane to the hunk under cursor
--   q            close the review
--   <leader>rn   new or edit note on current line
--   <leader>rd   delete note on current line
--   <leader>ry   copy all notes as markdown to * register
--
-- The revset picker (M.pick) is exposed as a module function — bind it
-- globally in your own config, e.g. `<leader>rs` -> require('jj-review').pick().

local M = {}

local ns = vim.api.nvim_create_namespace('JjReviewNotes')
local sign_group = 'JjReviewNotes'
local sign_name = 'JjReviewNote'
vim.fn.sign_define(sign_name, { text = '●', texthl = 'DiagnosticInfo' })

local state = {
  diff_buf = nil,
  diff_win = nil,
  file_win = nil,
  repo_root = nil,
  args = nil,
  -- notes keyed by "path\0new_line" -> { path, new_line, hunk_header, diff_line, text }
  notes = {},
}

-- Find the nearest `+++ b/path` above `lnum` and the nearest
-- `@@ -_,_ +new,_ @@` at-or-above `lnum`. Returns path, new_line, hunk_header.
local function locate(lines, lnum)
  local path, new_line, hunk_header
  for i = lnum, 1, -1 do
    local l = lines[i]
    if not new_line then
      local n = l:match('^@@ %-%d+,?%d* %+(%d+)')
      if n then
        new_line = tonumber(n)
        hunk_header = l
      end
    end
    if not path then
      local p = l:match('^%+%+%+ b/(.+)$')
      if p then path = p end
    end
    if path and new_line then break end
  end
  if not (path and new_line) then return nil end

  local hunk_start
  for i = lnum, 1, -1 do
    if lines[i]:match('^@@ ') then hunk_start = i; break end
  end
  local offset = 0
  for i = hunk_start + 1, lnum do
    local c = lines[i]:sub(1, 1)
    if c == '+' or c == ' ' then
      if i < lnum then offset = offset + 1 end
    elseif c == '-' then
      -- skip
    else
      break
    end
  end
  return path, new_line + offset, hunk_header
end

local function note_key(path, new_line)
  return path .. '\0' .. tostring(new_line)
end

local function follow()
  if not (state.diff_buf and vim.api.nvim_buf_is_valid(state.diff_buf)) then return end
  if not (state.file_win and vim.api.nvim_win_is_valid(state.file_win)) then return end

  local lnum = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_get_lines(state.diff_buf, 0, -1, false)
  local path, new_line = locate(lines, lnum)
  if not path then return end

  local full = state.repo_root .. '/' .. path
  if vim.fn.filereadable(full) == 0 then return end

  vim.api.nvim_win_call(state.file_win, function()
    local current = vim.api.nvim_buf_get_name(0)
    if current ~= full then
      vim.cmd('edit ' .. vim.fn.fnameescape(full))
      vim.cmd('filetype detect')
    end
    local total = vim.api.nvim_buf_line_count(0)
    local target = math.min(new_line, total)
    vim.api.nvim_win_set_cursor(state.file_win, { target, 0 })
    vim.cmd('normal! zz')
  end)
end

-- Re-place signs + virtual text for all current notes. Each note is pinned
-- to its recorded diff_line so it shows up exactly once.
local function render_notes()
  if not (state.diff_buf and vim.api.nvim_buf_is_valid(state.diff_buf)) then return end

  vim.fn.sign_unplace(sign_group, { buffer = state.diff_buf })
  vim.api.nvim_buf_clear_namespace(state.diff_buf, ns, 0, -1)

  for _, note in pairs(state.notes) do
    if note.diff_line then
      vim.fn.sign_place(0, sign_group, sign_name, state.diff_buf, { lnum = note.diff_line })
      vim.api.nvim_buf_set_extmark(state.diff_buf, ns, note.diff_line - 1, 0, {
        virt_text = { { '  // ' .. note.text, 'Comment' } },
        virt_text_pos = 'eol',
      })
    end
  end
end

local function refresh()
  if not (state.diff_buf and vim.api.nvim_buf_is_valid(state.diff_buf)) then return end

  local cmd = 'jj diff --git ' .. (state.args or '')
  local out = vim.fn.systemlist(cmd)
  if vim.v.shell_error ~= 0 then return end

  local cursor
  if state.diff_win and vim.api.nvim_win_is_valid(state.diff_win) then
    cursor = vim.api.nvim_win_get_cursor(state.diff_win)
  end

  vim.bo[state.diff_buf].modifiable = true
  vim.api.nvim_buf_set_lines(state.diff_buf, 0, -1, false, out)
  vim.bo[state.diff_buf].modifiable = false

  if cursor and state.diff_win and vim.api.nvim_win_is_valid(state.diff_win) then
    local total = vim.api.nvim_buf_line_count(state.diff_buf)
    cursor[1] = math.min(cursor[1], math.max(total, 1))
    pcall(vim.api.nvim_win_set_cursor, state.diff_win, cursor)
  end

  -- Re-resolve each note's diff_line against the new buffer.
  local lines = vim.api.nvim_buf_get_lines(state.diff_buf, 0, -1, false)
  local resolved = {}
  for key, note in pairs(state.notes) do
    for i = 1, #lines do
      local p, nl = locate(lines, i)
      if p and nl and note_key(p, nl) == key then
        note.diff_line = i
        resolved[key] = note
        break
      end
    end
  end
  state.notes = resolved
  render_notes()
end

local function note_add_or_edit()
  local lnum = vim.api.nvim_win_get_cursor(state.diff_win)[1]
  local lines = vim.api.nvim_buf_get_lines(state.diff_buf, 0, -1, false)
  local path, new_line, hunk_header = locate(lines, lnum)
  if not path then
    vim.notify('jj-review: no hunk at cursor', vim.log.levels.WARN)
    return
  end

  local key = note_key(path, new_line)
  local existing = state.notes[key]
  local prompt = string.format('Note (%s:%d): ', path, new_line)

  vim.ui.input({ prompt = prompt, default = existing and existing.text or '' }, function(input)
    if input == nil then return end -- cancelled
    if input == '' then
      state.notes[key] = nil
    else
      state.notes[key] = {
        path = path,
        new_line = new_line,
        hunk_header = hunk_header,
        diff_line = lnum,
        text = input,
      }
    end
    render_notes()
  end)
end

local function note_delete()
  local lnum = vim.api.nvim_win_get_cursor(state.diff_win)[1]
  local lines = vim.api.nvim_buf_get_lines(state.diff_buf, 0, -1, false)
  local path, new_line = locate(lines, lnum)
  if not path then return end
  state.notes[note_key(path, new_line)] = nil
  render_notes()
end

local function note_yank()
  local by_path = {}
  for _, note in pairs(state.notes) do
    by_path[note.path] = by_path[note.path] or {}
    table.insert(by_path[note.path], note)
  end
  if next(by_path) == nil then
    vim.notify('jj-review: no notes to yank', vim.log.levels.INFO)
    return
  end

  local paths = vim.tbl_keys(by_path)
  table.sort(paths)

  local out = { string.format('# Review notes for `jj diff %s`', state.args or ''), '' }
  for _, path in ipairs(paths) do
    table.insert(out, '## ' .. path)
    local notes = by_path[path]
    table.sort(notes, function(a, b) return a.new_line < b.new_line end)
    for _, note in ipairs(notes) do
      table.insert(out, string.format('- **L%d**: %s', note.new_line, note.text))
    end
    table.insert(out, '')
  end

  local text = table.concat(out, '\n')
  vim.fn.setreg('*', text)
  vim.fn.setreg('+', text)
  vim.notify(string.format('jj-review: copied %d notes to clipboard', vim.tbl_count(state.notes)))
end

local function close()
  pcall(vim.api.nvim_del_augroup_by_name, 'JjReview')
  if state.diff_win and vim.api.nvim_win_is_valid(state.diff_win) then
    vim.api.nvim_win_close(state.diff_win, true)
  end
  state.diff_buf, state.diff_win, state.file_win = nil, nil, nil
  state.notes = {}
end

-- Telescope picker: type a revset, preview via `jj log -r <revset>`.
--
-- Design: the finder is a job-style finder that echoes the prompt back as
-- its one and only result. This makes the "prompt" the "selected entry",
-- which means `define_preview` is called naturally on every keystroke —
-- the standard telescope data flow, not a workaround.
local function revset_picker()
  local ok, pickers = pcall(require, 'telescope.pickers')
  if not ok then
    vim.notify('jj-review: telescope.nvim not installed', vim.log.levels.ERROR)
    return
  end
  local finders = require('telescope.finders')
  local previewers = require('telescope.previewers')
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')
  local conf = require('telescope.config').values

  -- Seed suggestions shown when the prompt is empty. These render alongside
  -- the live prompt entry so users can arrow-down to pick one.
  local seeds = { '@', '@-', 'trunk()..@', '@-..@', 'mutable()' }

  local function make_entry(revset)
    return {
      value = revset,
      display = revset,
      ordinal = revset,
    }
  end

  -- A dynamic finder that re-invokes the function on every prompt change.
  -- Returning the prompt itself as an entry is what makes the preview update.
  local finder = finders.new_dynamic({
    fn = function(prompt)
      local results = {}
      if prompt and prompt ~= '' then
        table.insert(results, prompt)
      end
      for _, s in ipairs(seeds) do
        if s ~= prompt then table.insert(results, s) end
      end
      return results
    end,
    entry_maker = make_entry,
  })

  local previewer = previewers.new_buffer_previewer({
    title = 'jj log',
    define_preview = function(self, entry, _)
      local revset = entry.value
      local out = vim.fn.systemlist({
        'jj', 'log', '--no-pager', '--color=never', '-r', revset,
      })
      if vim.v.shell_error ~= 0 then
        out = { 'error evaluating revset: ' .. revset, '', unpack(out) }
      end
      vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, out)
    end,
  })

  pickers.new({}, {
    prompt_title = 'jj revset (diff)',
    finder = finder,
    sorter = conf.generic_sorter({}),
    previewer = previewer,
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        local revset = selection and selection.value or '@'
        actions.close(prompt_bufnr)
        M.start('-r ' .. revset)
      end)
      return true
    end,
  }):find()
end

M.pick = revset_picker

function M.start(args)
  args = args or ''
  state.args = args
  state.notes = {}

  local root = vim.fn.systemlist('jj root')[1]
  if vim.v.shell_error ~= 0 or not root or root == '' then
    vim.notify('jj-review: not in a jj repo', vim.log.levels.ERROR)
    return
  end
  state.repo_root = root

  local cmd = 'jj diff --git ' .. args
  local out = vim.fn.systemlist(cmd)
  if vim.v.shell_error ~= 0 then
    vim.notify('jj-review: `' .. cmd .. '` failed', vim.log.levels.ERROR)
    return
  end
  if #out == 0 then
    vim.notify('jj-review: empty diff', vim.log.levels.INFO)
    return
  end

  vim.cmd('topleft vsplit')
  vim.cmd('enew')
  state.diff_win = vim.api.nvim_get_current_win()
  state.diff_buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_lines(state.diff_buf, 0, -1, false, out)
  vim.bo[state.diff_buf].buftype = 'nofile'
  vim.bo[state.diff_buf].bufhidden = 'wipe'
  vim.bo[state.diff_buf].swapfile = false
  vim.bo[state.diff_buf].modifiable = false
  vim.bo[state.diff_buf].filetype = 'diff'
  vim.api.nvim_buf_set_name(state.diff_buf, 'jj-review://' .. (args ~= '' and args or '@'))
  vim.api.nvim_win_set_width(state.diff_win, math.floor(vim.o.columns / 2))

  local wins = vim.api.nvim_tabpage_list_wins(0)
  for _, w in ipairs(wins) do
    if w ~= state.diff_win then state.file_win = w; break end
  end
  if not state.file_win then
    vim.cmd('rightbelow vsplit')
    state.file_win = vim.api.nvim_get_current_win()
    vim.api.nvim_set_current_win(state.diff_win)
  end

  local grp = vim.api.nvim_create_augroup('JjReview', { clear = true })
  vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
    group = grp,
    buffer = state.diff_buf,
    callback = follow,
  })

  vim.api.nvim_create_autocmd('BufWritePost', {
    group = grp,
    callback = function(ev)
      local path = vim.api.nvim_buf_get_name(ev.buf)
      if path ~= '' and path:sub(1, #state.repo_root) == state.repo_root then
        vim.schedule(refresh)
      end
    end,
  })

  vim.api.nvim_create_autocmd('WinClosed', {
    group = grp,
    callback = function(ev)
      local win = tonumber(ev.match)
      if win == state.diff_win or win == state.file_win then
        vim.schedule(close)
      end
    end,
  })

  local function bopts(desc)
    return { buffer = state.diff_buf, nowait = true, silent = true, desc = desc }
  end
  vim.keymap.set('n', '<CR>', follow, bopts('jj-review: sync file pane to hunk'))
  vim.keymap.set('n', 'q', close, bopts('jj-review: close review'))
  vim.keymap.set('n', '<leader>rn', note_add_or_edit, bopts('jj-review: new/edit note'))
  vim.keymap.set('n', '<leader>rd', note_delete, bopts('jj-review: delete note'))
  vim.keymap.set('n', '<leader>ry', note_yank, bopts('jj-review: yank notes to clipboard'))

  follow()
end

return M