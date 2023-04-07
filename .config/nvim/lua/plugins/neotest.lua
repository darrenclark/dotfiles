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
      {
        "<C-P>",
        function()
          local run = require("neotest").run
          local line = vim.api.nvim_win_get_cursor(0)[1]
          if line == 1 then
            run.run(vim.fn.expand("%"))
          else
            run.run()
          end
        end,
        mode = {"n"},
        desc = "Run nearest test or whole file"
      },
      {
        "<C-N>",
        function()
          local run = require("neotest").run
          run.run_last()
        end,
        mode = {"n"},
        desc = "Run previous test"
      },
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
      output = {
        open_on_run = false,
      },
      quickfix = {
        open = function()
          local qflist = vim.fn.getqflist()
          local in_different_file = qflist[1].bufnr ~= vim.api.nvim_get_current_buf()

          if #qflist > 1 or in_different_file then
            require('telescope.builtin').quickfix({
              attach_mappings = function(_, map)
                map({'i','n'}, "<CR>", function(...)
                  require('telescope.actions').select_default(...)
                  require("neotest").output.open({enter=true})
                end)

                return true
              end
            })
          else
            -- jump to failed test and show output
            vim.cmd [[:cfirst]]
            require("neotest").output.open({enter=true})
          end
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
