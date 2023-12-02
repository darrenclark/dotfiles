local cmd = vim.api.nvim_create_user_command

cmd('Format', function () vim.lsp.buf.format() end, {})
