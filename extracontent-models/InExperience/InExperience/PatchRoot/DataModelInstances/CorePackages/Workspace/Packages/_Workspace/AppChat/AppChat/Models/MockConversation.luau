local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local AppCommonLib = require(parent.AppCommonLib)
local GenerateStringId = AppCommonLib.GenerateStringId
local AppCommonLib2 = require(parent.AppCommonLib)
local OrderedMap = AppCommonLib2.OrderedMap
local Constants = require(AppChat.Constants)
local Time = require(parent.Time)
local DateTime = Time.DateTime

local Conversation = require(script.Parent.Conversation)

local function getMessageId(p)
	return p.id
end

local function messageSortPredicate(p, p2): boolean
	return p.sent:GetUnixTimestamp() < p2.sent:GetUnixTimestamp()
end

local function sendingMessageSortPredicate(p, p2): boolean
	return p.order < p2.order
end

local MockConversation = {}
MockConversation.__index = MockConversation

function MockConversation.mock(items)
	local result = Conversation.new()

	result.messages = OrderedMap.new(getMessageId, messageSortPredicate)
	result.sendingMessages = OrderedMap.new(getMessageId, sendingMessageSortPredicate)
	result.id = GenerateStringId()

	result.clientId = GenerateStringId()
	result.title = ""
	result.initiator = GenerateStringId()
	result.hasUnreadMessages = false
	result.conversationType = Conversation.Type.MULTI_USER_CONVERSATION
	result.participants = {}
	result.usersTyping = {}
	result.isUserLeaving = false
	result.fetchingOlderMessages = false
	result.fetchedOldestMessage = false
	result.serverState = Constants.ServerState.NONE
	result.pinnedGame = {}
	result.pinnedGame.universeId = GenerateStringId()
	result.pinnedGame.rootPlaceId = GenerateStringId()

	result.lastUpdated = DateTime.now()

	result.titleForViewer = "title"
	result.isDefaultTitle = true

	if items ~= nil then
		for k, item in pairs(items) do
			result[k] = item
		end
	end

	setmetatable(result, { __index = Conversation })

	return result
end

return MockConversation
