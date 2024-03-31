return {
  'nvim-telescope/telescope.nvim', tag = '0.1.5',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-ui-select.nvim',
  },
  init = function()
    local rg = function(opts)
      require('telescope.builtin').live_grep({default_text=opts.args})
    end

    vim.api.nvim_create_user_command('Rg', rg, {nargs = '*'})

    require('lib/util').on_load("telescope.nvim", function()
      require("telescope").load_extension('ui-select')
    end)
  end,
  keys = {
    {
      "<C-space>",
      function()
        require('telescope.builtin').find_files()
      end,
      mode = {"n"},
      desc = "Find files"
    },
    {
      "<C-/>",
      function()
        require('telescope.builtin').keymaps()
      end,
      mode = {"n"},
      desc = "Show keymaps"
    },
    {
      "<C-enter>",
      vim.lsp.buf.code_action,
      mode = {"n"},
      desc = "LSP Code action"
    }
  },
  opts = {
    defaults = {
      mappings = {
        i = {
          ["<esc>"] = 'close'
        }
      },
      layout_config = {
        vertical = { width = 0.9 }
      },
      layout_strategy = 'vertical'
    },
    pickers = {
      find_files = {
        find_command = {"rg", "--ignore", "--hidden", "--files", "-g", "!.git"},
      },
      live_grep = {
        additional_args = {"--hidden", "-g", "!.git"}
      },
      keymaps = {
        show_plug = false,
      },
    }
  }
}

