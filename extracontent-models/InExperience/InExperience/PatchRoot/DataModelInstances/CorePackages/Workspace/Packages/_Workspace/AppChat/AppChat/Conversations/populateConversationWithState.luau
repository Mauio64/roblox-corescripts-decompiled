local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Cryo = require(AppChatParent.Cryo)
local Conversation = require(AppChat.SocialLibraries).Conversation
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

return function(p1, p2) -- line: 40
	-- upvalues: Cryo (copy), FFlagAppChatPresenceStoreMigration (copy), getOtherParticipant (copy), RoduxPresence (copy), userPresenceUtils (copy), getConversationTimestamp (copy), getConversationTitle (copy), populateUserIdsWithState (copy), getLastMessageContent (copy), getThumbnailsForUserIds (copy), getConversationGameId (copy)
	local v17 = p2.participants or {}
	local v18 = Cryo.List.filter(v17, function(p3) -- line: 42
		-- upvalues: p1 (copy)
		return p3 ~= p1.LocalUserId
	end)
	local v19 = nil

	if not FFlagAppChatPresenceStoreMigration and p2.conversationType == "OneToOneConversation" then
		local v20 = getOtherParticipant(p1, p2.participants)
		local v21 = RoduxPresence.Selectors.getUserPresenceByUserId(p1, v20)

		v19 = userPresenceUtils.getUserDisplayPresence(v21)
	end

	local t1 = {}
	local Users = p1.Users

	for _, v in pairs(v17) do
		t1[v] = Users[v]
	end

	local t2 = {
		shortRelativeTime = p2.lastUpdated and getConversationTimestamp(p2.lastUpdated),
		longRelativeTime = p2.lastUpdated and p2.lastUpdated:GetLongRelativeTime(),
		unixTime = p2.lastUpdated and p2.lastUpdated:GetUnixTimestamp()
	}

	return Cryo.Dictionary.join({
		id = p2.id,
		title = getConversationTitle(p2),
		participants = populateUserIdsWithState(p1, v17),
		otherParticipants = v18,
		isDefaultTitle = p2.isDefaultTitle,
		hasGroupUp = p2.hasGroupUp,
		lastMessageContent = getLastMessageContent(p2) or "",
		hasUnreadMessages = p2.hasUnreadMessages or false,
		thumbnails = getThumbnailsForUserIds(v18),
		presenceText = if not FFlagAppChatPresenceStoreMigration then v19 and v19.text else nil,
		presenceImage = if not FFlagAppChatPresenceStoreMigration then v19 and v19.image else nil,
		gameId = getConversationGameId(p2, p1.LocalUserId, t1),
		serverState = p2.serverState,
		moderationType = p2.moderationType,
		userPendingStatus = p2.userPendingStatus,
		conversationType = p2.conversationType,
		osaAcknowledgementStatus = p2.osaAcknowledgementStatus,
		userOptedIntoChatMessages = p2.userOptedIntoChatMessages
	}, t2)
end
