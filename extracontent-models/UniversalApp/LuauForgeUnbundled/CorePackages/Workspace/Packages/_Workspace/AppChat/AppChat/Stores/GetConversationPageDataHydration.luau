local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/DataHydration")
local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")

local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger"):new("GetConversationPageDataHydration")
local ingestConversationListPage = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/Ingestion/ingestConversationListPage")
local GetConversationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationStore")

local createDataCache = DataHydration.createDataCache
local createDataResolver = DataHydration.createDataResolver

local function getPageId(p2)
	if p2 == nil or p2 == "" then
		return "__initial__"
	end

	return p2
end

local function getCursorFromPageId(p2)
	if p2 == "__initial__" then
		return nil
	end

	return p2
end

local function isInitialCursor(p2): boolean
	return p2 == nil or p2 == ""
end

local function createConversationPageDataHydrationStore()
	local dataCache = createDataCache(60)
	local v6 = GetConversationStore(false)
	local dataResolver = createDataResolver({
		cache = dataCache,
		supportsMultiGet = false,
		queueProcessDelaySec = 0,
		replaceItems = true,
		logError = function(p2)
			v5:warning(`Failed to fetch AppChat conversation list page: {tostring(p2)}`)
			ingestConversationListPage.ingestFailure(v6, p2)
		end,
		fetchFn = function(p2)
			if p2 == "__initial__" then
				p2 = nil
			end

			return AppChatNetworking.http.GetUserConversations(nil, p2):andThen(function(p3)
				local ingestSuccess = ingestConversationListPage.ingestSuccess(v6, p2, p3)

				return {
					cursor = p2,
					nextCursor = ingestSuccess.nextCursor,
					conversationCount = ingestSuccess.conversationCount
				}
			end)
		end
	})

	v6.addClearListener(function()
		dataResolver.clear()
	end)
	return {
		fetchPage = function(p2)
			local v7 = (p2 == nil or p2 == "") and "__initial__" or p2

			local listStatus = v6.getListStatus(false)

			if
				listStatus.isFetchingConversations == true
				or p2 ~= nil and p2 ~= "" and listStatus.isExhausted == true
			then
				return dataResolver.getCachedItem(v7)
			end

			ingestConversationListPage.beginFetch(v6, p2)
			return dataResolver.fetchItem(v7)
		end,
		clear = function()
			dataResolver.clear()
		end
	}
end

return createConversationPageDataHydrationStore()
