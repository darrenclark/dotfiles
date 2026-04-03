return {
  {
    "nvim-treesitter/nvim-treesitter",
    commit = "4916d6592ede8c07973490d9322f187e07dfefac",
    lazy = false,
    build = ":TSUpdate",
    opts = {
      parsers_and_filetypes = {
        c = { 'c' },
        c_sharp = { 'cs' },
        bash = { 'sh', 'bash', 'zsh' },
        clojure = { 'clojure' },
        ebnf = { 'ebnf' },
        elixir = { 'elixir' },
        erlang = { 'erlang' },
        hcl = { 'hcl' },
        javascript = { 'javascript' },
        json = { 'json' },
        -- TODO: Remove? replace?
        --jsonc = { 'jsonc' },
        lua = { 'lua' },
        markdown = { 'markdown' },
        markdown_inline = { 'markdown' },
        nim = { 'nim' },
        nim_format_string = { 'nim' },
        ocaml = { 'ocaml' },
        ocaml_interface = { 'ocaml' },
        python = { 'python' },
        query = { 'query' },
        rust = { 'rust' },
        starlark = { 'bzl' },
        terraform = { 'terraform' },
        typescript = { 'typescript' },
        vim = { 'vim' },
        yaml = { 'yaml' },
        zig = { 'zig' },
      }
    },
    config = function(_, opts)
      local parsers = {}
      local filetypes = {}
      for p, fts in pairs(opts.parsers_and_filetypes) do
        table.insert(parsers, p)
        for _, ft in ipairs(fts) do
          table.insert(filetypes, ft)
        end
      end

      -- Install parsers
      require("nvim-treesitter").install(parsers)

      -- Enable highlighting
      vim.api.nvim_create_autocmd('FileType', {
        pattern = filetypes,
        callback = function() vim.treesitter.start() end,
      })

      vim.treesitter.language.register('starlark', 'tiltfile')

      -- TODO: Indent? Fold?
    end
  }
}
