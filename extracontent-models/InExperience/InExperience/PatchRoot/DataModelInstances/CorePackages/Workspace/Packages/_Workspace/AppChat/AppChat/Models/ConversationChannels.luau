local Players = game:GetService("Players")

local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent
local AppChatNetworking = require(parent.AppChatNetworking)
local Cryo = require(parent.Cryo)

local AppCommonLib = require(parent.AppCommonLib)
local OrderedMap = AppCommonLib.OrderedMap
local Constants = require(AppChat.Constants)
local Conversation = require(script.Parent.Conversation)
local Time = require(parent.Time)
local DateTime = Time.DateTime

local function getMessageId(p)
	return p.id
end

local function messageSortPredicate(p, p2): boolean
	local sent = p and p.sent
	local sent2 = p2 and p2.sent

	if not (sent or sent2) then
		return (p and p.id or "") > (p2 and p2.id or "")
	end

	if not sent then
		return false
	end

	if not sent2 then
		return true
	end

	local unixTimestamp = p.sent:GetUnixTimestamp()
	local unixTimestamp2 = p2.sent:GetUnixTimestamp()

	if unixTimestamp == unixTimestamp2 then
		return p.id > p2.id
	end

	return unixTimestamp < unixTimestamp2
end

local function sendingMessageSortPredicate(p, p2): boolean
	return p.order < p2.order
end

local function convertToLegacyConversationType(kind: string, source: string) -- 1 equivalent call inferred from this helper
	if source == "friends" then
		return Conversation.Type.ONE_TO_ONE_CONVERSATION
	end

	if kind == "group" then
		return Conversation.Type.MULTI_USER_CONVERSATION
	end

	if kind == "one_to_one" then
	end

	return Conversation.Type.ONE_TO_ONE_CONVERSATION
end

local function getFriendId(p)
	local localPlayer = Players.LocalPlayer

	if localPlayer then
		for _, participant_user_id in p.participant_user_ids do
			if tostring(participant_user_id) ~= tostring(localPlayer.UserId) then
				return "friends:" .. tostring(participant_user_id)
			end
		end
	end

	return "friends:unknown-id"
end

local function getConversationId(p) -- 2 equivalent calls inferred from this helper
	if p.source == "friends" then
		return getFriendId(p)
	end

	return (tostring(p.id))
end

local ConversationChannels = {
	ModerationType = {
		TrustedComms = "trusted_comms",
		Moderated = "moderated",
		Invalid = "invalid",
		UnknownType = "unknown_type"
	},
	UserPendingStatus = { Invalid = "invalid", Pending = "pending", NotPending = "not_pending" },
	["OsaAcknowledgementStatus"] = AppChatNetworking.Constants.OsaAcknowledgementStatusResponse,
	UserOptedIntoChatMessagesStatus = AppChatNetworking.Constants.UserOptedIntoChatMessagesStatusResponse,
	CallButtonEligibility = { Eligible = "eligible", Ineligible = "ineligible" },
	Source = { Friends = "friends", Channels = "channels", Chat = "chat" },
	Type = { Group = "group", OneToOne = "one_to_one" },
	getEmptyMessages = function()
		return OrderedMap.new(getMessageId, messageSortPredicate)
	end,
	getEmptySendingMessages = function()
		return OrderedMap.new(getMessageId, sendingMessageSortPredicate)
	end
}

function ConversationChannels.mockBase()
	return {
		source = "channels",
		type = "one_to_one",
		createdAt = nil,
		messages = ConversationChannels.getEmptyMessages(),
		sendingMessages = ConversationChannels.getEmptySendingMessages(),
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
		moderationType = ConversationChannels.ModerationType.TrustedComms,
		userPendingStatus = ConversationChannels.UserPendingStatus.NotPending,
		participantPendingStatus = ConversationChannels.UserPendingStatus.NotPending,
		callButtonEligibility = nil,
		previewMessageId = nil,
		previewContent = nil,
		lastUpdated = DateTime.now(),
		title = "test",
		titleForViewer = "test",
		isDefaultTitle = false,
		participants = { "1" },
		osaAcknowledgementStatus = ConversationChannels.OsaAcknowledgementStatus.NotApplicable,
		userOptedIntoChatMessages = ConversationChannels.UserOptedIntoChatMessagesStatus.NotApplicable,
		previousCursor = nil,
		nextCursor = nil,
		fetchedOldestMessage = nil
	}
