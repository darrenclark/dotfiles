local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Line number toggle

augroup('numberToggle', {clear = true})

autocmd({'BufEnter', 'FocusGained', 'InsertLeave'}, {
  group = 'numberToggle',
  callback = function()
    vim.opt.relativenumber = true
  end
})

autocmd({'BufLeave', 'FocusLost', 'InsertEnter'}, {
  group = 'numberToggle',
  callback = function()
    vim.opt.relativenumber = false
  end
})
