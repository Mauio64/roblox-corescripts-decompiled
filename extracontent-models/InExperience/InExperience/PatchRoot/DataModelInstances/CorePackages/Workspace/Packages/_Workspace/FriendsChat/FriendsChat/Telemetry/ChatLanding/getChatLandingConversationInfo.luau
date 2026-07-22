local Parent = script:FindFirstAncestor("FriendsChat").Parent

require(Parent.AppChat.GetConversationListStore)

local serializeParticipantIdsForTelemetry = require(script.Parent.Parent.App.serializeParticipantIdsForTelemetry)

local function indexOfConversation(t1: {[any]: any}, s1: string) -- line: 30
	for v7, v8 in t1 do
		if s1 == v8.id then
			return v7
		end
	end

	return 0
end
local function getChatLandingConversationInfo(p1, t2: {[any]: any}, b1: boolean) -- line: 39
	-- upvalues: serializeParticipantIdsForTelemetry (copy)
	local t3 = {
		isFiltered = b1,
		conversationListCount = #t2,
		selectedConversationId = p1.id
	}
	local id = p1.id
	local g17 = nil
	local v16 = nil

	for v14, v15 in t2 do
		if id == v15.id then
			v16 = v14
			g17 = true
		end

		if g17 then
			break
		end
	end

	if not g17 then
		v16 = 0
	end

	g17 = false
	t3.selectedIndex = v16
	t3.hasUnreadMessages = p1.hasUnreadMessages
	t3.selectedConversationModerationType = p1.moderationType
	t3.selectedConversationUserPendingStatus = p1.userPendingStatus
	t3.participantUserIds = serializeParticipantIdsForTelemetry(p1.participants)
	t3.osaAcknowledgementStatus = p1.osaAcknowledgementStatus

	return t3
end

return getChatLandingConversationInfo
