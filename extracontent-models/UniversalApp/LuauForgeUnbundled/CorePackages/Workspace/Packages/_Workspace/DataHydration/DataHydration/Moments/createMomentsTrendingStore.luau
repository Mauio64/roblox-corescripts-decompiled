local HttpService = game:GetService("HttpService")

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Promise")
local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/MomentsStoreTypes")
local fetchTrendingMoments = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Requests/fetchTrendingMoments")

local function paramsKey(p2, value)
	return HttpService:JSONEncode({
		momentsSessionId = p2,
		hasCursor = value ~= nil,
		cursor = value or ""
	})
end

local function createMomentsTrendingStore(options)
	local v5 = options or {}
	local v6 = {}
	local v8 = createDataResolver({
		cache = createDataCache(),
		supportsMultiGet = false,
		replaceItems = true,
		fetchFn = function(p2, p3)
			local v9 = v6[p2]

			if v9 == nil then
				return Promise.reject(`Missing trending moments request params for {p2}`)
			end

			return HttpClient.asPromise(fetchTrendingMoments(v9.momentsSessionId, v9.cursor, v5.network))
		end
	})

	local function setParams(p2, value)
		local jsonEncode = HttpService:JSONEncode({
			momentsSessionId = p2,
			hasCursor = value ~= nil,
			cursor = value or ""
		})

		v6[jsonEncode] = { momentsSessionId = p2, cursor = value }

		return jsonEncode
	end

	return {
		getTrending = function(p2, p3, p4)
			return HttpClient.asPromise(fetchTrendingMoments(p2, p3, v5.network, p4))
		end,
		getCachedTrending = function(p2, value)
			local getCachedItem = v8.getCachedItem
			local jsonEncode = HttpService:JSONEncode({
				momentsSessionId = p2,
				hasCursor = value ~= nil,
				cursor = value or ""
			})

			v6[jsonEncode] = { momentsSessionId = p2, cursor = value }

			return getCachedItem(jsonEncode)
		end,
		fetchTrending = function(p2, value)
			local fetchItem = v8.fetchItem
			local jsonEncode = HttpService:JSONEncode({
				momentsSessionId = p2,
				hasCursor = value ~= nil,
				cursor = value or ""
			})

			v6[jsonEncode] = { momentsSessionId = p2, cursor = value }

			return fetchItem(jsonEncode)
		end,
		getAndFetchTrending = function(p2, value)
			local getAndFetchItem = v8.getAndFetchItem
			local jsonEncode = HttpService:JSONEncode({
				momentsSessionId = p2,
				hasCursor = value ~= nil,
				cursor = value or ""
			})

			v6[jsonEncode] = { momentsSessionId = p2, cursor = value }

			return getAndFetchItem(jsonEncode)
		end,
		clear = function()
			v6 = {}
			v8.clear()
		end,
		dispose = function()
			v6 = {}
			v8.dispose()
		end
	}
end

return createMomentsTrendingStore
