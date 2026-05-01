vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.mouse = 'a'

vim.opt.guicursor = ''

vim.opt.hidden = true

vim.opt.ruler = true

vim.opt.termguicolors = true

vim.opt.completeopt:remove('preview')

vim.opt.backspace = 'indent,eol,start'

-- higlight trailing whitespace + tabs
vim.opt.list = true
vim.opt.listchars = 'trail:•,tab:--❭'

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Search - highlight, ignore case (unless search term contains capitals)
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Persistent undo
vim.opt.undofile = true

-- Live substitution
vim.opt.inccommand = 'split'

-- Spell checking
vim.opt.spell = true
vim.opt.spelllang = { "en_ca", "en_us" }
vim.opt.spelloptions = "camel"
vim.opt.spellfile = vim.fn.expand("~/.config/nvim/spell/custom.utf-8.add")
vim.api.nvim_set_hl(0, "SpellBad",  { undercurl = true, sp = "#d48787" }) -- red
-- disabled (word is correct, just not in en_ca/en_us dictionaries)
vim.api.nvim_set_hl(0, "SpellLocal",{})
-- disabled (capitalization)
vim.api.nvim_set_hl(0, "SpellCap",  {})
-- disabled (rare/archaic/etc. words)
vim.api.nvim_set_hl(0, "SpellRare", {})

-- disable providers - not needed and (python3 at least) causes slow boot times
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- ui2
require('vim._core.ui2').enable()

-- Helpers
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Toggle line numbers based on focus
augroup('numberToggle', {clear = true})
autocmd({'BufEnter', 'FocusGained', 'InsertLeave'}, {
  group = 'numberToggle',
  callback = function()
    if vim.opt.number:get() then
      vim.opt.relativenumber = true
    end
  end
})
autocmd({'BufLeave', 'FocusLost', 'InsertEnter'}, {
  group = 'numberToggle',
  callback = function()
    if vim.opt.number:get() then
      vim.opt.relativenumber = false
    end
  end
})

-- Enter to clear search highlight
vim.keymap.set("n", "<CR>", ":nohlsearch<CR>", { silent = true })

-- Tabline
vim.o.tabline = "%!v:lua.MyTabline()"
local function iter_buffers()
  local t = {}
  for bufnr = 1, vim.fn.bufnr("$") do
    if vim.fn.bufexists(bufnr) == 1 and vim.bo[bufnr].buftype == "" and vim.bo[bufnr].buflisted then
      t[#t + 1] = bufnr
    end
  end
  return ipairs(t)
end
function _G.MyTabline()
  local s = ""
  for idx, bufnr in iter_buffers() do
    local hl = (bufnr == vim.fn.bufnr("%")) and "%#TabLineSel#" or "%#TabLine#"
    local name = vim.fn.fnamemodify(vim.fn.bufname(bufnr), ":t")
    if name == "" then name = "[No Name]" end
    local mod = vim.bo[bufnr].modified and "●" or " "
    s = s .. hl .. "%" .. bufnr .. "@v:lua.MyTablineSwitch@ " .. " " .. idx .. " " .. name .. " " .. mod .. " "
  end
  return s .. "%#TabLineFill#"
end
function _G.MyTablineSwitch(bufnr, _, _, _)
  vim.cmd("buffer " .. bufnr)
end
autocmd({"BufAdd", "BufDelete", "BufWinEnter", "BufFilePost"}, {
  group = augroup('MyTabline', {clear = true}),
  callback = function()
    local count = 0
    for _ in iter_buffers() do
      count = count + 1
      if count > 1 then break end
    end
    vim.o.showtabline = count > 1 and 2 or 0
  end
})

-- Jump to tab (leader + number)
for i = 1, 9 do
  vim.keymap.set("n", "<leader>" .. i, function()
    for idx, bufnr in iter_buffers() do
      if idx == i then
        vim.cmd("buffer " .. bufnr)
        return
      end
    end
  end)
end

-- Previous tab (Ctrl-H or Ctrl-J)
vim.keymap.set("n", "<C-H>", ":bp<CR>", { silent = true })
vim.keymap.set("n", "<C-J>", ":bp<CR>", { silent = true })
vim.keymap.set("v", "<C-H>", "<C-C>:bp<CR>", { silent = true })
vim.keymap.set("v", "<C-J>", "<C-C>:bp<CR>", { silent = true })
vim.keymap.set("i", "<C-H>", "<C-C>:bp<CR>", { silent = true })
vim.keymap.set("i", "<C-J>", "<C-C>:bp<CR>", { silent = true })

-- Next tab (Ctrl-K or Ctrl-L)
vim.keymap.set("n", "<C-K>", ":bn<CR>", { silent = true })
vim.keymap.set("n", "<C-L>", ":bn<CR>", { silent = true })
vim.keymap.set("v", "<C-K>", "<C-C>:bn<CR>", { silent = true })
vim.keymap.set("v", "<C-L>", "<C-C>:bn<CR>", { silent = true })
vim.keymap.set("i", "<C-K>", "<C-C>:bn<CR>", { silent = true })
vim.keymap.set("i", "<C-L>", "<C-C>:bn<CR>", { silent = true })

-- Close buffer (Ctrl-Q, { silent = true })
vim.keymap.set("n", "<C-Q>", ":bd<CR>", { silent = true })
