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
    cmd = {
      "CopilotChat",
      "CopilotChatOpen",
      "CopilotChatClose",
      "CopilotChatToggle",
      "CopilotChatStop",
      "CopilotChatReset",
      "CopilotChatSave",
      "CopilotChatLoad",
      "CopilotChatDebugInfo",
      "CopilotChatModels",
      "CopilotChatExplain",
      "CopilotChatReview",
      "CopilotChatFix",
      "CopilotChatOptimize",
      "CopilotChatDocs",
      "CopilotChatTests",
      "CopilotChatFixDiagnostic",
      "CopilotChatCommit",
      "CopilotChatCommitStaged"
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
        function()
          local prompt = [[
            Write a commit message.

            If the the change is simple, simply output a title.

            Otherwise, add additional paragraphs proportional to the size and
            complexity of the change.

            The commit message should be in the following format:
            ```
            title (less than 50 characters)

            body (if necessary, each line less than 72 characters)
            ```

            Do not include the backticks.

            Be terse, but clear.
          ]]

          require("CopilotChat").ask(prompt, {
            selection = function(source)
              return require("CopilotChat.select").gitdiff(source, true)
            end,
            callback = function(response)
              -- credit to https://gist.github.com/jaredallard/ddb152179831dd23b230
              local lines = {}
              local from = 1
              local delim_from, delim_to = string.find(response, "\n", from)
              while delim_from do
                table.insert(lines, string.sub(response, from, delim_from - 1))
                from                 = delim_to + 1
                delim_from, delim_to = string.find(response, "\n", from)
              end
              table.insert(lines, string.sub(response, from))

              vim.api.nvim_buf_set_text(1, 0, 0, 0, 0, lines)

              require("CopilotChat").close()
            end,
            window = {
              layout = "float",
              title = "Generating commit message..."
            }
          })
        end
      },
    }
  }
}
