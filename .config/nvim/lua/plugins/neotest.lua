return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      -- adapters
      "jfpedroza/neotest-elixir"
    },
    keys = {

    },
    opts = {
      diagnostic = {
        enabled = false,
      },
      icons = {
        passed = "✓",
        failed = "✖",
        running = "⏺",
        skipped = "-",
      },
      status = {
        --signs = false,
      },
      quickfix = {
        open = function()
          require('telescope.builtin').quickfix()
        end,
      }
    },
    config = function(_, opts)
      local adapters = {
        require("neotest-elixir")
      }

      local config = vim.tbl_extend('force', opts, {adapters=adapters})
      require("neotest").setup(config)
    end,
  }

}
