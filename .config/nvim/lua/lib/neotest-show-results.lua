local nio = require("nio")

local consumer = {}

local client

local init = function()
  client.listeners.results = function(_, results)
    local pass, fail = 0, 0
    for _, res in pairs(results) do
      if res.status == "failed" then
        fail = fail + 1
      elseif res.status == "passed" then
        pass = pass + 1
      end
    end

    if pass > 0 and fail == 0 then
      vim.cmd("echohl DiagnosticOk | echo \"✓ Tests passed\" | echohl None")
    elseif pass == 0 and fail >= 0 then
      -- Copied from https://github.com/nvim-neotest/neotest/blob/master/lua/neotest/consumers/output.lua
      local cur_pos = nio.fn.getpos(".")
      local line = cur_pos[2] - 1
      local buf_path = vim.fn.expand("%:p")
      local positions = client:get_position(buf_path)
      if not positions then
        -- show full output
        require('neotest').output.open({enter = true})
        return
      end

      -- open default output if cursor is in a test case
      for _, node in positions:iter_nodes() do
        local pos = node:data()
        local range = node:closest_value_for("range")

        if
          pos.type == "test"
          and results[pos.id]
          and results[pos.id].status == "failed"
          and range[1] <= line
          and range[3] >= line
        then
          require('neotest').output.open({short = true, enter = false})
          return
        end
      end

      -- show full output
      require('neotest').output.open({enter = true})
    elseif pass == 0 and fail == 0 then
      vim.cmd("echohl ErrorMsg | echo \"No tests run\" | echohl None")
    end
  end
end

consumer = setmetatable(consumer, {
  __call = function(_, client_)
    client = client_
    init()
    return consumer
  end,
})

return consumer
