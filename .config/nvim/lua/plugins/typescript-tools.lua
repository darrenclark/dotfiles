local util = require "lspconfig.util"

return {
  "pmizio/typescript-tools.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  opts = {
    settings = {
      tsserver_logs = "verbose",
      tsserver_file_preferences = {
        importModuleSpecifierPreference = "non-relative",
      }
    },
    root_dir = function(fname)
      -- Adapted from https://github.com/pmizio/typescript-tools.nvim/blob/3c501d7c7f79457932a8750a2a1476a004c5c1a9/lua/typescript-tools/init.lua#L29

      -- CHANGE: Added nx.json as a root file to search for
      local root_dir = util.root_pattern('nx.json')(fname)
        or util.root_pattern "tsconfig.json"(fname)
        or util.root_pattern("package.json", "jsconfig.json", ".git")(fname)

      local node_modules_index = root_dir and root_dir:find("node_modules", 1, true)
      if node_modules_index and node_modules_index > 0 then
        root_dir = root_dir:sub(1, node_modules_index - 2)
      end

      return root_dir
    end,
  },
}
