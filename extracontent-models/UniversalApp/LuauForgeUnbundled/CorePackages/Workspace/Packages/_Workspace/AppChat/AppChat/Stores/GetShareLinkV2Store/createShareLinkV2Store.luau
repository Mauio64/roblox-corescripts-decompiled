local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/DataHydration")
local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/HttpClient")

local classifyShareLinkV2 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Utils/RobloxUrlUtils/classifyShareLinkV2")
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger"):new("createShareLinkV2Store")
local fetchResolvedShareLink = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetShareLinkV2Store/Requests/fetchResolvedShareLink")

local function createShareLinkV2Store(options)
	local v6 = options or {}

	local dataCache = DataHydration.createDataCache(v6.ttlSeconds, v6.failedTtlSeconds)
	local dataResolver = DataHydration.createDataResolver({
		cache = dataCache,
		supportsMultiGet = false,
		replaceItems = true,
		logError = function(p2)
			v5:warning(`Error resolving share link v2: {tostring(p2)}`)
		end,
		fetchFn = function(p2)
			return HttpClient.asPromise(fetchResolvedShareLink(p2, v6.network)):andThen(classifyShareLinkV2)
		end
	})

	return {
		getCachedClassification = dataResolver.getCachedItem,
		fetchClassification = dataResolver.fetchItem,
		getAndFetchClassification = dataResolver.getAndFetchItem,
		clear = dataResolver.clear,
		dispose = dataResolver.dispose
	}
end

return createShareLinkV2Store
