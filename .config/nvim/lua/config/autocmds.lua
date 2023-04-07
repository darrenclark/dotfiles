local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Line number toggle

augroup('numberToggle', {clear = true})

autocmd({'BufEnter', 'FocusGained', 'InsertLeave'}, {
  group = 'numberToggle',
  callback = function()
    if vim.opt.number._value then
      vim.opt.relativenumber = true
    end
  end
})

autocmd({'BufLeave', 'FocusLost', 'InsertEnter'}, {
  group = 'numberToggle',
  callback = function()
    if vim.opt.number._value then
      vim.opt.relativenumber = false
    end
  end
})
