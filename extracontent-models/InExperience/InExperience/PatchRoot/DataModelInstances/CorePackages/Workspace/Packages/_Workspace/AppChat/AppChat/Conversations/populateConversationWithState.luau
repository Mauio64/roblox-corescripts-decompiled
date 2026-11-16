local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Cryo = require(parent.Cryo)

local SocialLibraries = require(AppChat.SocialLibraries)
local Conversation = SocialLibraries.Conversation
local getConversationTitle = require(AppChat.Conversations.getConversationTitle)
local getOtherParticipant = Conversation.getOtherParticipant
local getConversationGameId = Conversation.getConversationGameId

local populateUserIdsWithState = require(script.Parent.populateUserIdsWithState)
local getThumbnailsForUserIds = require(AppChat.Users.getThumbnailsForUserIds)
local getLastMessageContent = require(script.Parent.getLastMessageContent)
local RoduxPresence = require(AppChat.Http.RoduxPresence)
local FFlagAppChatPresenceStoreMigration = require(AppChat.Flags.FFlagAppChatPresenceStoreMigration)

local userPresenceUtils = require(AppChat.Users.userPresenceUtils)

local getConversationTimestamp = require(AppChat.Utils.getConversationTimestamp)

return function(p, data)
	local participants = data.participants or {}
	local filtered = Cryo.List.filter(participants, function(p2): boolean
		return p2 ~= p.LocalUserId
	end)
	local v

	if not (FFlagAppChatPresenceStoreMigration or data.conversationType ~= "OneToOneConversation") then
		local otherParticipant = getOtherParticipant(p, data.participants)
		local userPresenceByUserId = RoduxPresence.Selectors.getUserPresenceByUserId(p, otherParticipant)
		v = userPresenceUtils.getUserDisplayPresence(userPresenceByUserId)
	end

	local users = p.Users
	local v2 = {}

	for _, participant in pairs(participants) do
		v2[participant] = users[participant]
	end

	local v3 = {
		shortRelativeTime = data.lastUpdated and getConversationTimestamp(data.lastUpdated),
		longRelativeTime = data.lastUpdated and data.lastUpdated:GetLongRelativeTime(),
		unixTime = data.lastUpdated and data.lastUpdated:GetUnixTimestamp()
	}

	local join = Cryo.Dictionary.join
	local v4 = {
		id = data.id,
		title = getConversationTitle(data),
		participants = populateUserIdsWithState(p, participants),
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
	local presenceText

	if not FFlagAppChatPresenceStoreMigration then
		presenceText = v and v.text
	end

	v4.presenceText = presenceText
	local presenceImage

	if not FFlagAppChatPresenceStoreMigration then
		presenceImage = v and v.image
	end

	v4.presenceImage = presenceImage

	v4.gameId = getConversationGameId(data, p.LocalUserId, v2)

	v4.serverState = data.serverState

	v4.moderationType = data.moderationType
	v4.userPendingStatus = data.userPendingStatus
	v4.conversationType = data.conversationType
	v4.osaAcknowledgementStatus = data.osaAcknowledgementStatus
	v4.userOptedIntoChatMessages = data.userOptedIntoChatMessages
	return join(v4, v3)
end
