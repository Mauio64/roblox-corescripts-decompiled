local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")

local conversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/SocialLibraries").Conversation
local getConversationTitle = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/getConversationTitle")
local getOtherParticipant = conversation.getOtherParticipant
local getConversationGameId = conversation.getConversationGameId

local populateUserIdsWithState = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/populateUserIdsWithState")
local getThumbnailsForUserIds = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Users/getThumbnailsForUserIds")
local getLastMessageContent = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/getLastMessageContent")
local RoduxPresence = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Http/RoduxPresence")
local FFlagAppChatPresenceStoreMigration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatPresenceStoreMigration")

local userPresenceUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Users/userPresenceUtils")

local getConversationTimestamp = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getConversationTimestamp")

return function(p2, data)
	local participants = data.participants or {}
	local filtered = Cryo.List.filter(participants, function(p3): boolean
		return p3 ~= p2.LocalUserId
	end)
	local v5

	if not (FFlagAppChatPresenceStoreMigration or data.conversationType ~= "OneToOneConversation") then
		local otherParticipant = getOtherParticipant(p2, data.participants)
		local userPresenceByUserId = RoduxPresence.Selectors.getUserPresenceByUserId(p2, otherParticipant)
		v5 = userPresenceUtils.getUserDisplayPresence(userPresenceByUserId)
	end

	local users = p2.Users
	local v6 = {}

	for k, participant in pairs(participants) do
		v6[participant] = users[participant]
	end

	local v7 = {
		shortRelativeTime = data.lastUpdated and getConversationTimestamp(data.lastUpdated),
		longRelativeTime = data.lastUpdated and data.lastUpdated:GetLongRelativeTime(),
		unixTime = data.lastUpdated and data.lastUpdated:GetUnixTimestamp()
	}

	local join = Cryo.Dictionary.join
	local v8 = {
		id = data.id,
		title = getConversationTitle(data),
		participants = populateUserIdsWithState(p2, participants),
		otherParticipants = filtered,
		isDefaultTitle = data.isDefaultTitle,
		hasGroupUp = data.hasGroupUp,
		lastMessageContent = getLastMessageContent(data) or "",
		hasUnreadMessages = data.hasUnreadMessages or false,
		thumbnails = getThumbnailsForUserIds(filtered),
		presenceText = 0,
		presenceImage = 0,
		gameId = 0,
		serverState = 0,
		moderationType = 0,
		userPendingStatus = 0,
		conversationType = 0,
		osaAcknowledgementStatus = 0,
		userOptedIntoChatMessages = 0
	}
	local v9 = if not FFlagAppChatPresenceStoreMigration then v5 and v5.text else nil
	v8.presenceText = v9
	local v10 = if not FFlagAppChatPresenceStoreMigration then v5 and v5.image else nil
	v8.presenceImage = v10

	v8.gameId = getConversationGameId(data, p2.LocalUserId, v6)

	v8.serverState = data.serverState

	v8.moderationType = data.moderationType
	v8.userPendingStatus = data.userPendingStatus
	v8.conversationType = data.conversationType
	v8.osaAcknowledgementStatus = data.osaAcknowledgementStatus
	v8.userOptedIntoChatMessages = data.userOptedIntoChatMessages
	return join(v8, v7)
end
