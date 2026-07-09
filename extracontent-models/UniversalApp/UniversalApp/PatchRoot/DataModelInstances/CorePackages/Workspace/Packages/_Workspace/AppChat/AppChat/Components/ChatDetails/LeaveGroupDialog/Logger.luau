local AppChat = script:FindFirstAncestor("AppChat")
local v2 = require(AppChat.Logger):new(script:GetFullName() .. ":LeaveGroupDialogScreen")

v2:setContext({
	screen = "LeaveGroupDialogScreen"
})

return v2
