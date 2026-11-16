local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local dateTime = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Time").DateTime

local ConversationChannels = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/ConversationChannels")

local v5 = {}

local function hasIteratorMember(p2): boolean
	return type(p2) == "table" and p2.CreateIterator ~= nil
end

function v5.isFriendsPlaceholderConversationId(value): boolean
	return type(value) == "string" and string.sub(value, 1, 8) == "friends:"
end

function v5.isFriendsPlaceholderConversation(p2, p3)
	if p3 == nil then
		return v5.isFriendsPlaceholderConversationId(p2)
	end

	return p3.source == ConversationChannels.Source.Friends
end

function v5.normalizeStoreConversationForRodux(data)
	local lastUpdated = data.lastUpdated
	local v6 = nil

	if typeof(lastUpdated) == "DateTime" then
		v6 = dateTime.fromUnixTimestamp(lastUpdated.UnixTimestamp)
	elseif type(lastUpdated) == "table" and typeof(lastUpdated.dateTime) == "DateTime" then
		v6 = dateTime.fromUnixTimestamp(lastUpdated.dateTime.UnixTimestamp)
	end

	local messages = data.messages
	local v7 = type(messages) == "table" and messages.CreateIterator ~= nil

	local v8 = if v7 then data.messages else ConversationChannels.getEmptyMessages()
	local sendingMessages = data.sendingMessages
	local v9 = type(sendingMessages) == "table" and sendingMessages.CreateIterator ~= nil

	local v10 = if v9 then data.sendingMessages else ConversationChannels.getEmptySendingMessages()

	if v6 == nil and v8 == data.messages and v10 == data.sendingMessages then
		return data
	end

	return Cryo.Dictionary.join(data, {
		lastUpdated = v6 or lastUpdated,
		messages = v8,
		sendingMessages = v10
	})
end

return v5
