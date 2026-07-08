local AppChat = script:FindFirstAncestor("AppChat")
local v2 = require(AppChat.Logger):new(script:GetFullName() .. ":RemoveUserDialogScreen")

v2:setContext({
	screen = "RemoveUserDialogScreen"
})

return v2
