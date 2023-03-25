return {
  "nvim-treesitter/nvim-treesitter",
  build = function()
    require("nvim-treesitter.install").update({ with_sync = true })
  end,
  opts = {
    highlight = { enable = true },
    ensure_installed = {
      'c',
      'bash',
      'help',
      'json',
      'jsonc',
      'lua',
      'markdown',
      'markdown_inline',
      'vim',
    }
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
  end
}
