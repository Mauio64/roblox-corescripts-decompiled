local AppChat = script:FindFirstAncestor("AppChat")
local v2 = require(AppChat.Logger):new(script:GetFullName() .. ":MessageInteraction")

v2:setContext({
	screen = "MessageContextMenuScreen"
})

return v2
