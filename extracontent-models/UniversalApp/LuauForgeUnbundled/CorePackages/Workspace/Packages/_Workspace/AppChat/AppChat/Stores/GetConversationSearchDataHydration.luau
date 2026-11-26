local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/DataHydration")
local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")
local SignalsExperimental = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsExperimental")

local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger"):new("GetConversationSearchDataHydration")
local ConversationChannels = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/ConversationChannels")
local ingestConversationListPage = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/Ingestion/ingestConversationListPage")
local getResponseBody = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/Ingestion/getResponseBody")
local GetConversationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationStore")
local searchIntroducedConversationIds = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/searchIntroducedConversationIds")
local createDataCache = DataHydration.createDataCache
local createDataResolver = DataHydration.createDataResolver

local function isEmptyQuery(p2): boolean
	return p2 == nil or p2 == ""
end

local function getPageId(p2, p3)
	return (("%*\0%*"):format(p2, (p3 == nil or p3 == "") and "__initial__" or p3))
end

local function supersedesStoredFriendPlaceholder(p2, data): boolean
	if
		data.source ~= ConversationChannels.Source.Channels
		or data.type ~= ConversationChannels.Type.OneToOne
		or data.participant_user_ids == nil
	then
		return false
	end

	local friendConversationId = ConversationChannels.getFriendConversationId(data.participant_user_ids)
	return p2.getConversation(friendConversationId, false) ~= nil
end

local function collectSearchOnlyIds(p2, p3)
	local conversationIds = {}

	if p3 == nil or p3.conversations == nil then
		return conversationIds
	end

	for k, conversation in p3.conversations do
		if not (conversation ~= nil and conversation.status ~= "failed") then
			continue
		end

		local conversationId = ConversationChannels.getConversationId(conversation)
		local v6

		if
			conversation.source == ConversationChannels.Source.Channels
			and conversation.type == ConversationChannels.Type.OneToOne
			and conversation.participant_user_ids ~= nil
		then
			local friendConversationId = ConversationChannels.getFriendConversationId(conversation.participant_user_ids)
			v6 = p2.getConversation(friendConversationId, false) ~= nil
		else
			v6 = false
		end

		if v6 or not (p2.getConversation(conversationId, false) == nil or searchIntroducedConversationIds.has(conversationId)) then
			continue
		end

		table.insert(conversationIds, conversationId)
	end

	return conversationIds
end

local function getOrderedMatchedIds(p2)
	local conversationIds = {}

	if p2 == nil or p2.conversations == nil then
		return conversationIds
	end

	local conversationIdSet = {}

	for k, conversation in p2.conversations do
		if not (conversation ~= nil and conversation.status ~= "failed") then
			continue
		end

		local conversationId = ConversationChannels.getConversationId(conversation)

		if conversationIdSet[conversationId] then
			continue
		end

		conversationIdSet[conversationId] = true
		table.insert(conversationIds, conversationId)
	end

	return conversationIds
end

local function createConversationSearchDataHydrationStore()
	local dataCache = createDataCache(30)
	local v6 = GetConversationStore(false)

	local v7 = {}

	local count = 0

	local signal, v8 = Signals.createSignal(0)
	local v9 = {}
	local fetchPage

	local dataResolver = createDataResolver({
		cache = dataCache,
		supportsMultiGet = false,
		queueProcessDelaySec = 0,
		replaceItems = true,
		logError = function(p2)
			v5:warning(`Failed to fetch AppChat conversation search page: {tostring(p2)}`)
		end,
		fetchFn = function(p2)
			local v10 = v7[p2]
			local v11 = v10 == nil and "" or v10.query
			local cursor = if v10 ~= nil then v10.cursor else nil
			local placement = if v10 ~= nil then v10.placement else nil
			local v12 = count
			v9[p2] = signal(false)

			return AppChatNetworking.http.SearchConversations(nil, v11, cursor, nil, placement):andThen(function(p3)
				if v12 ~= count then
					return { matchedConversationIds = {}, nextCursor = nil }
				end

				local v13 = getResponseBody(p3)

				local v14 = collectSearchOnlyIds(v6, v13)

				SignalsExperimental.batch(function()
					ingestConversationListPage.ingestConversationResponses(v6, v13)

					for k, v15 in v14 do
						searchIntroducedConversationIds.add(v15)
					end
				end)

				local orderedMatchedIds = getOrderedMatchedIds(v13)
				local next_cursor = if v13 ~= nil then v13.next_cursor else nil

				if v9[p2] ~= signal(false) then
					task.defer(function()
						if v12 == count then
							fetchPage(v11, cursor, placement)
						end
					end)
				end

				if next_cursor == nil or next_cursor == "" then
					next_cursor = nil
				end

				return {
					matchedConversationIds = orderedMatchedIds,
					nextCursor = next_cursor
				}
			end)
		end
	})

	fetchPage = function(p2, cursor, placement)
		if p2 == nil or p2 == "" then
			return nil
		end

		local formatted = ("%*\0%*"):format(p2, (cursor == nil or cursor == "") and "__initial__" or cursor)

		v7[formatted] = { query = p2, cursor = cursor, placement = placement }
		return dataResolver.getAndFetchItem(formatted, function(): boolean
			return v9[formatted] ~= signal(false)
		end)
	end

	v6.addClearListener(function()
		count += 1
		v7 = {}
		v9 = {}
		searchIntroducedConversationIds.clear()
		dataResolver.clear()
	end)
	return {
		fetchPage = fetchPage,
		getInvalidationGeneration = signal,
		invalidate = function()
			v8(signal(false) + 1)
		end
	}
end

return Signals.createComputed(createConversationSearchDataHydrationStore)
