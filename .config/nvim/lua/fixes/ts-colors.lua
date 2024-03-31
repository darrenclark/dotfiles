-- Source: https://gist.github.com/last-partizan/f7147ddccf98a4df9d5a6358edc0809f
--
-- Fix TS Colors
-- https://github.com/nvim-treesitter/nvim-treesitter/pull/3656/files
-- https://github.com/nvim-treesitter/nvim-treesitter/commit/1ae9b0e4558fe7868f8cda2db65239cfb14836d0
-- https://github.com/nvim-treesitter/nvim-treesitter/blob/master/CONTRIBUTING.md#highlights

local function set_default_hlgroups()
  local highlights = {
    -- Identifiers
    ["@variable"] = { link = "Variable", default = true },
    ["@variable.builtin"] = { link = "Special", default = true },
    ["@variable.parameter"] = { link = "Identifier", default = true },
    ["@variable.member"] = { link = "Identifier", default = true },

    ["@constant"] = { link = "Constant", default = true },
    ["@constant.builtin"] = { link = "Special", default = true },
    ["@constant.macro"] = { link = "Define", default = true },

    ["@module"] = { link = "Include", default = true },
    ["@label"] = { link = "Label", default = true },
    -- Literals
    ["@string"] = { link = "String", default = true },
    ["@string.regexp"] = { link = "String", default = true },
    ["@string.escape"] = { link = "SpecialChar", default = true },
    ["@string.special"] = { link = "SpecialChar", default = true },
    ["@string.special.symbol"] = { link = "Identifier", default = true },

    ["@character"] = { link = "Character", default = true },
    ["@character.special"] = { link = "SpecialChar", default = true },

    ["@boolean"] = { link = "Boolean", default = true },
    ["@number"] = { link = "Number", default = true },
    ["@number.float"] = { link = "Float", default = true },
    -- Types
    ["@type"] = { link = "Type", default = true },
    ["@type.builtin"] = { link = "Type", default = true },
    ["@type.qualifier"] = { link = "Type", default = true },
    ["@type.definition"] = { link = "Typedef", default = true },

    ["@attribute"] = { link = "PreProc", default = true },
    ["@property"] = { link = "Identifier", default = true },
    -- Functions
    ["@function"] = { link = "Function", default = true },
    ["@function.builtin"] = { link = "Special", default = true },
    ["@function.macro"] = { link = "Macro", default = true },
    ["@function.method"] = { link = "Function", default = true },

    ["@constructor"] = { link = "Special", default = true },
    ["@operator"] = { link = "Operator", default = true },
    -- Keyword
    ["@keyword"] = { link = "Keyword", default = true },
    ["@keyword.function"] = { link = "Keyword", default = true },
    ["@keyword.operator"] = { link = "Operator", default = true },
    ["@keyword.import"] = { link = "Include", default = true },
    ["@keyword.repeat"] = { link = "Repeat", default = true },
    ["@keyword.return"] = { link = "Keyword", default = true },
    ["@keyword.debug"] = { link = "Debug", default = true },
    ["@keyword.exception"] = { link = "Exception", default = true },

    ["@keyword.conditional"] = { link = "Conditional", default = true },
    ["@keyword.directive"] = { link = "PreProc", default = true },
    -- Punctutation
    ["@punctutation.delimiter"] = { link = "Delimiter", default = true },
    ["@punctutation.bracket"] = { link = "Delimiter", default = true },
    ["@punctutation.special"] = { link = "Delimiter", default = true },
    -- Comments
    ["@comment"] = { link = "Comment", default = true },

    ["@comment.note"] = { link = "SpecialComment", default = true },
    ["@comment.warning"] = { link = "WarningMsg", default = true },
    ["@comment.error"] = { link = "Error", default = true },
    ["@comment.todo"] = { link = "Todo", default = true },
    -- Markup
    ["@markup.strong"] = { bold = true, default = true },
    ["@markup.emphasis"] = { italic = true, default = true },
    ["@markup.underline"] = { underline = true },
    ["@markup.strike"] = { strikethrough = true },

    ["@markup.math"] = { link = "Special", default = true },
    ["@markup.environment"] = { link = "Macro", default = true },

    ["@markup.heading"] = { link = "Title", default = true },

    ["@markup.raw"] = { link = "SpecialComment", default = true },

    ["@markup.link"] = { link = "Underlined", default = true },
    ["@markup.link.label"] = { link = "SpecialChar", default = true },
    ["@markup.link.url"] = { link = "Keyword", default = true },

    ["@markup.list"] = { link = "Keyword", default = true },

    ["@tag"] = { link = "Label", default = true },
    ["@tag.delimiter"] = { link = "Delimiter", default = true },
    ["@tag.attribute"] = { link = "Identifier", default = true },
  }

  for k, v in pairs(highlights) do
    vim.api.nvim_set_hl(0, k, v)
  end

  vim.defer_fn(
    function()
      -- Fix underlined links
      vim.api.nvim_set_hl(0, "Underlined", {})
    end,
    300
  )
end

set_default_hlgroups()

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = set_default_hlgroups,
  desc = "Set default highlights for TS",
})
