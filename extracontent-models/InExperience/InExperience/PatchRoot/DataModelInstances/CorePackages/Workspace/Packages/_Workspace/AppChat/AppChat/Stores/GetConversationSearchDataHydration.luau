local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local DataHydration = require(parent.DataHydration)
local AppChatNetworking = require(parent.AppChatNetworking)
local Signals = require(parent.Signals)
local SignalsExperimental = require(parent.SignalsExperimental)

local Logger = require(AppChat.Logger)
local v = Logger:new(script.Name)
local ConversationChannels = require(AppChat.Models.ConversationChannels)
local ingestConversationListPage = require(AppChat.Stores.Ingestion.ingestConversationListPage)
local getResponseBody = require(AppChat.Stores.Ingestion.getResponseBody)
local GetConversationStore = require(AppChat.Stores.GetConversationStore)
local searchIntroducedConversationIds = require(AppChat.Stores.searchIntroducedConversationIds)
local createDataCache = DataHydration.createDataCache
local createDataResolver = DataHydration.createDataResolver

local function isEmptyQuery(p: string?): boolean -- 1 equivalent call inferred from this helper
	return p == nil or p == ""
end

local function getPageId(p: string, p2: string?) -- 1 equivalent call inferred from this helper
	return (("%*\0%*"):format(p, (p2 == nil or p2 == "") and "__initial__" or p2))
end

local function supersedesStoredFriendPlaceholder(p, conversation): boolean -- 1 equivalent call inferred from this helper
	if
		conversation.source ~= ConversationChannels.Source.Channels
		or conversation.type ~= ConversationChannels.Type.OneToOne
		or conversation.participant_user_ids == nil
	then
		return false
	end

	local friendConversationId = ConversationChannels.getFriendConversationId(conversation.participant_user_ids)
	return p.getConversation(friendConversationId, false) ~= nil
end

local function collectSearchOnlyIds(p, responseBody)
	local conversationIds = {}

	if responseBody == nil or responseBody.conversations == nil then
		return conversationIds
	end

	for _, conversation in responseBody.conversations do
		if not (conversation ~= nil and conversation.status ~= "failed") then
			continue
		end

		local conversationId = ConversationChannels.getConversationId(conversation)

		if
			supersedesStoredFriendPlaceholder(p, conversation) -- inferred equivalent call
			or not (p.getConversation(conversationId, false) == nil or searchIntroducedConversationIds.has(conversationId))
		then
			continue
		end

		table.insert(conversationIds, conversationId)
	end

	return conversationIds
end

local function getOrderedMatchedIds(responseBody)
	local conversationIds = {}

	if responseBody == nil or responseBody.conversations == nil then
		return conversationIds
	end

	local conversationIdSet = {}

	for _, conversation in responseBody.conversations do
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
	local conversationStore = GetConversationStore(false)

	local v2 = {}

	local count = 0

	local signal, v3 = Signals.createSignal(0)
	local v4 = {}
	local fetchPage

	local dataResolver = createDataResolver({
		cache = dataCache,
		supportsMultiGet = false,
		queueProcessDelaySec = 0,
		replaceItems = true,
		logError = function(p)
			v:warning(`Failed to fetch AppChat conversation search page: {tostring(p)}`)
		end,
		fetchFn = function(p: string)
			local v5 = v2[p]
			local v6 = v5 == nil and "" or v5.query
			local cursor

			if v5 == nil then
				cursor = nil
			else
				cursor = v5.cursor
			end

			local placement

			if v5 == nil then
				placement = nil
			else
				placement = v5.placement
			end

			local v7 = count
			v4[p] = signal(false)

			return AppChatNetworking.http.SearchConversations(nil, v6, cursor, nil, placement):andThen(function(p2)
				if v7 ~= count then
					return { matchedConversationIds = {}, nextCursor = nil }
				end

				local responseBody = getResponseBody(p2)

				local v8 = collectSearchOnlyIds(conversationStore, responseBody)

				SignalsExperimental.batch(function()
					ingestConversationListPage.ingestConversationResponses(conversationStore, responseBody)

					for _, v9 in v8 do
						searchIntroducedConversationIds.add(v9)
					end
				end)

				local orderedMatchedIds = getOrderedMatchedIds(responseBody)
				local next_cursor

				if responseBody ~= nil then
					next_cursor = responseBody.next_cursor
				end

				if v4[p] ~= signal(false) then
					task.defer(function()
						if v7 == count then
							fetchPage(v6, cursor, placement)
						end
					end)
				end

				if next_cursor == nil or next_cursor == "" then
					next_cursor = nil
				end

				return { matchedConversationIds = orderedMatchedIds, nextCursor = next_cursor }
			end)
		end
	})

	fetchPage = function(query: string, cursor: string?, placement: string?)
		if isEmptyQuery(query) then -- inferred equivalent call
			return nil
		end

		local pageId = getPageId(query, cursor) -- inferred equivalent call
		v2[pageId] = { query = query, cursor = cursor, placement = placement }
		return dataResolver.getAndFetchItem(pageId, function(): boolean
			return v4[pageId] ~= signal(false)
		end)
	end

	conversationStore.addClearListener(function()
		count += 1
		v2 = {}
		v4 = {}
		searchIntroducedConversationIds.clear()
		dataResolver.clear()
	end)
	return {
		fetchPage = fetchPage,
		getInvalidationGeneration = signal,
		invalidate = function()
			v3(signal(false) + 1)
		end
	}
end

return Signals.createComputed(createConversationSearchDataHydrationStore)
