local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local DataHydration = require(AppChatParent.DataHydration)
local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local v5 = require(AppChat.Logger):new(script.Name)
local ingestConversationListPage = require(AppChat.Stores.Ingestion.ingestConversationListPage)
local GetConversationStore = require(AppChat.Stores.GetConversationStore)
local createDataCache = DataHydration.createDataCache
local createDataResolver = DataHydration.createDataResolver

local function getPageId(s1: string?) -- line: 28
	if s1 == nil or s1 == "" then
		return "__initial__"
	end

	return s1
end
local function getCursorFromPageId(s2: string) -- line: 32
	if s2 == "__initial__" then
		return nil
	end

	return s2
end
local function isInitialCursor(s3: string?) -- line: 36
	return s3 == nil or s3 == ""
end
local function createConversationPageDataHydrationStore() -- line: 40
	-- upvalues: createDataCache (copy), GetConversationStore (copy), createDataResolver (copy), v5 (copy), ingestConversationListPage (copy), AppChatNetworking (copy)
	local v17 = createDataCache(60)
	local v18 = GetConversationStore(false)
	local v19 = createDataResolver({
		supportsMultiGet = false,
		queueProcessDelaySec = 0,
		replaceItems = true,
		cache = v17,
		logError = function(p1) -- line: 48
			-- upvalues: v5 (copy), ingestConversationListPage (copy), v18 (copy)
			v5:warning(`Failed to fetch AppChat conversation list page: { tostring(p1) }`)
			ingestConversationListPage.ingestFailure(v18, p1)
		end,
		fetchFn = function(s4: string) -- line: 52
			-- upvalues: AppChatNetworking (copy), ingestConversationListPage (copy), v18 (copy)
			local v22 = if s4 ~= "__initial__" then s4 else nil

			return AppChatNetworking.http.GetUserConversations(nil, v22):andThen(function(p2) -- line: 55
				-- upvalues: ingestConversationListPage (copy), v18 (copy), v22 (copy)
				local v27 = ingestConversationListPage.ingestSuccess(v18, v22, p2)

				return {
					cursor = v22,
					nextCursor = v27.nextCursor,
					conversationCount = v27.conversationCount
				}
			end)
		end
	})

	v18.addClearListener(function() -- line: 83
		-- upvalues: v19 (copy)
		v19.clear()
	end)

	return {
		fetchPage = function(s5: string?) -- line: 67
			-- upvalues: v18 (copy), v19 (copy), ingestConversationListPage (copy)
			local v24 = if s5 ~= nil and s5 ~= "" then s5 else "__initial__"
			local v25 = v18.getListStatus(false)

			if v25.isFetchingConversations == true then
				return v19.getCachedItem(v24)
			end

			if s5 ~= nil and s5 ~= "" and v25.isExhausted == true then
				return v19.getCachedItem(v24)
			end

			ingestConversationListPage.beginFetch(v18, s5)

			return v19.fetchItem(v24)
		end,
		clear = function() -- line: 89
			-- upvalues: v19 (copy)
			v19.clear()
		end
	}
end

return (createConversationPageDataHydrationStore())
