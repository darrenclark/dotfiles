local cmd = vim.api.nvim_create_user_command

cmd('Format', function () vim.lsp.buf.format() end, {})

cmd('JJReview', function(opts)
  local mod = require('jj-review')
  if opts.args == '' then
    mod.pick()
  else
    mod.start(opts.args)
  end
end, { nargs = '?', desc = 'Open jj diff review (no args = picker)' })
