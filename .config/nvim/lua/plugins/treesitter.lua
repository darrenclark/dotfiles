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
        'c_sharp',
        'bash',
        'clojure',
        'ebnf',
        'elixir',
        'erlang',
        'javascript',
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
        'starlark',
        'typescript',
        'vim',
        'zig',
      }
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
      vim.treesitter.language.register('starlark', 'tiltfile')
    end
  },
  {
    "nvim-treesitter/playground",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    }
  }
}
