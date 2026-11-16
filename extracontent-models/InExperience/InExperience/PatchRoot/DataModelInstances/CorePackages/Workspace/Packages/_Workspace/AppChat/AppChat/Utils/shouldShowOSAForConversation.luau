local AppChat = script:FindFirstAncestor("AppChat")
local Conversation = require(AppChat.Models.Conversation)

return function(p): boolean
	if not p then
		return false
	end

	return p.conversationType == Conversation.Type.MULTI_USER_CONVERSATION
		and p.osaAcknowledgementStatus == Conversation.OsaAcknowledgementStatus.Unacknowledged
end
