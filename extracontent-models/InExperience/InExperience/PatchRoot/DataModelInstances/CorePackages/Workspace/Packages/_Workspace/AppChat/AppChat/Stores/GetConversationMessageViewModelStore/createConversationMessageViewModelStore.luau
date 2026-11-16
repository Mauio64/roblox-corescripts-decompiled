local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Signals = require(parent.Signals)

require(AppChat.MessageData.Types)
local Enums = require(AppChat.MessageData.Enums)
local FFlagAppChatParseMessageTimestampsOnce = require(AppChat.Flags.FFlagAppChatParseMessageTimestampsOnce)
local FFlagAppChatGroupedVariantNeighbourIds = require(AppChat.Flags.FFlagAppChatGroupedVariantNeighbourIds)
local parseIsoDateUnixMillis = require(AppChat.Utils.parseIsoDateUnixMillis)

require(script.Parent.Parent.GetConversationMessageStore.createConversationMessageStore)

require(script.Parent.Parent.GetConversationMessageListStore.createConversationMessageListStore)

local GroupedMessageVariant = Enums.GroupedMessageVariant
local MessageStatus = Enums.MessageStatus
local MessageType = Enums.MessageType
local MessageVisibility = Enums.MessageVisibility

local function isChatMessage(p): boolean -- 3 equivalent calls inferred from this helper
	return p ~= nil and p.type == MessageType.User
end

local function parseTimestamp(created_at: string?) -- 2 equivalent calls inferred from this helper
	if created_at == nil then
		return nil
	end

	local dateTime = DateTime.fromIsoDate(created_at)

	return if dateTime then dateTime.UnixTimestamp else nil
end

local function getCreatedAtUnixTimestamp(p) -- 2 equivalent calls inferred from this helper
	local v = p.createdAtUnixMillis

	if v == nil then
		v = parseIsoDateUnixMillis(p.created_at)
	end

	if v == nil then
		return nil
	end

	return (math.floor(v / 1000))
end

local function timeDiffExceedsThreshold(p, p2): boolean
	if p == nil or p2 == nil then
		return false
	end

	local v

	if FFlagAppChatParseMessageTimestampsOnce then
		v = getCreatedAtUnixTimestamp(p) -- inferred equivalent call
	else
		v = parseTimestamp(p.created_at) -- inferred equivalent call
	end

	local v2

	if FFlagAppChatParseMessageTimestampsOnce then
		v2 = getCreatedAtUnixTimestamp(p2) -- inferred equivalent call
	else
		v2 = parseTimestamp(p2.created_at) -- inferred equivalent call
	end

	return v ~= nil and v2 ~= nil and math.abs(v - v2) > 300
end

local function isModeratedMessage(p): boolean -- 2 equivalent calls inferred from this helper
	return p ~= nil and p.status == MessageStatus.Moderated
end

local function isHiddenMessage(p): boolean -- 2 equivalent calls inferred from this helper
	return p ~= nil and p.visibility == MessageVisibility.Hidden
end

local function isReplyMessage(p): boolean -- 2 equivalent calls inferred from this helper
	return p ~= nil and p.replies_to ~= nil
end

local function canGroupWithAdjacent(p, p2)
	local v

	if p2 == nil then
		return false
	end

	v = isChatMessage(p2) -- inferred equivalent call

	if v then
		if p2.sender_user_id == p.sender_user_id then
			v = not isHiddenMessage(p) -- inferred equivalent call

			if v then
				v = not isHiddenMessage(p2) -- inferred equivalent call

				if v then
					return not isModeratedMessage(p) and not (isModeratedMessage(p2) or timeDiffExceedsThreshold(p2, p)) -- inferred equivalent call
				end
			end
		else
			return false
		end
	end

	return v
end

local function computeGroupedVariant(message, p, p2)
	if not isChatMessage(message) then -- inferred equivalent call
		return nil
	end

	local v = canGroupWithAdjacent(message, p) and not isReplyMessage(p) -- inferred equivalent call
	local v2 = canGroupWithAdjacent(message, p2) and not isReplyMessage(message) -- inferred equivalent call

	if not (v or v2) then
		return GroupedMessageVariant.Single
	end

	if v or not v2 then
		if v and not v2 then
			return GroupedMessageVariant.First
		end

		return GroupedMessageVariant.Middle
	end

	return GroupedMessageVariant.Last
end

local function createConversationMessageViewModelStore(conversationMessageStore, conversationMessageListStore)
	local v = {}

	return {
		conversationMessageStore = conversationMessageStore,
		conversationMessageListStore = conversationMessageListStore,
		getGroupedVariant = function(p: string, p2: string)
			local computeds = v[p2]

			if computeds then
				local v2 = computeds[p]

				if v2 ~= nil then
					return v2
				end
			else
				computeds = {}
				v[p2] = computeds
			end

			local computed = Signals.createComputed(function(p3)
				local messages = conversationMessageStore.messages(p3)
				local message = messages[p]

				if not (message ~= nil and isChatMessage(message)) then -- inferred equivalent call
					return nil
				end

				if FFlagAppChatGroupedVariantNeighbourIds then
					local neighbourIds = conversationMessageListStore.getNeighbourIds(p2, p, p3)
					local v2

					if neighbourIds.prevId ~= nil then
						v2 = messages[neighbourIds.prevId]
					end

					local v3

					if neighbourIds.nextId ~= nil then
						v3 = messages[neighbourIds.nextId]
					end

					return computeGroupedVariant(message, v2, v3)
				else
					if conversationMessageListStore.getIndex(p2, p, p3) == nil then
						return GroupedMessageVariant.Single
					end

					local prevId = conversationMessageListStore.getPrevId(p2, p, p3)
					local nextId = conversationMessageListStore.getNextId(p2, p, p3)
					local v2

					if prevId ~= nil then
						v2 = messages[prevId]
					end

					local v3

					if nextId ~= nil then
						v3 = messages[nextId]
					end

					return computeGroupedVariant(message, v2, v3)
				end
			end)

			computeds[p] = computed
			return computed
		end,
		evictConversation = function(p: string)
			v[p] = nil
		end
	}
end

return createConversationMessageViewModelStore
