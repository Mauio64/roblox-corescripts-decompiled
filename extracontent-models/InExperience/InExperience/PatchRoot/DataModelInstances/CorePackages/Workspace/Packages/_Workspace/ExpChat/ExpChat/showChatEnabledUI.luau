local ExpChat = script:FindFirstAncestor("ExpChat")
local isUserChatEnabled = require(ExpChat.isUserChatEnabled)

return function(p: string)
	return isUserChatEnabled(p) or p == "NoOne"
end
