local Players = game:GetService("Players")
local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local Cryo = require(AppChatParent.Cryo)
local OrderedMap = require(AppChatParent.AppCommonLib).OrderedMap
local Constants = require(AppChat.Constants)
local Conversation = require(script.Parent.Conversation)
local DateTime = require(AppChatParent.Time).DateTime
local FFlagAppChatNilGuardMessageSort = require(AppChat.Flags.FFlagAppChatNilGuardMessageSort)

local function getMessageId(p1) -- line: 15
	return p1.id
end
local function messageSortPredicate(p2, p3) -- line: 19
	-- upvalues: FFlagAppChatNilGuardMessageSort (copy)
	if FFlagAppChatNilGuardMessageSort then
		local v20 = p2 and p2.sent
		local v21 = p3 and p3.sent

		if not v20 and not v21 then
			return (p2 and p2.id or "") > (p3 and p3.id or "")
		end

		if not v20 then
			return false
		end

		if not v21 then
			return true
		end
	end

	local UnixTimestamp = p2.sent:GetUnixTimestamp()
	local UnixTimestamp2 = p3.sent:GetUnixTimestamp()

	if UnixTimestamp == UnixTimestamp2 then
		return p2.id > p3.id
	end

	return UnixTimestamp < UnixTimestamp2
end
local function sendingMessageSortPredicate(t1: {[any]: any}, p4) -- line: 44
	return t1.order < p4.order
end
local function convertToLegacyConversationType(s1: string, s2: string) -- line: 50
	-- upvalues: Conversation (copy)
	if s2 == "friends" then
		return Conversation.Type.ONE_TO_ONE_CONVERSATION
	end

	if s1 == "group" then
		return Conversation.Type.MULTI_USER_CONVERSATION
	end

	if s1 == "one_to_one" then
		return Conversation.Type.ONE_TO_ONE_CONVERSATION
	end

	return Conversation.Type.ONE_TO_ONE_CONVERSATION
end
local function getFriendId(p5) -- line: 63
	-- upvalues: Players (copy)
	local LocalPlayer = Players.LocalPlayer

	if LocalPlayer then
		for _, v31 in p5.participant_user_ids do
			if tostring(v31) ~= tostring(LocalPlayer.UserId) then
				return "friends:" .. tostring(v31)
			end
		end
	end

	return "friends:unknown-id"
end

local t2 = {
	ModerationType = {
		TrustedComms = "trusted_comms",
		Moderated = "moderated",
		Invalid = "invalid",
		UnknownType = "unknown_type"
	},
	UserPendingStatus = {
		Invalid = "invalid",
		Pending = "pending",
		NotPending = "not_pending"
	},
	OsaAcknowledgementStatus = AppChatNetworking.Constants.OsaAcknowledgementStatusResponse,
	UserOptedIntoChatMessagesStatus = AppChatNetworking.Constants.UserOptedIntoChatMessagesStatusResponse,
	Source = {
		Friends = "friends",
		Channels = "channels",
		Chat = "chat"
	},
	Type = {
		Group = "group",
		OneToOne = "one_to_one"
	},
	getEmptyMessages = function() -- line: 107
		-- upvalues: OrderedMap (copy), getMessageId (copy), messageSortPredicate (copy)
		return OrderedMap.new(getMessageId, messageSortPredicate)
	end,
	getEmptySendingMessages = function() -- line: 110
		-- upvalues: OrderedMap (copy), getMessageId (copy), sendingMessageSortPredicate (copy)
		return OrderedMap.new(getMessageId, sendingMessageSortPredicate)
	end
}

function t2.mockBase() -- line: 114
	-- upvalues: t2 (copy), Conversation (copy), Constants (copy), DateTime (copy)
	return {
		source = "channels",
		type = "one_to_one",
		createdAt = nil,
		id = "1-2-3",
		clientId = "1-2-3",
		initiator = "1",
		hasUnreadMessages = false,
		hasGroupUp = false,
		isUserLeaving = false,
		fetchingOlderMessages = false,
		previewMessageId = nil,
		previewContent = nil,
		title = "test",
		titleForViewer = "test",
		isDefaultTitle = false,
		previousCursor = nil,
		nextCursor = nil,
		fetchedOldestMessage = nil,
		messages = t2.getEmptyMessages(),
		sendingMessages = t2.getEmptySendingMessages(),
		conversationType = Conversation.Type.ONE_TO_ONE_CONVERSATION,
		usersTyping = {},
		serverState = Constants.ServerState.CREATED,
		pinnedGame = {},
		moderationType = t2.ModerationType.TrustedComms,
		userPendingStatus = t2.UserPendingStatus.NotPending,
		participantPendingStatus = t2.UserPendingStatus.NotPending,
		lastUpdated = DateTime.now(),
		participants = { "1" },
		osaAcknowledgementStatus = t2.OsaAcknowledgementStatus.NotApplicable,
		userOptedIntoChatMessages = t2.UserOptedIntoChatMessagesStatus.NotApplicable
	}
