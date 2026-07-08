local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Signals = require(AppChatParent.Signals)

require(AppChat.Stores.GetConversationStore.createConversationStore)

local getConversationIds = require(AppChat.Utils.getConversationIds)

local function getLastUpdatedUnixTime(p1) -- line: 23
	local lastUpdated = p1.lastUpdated

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
local function conversationSortPredicate(p2, p3) -- line: 37
	local lastUpdated = p2.lastUpdated
	local v15 = if lastUpdated ~= nil then if typeof(lastUpdated) ~= "DateTime" then if type(lastUpdated) ~= "table" or lastUpdated.GetUnixTimestamp == nil then nil else lastUpdated:GetUnixTimestamp() else lastUpdated.UnixTimestamp else nil
	local lastUpdated2 = p3.lastUpdated
	local v17 = if lastUpdated2 ~= nil then if typeof(lastUpdated2) ~= "DateTime" then if type(lastUpdated2) ~= "table" or lastUpdated2.GetUnixTimestamp == nil then nil else lastUpdated2:GetUnixTimestamp() else lastUpdated2.UnixTimestamp else nil

	if v15 ~= nil and v17 ~= nil then
		return v17 < v15
	end

	if v15 == nil and v17 == nil then
		return string.lower(p2.title or "") < string.lower(p3.title or "")
	end

	return v15 ~= nil
end
local function containsAllFrozenConversations(t1: {[any]: any}, t2: {[any]: any}) -- line: 48
	for _, v21 in t2 do
		if table.find(t1, v21) == nil then
			return false
		end
	end

	return true
end
local function getSortedConversations(p4, p5) -- line: 57
	-- upvalues: conversationSortPredicate (copy)
	local v24 = p4.getConversations(p5)

	table.sort(v24, conversationSortPredicate)

	return v24
end
local function createConversationListStore(p6) -- line: 63
	-- upvalues: Signals (copy), conversationSortPredicate (copy), getConversationIds (copy), containsAllFrozenConversations (copy)
	local u26 = nil
	local v27, v28 = Signals.createSignal(false)

	p6.addClearListener(function() -- line: 67
		-- upvalues: u26 (ref), v28 (copy)
		u26 = nil
		v28(false)
	end)

	local function getOrderedConversationIds(p7) -- line: 72
		-- upvalues: p6 (copy), conversationSortPredicate (copy), getConversationIds (copy), v27 (copy), u26 (ref), containsAllFrozenConversations (copy)
		local v31 = p6.getConversations(p7)

		table.sort(v31, conversationSortPredicate)

		local v32 = getConversationIds(v31)

		if v27(p7) == true and u26 ~= nil then
			if #v32 == 0 then
				u26 = nil

				return {}
			end

			if not containsAllFrozenConversations(v32, u26) then
				u26 = v32

				return v32
			end

			return u26
		end

		u26 = v32

		return v32
	end

	return {
		getOrderedConversationIds = getOrderedConversationIds,
		getConversations = function(p8) -- line: 93
			-- upvalues: getOrderedConversationIds (copy), p6 (copy)
			local t3 = {}

			for _, v36 in getOrderedConversationIds(p8) do
				local v37 = p6.getConversation(v36, p8)

				if v37 ~= nil then
					table.insert(t3, v37)
				end
			end

			return t3
		end,
		getListStatus = function(p9) -- line: 104
			-- upvalues: p6 (copy)
			return p6.getListStatus(p9)
		end,
		setLatestMessagesFetching = function(b1: boolean) -- line: 108
			-- upvalues: v28 (copy)
			v28(b1)
		end
	}
end

return createConversationListStore
