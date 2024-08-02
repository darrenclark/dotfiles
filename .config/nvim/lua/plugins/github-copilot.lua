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
    config = function()
      vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })

      require("copilot_cmp").setup()
    end
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" },
    },
    opts = {
      debug = true,
    },
    keys = {
      {
        "<leader>cc",
        "<cmd>CopilotChatToggle<cr>",
        desc = "Toggle chat window",
      },
      {
        "<leader>cs",
        "<cmd>CopilotChatStop<cr>",
        desc = "Stop current copilot output",
      },
      {
        "<leader>cr",
        "<cmd>CopilotChatReset<cr>",
        desc = "Reset chat window",
      },
      {
        "<leader>ce",
        "<cmd>CopilotChatExplain<cr>",
        desc = "Write an explanation for the active selection"
      },
      {
        "<leader>cv",
        "<cmd>CopilotChatReview<cr>",
        desc = "Review the selected code"
      },
      {
        "<leader>cf",
        "<cmd>CopilotChatFix<cr>",
        desc = "Rewrite the code to fix the bug"
      },
      {
        "<leader>co",
        "<cmd>CopilotChatOptimize<cr>",
        desc = "Optimize the selected code"
      },
      {
        "<leader>cd",
        "<cmd>CopilotChatDocs<cr>",
        desc = "Add documentation comment for the selection"
      },
      {
        "<leader>ct",
        "<cmd>CopilotChatTests<cr>",
        desc = "Generate tests for the code"
      },
      {
        "<leader>ci",
        "<cmd>CopilotChatFixDiagnostic<cr>",
        desc = "Assist with the diagnostic issue"
      },
      {
        "<leader>cm",
        "<cmd>CopilotChatCommit<cr>",
        desc = "Write commit message with commitizen convention"
      },
      {
        "<leader>cM",
        "<cmd>CopilotChatCommitStaged<cr>",
        desc = "Write commit message for staged changes"
      },
    }
  }
}
