local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local GenerateStringId = require(AppChatParent.AppCommonLib).GenerateStringId
local OrderedMap = require(AppChatParent.AppCommonLib).OrderedMap
local Constants = require(AppChat.Constants)
local DateTime = require(AppChatParent.Time).DateTime
local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local Players = game:GetService("Players")

local function getMessageId(p1) -- line: 13
	return p1.id
end
local function messageSortPredicate(p2, p3) -- line: 17
	return p2.sent:GetUnixTimestamp() < p3.sent:GetUnixTimestamp()
end
local function sendingMessageSortPredicate(p4, p5) -- line: 24
	return p4.order < p5.order
end

local t1 = {
	Type = {
		MULTI_USER_CONVERSATION = "MultiUserConversation",
		ONE_TO_ONE_CONVERSATION = "OneToOneConversation"
	},
	OsaAcknowledgementStatus = AppChatNetworking.Constants.OsaAcknowledgementStatusResponse,
	UserOptedIntoChatMessagesStatus = AppChatNetworking.Constants.UserOptedIntoChatMessagesStatusResponse
}

function t1.IdForFakeOneOnOne(p6) -- line: 38
	-- upvalues: t1 (copy)
	local ONE_TO_ONE_CONVERSATION = t1.Type.ONE_TO_ONE_CONVERSATION

	table.sort(p6)

	for _, v in ipairs(p6) do
		ONE_TO_ONE_CONVERSATION ..= "-" .. tostring(v)
	end

	return ONE_TO_ONE_CONVERSATION
end
function t1.new() -- line: 50
	return {}
end
function t1.fromUser(p7) -- line: 56
	-- upvalues: t1 (copy), OrderedMap (copy), getMessageId (copy), messageSortPredicate (copy), sendingMessageSortPredicate (copy), GenerateStringId (copy), Players (copy), Constants (copy)
	local v23 = t1.new()

	v23.messages = OrderedMap.new(getMessageId, messageSortPredicate)
	v23.sendingMessages = OrderedMap.new(getMessageId, sendingMessageSortPredicate)
	v23.clientId = GenerateStringId()
	v23.initiator = nil
	v23.hasUnreadMessages = false
	v23.conversationType = t1.Type.ONE_TO_ONE_CONVERSATION
	v23.participants = {
		tostring(Players.LocalPlayer.UserId),
		p7.id
	}
	v23.usersTyping = {}
	v23.isUserLeaving = false
	v23.fetchingOlderMessages = false
	v23.fetchedOldestMessage = false
	v23.serverState = Constants.ServerState.NONE
	v23.id = t1.IdForFakeOneOnOne(v23.participants)
	v23.lastUpdated = nil
	v23.isDefaultTitle = true
	v23.title = p7.displayName or p7.name

	return v23
end
function t1.empty(p8) -- line: 82
	-- upvalues: t1 (copy), OrderedMap (copy), getMessageId (copy), messageSortPredicate (copy), sendingMessageSortPredicate (copy), Constants (copy), DateTime (copy)
	local v25 = t1.new()

	v25.id = "-1"
	v25.messages = OrderedMap.new(getMessageId, messageSortPredicate)
	v25.sendingMessages = OrderedMap.new(getMessageId, sendingMessageSortPredicate)
	v25.title = ""
	v25.initiator = "0"
	v25.hasUnreadMessages = false
	v25.conversationType = t1.Type.MULTI_USER_CONVERSATION
	v25.participants = {}
	v25.usersTyping = {}
	v25.isUserLeaving = false
	v25.fetchingOlderMessages = false
	v25.serverState = Constants.ServerState.NONE
	v25.pinnedGame = {}
	v25.lastUpdated = DateTime.now()
	v25.isDefaultTitle = true
	v25.osaAcknowledgementStatus = t1.OsaAcknowledgementStatus.NotApplicable
	v25.userOptedIntoChatMessages = t1.UserOptedIntoChatMessagesStatus.NotApplicable

	if p8 ~= nil then
		for k, v in pairs(p8) do
			v25[k] = v
		end
	end

	return v25
end
function t1.fromWeb(p9, p10) -- line: 116
	-- upvalues: t1 (copy), OrderedMap (copy), getMessageId (copy), messageSortPredicate (copy), sendingMessageSortPredicate (copy), GenerateStringId (copy), Constants (copy), DateTime (copy)
	local v30 = t1.new()

	v30.messages = OrderedMap.new(getMessageId, messageSortPredicate)
	v30.sendingMessages = OrderedMap.new(getMessageId, sendingMessageSortPredicate)
	v30.id = tostring(p9.id)
	v30.clientId = p10 or GenerateStringId()
	v30.title = p9.title
	v30.initiator = tostring(p9.initiator.targetId)
	v30.hasUnreadMessages = p9.hasUnreadMessages
	v30.conversationType = p9.conversationType
	v30.participants = {}
	v30.usersTyping = {}
	v30.isUserLeaving = false
	v30.fetchingOlderMessages = false
	v30.serverState = Constants.ServerState.CREATED
	v30.pinnedGame = {}

	if p9.conversationUniverse ~= nil then
		v30.pinnedGame.universeId = tostring(p9.conversationUniverse.universeId)
		v30.pinnedGame.rootPlaceId = tostring(p9.conversationUniverse.rootPlaceId)
	end

	v30.lastUpdated = DateTime.fromIsoDate(p9.lastUpdated)
	v30.titleForViewer = p9.conversationTitle.titleForViewer
	v30.isDefaultTitle = p9.conversationTitle.isDefaultTitle

	for _, v in ipairs(p9.participants) do
		table.insert(v30.participants, (tostring(v.targetId)))
	end

	return v30
end

return t1
