local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/MomentsStoreTypes")
local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Requests/fetchShareLink")

local function shouldRefreshCachedShareLink(p2): boolean
	return p2 == nil
end

local function createMomentsShareLinkStore(options)
	local v5 = options or {}

	local v6 = {}
	local v7 = {}
	local v8 = {}
	local v10 = createDataResolver({
		cache = createDataCache(),
		supportsMultiGet = false,
		replaceItems = true,
		fetchFn = function(p2, p3)
			return HttpClient.asPromise(module4(
				{
					momentId = p2,
					feedItemId = v8[p2],
					description = v6[p2],
					title = v7[p2]
				},
				v5.network
			))
		end
	})

	local function setRequestParams(p2, p3, p4, p5)
		v6[p2] = p3
		v7[p2] = p4
		v8[p2] = p5
		return p2
	end

	return {
		getCachedShareLink = function(p2)
			return v10.getCachedItem(p2)
		end,
		fetchShareLink = function(p2, p3, p4, p5)
			local fetchItem = v10.fetchItem
			v6[p2] = p3
			v7[p2] = p4
			v8[p2] = p5

			return fetchItem(p2)
		end,
		getAndFetchShareLink = function(p2, p3, p4, p5)
			local getAndFetchItem = v10.getAndFetchItem
			v6[p2] = p3
			v7[p2] = p4
			v8[p2] = p5

			return getAndFetchItem(p2, shouldRefreshCachedShareLink)
		end,
		clear = function()
			v6 = {}
			v7 = {}
			v8 = {}
			v10.clear()
		end,
		dispose = function()
			v6 = {}
			v7 = {}
			v8 = {}
			v10.dispose()
		end
	}
end

return createMomentsShareLinkStore
