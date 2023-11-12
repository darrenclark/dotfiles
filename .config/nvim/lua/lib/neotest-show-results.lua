local nio = require("nio")
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local previewers = require "telescope.previewers"
local make_entry = require "telescope.make_entry"
local conf = require('telescope.config').values

local consumer = {}

local client

-- Copied from https://github.com/nvim-telescope/telescope.nvim/blob/20bf20500c95208c3ac0ef07245065bf94dcab15/lua/telescope/previewers/buffer_previewer.lua
local function defaulter(f, default_opts)
  default_opts = default_opts or {}
  return {
    new = function(opts)
      if conf.preview == false and not opts.preview then
        return false
      end
      opts.preview = type(opts.preview) ~= "table" and {} or opts.preview
      if type(conf.preview) == "table" then
        for k, v in pairs(conf.preview) do
          opts.preview[k] = vim.F.if_nil(opts.preview[k], v)
        end
      end
      return f(opts)
    end,
    __call = function()
      local ok, err = pcall(f(default_opts))
      if not ok then
        error(debug.traceback(err))
      end
    end,
  }
end

local previewer = defaulter(function(_)
  return previewers.new_buffer_previewer {
    title = "Output",
    define_preview = function(self, entry)
      vim.api.nvim_buf_call(self.state.bufnr, function()
        if entry.value.short then
          local lines = vim.split(entry.value.short, "\n")
          pcall(vim.api.nvim_buf_set_lines, self.state.bufnr, 0, -1, false, lines)
        end
        --entry.preview_command(entry, self.state.bufnr)
      end)
    end,
  }
end, {})

local function get_open_files()
  local open_files = {}
  local vim_fn = vim.fn

  for buffer = 1, vim_fn.bufnr('$') do
    if vim.api.nvim_buf_is_loaded(buffer) and vim.bo[buffer].buftype == '' then
      local path = vim.fn.expand("#" .. buffer .. ":p")
      table.insert(open_files, path)
    end
  end

  return open_files
end


local show_list = function(results)
  local results_with_files = vim.deepcopy(results)

  -- augment results with positions (file, line, etc.) based on treesitter
  for _, f in ipairs(get_open_files()) do
    local positions = client:get_position(f)
    if positions then
      for _, node in positions:iter_nodes() do
        local pos = node:data()
        if pos.type == "test" and results[pos.id] then
          results_with_files[pos.id].pos = pos
        end
      end
    end
  end

  local output_files = {}

  local failed = {}
  for test_name, res in pairs(results_with_files) do
    if res.status == "failed" and res.output ~= nil then
      output_files[res.output] = res.output
    end

    if res.status == "failed" and res.short ~= nil then
      table.insert(failed, {kind='test', test_name=test_name, result=res})
    end
  end

  for _,v in pairs(output_files) do
    table.insert(failed, {kind='output', output=v})
  end

  -- start in normal mode so that it doesn't filter down to 'A' immediately
  -- TODO: Figure out the root cause of the 'A' prefilling the input
  local opts = {initial_mode="normal"}

  _G.previewer = previewer

  pickers
    .new(opts, {
      prompt_title = "Test results",
      finder = finders.new_table {
        results = failed,
        entry_maker = function(result)
          if result.kind == 'test' then
            return make_entry.set_default_entry_mt({
              value = result,
              ordinal = result.test_name,
              display = result.test_name,
              filename = result.result.output
            }, opts)
          elseif result.kind == 'output' then
            return make_entry.set_default_entry_mt({
              value = result,
              ordinal = 'Full test output',
              display = 'Full test output',
              filename = result.output
            })
          end
        end
      },
      previewer = previewer,
      sorter = conf.generic_sorter(opts),
    })
    :find()

  _G.failed = failed
  _G.conf = conf
end

local init = function()
  client.listeners.results = function(_, results)
    local pass, fail = 0, 0
    for _, res in pairs(results) do
      if res.status == "failed" then
        fail = fail + 1
      elseif res.status == "passed" then
        pass = pass + 1
      end
    end

    if pass > 0 and fail == 0 then
      vim.cmd("echohl DiagnosticOk | echo \"✓ Tests passed\" | echohl None")
    elseif pass == 0 and fail >= 0 then
      -- Copied from https://github.com/nvim-neotest/neotest/blob/master/lua/neotest/consumers/output.lua

      local cur_pos = nio.fn.getpos(".")
      local line = cur_pos[2] - 1
      local buf_path = vim.fn.expand("%:p")
      local positions = client:get_position(buf_path)
      if not positions then
        -- show list
        --show_list(results)
        return
      end

      _G.res = {}

      -- open default output if cursor is in a test case
      for _, node in positions:iter_nodes() do
        local pos = node:data()
        local range = node:closest_value_for("range")

        if pos.type == "test" and results[pos.id] and results[pos.id].status == "failed" then
          _G.res[pos.id] = {pos = pos, range = range}
        end

        if
          pos.type == "test"
          and results[pos.id]
          and results[pos.id].status == "failed"
          and range[1] <= line
          and range[3] >= line
        then
          require('neotest').output.open({short = true, enter = false})
          return
        end
      end

      -- else show list in telescope
      --show_list(results)
    elseif pass == 0 and fail == 0 then
      vim.cmd("echohl ErrorMsg | echo \"No tests run\" | echohl None")
    end
  end
end

consumer = setmetatable(consumer, {
  __call = function(_, client_)
    client = client_
    init()
    return consumer
  end,
})

return consumer
