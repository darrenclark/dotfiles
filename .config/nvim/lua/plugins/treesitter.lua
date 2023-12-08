return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = function()
      require("nvim-treesitter.install").update({ with_sync = true })
    end,
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = {
        'c',
        'bash',
        'elixir',
        'help',
        'json',
        'jsonc',
        'lua',
        'markdown',
        'markdown_inline',
        'ocaml',
        'ocaml_interface',
        'python',
        'query',
        'rust',
        'vim',
        'zig',
      }
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end
  },
  {
    "nvim-treesitter/playground",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    }
  }
}
