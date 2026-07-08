local AppChat = script:FindFirstAncestor("AppChat")
local Conversation = require(AppChat.Models.Conversation)

return function(p1) -- line: 4
	-- upvalues: Conversation (copy)
	if not p1 then
		return false
	end

	return p1.conversationType == Conversation.Type.MULTI_USER_CONVERSATION and p1.osaAcknowledgementStatus == Conversation.OsaAcknowledgementStatus.Unacknowledged
end
