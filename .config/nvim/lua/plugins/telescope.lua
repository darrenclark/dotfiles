return {
  'nvim-telescope/telescope.nvim', tag = '0.1.1',
  dependencies = { 'nvim-lua/plenary.nvim' },
  init = function()
    local rg = function(opts)
      if opts.args == "" then
        require('telescope.builtin').live_grep()
      else
        require('telescope.builtin').grep_string({search=opts.args, use_regex=true})
      end
    end

    vim.api.nvim_create_user_command('Rg', rg, {nargs = '*'})
  end,
  keys = {
    {
      "<C-space>",
      function()
        require('telescope.builtin').find_files()
      end,
      mode = {"n"},
      desc = "Find files"
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
      }
    }
  }
}

