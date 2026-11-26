local Conversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/Conversation")
local ConversationChannels = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/ConversationChannels")

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
