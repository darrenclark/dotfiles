return {
  {
    "Sewb21/nx.nvim",

    lazy = vim.fn.filereadable("nx.json") ~= 1,

    dependencies = {
      "nvim-telescope/telescope.nvim",
    },

    opts  = {
      nx_cmd_root = "npx nx",
    },

    keys = {
      { "<leader>nx", "<cmd>Telescope nx actions<CR>", desc = "nx actions"}
    },
  },
}
