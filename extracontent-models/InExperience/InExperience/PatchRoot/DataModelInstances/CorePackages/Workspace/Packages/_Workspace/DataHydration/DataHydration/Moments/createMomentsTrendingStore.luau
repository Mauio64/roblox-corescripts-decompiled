local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local HttpService = game:GetService("HttpService")

local Promise = require(parent.Promise)
local HttpClient = require(parent.HttpClient)
local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)
require(DataHydration.DataHydrationTypes)
require(script.Parent.MomentsStoreTypes)
local fetchTrendingMoments = require(script.Parent.Requests.fetchTrendingMoments)

local function paramsKey(momentsSessionId: string, value: string?) -- 1 equivalent call inferred from this helper
	return HttpService:JSONEncode({
		momentsSessionId = momentsSessionId,
		hasCursor = value ~= nil,
		cursor = value or ""
	})
end

local function createMomentsTrendingStore(options)
	local v = options or {}
	local v2 = {}
	local dataResolver = createDataResolver({
		cache = createDataCache(),
		supportsMultiGet = false,
		replaceItems = true,
		fetchFn = function(p: string, _)
			local v3 = v2[p]

			if v3 == nil then
				return Promise.reject(`Missing trending moments request params for {p}`)
			end

			return HttpClient.asPromise(fetchTrendingMoments(v3.momentsSessionId, v3.cursor, v.network))
		end
	})

	local function setParams(momentsSessionId: string, cursor: string?) -- 3 equivalent calls inferred from this helper
		local v3 = paramsKey(momentsSessionId, cursor) -- inferred equivalent call
		v2[v3] = { momentsSessionId = momentsSessionId, cursor = cursor }

		return v3
	end

	return {
		getTrending = function(p: string, p2: string?, p3)
			return HttpClient.asPromise(fetchTrendingMoments(p, p2, v.network, p3))
		end,
		getCachedTrending = function(momentsSessionId: string, cursor: string?)
			return dataResolver.getCachedItem(setParams(momentsSessionId, cursor)) -- inferred equivalent call
		end,
		fetchTrending = function(momentsSessionId: string, cursor: string?)
			return dataResolver.fetchItem(setParams(momentsSessionId, cursor)) -- inferred equivalent call
		end,
		getAndFetchTrending = function(momentsSessionId: string, cursor: string?)
			return dataResolver.getAndFetchItem(setParams(momentsSessionId, cursor)) -- inferred equivalent call
		end,
		clear = function()
			v2 = {}
			dataResolver.clear()
		end,
		dispose = function()
			v2 = {}
			dataResolver.dispose()
		end
	}
end

return createMomentsTrendingStore
