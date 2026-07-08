local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local GenerateStringId = require(AppChatParent.AppCommonLib).GenerateStringId
local OrderedMap = require(AppChatParent.AppCommonLib).OrderedMap
local Constants = require(AppChat.Constants)
local DateTime = require(AppChatParent.Time).DateTime
local Conversation = require(script.Parent.Conversation)

local function getMessageId(p1) -- line: 11
	return p1.id
end
local function messageSortPredicate(p2, p3) -- line: 15
	return p2.sent:GetUnixTimestamp() < p3.sent:GetUnixTimestamp()
end
local function sendingMessageSortPredicate(p4, p5) -- line: 22
	return p4.order < p5.order
end

local t1 = {}

t1.__index = t1

function t1.mock(t2: {[any]: any}?) -- line: 29
	-- upvalues: Conversation (copy), OrderedMap (copy), getMessageId (copy), messageSortPredicate (copy), sendingMessageSortPredicate (copy), GenerateStringId (copy), Constants (copy), DateTime (copy)
	local v18 = Conversation.new()

	v18.messages = OrderedMap.new(getMessageId, messageSortPredicate)
	v18.sendingMessages = OrderedMap.new(getMessageId, sendingMessageSortPredicate)
	v18.id = GenerateStringId()
	v18.clientId = GenerateStringId()
	v18.title = ""
	v18.initiator = GenerateStringId()
	v18.hasUnreadMessages = false
	v18.conversationType = Conversation.Type.MULTI_USER_CONVERSATION
	v18.participants = {}
	v18.usersTyping = {}
	v18.isUserLeaving = false
	v18.fetchingOlderMessages = false
	v18.fetchedOldestMessage = false
	v18.serverState = Constants.ServerState.NONE
	v18.pinnedGame = {}
	v18.pinnedGame.universeId = GenerateStringId()
	v18.pinnedGame.rootPlaceId = GenerateStringId()
	v18.lastUpdated = DateTime.now()
	v18.titleForViewer = "title"
	v18.isDefaultTitle = true

	if t2 ~= nil then
		for k, v in pairs(t2) do
			v18[k] = v
		end
	end

	setmetatable(v18, {
		__index = Conversation
	})

	return v18
end

return t1
