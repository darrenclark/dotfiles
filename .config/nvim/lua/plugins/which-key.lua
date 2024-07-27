return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300

    local wk = require("which-key")
    wk.register({
      b = {
        name = "buffer"
      },
      e = {
        name = "LSP"
      }
    }, {prefix = "<leader>"})
  end,
  opts = {
    triggers = {"<leader>"}
  }
}
