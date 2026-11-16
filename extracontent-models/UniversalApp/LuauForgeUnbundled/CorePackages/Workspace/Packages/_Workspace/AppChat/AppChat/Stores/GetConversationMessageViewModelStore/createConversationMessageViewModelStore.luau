local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")

require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/MessageData/Types")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/MessageData/Enums")
local FFlagAppChatParseMessageTimestampsOnce = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatParseMessageTimestampsOnce")
local FFlagAppChatGroupedVariantNeighbourIds = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatGroupedVariantNeighbourIds")
local parseIsoDateUnixMillis = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/parseIsoDateUnixMillis")

require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationMessageStore/createConversationMessageStore")

require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationMessageListStore/createConversationMessageListStore")

local groupedMessageVariant = Enums.GroupedMessageVariant
local messageStatus = Enums.MessageStatus
local messageType = Enums.MessageType
local messageVisibility = Enums.MessageVisibility

local function isChatMessage(p2): boolean
	if p2 == nil then
		return false
	end

	return p2.type == messageType.User
end

local function parseTimestamp(p2)
	if p2 == nil then
		return nil
	end

	local dateTime = DateTime.fromIsoDate(p2)

	if dateTime then
		return dateTime.UnixTimestamp
	end

	return nil
end

local function getCreatedAtUnixTimestamp(p2)
	local v5 = p2.createdAtUnixMillis

	if v5 == nil then
		v5 = parseIsoDateUnixMillis(p2.created_at)
	end

	if v5 == nil then
		return nil
	end

	return (math.floor(v5 / 1000))
end

local function timeDiffExceedsThreshold(data, data2): boolean
	if data == nil or data2 == nil then
		return false
	end

	local v5

	if FFlagAppChatParseMessageTimestampsOnce then
		local v6 = data.createdAtUnixMillis

		if v6 == nil then
			v6 = parseIsoDateUnixMillis(data.created_at)
		end

		if v6 ~= nil then
			v5 = math.floor(v6 / 1000)
		end
	else
		local created_at = data.created_at

		if created_at ~= nil then
			local dateTime = DateTime.fromIsoDate(created_at)

			if dateTime then
				v5 = dateTime.UnixTimestamp
			end
		end
	end

	local v6

	if FFlagAppChatParseMessageTimestampsOnce then
		local v7 = data2.createdAtUnixMillis

		if v7 == nil then
			v7 = parseIsoDateUnixMillis(data2.created_at)
		end

		if v7 ~= nil then
			v6 = math.floor(v7 / 1000)
		end
	else
		local created_at = data2.created_at

		if created_at ~= nil then
			local dateTime = DateTime.fromIsoDate(created_at)

			if dateTime then
				v6 = dateTime.UnixTimestamp
			end
		end
	end

	if v5 == nil or v6 == nil then
		return false
	end

	return math.abs(v5 - v6) > 300
end

local function isModeratedMessage(p2): boolean
	return p2 ~= nil and p2.status == messageStatus.Moderated
end

local function isHiddenMessage(p2): boolean
	return p2 ~= nil and p2.visibility == messageVisibility.Hidden
end

local function isReplyMessage(p2): boolean
	return p2 ~= nil and p2.replies_to ~= nil
end

local function canGroupWithAdjacent(data, data2)
	local v5

	if data2 == nil then
		v5 = false
	else
		v5 = not (data2 == nil) and data2.type == messageType.User

		if v5 then
			if data2.sender_user_id == data.sender_user_id then
				v5 = data == nil or data.visibility ~= messageVisibility.Hidden

				if v5 then
					v5 = data2 == nil or data2.visibility ~= messageVisibility.Hidden

					if v5 then
						v5 = data == nil or data.status ~= messageStatus.Moderated

						if v5 then
							v5 = (data2 == nil or data2.status ~= messageStatus.Moderated)
								and not timeDiffExceedsThreshold(data2, data)
						end
					end
				end
			else
				v5 = false
			end
		end
	end

	return v5
end

local function computeGroupedVariant(message, p2, p3)
	local v5 = not (message == nil) and message.type == messageType.User

	if not v5 then
		return nil
	end

	local v6 = canGroupWithAdjacent(message, p2)

	if v6 then
		v6 = p2 == nil or p2.replies_to == nil
	end

	local v7 = canGroupWithAdjacent(message, p3)

	if v7 then
		v7 = message == nil or message.replies_to == nil
	end

	if not (v6 or v7) then
		return groupedMessageVariant.Single
	end

	if v6 or not v7 then
		if v6 and not v7 then
			return groupedMessageVariant.First
		end

		return groupedMessageVariant.Middle
	end

	return groupedMessageVariant.Last
end

local function createConversationMessageViewModelStore(p2, data)
	local v5 = {}

	return {
		conversationMessageStore = p2,
		conversationMessageListStore = data,
		getGroupedVariant = function(p3, p4)
			local computeds = v5[p4]

			if computeds then
				local v6 = computeds[p3]

				if v6 ~= nil then
					return v6
				end
			else
				computeds = {}
				v5[p4] = computeds
			end

			local computed = Signals.createComputed(function(p5)
				local messages = p2.messages(p5)
				local message = messages[p3]

				if message == nil then
					return nil
				end

				local v6 = not (message == nil) and message.type == messageType.User

				if not v6 then
					return nil
				end

				if FFlagAppChatGroupedVariantNeighbourIds then
					local neighbourIds = data.getNeighbourIds(p4, p3, p5)
					local v7 = if neighbourIds.prevId ~= nil then messages[neighbourIds.prevId] else nil
					local v8 = if neighbourIds.nextId ~= nil then messages[neighbourIds.nextId] else nil
					return computeGroupedVariant(message, v7, v8)
				else
					if data.getIndex(p4, p3, p5) == nil then
						return groupedMessageVariant.Single
					end

					local prevId = data.getPrevId(p4, p3, p5)
					local nextId = data.getNextId(p4, p3, p5)

					local v7 = if prevId ~= nil then messages[prevId] else nil
					local v8 = if nextId ~= nil then messages[nextId] else nil

					return computeGroupedVariant(message, v7, v8)
				end
			end)

			computeds[p3] = computed
			return computed
		end,
		evictConversation = function(p3)
			v5[p3] = nil
		end
	}
end

return createConversationMessageViewModelStore
