hs.hotkey.bind({"ctrl", "shift"}, "`", function()
  local app = hs.application.find("iTerm2")
  if app and app:isFrontmost() then
    app:hide()
  else
    hs.application.launchOrFocus("iTerm")
  end
end)
