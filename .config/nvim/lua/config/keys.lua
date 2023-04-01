local function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local function buf_map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_buf_set_keymap(0, mode, lhs, rhs, options)
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

autocmd({'LspAttach'}, {
  group = augroup('lspKeys', {clear = true}),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    buf_map('n', 'K', '', {silent = true, callback = vim.lsp.buf.hover})

    if client.server_capabilities['definitionProvider'] then
      buf_map('n', 'gd', '<cmd>Telescope lsp_definitions<CR>', { silent = true })
      buf_map('n', 'gr', '<cmd>Telescope lsp_references<CR>', { silent = true })
    end
  end
})
