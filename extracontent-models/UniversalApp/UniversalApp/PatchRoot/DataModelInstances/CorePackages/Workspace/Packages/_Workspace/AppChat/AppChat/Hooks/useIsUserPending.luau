local AppChat = script:FindFirstAncestor("AppChat")
local Conversation = require(AppChat.Models.Conversation)
local ConversationChannels = require(AppChat.Models.ConversationChannels)

return function(t1: {[any]: any}) -- line: 12
	-- upvalues: Conversation (copy), ConversationChannels (copy)
	if t1.conversationType ~= Conversation.Type.MULTI_USER_CONVERSATION then
		return false
	end

	if t1.userPendingStatus == ConversationChannels.UserPendingStatus.Pending then
		return true
	end

	if t1.userPendingStatus == ConversationChannels.UserPendingStatus.Invalid and t1.moderationType == ConversationChannels.ModerationType.TrustedComms then
		return true
	end

	return false
end
