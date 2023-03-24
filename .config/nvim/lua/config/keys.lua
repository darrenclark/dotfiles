function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Enter to clear search highlight
map("n", "<CR>", ":nohlsearch<CR>", { silent = true })

-- Previous tab (Ctrl-H or Ctrl-J)
map("n", "<C-H>", ":bp<CR>", { silent = true })
map("n", "<C-J>", ":bp<CR>", { silent = true })
map("v", "<C-H>", "<C-C>:bp<CR>", { silent = true })
map("v", "<C-J>", "<C-C>:bp<CR>", { silent = true })
map("i", "<C-H>", "<C-C>:bp<CR>", { silent = true })
map("i", "<C-J>", "<C-C>:bp<CR>", { silent = true })

-- Next tab (Ctrl-K or Ctrl-L)
map("n", "<C-K>", ":bn<CR>", { silent = true })
map("n", "<C-L>", ":bn<CR>", { silent = true })
map("v", "<C-K>", "<C-C>:bn<CR>", { silent = true })
map("v", "<C-L>", "<C-C>:bn<CR>", { silent = true })
map("i", "<C-K>", "<C-C>:bn<CR>", { silent = true })
map("i", "<C-L>", "<C-C>:bn<CR>", { silent = true })

-- Close buffer
map("n", "<C-Q>", ":bd<CR>", { silent = true })
