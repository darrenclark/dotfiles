local M = {}

---@param name string
---@param fn fun(name:string)
M.on_load = function (name, fn)
  vim.api.nvim_create_autocmd("User", {
    pattern = "LazyLoad",
    callback = function(event)
      if event.data == name then
        fn(name)
        return true
      end
    end,
  })
end

return M
