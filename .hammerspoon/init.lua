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
