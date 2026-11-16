local generateStringId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppCommonLib").GenerateStringId
local orderedMap = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppCommonLib").OrderedMap
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Constants")
local dateTime = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Time").DateTime

local Conversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/Conversation")

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
v5.__index = v5

function v5.mock(items)
	local result = Conversation.new()

	result.messages = orderedMap.new(getMessageId, messageSortPredicate)
	result.sendingMessages = orderedMap.new(getMessageId, sendingMessageSortPredicate)
	result.id = generateStringId()

	result.clientId = generateStringId()
	result.title = ""
	result.initiator = generateStringId()
	result.hasUnreadMessages = false
	result.conversationType = Conversation.Type.MULTI_USER_CONVERSATION
	result.participants = {}
	result.usersTyping = {}
	result.isUserLeaving = false
	result.fetchingOlderMessages = false
	result.fetchedOldestMessage = false
	result.serverState = Constants.ServerState.NONE
	result.pinnedGame = {}
	result.pinnedGame.universeId = generateStringId()
	result.pinnedGame.rootPlaceId = generateStringId()

	result.lastUpdated = dateTime.now()

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

return v5
