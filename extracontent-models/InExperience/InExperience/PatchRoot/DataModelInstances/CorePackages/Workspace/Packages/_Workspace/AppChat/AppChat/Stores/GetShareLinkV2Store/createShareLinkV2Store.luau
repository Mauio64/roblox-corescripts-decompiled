local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local DataHydration = require(AppChatParent.DataHydration)
local HttpClient = require(AppChatParent.HttpClient)
local classifyShareLinkV2 = require(AppChat.Components.ChatConversation.Utils.RobloxUrlUtils.classifyShareLinkV2)
local v6 = require(AppChat.Logger):new(script.Name)
local fetchResolvedShareLink = require(script.Parent.Requests.fetchResolvedShareLink)

local function createShareLinkV2Store(t1: {[any]: any}?) -- line: 29
	-- upvalues: DataHydration (copy), v6 (copy), HttpClient (copy), fetchResolvedShareLink (copy), classifyShareLinkV2 (copy)
	local v10 = t1 or {}
	local v11 = DataHydration.createDataCache(v10.ttlSeconds, v10.failedTtlSeconds)
	local v12 = DataHydration.createDataResolver({
		supportsMultiGet = false,
		replaceItems = true,
		cache = v11,
		logError = function(p1) -- line: 37
			-- upvalues: v6 (copy)
			v6:warning(`Error resolving share link v2: { tostring(p1) }`)
		end,
		fetchFn = function(s1: string) -- line: 40
			-- upvalues: HttpClient (copy), fetchResolvedShareLink (copy), v10 (copy), classifyShareLinkV2 (copy)
			return HttpClient.asPromise(fetchResolvedShareLink(s1, v10.network)):andThen(classifyShareLinkV2)
		end
	})

	return {
		getCachedClassification = v12.getCachedItem,
		fetchClassification = v12.fetchItem,
		getAndFetchClassification = v12.getAndFetchItem,
		clear = v12.clear,
		dispose = v12.dispose
	}
end

return createShareLinkV2Store
