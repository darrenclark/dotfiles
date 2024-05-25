return {
  {"elixir-editors/vim-elixir"},
  {
    "elixir-tools/elixir-tools.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    ft = { "elixir", "eex", "heex", "surface" },
    config = function()
      local elixir = require("elixir")
      local elixirls = require("elixir.elixirls")

      elixir.setup {
        credo = {},
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        settings = elixirls.settings {
          dialyzerEnabled = false,
          enableTestLenses = false,
          fetchDeps = true,
          suggestSpecs = false,
        },
        log_level = vim.lsp.protocol.MessageType.Log,
        message_level = vim.lsp.protocol.MessageType.Log,
      }
    end,
  }
}
