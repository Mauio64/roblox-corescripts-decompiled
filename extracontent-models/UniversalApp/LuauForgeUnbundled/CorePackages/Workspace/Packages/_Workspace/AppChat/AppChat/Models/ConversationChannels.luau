local Players = game:GetService("Players")

local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")

local orderedMap = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppCommonLib").OrderedMap
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Constants")
local Conversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/Conversation")
local dateTime = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Time").DateTime

local function getMessageId(p2)
	return p2.id
end

local function messageSortPredicate(p2, p3): boolean
	local sent = p2 and p2.sent
	local sent2 = p3 and p3.sent

	if not (sent or sent2) then
		return (p2 and p2.id or "") > (p3 and p3.id or "")
	end

	if not sent then
		return false
	end

	if not sent2 then
		return true
	end

	local unixTimestamp = p2.sent:GetUnixTimestamp()
	local unixTimestamp2 = p3.sent:GetUnixTimestamp()

	if unixTimestamp == unixTimestamp2 then
		return p2.id > p3.id
	end

	return unixTimestamp < unixTimestamp2
end

local function sendingMessageSortPredicate(p2, p3): boolean
	return p2.order < p3.order
end

local function convertToLegacyConversationType(p2, p3)
	if p3 == "friends" then
		return Conversation.Type.ONE_TO_ONE_CONVERSATION
	end

	if p2 == "group" then
		return Conversation.Type.MULTI_USER_CONVERSATION
	end

	if p2 == "one_to_one" then
	end

	return Conversation.Type.ONE_TO_ONE_CONVERSATION
end

local function getFriendId(p2)
	local localPlayer = Players.LocalPlayer

	if localPlayer then
		for k, participant_user_id in p2.participant_user_ids do
			if tostring(participant_user_id) ~= tostring(localPlayer.UserId) then
				return "friends:" .. tostring(participant_user_id)
			end
		end
	end

	return "friends:unknown-id"
end

local function getConversationId(p2)
	if p2.source == "friends" then
		return getFriendId(p2)
	end

	return (tostring(p2.id))
end

local v5 = {
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
	["OsaAcknowledgementStatus"] = AppChatNetworking.Constants.OsaAcknowledgementStatusResponse,
	UserOptedIntoChatMessagesStatus = AppChatNetworking.Constants.UserOptedIntoChatMessagesStatusResponse,
	CallButtonEligibility = { Eligible = "eligible", Ineligible = "ineligible" },
	Source = { Friends = "friends", Channels = "channels", Chat = "chat" },
	Type = { Group = "group", OneToOne = "one_to_one" },
	getEmptyMessages = function()
		return orderedMap.new(getMessageId, messageSortPredicate)
	end,
	getEmptySendingMessages = function()
		return orderedMap.new(getMessageId, sendingMessageSortPredicate)
	end
}

function v5.mockBase()
	return {
		source = "channels",
		type = "one_to_one",
		createdAt = nil,
		messages = v5.getEmptyMessages(),
		sendingMessages = v5.getEmptySendingMessages(),
		id = "1-2-3",
		clientId = "1-2-3",
		initiator = "1",
		hasUnreadMessages = false,
		conversationType = Conversation.Type.ONE_TO_ONE_CONVERSATION,
		hasGroupUp = false,
		usersTyping = {},
		isUserLeaving = false,
		fetchingOlderMessages = false,
		serverState = Constants.ServerState.CREATED,
		pinnedGame = {},
		moderationType = v5.ModerationType.TrustedComms,
		userPendingStatus = v5.UserPendingStatus.NotPending,
		participantPendingStatus = v5.UserPendingStatus.NotPending,
		callButtonEligibility = nil,
		previewMessageId = nil,
		previewContent = nil,
		lastUpdated = dateTime.now(),
		title = "test",
		titleForViewer = "test",
		isDefaultTitle = false,
		participants = { "1" },
		osaAcknowledgementStatus = v5.OsaAcknowledgementStatus.NotApplicable,
		userOptedIntoChatMessages = v5.UserOptedIntoChatMessagesStatus.NotApplicable,
		previousCursor = nil,
		nextCursor = nil,
		fetchedOldestMessage = nil
	}
end

function v5.mock(options)
	return Cryo.Dictionary.join(v5.mockBase(), options or {})
end

