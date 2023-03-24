vim.opt.mouse = 'a'

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
