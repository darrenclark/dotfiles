hs.hotkey.bind({"ctrl", "shift"}, "`", function()
  local app = hs.application.find("iTerm2")
  if app and app:isFrontmost() then
    app:hide()
  else
    hs.application.launchOrFocus("iTerm")
  end
end)

hs.hotkey.bind({"ctrl", "shift"}, "1", function()
  hs.application.launchOrFocus("Google Chrome")
end)

hs.hotkey.bind({"ctrl", "shift"}, "2", function()
  hs.application.launchOrFocus("Slack")
end)


-- Fix ChatGPT
-- https://www.reddit.com/r/ChatGPT/comments/1mo1r6l/comment/n8c3tu4/
local function nudgeChatGPTWindow()
  local frontApp = hs.application.frontmostApplication()
  if frontApp and frontApp:name() == "ChatGPT" then
    local win = frontApp:mainWindow()
    if win then
      local frame = win:frame()

      -- Nudge smaller
      frame.w = frame.w - 1
      frame.h = frame.h - 1
      win:setFrame(frame)

      -- Nudge back after short delay (so it's visible)
      hs.timer.doAfter(0.05, function()
        frame.w = frame.w + 1
        frame.h = frame.h + 1
        win:setFrame(frame)
      end)
    end
  end
end
hs.timer.doEvery(5, nudgeChatGPTWindow)