function v5.response(data)
	local v6 = {
		source = not data.source and "channels" or data.source,
		type = not data.type and "one_to_one" or data.type,
		created_at = not data.created_at and "2021-01-01T00:00:00Z" or data.created_at,
		created_by = not data.created_by and 1 or data.created_by,
		id = not data.id and "1-2-3" or data.id,
		name = not data.name and "test" or data.name,
		participant_user_ids = not data.participant_user_ids and { 1 } or data.participant_user_ids,
		unread_message_count = not data.unread_message_count and 0 or data.unread_message_count,
		updated_at = not data.updated_at and "2021-01-01T00:00:00Z" or data.updated_at,
		messages = not data.messages and {} or data.messages,
		moderation_type = not data.moderation_type and "trusted_comms" or data.moderation_type,
		user_pending_status = not data.user_pending_status and "not_pending" or data.user_pending_status,
		participant_pending_status = not data.participant_pending_status and "not_pending" or data.participant_pending_status,
		success = 0,
		preview_message = 0,
		hasGroupUp = 0,
		osa_acknowledgement_status = 0,
		user_opted_into_chat_messages = 0,
		call_button_eligibility = 0
	}

	local v7 = if data.success then data.success else nil
	v6.success = v7
	local v8 = if data.preview_message then data.preview_message else nil
	v6.preview_message = v8
	local v9 = if data.hasGroupUp then data.hasGroupUp else false
	v6.hasGroupUp = v9
	local v10 = if data.osa_acknowledgement_status then data.osa_acknowledgement_status else nil
	v6.osa_acknowledgement_status = v10

	local v11 = if data.user_opted_into_chat_messages then data.user_opted_into_chat_messages else nil
	v6.user_opted_into_chat_messages = v11

	v6.call_button_eligibility = data.call_button_eligibility
	return v6
end

function v5.fromChannelsApi(data)
	local v6 = {}

	v6.source = data.source
	v6.type = data.type
	v6.createdAt = data.created_at

	v6.messages = v5.getEmptyMessages()
	v6.sendingMessages = v5.getEmptySendingMessages()
	local v7 = if data.source == "friends" then getFriendId(data) else tostring(data.id)

	v6.id = v7

	v6.clientId = ""
	v6.initiator = tostring(data.created_by)
	v6.hasUnreadMessages = data.unread_message_count > 0
	local kind = data.type
	local v8

	if data.source == "friends" then
		v8 = Conversation.Type.ONE_TO_ONE_CONVERSATION
	elseif kind == "group" then
		v8 = Conversation.Type.MULTI_USER_CONVERSATION
	else
		if kind == "one_to_one" then
		end

		v8 = Conversation.Type.ONE_TO_ONE_CONVERSATION
	end

	v6.conversationType = v8
	v6.usersTyping = {}
	v6.isUserLeaving = false
	v6.fetchingOlderMessages = false
	local v9 = if data.source == "friends" then Constants.ServerState.NONE else Constants.ServerState.CREATED
	v6.serverState = v9

	v6.pinnedGame = {}
	v6.moderationType = data.moderation_type
	v6.userPendingStatus = data.user_pending_status
	v6.participantPendingStatus = data.participant_pending_status
	v6.callButtonEligibility = data.call_button_eligibility
	local preview_message = data.preview_message

	if preview_message then
		if preview_message.is_previewable then
			v6.previewMessageId = preview_message.id
		end

		v6.previewContent = preview_message.content or preview_message.preview_content
	end

	local v10 = if data.has_group_up then data.has_group_up else false
	v6.hasGroupUp = v10
	v6.lastUpdated = dateTime.fromIsoDate(data.updated_at)

	v6.title = data.name
	v6.titleForViewer = ""
	v6.isDefaultTitle = data.name == nil

	v6.participants = {}

	if data.participant_user_ids then
		for k, participant_user_id in data.participant_user_ids do
			table.insert(v6.participants, (tostring(participant_user_id)))
		end
	end

	if data.osa_acknowledgement_status then
		v6.osaAcknowledgementStatus = data.osa_acknowledgement_status
	end

	if data.user_opted_into_chat_messages then
		v6.userOptedIntoChatMessages = data.user_opted_into_chat_messages
	end

	return v6
end

function v5.getFriendConversationId(p2)
	return getFriendId({ participant_user_ids = p2 })
end

function v5.getConversationId(p2)
	if p2.source == "friends" then
		return getFriendId(p2)
	end

	return (tostring(p2.id))
end

return v5
