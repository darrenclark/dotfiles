return {
  "nvim-treesitter/nvim-treesitter",
  build = function()
    require("nvim-treesitter.install").update({ with_sync = true })
  end,
  opts = {
    highlight = { enable = true },
    ensure_installed = {
      'bash',
      'json',
      'jsonc',
      'lua',
      'markdown',
      'markdown_inline',
    }
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
  end
}
