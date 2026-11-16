local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Cryo = require(parent.Cryo)
local Time = require(parent.Time)
local DateTime = Time.DateTime

local ConversationChannels = require(AppChat.Models.ConversationChannels)

local ConversationRoduxSeed = {}

local function hasIteratorMember(p): boolean -- 2 equivalent calls inferred from this helper
	return type(p) == "table" and p.CreateIterator ~= nil
end

function ConversationRoduxSeed.isFriendsPlaceholderConversationId(value): boolean
	return type(value) == "string" and string.sub(value, 1, 8) == "friends:"
end

function ConversationRoduxSeed.isFriendsPlaceholderConversation(p, p2)
	if p2 == nil then
		return ConversationRoduxSeed.isFriendsPlaceholderConversationId(p)
	end

	return p2.source == ConversationChannels.Source.Friends
end

function ConversationRoduxSeed.normalizeStoreConversationForRodux(data)
	local lastUpdated = data.lastUpdated
	local v = nil

	if typeof(lastUpdated) == "DateTime" then
		v = DateTime.fromUnixTimestamp(lastUpdated.UnixTimestamp)
	elseif type(lastUpdated) == "table" and typeof(lastUpdated.dateTime) == "DateTime" then
		v = DateTime.fromUnixTimestamp(lastUpdated.dateTime.UnixTimestamp)
	end

	local iteratorMember = hasIteratorMember(data.messages) -- inferred equivalent call
	local messages

	if iteratorMember then
		messages = data.messages
	else
		messages = ConversationChannels.getEmptyMessages()
	end

	local iteratorMember2 = hasIteratorMember(data.sendingMessages) -- inferred equivalent call
	local sendingMessages

	if iteratorMember2 then
		sendingMessages = data.sendingMessages
	else
		sendingMessages = ConversationChannels.getEmptySendingMessages()
	end

	if v == nil and messages == data.messages and sendingMessages == data.sendingMessages then
		return data
	end

	return Cryo.Dictionary.join(data, {
		lastUpdated = v or lastUpdated,
		messages = messages,
		sendingMessages = sendingMessages
	})
end

return ConversationRoduxSeed
