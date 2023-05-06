vim.opt.background = 'dark'
vim.g.colors_name = 'my-jellybeans'

local lush = require('lush')
local jellybeans = require('lush_theme.jellybeans-nvim')

local spec = lush.extends({jellybeans}).with(function()
  return {
    diffAdded { fg = lush.hsl('#99ad6a') },
    diffRemoved { fg = lush.hsl('#b51717') },
  }
end)

lush(spec)
