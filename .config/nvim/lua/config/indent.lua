local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

augroup('indent', {clear = true})

local function indent(filetype, width, expand_tab_to_spaces)
  autocmd('FileType', {
    pattern = filetype,
    callback = function()
      vim.opt_local.ts = width
      vim.opt_local.sw = width
      vim.opt_local.sts = width
      vim.opt_local.expandtab = expand_tab_to_spaces
    end
  })

end

-- Default
vim.opt.ts = 2
vim.opt.sw = 2
vim.opt.sts = 2
vim.opt.expandtab = true

indent('go', 4, false)
