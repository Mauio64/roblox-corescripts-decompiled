local AppChat = script:FindFirstAncestor("AppChat")

local Conversation = require(AppChat.Models.Conversation)
local ConversationChannels = require(AppChat.Models.ConversationChannels)

return function(data): boolean
	if data.conversationType ~= Conversation.Type.MULTI_USER_CONVERSATION then
		return false
	end

	if data.userPendingStatus == ConversationChannels.UserPendingStatus.Pending then
		return true
	end

	return data.userPendingStatus == ConversationChannels.UserPendingStatus.Invalid
		and data.moderationType == ConversationChannels.ModerationType.TrustedComms
end
