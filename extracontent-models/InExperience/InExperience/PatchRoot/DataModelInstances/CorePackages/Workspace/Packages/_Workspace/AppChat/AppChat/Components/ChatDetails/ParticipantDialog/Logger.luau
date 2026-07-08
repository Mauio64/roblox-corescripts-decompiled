local AppChat = script:FindFirstAncestor("AppChat")
local v2 = require(AppChat.Logger):new(script:GetFullName() .. ":ParticipantDialogScreen")

v2:setContext({
	screen = "ParticipantDialogScreen"
})

return v2
