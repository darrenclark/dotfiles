return {
  "kndndrj/nvim-dbee",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  build = function()
    require("dbee").install()
  end,
  config = function()
    require("dbee").setup{
      sources = {
        require("dbee.sources").FileSource:new("./.dbee.json"),
      },
      drawer = {
        disable_candies = true,
      }
    }
  end,
  keys = {
    { "<leader>d", function() require("dbee").toggle() end, desc = "open dbee"}
  },
}
