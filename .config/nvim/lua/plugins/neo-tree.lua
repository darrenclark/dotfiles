return {
  -- file explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    keys = {
      {
        "<C-F>",
        function()
          require("neo-tree.command").execute({ toggle = true })
        end,
        mode = {"n"},
        desc = "Toggle NeoTree",
      },
      {"<C-F>", "<C-C><C-F>", mode = {"v", "i"}, desc = "Toggle NeoTree", remap = true},
    },
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    init = function()
      vim.g.neo_tree_remove_legacy_commands = 1
      if vim.fn.argc() == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          require("neo-tree")
        end
      end
    end,
    opts = {
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = true,
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = true,
        },
      },
      window = {
        mappings = {
          ["<space>"] = "none",
        },
      },
      default_component_configs = {
        name = {
          use_git_status_colors = true,
        },
        git_status = {
          symbols = {
            -- change type
            added = "✚",
            modified = "*",
            deleted = "✖",
            renamed = "*",
            -- status
            untracked = "?",
            ignored = " ",
            unstaged = " ",
            staged = " ",
            conflict = " ",
          },
        },
        icon = {
          folder_closed = "▸",
          folder_open = "▾",
          folder_empty = " ",
          default = " ",
        },
        indent = {
          with_markers = false,
        },
      },
    },
  },

  -- ???
  { "nvim-lua/plenary.nvim", lazy = true },


  -- icons
  --{ "nvim-tree/nvim-web-devicons", lazy = true },

  -- ui components
  { "MunifTanjim/nui.nvim", lazy = true },
}
