local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationStore/createConversationStore")

require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationViewModelStore/createConversationViewModelStore")
local getConversationIds = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getConversationIds")
local searchIntroducedConversationIds = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/searchIntroducedConversationIds")
local FFlagAppChatAnyServerSideConversationSearch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatAnyServerSideConversationSearch")

local FFlagAppChatDerivedConversationLatestActivity = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatDerivedConversationLatestActivity")

local function getLastUpdatedUnixTime(p2)
	local lastUpdated = p2.lastUpdated

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

local function compareConversations(p2, p3, p4, p5): boolean
	if p4 ~= nil and p5 ~= nil then
		return p5 < p4
	end

	if p4 == nil and p5 == nil then
		return string.lower(p2.title or "") < string.lower(p3.title or "")
	end

	return p4 ~= nil
end

local function compareByServerLastUpdated(p2, p3): boolean
	local lastUpdated = p2.lastUpdated
	local unixTimestamp

	if lastUpdated ~= nil then
		if typeof(lastUpdated) == "DateTime" then
			unixTimestamp = lastUpdated.UnixTimestamp
		elseif type(lastUpdated) == "table" and lastUpdated.GetUnixTimestamp ~= nil then
			unixTimestamp = lastUpdated:GetUnixTimestamp()
		end
	end

	local lastUpdated2 = p3.lastUpdated
	local unixTimestamp2

	if lastUpdated2 ~= nil then
		if typeof(lastUpdated2) == "DateTime" then
			unixTimestamp2 = lastUpdated2.UnixTimestamp
		elseif type(lastUpdated2) == "table" and lastUpdated2.GetUnixTimestamp ~= nil then
			unixTimestamp2 = lastUpdated2:GetUnixTimestamp()
		end
	end

	if unixTimestamp ~= nil and unixTimestamp2 ~= nil then
		return unixTimestamp2 < unixTimestamp
	end

	if unixTimestamp == nil and unixTimestamp2 == nil then
		return string.lower(p2.title or "") < string.lower(p3.title or "")
	end

	return unixTimestamp ~= nil
end

local function sortByLatestActivity(conversations, p2, p3)
	local v5 = {}

	for k, item in conversations do
		v5[item.id] = p2.getUnixTime(item.id)(p3)
	end

	table.sort(conversations, function(a, b): boolean
		local v6 = v5[a.id]
		local v7 = v5[b.id]

		if v6 ~= nil and v7 ~= nil then
			return v7 < v6
		end

		if v6 == nil and v7 == nil then
			return string.lower(a.title or "") < string.lower(b.title or "")
		end

		return v6 ~= nil
	end)
end

local function containsAllFrozenConversations(list, items): boolean
	for k, item in items do
		if table.find(list, item) == nil then
			return false
		end
	end

	return true
end

local function excludeSearchIntroduced(conversations)
	local result = {}

	for k, item in conversations do
		if not searchIntroducedConversationIds.has(item.id) then
			table.insert(result, item)
		end
	end

	return result
end

local function getSortedConversations(p2, p3, p4)
	local conversations = p2.getConversations(p4)

	if FFlagAppChatAnyServerSideConversationSearch then
		conversations = excludeSearchIntroduced(conversations)
	end

	if FFlagAppChatDerivedConversationLatestActivity then
		sortByLatestActivity(conversations, p3, p4)
		return conversations
	end

	table.sort(conversations, compareByServerLastUpdated)
	return conversations
end

local function createConversationListStore(data, p2)
	local v5 = nil
	local signal, v6 = Signals.createSignal(false)

	data.addClearListener(function()
		v5 = nil
		v6(false)
	end)

	local function getOrderedConversationIds(p3)
		local v7 = p2
		local conversations = data.getConversations(p3)

		if FFlagAppChatAnyServerSideConversationSearch then
			conversations = excludeSearchIntroduced(conversations)
		end

		if FFlagAppChatDerivedConversationLatestActivity then
			sortByLatestActivity(conversations, v7, p3)
		else
			table.sort(conversations, compareByServerLastUpdated)
		end

		local v8 = getConversationIds(conversations)

		if signal(p3) ~= true or v5 == nil then
			v5 = v8
			return v8
		end

		if #v8 == 0 then
			v5 = nil
			return {}
		end

		if containsAllFrozenConversations(v8, v5) then
			return v5
		end

		v5 = v8
		return v8
	end

	return {
		getOrderedConversationIds = getOrderedConversationIds,
		getConversations = function(p3)
			local conversations = {}

			for k, v7 in getOrderedConversationIds(p3) do
				local conversation = data.getConversation(v7, p3)

				if conversation ~= nil then
					table.insert(conversations, conversation)
				end
			end

			return conversations
		end,
		getListStatus = function(p3)
			return data.getListStatus(p3)
		end,
		setLatestMessagesFetching = function(p3)
			v6(p3)
		end
	}
end

return createConversationListStore
