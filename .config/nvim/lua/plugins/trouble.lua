return {
  "folke/trouble.nvim",
  opts = {
    keys = {
      ["<esc>"] = "close",
      ["<cr>"] = "jump_close",
    }
  },
  cmd = "Trouble",
  keys = {
    {
      "<leader>ex",
      "<cmd>Trouble diagnostics toggle focus=true win.size.height=20<cr>",
      desc = "Diagnostics",
    },
    {
      "<leader>eX",
      "<cmd>Trouble diagnostics toggle filter.buf=0 focus=true win.size.height=20<cr>",
      desc = "Diagnostics (this buffer)",
    },
    {
      "<leader>es",
      "<cmd>Trouble symbols toggle win.position=right focus=true<cr>",
      desc = "Symbols",
    },
    {
      "<leader>el",
      "<cmd>Trouble lsp toggle win.position=bottom focus=true win.size.height=20<cr>",
      desc = "Definitions / references / ...",
    },
  },
}
