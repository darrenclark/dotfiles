return {
  {
    "zbirenbaum/copilot.lua",
    lazy = true,
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
    },
    config = function(_, opts)
      require("copilot").setup(opts)
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    config = function ()
      vim.api.nvim_set_hl(0, "CmpItemKindCopilot", {fg ="#6CC644"})

      require("copilot_cmp").setup()
    end
  }
}
