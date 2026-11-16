local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Signals = require(parent.Signals)
require(AppChat.Stores.GetConversationStore.createConversationStore)

require(AppChat.Stores.GetConversationViewModelStore.createConversationViewModelStore)
local getConversationIds = require(AppChat.Utils.getConversationIds)
local searchIntroducedConversationIds = require(AppChat.Stores.searchIntroducedConversationIds)
local FFlagAppChatAnyServerSideConversationSearch = require(AppChat.Flags.FFlagAppChatAnyServerSideConversationSearch)

local FFlagAppChatDerivedConversationLatestActivity = require(AppChat.Flags.FFlagAppChatDerivedConversationLatestActivity)

local function getLastUpdatedUnixTime(p) -- 2 equivalent calls inferred from this helper
	local lastUpdated = p.lastUpdated

	if lastUpdated == nil then
		return nil
	end

	if typeof(lastUpdated) == "DateTime" then
		return lastUpdated.UnixTimestamp
	end

	if type(lastUpdated) == "table" and lastUpdated.GetUnixTimestamp ~= nil then
		return lastUpdated:GetUnixTimestamp()
	end

	return nil
end

local function compareConversations(p, p2, p3: number?, p4: number?): boolean -- 2 equivalent calls inferred from this helper
	if p3 ~= nil and p4 ~= nil then
		return p4 < p3
	end

	if p3 == nil and p4 == nil then
		return string.lower(p.title or "") < string.lower(p2.title or "")
	end

	return p3 ~= nil
end

local function compareByServerLastUpdated(p, p2)
	return compareConversations(p, p2, getLastUpdatedUnixTime(p), getLastUpdatedUnixTime(p2)) -- inferred equivalent call
end

local function sortByLatestActivity(conversations, p, p2)
	local v = {}

	for _, item in conversations do
		v[item.id] = p.getUnixTime(item.id)(p2)
	end

	table.sort(conversations, function(a, b)
		return compareConversations(a, b, v[a.id], v[b.id]) -- inferred equivalent call
	end)
end

local function containsAllFrozenConversations(conversationIds, items): boolean
	for _, item in items do
		if table.find(conversationIds, item) == nil then
			return false
		end
	end

	return true
end

local function excludeSearchIntroduced(conversations)
	local result = {}

	for _, item in conversations do
		if not searchIntroducedConversationIds.has(item.id) then
			table.insert(result, item)
		end
	end

	return result
end

local function getSortedConversations(data, p, p2) -- 1 equivalent call inferred from this helper
	local conversations = data.getConversations(p2)

	if FFlagAppChatAnyServerSideConversationSearch then
		conversations = excludeSearchIntroduced(conversations)
	end

	if FFlagAppChatDerivedConversationLatestActivity then
		sortByLatestActivity(conversations, p, p2)
		return conversations
	end

	table.sort(conversations, compareByServerLastUpdated)
	return conversations
end

local function createConversationListStore(data, p)
	local v = nil
	local signal, v2 = Signals.createSignal(false)

	data.addClearListener(function()
		v = nil
		v2(false)
	end)

	local function getOrderedConversationIds(p2)
		local conversationIds = getConversationIds(getSortedConversations(data, p, p2)) -- inferred equivalent call

		if signal(p2) ~= true or v == nil then
			v = conversationIds
			return conversationIds
		end

		if #conversationIds == 0 then
			v = nil
			return {}
		end

		if containsAllFrozenConversations(conversationIds, v) then
			return v
		end

		v = conversationIds
		return conversationIds
	end

	return {
		getOrderedConversationIds = getOrderedConversationIds,
		getConversations = function(p2)
			local conversations = {}

			for _, v3 in getOrderedConversationIds(p2) do
				local conversation = data.getConversation(v3, p2)

				if conversation ~= nil then
					table.insert(conversations, conversation)
				end
			end

			return conversations
		end,
		getListStatus = function(p2)
			return data.getListStatus(p2)
		end,
		setLatestMessagesFetching = function(flag: boolean)
			v2(flag)
		end
	}
end

return createConversationListStore
