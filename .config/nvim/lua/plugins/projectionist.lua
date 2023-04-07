return {
  "tpope/vim-projectionist",
  lazy = false,
  keys = {
    { "<C-A>", "<Cmd>A<CR>", desc = "Alternate file" },
  },
  init = function()
    vim.cmd [[
      let g:projectionist_heuristics = {
            \   "apps/*/mix.exs": {
            \     "apps/*.ex": {"alternate": "apps/{}_test.exs"},
            \     "apps/*_test.exs": {"alternate": "apps/{}.ex"}
            \   },
            \   "mix.exs": {
            \     "lib/*.ex": {"alternate": "test/{}_test.exs"},
            \     "lib/*.html.leex": {"type": "leex", "related": "lib/{}.ex", "alternate": "lib/{}.ex"},
            \     "test/*_test.exs": {"alternate": "lib/{}.ex"}
            \   },
            \   "gradlew": {
            \     "src/main/*.kt": {"alternate": "src/test/{dirname}/Test{basename}.kt"},
            \     "src/test/**/Test*.kt": {"alternate": "src/main/{}.kt"}
            \   }
            \ }
    ]]
  end
}
