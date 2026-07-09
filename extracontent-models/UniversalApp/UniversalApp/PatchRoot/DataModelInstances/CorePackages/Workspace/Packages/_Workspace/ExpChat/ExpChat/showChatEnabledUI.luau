local ExpChat = script:FindFirstAncestor("ExpChat")
local isUserChatEnabled = require(ExpChat.isUserChatEnabled)

return function(s1: string) -- line: 10
	-- upvalues: isUserChatEnabled (copy)
	return isUserChatEnabled(s1) or s1 == "NoOne"
end
