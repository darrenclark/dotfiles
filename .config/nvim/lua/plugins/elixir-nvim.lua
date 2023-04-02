return {
  "mhanberg/elixir.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  ft = { "elixir", "eex", "heex", "surface" },
  config = function()
    local elixir = require("elixir")

    elixir.setup {
      settings = elixir.settings {
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

