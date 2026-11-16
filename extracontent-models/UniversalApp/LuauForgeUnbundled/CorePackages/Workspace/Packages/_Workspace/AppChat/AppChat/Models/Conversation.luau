local generateStringId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppCommonLib").GenerateStringId
local orderedMap = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppCommonLib").OrderedMap
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Constants")
local dateTime = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Time").DateTime
local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")

local Players = game:GetService("Players")

local function getMessageId(p2)
	return p2.id
end

local function messageSortPredicate(p2, p3): boolean
	return p2.sent:GetUnixTimestamp() < p3.sent:GetUnixTimestamp()
end

local function sendingMessageSortPredicate(p2, p3): boolean
	return p2.order < p3.order
end

local v5 = {}

v5.Type = {
	MULTI_USER_CONVERSATION = "MultiUserConversation",
	ONE_TO_ONE_CONVERSATION = "OneToOneConversation"
}

v5.OsaAcknowledgementStatus = AppChatNetworking.Constants.OsaAcknowledgementStatusResponse
v5.UserOptedIntoChatMessagesStatus = AppChatNetworking.Constants.UserOptedIntoChatMessagesStatusResponse

function v5.IdForFakeOneOnOne(list)
	local v6 = v5.Type.ONE_TO_ONE_CONVERSATION
	table.sort(list)

	for i, item in ipairs(list) do
		v6 ..= "-" .. tostring(item)
	end

	return v6
end

function v5.new()
	return {}
end

function v5.fromUser(data)
	local v6 = v5.new()

	v6.messages = orderedMap.new(getMessageId, messageSortPredicate)
	v6.sendingMessages = orderedMap.new(getMessageId, sendingMessageSortPredicate)
	v6.clientId = generateStringId()
	v6.initiator = nil
	v6.hasUnreadMessages = false
	v6.conversationType = v5.Type.ONE_TO_ONE_CONVERSATION
	v6.participants = { tostring(Players.LocalPlayer.UserId), data.id }
	v6.usersTyping = {}
	v6.isUserLeaving = false
	v6.fetchingOlderMessages = false
	v6.fetchedOldestMessage = false
	v6.serverState = Constants.ServerState.NONE

	v6.id = v5.IdForFakeOneOnOne(v6.participants)
	v6.lastUpdated = nil

	v6.isDefaultTitle = true

	v6.title = data.displayName or data.name

	return v6
end

function v5.empty(items)
	local result = v5.new()

	result.id = "-1"
	result.messages = orderedMap.new(getMessageId, messageSortPredicate)
	result.sendingMessages = orderedMap.new(getMessageId, sendingMessageSortPredicate)
	result.title = ""
	result.initiator = "0"
	result.hasUnreadMessages = false
	result.conversationType = v5.Type.MULTI_USER_CONVERSATION
	result.participants = {}
	result.usersTyping = {}
	result.isUserLeaving = false
	result.fetchingOlderMessages = false
	result.serverState = Constants.ServerState.NONE
	result.pinnedGame = {}

	result.lastUpdated = dateTime.now()

	result.isDefaultTitle = true

	result.osaAcknowledgementStatus = v5.OsaAcknowledgementStatus.NotApplicable
	result.userOptedIntoChatMessages = v5.UserOptedIntoChatMessagesStatus.NotApplicable

	if items ~= nil then
		for k, item in pairs(items) do
			result[k] = item
		end
	end

	return result
end

function v5.fromWeb(data, p2)
	local v6 = v5.new()

	v6.messages = orderedMap.new(getMessageId, messageSortPredicate)
	v6.sendingMessages = orderedMap.new(getMessageId, sendingMessageSortPredicate)
	v6.id = tostring(data.id)
	v6.clientId = p2 or generateStringId()
	v6.title = data.title
	v6.initiator = tostring(data.initiator.targetId)
	v6.hasUnreadMessages = data.hasUnreadMessages
	v6.conversationType = data.conversationType
	v6.participants = {}
	v6.usersTyping = {}
	v6.isUserLeaving = false
	v6.fetchingOlderMessages = false
	v6.serverState = Constants.ServerState.CREATED
	v6.pinnedGame = {}

	if data.conversationUniverse ~= nil then
		v6.pinnedGame.universeId = tostring(data.conversationUniverse.universeId)
		v6.pinnedGame.rootPlaceId = tostring(data.conversationUniverse.rootPlaceId)
	end

	v6.lastUpdated = dateTime.fromIsoDate(data.lastUpdated)

	v6.titleForViewer = data.conversationTitle.titleForViewer
	v6.isDefaultTitle = data.conversationTitle.isDefaultTitle

	for i, participant in ipairs(data.participants) do
		table.insert(v6.participants, (tostring(participant.targetId)))
	end

	return v6
end

return v5
