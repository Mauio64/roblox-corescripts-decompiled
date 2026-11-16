local parent = script:FindFirstAncestor("FriendsChat").Parent

require(parent.AppChat.GetConversationListStore)

local serializeParticipantIdsForTelemetry = require(script.Parent.Parent.App.serializeParticipantIdsForTelemetry)

local function indexOfConversation(items, id: string) -- 1 equivalent call inferred from this helper
	for k, item in items do
		if item.id == id then
			return k
		end
	end

	return 0
end

local function getChatLandingConversationInfo(data, list, isFiltered: boolean)
	return {
		isFiltered = isFiltered,
		conversationListCount = #list,
		selectedConversationId = data.id,
		selectedIndex = indexOfConversation(list, data.id), -- inferred equivalent call
		hasUnreadMessages = data.hasUnreadMessages,
		selectedConversationModerationType = data.moderationType,
		selectedConversationUserPendingStatus = data.userPendingStatus,
		participantUserIds = serializeParticipantIdsForTelemetry(data.participants),
		osaAcknowledgementStatus = data.osaAcknowledgementStatus
	}
end

return getChatLandingConversationInfo
