return {
  {
    "abidibo/nvim-httpyac",
    lazy = false,
    config = function ()
      require('nvim-httpyac').setup()
    end,
    cmd = {
      "NvimHttpYac",
      "NvimHttpYacAll",
    },
    keys = {
      {
        "<leader>ha",
        "<cmd>NvimHttpYacAll<cr>",
        desc = "Run httpyac file",
      },
      {
        "<leader>ho",
        "<cmd>NvimHttpYac<cr>",
        desc = "Run one httpyac request",
      },
    }
  },
}

