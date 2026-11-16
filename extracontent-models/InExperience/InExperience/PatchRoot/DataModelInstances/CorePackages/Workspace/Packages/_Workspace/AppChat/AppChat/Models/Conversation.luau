local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local AppCommonLib = require(parent.AppCommonLib)
local GenerateStringId = AppCommonLib.GenerateStringId
local AppCommonLib2 = require(parent.AppCommonLib)
local OrderedMap = AppCommonLib2.OrderedMap
local Constants = require(AppChat.Constants)
local Time = require(parent.Time)
local DateTime = Time.DateTime
local AppChatNetworking = require(parent.AppChatNetworking)

local Players = game:GetService("Players")

local function getMessageId(p)
	return p.id
end

local function messageSortPredicate(p, p2): boolean
	return p.sent:GetUnixTimestamp() < p2.sent:GetUnixTimestamp()
end

local function sendingMessageSortPredicate(p, p2): boolean
	return p.order < p2.order
end

local Conversation = {}

Conversation.Type = {
	MULTI_USER_CONVERSATION = "MultiUserConversation",
	ONE_TO_ONE_CONVERSATION = "OneToOneConversation"
}

Conversation.OsaAcknowledgementStatus = AppChatNetworking.Constants.OsaAcknowledgementStatusResponse
Conversation.UserOptedIntoChatMessagesStatus = AppChatNetworking.Constants.UserOptedIntoChatMessagesStatusResponse

function Conversation.IdForFakeOneOnOne(list)
	local v = Conversation.Type.ONE_TO_ONE_CONVERSATION
	table.sort(list)

	for _, item in ipairs(list) do
		v ..= "-" .. tostring(item)
	end

	return v
end

function Conversation.new()
	return {}
end

function Conversation.fromUser(data)
	local v = Conversation.new()

	v.messages = OrderedMap.new(getMessageId, messageSortPredicate)
	v.sendingMessages = OrderedMap.new(getMessageId, sendingMessageSortPredicate)
	v.clientId = GenerateStringId()
	v.initiator = nil
	v.hasUnreadMessages = false
	v.conversationType = Conversation.Type.ONE_TO_ONE_CONVERSATION
	v.participants = { tostring(Players.LocalPlayer.UserId), data.id }
	v.usersTyping = {}
	v.isUserLeaving = false
	v.fetchingOlderMessages = false
	v.fetchedOldestMessage = false
	v.serverState = Constants.ServerState.NONE

	v.id = Conversation.IdForFakeOneOnOne(v.participants)
	v.lastUpdated = nil

	v.isDefaultTitle = true

	v.title = data.displayName or data.name

	return v
end

function Conversation.empty(items)
	local result = Conversation.new()

	result.id = "-1"
	result.messages = OrderedMap.new(getMessageId, messageSortPredicate)
	result.sendingMessages = OrderedMap.new(getMessageId, sendingMessageSortPredicate)
	result.title = ""
	result.initiator = "0"
	result.hasUnreadMessages = false
	result.conversationType = Conversation.Type.MULTI_USER_CONVERSATION
	result.participants = {}
	result.usersTyping = {}
	result.isUserLeaving = false
	result.fetchingOlderMessages = false
	result.serverState = Constants.ServerState.NONE
	result.pinnedGame = {}

	result.lastUpdated = DateTime.now()

	result.isDefaultTitle = true

	result.osaAcknowledgementStatus = Conversation.OsaAcknowledgementStatus.NotApplicable
	result.userOptedIntoChatMessages = Conversation.UserOptedIntoChatMessagesStatus.NotApplicable

	if items ~= nil then
		for k, item in pairs(items) do
			result[k] = item
		end
	end

	return result
end

function Conversation.fromWeb(data, p)
	local v = Conversation.new()

	v.messages = OrderedMap.new(getMessageId, messageSortPredicate)
	v.sendingMessages = OrderedMap.new(getMessageId, sendingMessageSortPredicate)
	v.id = tostring(data.id)
	v.clientId = p or GenerateStringId()
	v.title = data.title
	v.initiator = tostring(data.initiator.targetId)
	v.hasUnreadMessages = data.hasUnreadMessages
	v.conversationType = data.conversationType
	v.participants = {}
	v.usersTyping = {}
	v.isUserLeaving = false
	v.fetchingOlderMessages = false
	v.serverState = Constants.ServerState.CREATED
	v.pinnedGame = {}

	if data.conversationUniverse ~= nil then
		v.pinnedGame.universeId = tostring(data.conversationUniverse.universeId)
		v.pinnedGame.rootPlaceId = tostring(data.conversationUniverse.rootPlaceId)
	end

	v.lastUpdated = DateTime.fromIsoDate(data.lastUpdated)

	v.titleForViewer = data.conversationTitle.titleForViewer
	v.isDefaultTitle = data.conversationTitle.isDefaultTitle

	for _, participant in ipairs(data.participants) do
		table.insert(v.participants, (tostring(participant.targetId)))
	end

	return v
end

return Conversation
