vim.opt.spell = true
vim.opt.spelllang = { "en_ca", "en_us" }

vim.api.nvim_set_hl(0, "SpellBad",  { undercurl = true, sp = "#d48787" }) -- red

-- disabled (word is correct, just not in en_ca/en_us dictionaries)
vim.api.nvim_set_hl(0, "SpellLocal",{})
-- disabled (capitalization)
vim.api.nvim_set_hl(0, "SpellCap",  {})
-- disabled (rare/archaic/etc. words)
vim.api.nvim_set_hl(0, "SpellRare", {})

vim.opt.spellfile = "~/.config/nvim/spell/custom.utf-8.add"
