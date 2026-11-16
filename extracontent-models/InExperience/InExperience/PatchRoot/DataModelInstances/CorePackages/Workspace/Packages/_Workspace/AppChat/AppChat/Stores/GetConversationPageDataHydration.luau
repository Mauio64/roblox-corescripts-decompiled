local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local DataHydration = require(parent.DataHydration)
local AppChatNetworking = require(parent.AppChatNetworking)

local Logger = require(AppChat.Logger)
local v = Logger:new(script.Name)
local ingestConversationListPage = require(AppChat.Stores.Ingestion.ingestConversationListPage)
local GetConversationStore = require(AppChat.Stores.GetConversationStore)

local createDataCache = DataHydration.createDataCache
local createDataResolver = DataHydration.createDataResolver

local function getPageId(p: string?) -- 1 equivalent call inferred from this helper
	return if p == nil or p == "" then "__initial__" else p
end

local function getCursorFromPageId(p: string) -- 1 equivalent call inferred from this helper
	return if p ~= "__initial__" then p else nil
end

local function isInitialCursor(p: string?): boolean -- 1 equivalent call inferred from this helper
	return p == nil or p == ""
end

local function createConversationPageDataHydrationStore()
	local dataCache = createDataCache(60)
	local conversationStore = GetConversationStore(false)
	local dataResolver = createDataResolver({
		cache = dataCache,
		supportsMultiGet = false,
		queueProcessDelaySec = 0,
		replaceItems = true,
		logError = function(p)
			v:warning(`Failed to fetch AppChat conversation list page: {tostring(p)}`)
			ingestConversationListPage.ingestFailure(conversationStore, p)
		end,
		fetchFn = function(cursor: string)
			cursor = getCursorFromPageId(cursor) -- inferred equivalent call
			return AppChatNetworking.http.GetUserConversations(nil, cursor):andThen(function(p)
				local ingestSuccess = ingestConversationListPage.ingestSuccess(conversationStore, cursor, p)

				return {
					cursor = cursor,
					nextCursor = ingestSuccess.nextCursor,
					conversationCount = ingestSuccess.conversationCount
				}
			end)
		end
	})

	conversationStore.addClearListener(function()
		dataResolver.clear()
	end)
	return {
		fetchPage = function(p: string?)
			local pageId = getPageId(p) -- inferred equivalent call
			local listStatus = conversationStore.getListStatus(false)

			if
				listStatus.isFetchingConversations == true
				or not isInitialCursor(p) and listStatus.isExhausted == true -- inferred equivalent call
			then
				return dataResolver.getCachedItem(pageId)
			end

			ingestConversationListPage.beginFetch(conversationStore, p)
			return dataResolver.fetchItem(pageId)
		end,
		clear = function()
			dataResolver.clear()
		end
	}
end

return createConversationPageDataHydrationStore()
