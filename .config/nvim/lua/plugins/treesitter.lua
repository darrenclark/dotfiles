return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = function()
      require("nvim-treesitter.install").update({ with_sync = true })
    end,
    opts = {
      highlight = { enable = true },
      indent = { enable = false },
      ensure_installed = {
        'c',
        'c_sharp',
        'bash',
        'clojure',
        'elixir',
        'erlang',
        'help',
        'json',
        'jsonc',
        'lua',
        'markdown',
        'markdown_inline',
        'nim',
        'nim_format_string',
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
