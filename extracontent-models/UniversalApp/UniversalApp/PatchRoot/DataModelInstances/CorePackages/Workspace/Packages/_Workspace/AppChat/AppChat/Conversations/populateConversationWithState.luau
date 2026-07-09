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
local userPresenceUtils = require(AppChat.Users.userPresenceUtils)
local getConversationTimestamp = require(AppChat.Utils.getConversationTimestamp)

return function(p1, p2) -- line: 39
	-- upvalues: Cryo (copy), getOtherParticipant (copy), RoduxPresence (copy), userPresenceUtils (copy), getConversationTimestamp (copy), getConversationTitle (copy), populateUserIdsWithState (copy), getLastMessageContent (copy), getThumbnailsForUserIds (copy), getConversationGameId (copy)
	local v16 = p2.participants or {}
	local v17 = Cryo.List.filter(v16, function(p3) -- line: 41
		-- upvalues: p1 (copy)
		return p3 ~= p1.LocalUserId
	end)
	local v18 = nil

	if p2.conversationType == "OneToOneConversation" then
		local v19 = getOtherParticipant(p1, p2.participants)
		local v20 = RoduxPresence.Selectors.getUserPresenceByUserId(p1, v19)

		v18 = userPresenceUtils.getUserDisplayPresence(v20)
	end

	local t1 = {}
	local Users = p1.Users

	for _, v in pairs(v16) do
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
		participants = populateUserIdsWithState(p1, v16),
		otherParticipants = v17,
		isDefaultTitle = p2.isDefaultTitle,
		hasGroupUp = p2.hasGroupUp,
		lastMessageContent = getLastMessageContent(p2) or "",
		hasUnreadMessages = p2.hasUnreadMessages or false,
		thumbnails = getThumbnailsForUserIds(v17),
		presenceText = v18 and v18.text,
		presenceImage = v18 and v18.image,
		gameId = getConversationGameId(p2, p1.LocalUserId, t1),
		serverState = p2.serverState,
		moderationType = p2.moderationType,
		userPendingStatus = p2.userPendingStatus,
		conversationType = p2.conversationType,
		osaAcknowledgementStatus = p2.osaAcknowledgementStatus,
		userOptedIntoChatMessages = p2.userOptedIntoChatMessages
	}, t2)
end