end

function ConversationChannels.mock(options)
	return Cryo.Dictionary.join(ConversationChannels.mockBase(), options or {})
end

function ConversationChannels.response(data)
	local v = {
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
	local success

	if data.success then
		success = data.success
	end

	v.success = success
	local preview_message

	if data.preview_message then
		preview_message = data.preview_message
	end

	v.preview_message = preview_message
	local hasGroupUp

	if data.hasGroupUp then
		hasGroupUp = data.hasGroupUp
	else
		hasGroupUp = false
	end

	v.hasGroupUp = hasGroupUp
	local osa_acknowledgement_status

	if data.osa_acknowledgement_status then
		osa_acknowledgement_status = data.osa_acknowledgement_status
	end

	v.osa_acknowledgement_status = osa_acknowledgement_status
	local user_opted_into_chat_messages

	if data.user_opted_into_chat_messages then
		user_opted_into_chat_messages = data.user_opted_into_chat_messages
	end

	v.user_opted_into_chat_messages = user_opted_into_chat_messages

	v.call_button_eligibility = data.call_button_eligibility
	return v
end

function ConversationChannels.fromChannelsApi(data)
	local v = {}

	v.source = data.source
	v.type = data.type
	v.createdAt = data.created_at

	v.messages = ConversationChannels.getEmptyMessages()
	v.sendingMessages = ConversationChannels.getEmptySendingMessages()
	v.id = getConversationId(data) -- inferred equivalent call
	v.clientId = ""
	v.initiator = tostring(data.created_by)
	v.hasUnreadMessages = data.unread_message_count > 0
	v.conversationType = convertToLegacyConversationType(data.type, data.source) -- inferred equivalent call
	v.usersTyping = {}
	v.isUserLeaving = false
	v.fetchingOlderMessages = false
	local serverState

	if data.source == "friends" then
		serverState = Constants.ServerState.NONE
	else
		serverState = Constants.ServerState.CREATED
	end

	v.serverState = serverState

	v.pinnedGame = {}
	v.moderationType = data.moderation_type
	v.userPendingStatus = data.user_pending_status
	v.participantPendingStatus = data.participant_pending_status
	v.callButtonEligibility = data.call_button_eligibility
	local preview_message = data.preview_message

	if preview_message then
		if preview_message.is_previewable then
			v.previewMessageId = preview_message.id
		end

		v.previewContent = preview_message.content or preview_message.preview_content
	end

	local hasGroupUp

	if data.has_group_up then
		hasGroupUp = data.has_group_up
	else
		hasGroupUp = false
	end

	v.hasGroupUp = hasGroupUp
	v.lastUpdated = DateTime.fromIsoDate(data.updated_at)

	v.title = data.name
	v.titleForViewer = ""
	v.isDefaultTitle = data.name == nil

	v.participants = {}

	if data.participant_user_ids then
		for _, participant_user_id in data.participant_user_ids do
			table.insert(v.participants, (tostring(participant_user_id)))
		end
	end

	if data.osa_acknowledgement_status then
		v.osaAcknowledgementStatus = data.osa_acknowledgement_status
	end

	if data.user_opted_into_chat_messages then
		v.userOptedIntoChatMessages = data.user_opted_into_chat_messages
	end

	return v
end

function ConversationChannels.getFriendConversationId(participant_user_ids)
	return getFriendId({ participant_user_ids = participant_user_ids })
end

function ConversationChannels.getConversationId(p)
	return getConversationId(p) -- inferred equivalent call
end

return ConversationChannels