end
function t2.mock(p6) -- line: 161
	-- upvalues: Cryo (copy), t2 (copy)
	return Cryo.Dictionary.join(t2.mockBase(), p6 or {})
end
function t2.response(t3: {[any]: any}) -- line: 165
	return {
		source = not t3.source and "channels" or t3.source,
		type = not t3.type and "one_to_one" or t3.type,
		created_at = not t3.created_at and "2021-01-01T00:00:00Z" or t3.created_at,
		created_by = not t3.created_by and 1 or t3.created_by,
		id = not t3.id and "1-2-3" or t3.id,
		name = not t3.name and "test" or t3.name,
		participant_user_ids = if not t3.participant_user_ids then { 1 } else t3.participant_user_ids,
		unread_message_count = not t3.unread_message_count and 0 or t3.unread_message_count,
		updated_at = not t3.updated_at and "2021-01-01T00:00:00Z" or t3.updated_at,
		messages = if not t3.messages then {} else t3.messages,
		moderation_type = not t3.moderation_type and "trusted_comms" or t3.moderation_type,
		user_pending_status = not t3.user_pending_status and "not_pending" or t3.user_pending_status,
		participant_pending_status = not t3.participant_pending_status and "not_pending" or t3.participant_pending_status,
		success = if not t3.success then nil else t3.success,
		preview_message = if not t3.preview_message then nil else t3.preview_message,
		hasGroupUp = not not t3.hasGroupUp and t3.hasGroupUp,
		osa_acknowledgement_status = if not t3.osa_acknowledgement_status then nil else t3.osa_acknowledgement_status,
		user_opted_into_chat_messages = if not t3.user_opted_into_chat_messages then nil else t3.user_opted_into_chat_messages
	}
end
function t2.fromChannelsApi(p7) -- line: 214
	-- upvalues: t2 (copy), getFriendId (copy), Conversation (copy), Constants (copy), DateTime (copy)
	local t4 = {
		source = p7.source,
		type = p7.type,
		createdAt = p7.created_at,
		messages = t2.getEmptyMessages(),
		sendingMessages = t2.getEmptySendingMessages(),
		id = if p7.source ~= "friends" then tostring(p7.id) else getFriendId(p7),
		clientId = "",
		initiator = tostring(p7.created_by),
		hasUnreadMessages = p7.unread_message_count > 0
	}
	local type = p7.type

	t4.conversationType = if p7.source ~= "friends" then if type ~= "group" then if type ~= "one_to_one" then Conversation.Type.ONE_TO_ONE_CONVERSATION else Conversation.Type.ONE_TO_ONE_CONVERSATION else Conversation.Type.MULTI_USER_CONVERSATION else Conversation.Type.ONE_TO_ONE_CONVERSATION
	t4.usersTyping = {}
	t4.isUserLeaving = false
	t4.fetchingOlderMessages = false
	t4.serverState = if p7.source ~= "friends" then Constants.ServerState.CREATED else Constants.ServerState.NONE
	t4.pinnedGame = {}
	t4.moderationType = p7.moderation_type
	t4.userPendingStatus = p7.user_pending_status
	t4.participantPendingStatus = p7.participant_pending_status

	local preview_message = p7.preview_message

	if preview_message then
		if preview_message.is_previewable then
			t4.previewMessageId = preview_message.id
		end

		t4.previewContent = preview_message.content or preview_message.preview_content
	end

	t4.hasGroupUp = not not p7.has_group_up and p7.has_group_up
	t4.lastUpdated = DateTime.fromIsoDate(p7.updated_at)
	t4.title = p7.name
	t4.titleForViewer = ""
	t4.isDefaultTitle = p7.name == nil
	t4.participants = {}

	if p7.participant_user_ids then
		for _, v39 in p7.participant_user_ids do
			table.insert(t4.participants, (tostring(v39)))
		end
	end

	if p7.osa_acknowledgement_status then
		t4.osaAcknowledgementStatus = p7.osa_acknowledgement_status
	end

	if p7.user_opted_into_chat_messages then
		t4.userOptedIntoChatMessages = p7.user_opted_into_chat_messages
	end

	return t4
end
function t2.getFriendConversationId(t5: {[any]: any}) -- line: 272
	-- upvalues: getFriendId (copy)
	return (getFriendId({
		participant_user_ids = t5
	}))
end

return t2
