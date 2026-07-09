local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local HttpService = game:GetService("HttpService")
local Promise = require(DataHydrationParent.Promise)
local HttpClient = require(DataHydrationParent.HttpClient)
local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)

require(DataHydration.DataHydrationTypes)
require(script.Parent.MomentsStoreTypes)

local fetchTrendingMoments = require(script.Parent.Requests.fetchTrendingMoments)

local function paramsKey(s1: string, s2: string?) -- line: 26
	-- upvalues: HttpService (copy)
	return HttpService:JSONEncode({
		momentsSessionId = s1,
		hasCursor = s2 ~= nil,
		cursor = s2 or ""
	})
end
local function createMomentsTrendingStore(p1) -- line: 34
	-- upvalues: createDataCache (copy), createDataResolver (copy), Promise (copy), HttpClient (copy), fetchTrendingMoments (copy), HttpService (copy)
	local v14 = p1 or {}
	local t1 = {}
	local v16 = createDataCache()
	local v17 = createDataResolver({
		supportsMultiGet = false,
		replaceItems = true,
		cache = v16,
		fetchFn = function(s3: string, _) -- line: 42
			-- upvalues: t1 (ref), Promise (copy), HttpClient (copy), fetchTrendingMoments (copy), v14 (copy)
			local v21 = t1[s3]

			if v21 == nil then
				return Promise.reject(`Missing trending moments request params for { s3 }`)
			end

			return HttpClient.asPromise(fetchTrendingMoments(v21.momentsSessionId, v21.cursor, v14.network))
		end
	})

	local function setParams(s4: string, s5: string?) -- line: 56
		-- upvalues: HttpService (copy), t1 (ref)
		local json = HttpService:JSONEncode({
			momentsSessionId = s4,
			hasCursor = s5 ~= nil,
			cursor = s5 or ""
		})

		t1[json] = {
			momentsSessionId = s4,
			cursor = s5
		}

		return json
	end

	return {
		getTrending = function(s6: string, s7: string?, p3) -- line: 86
			-- upvalues: HttpClient (copy), fetchTrendingMoments (copy), v14 (copy)
			return HttpClient.asPromise(fetchTrendingMoments(s6, s7, v14.network, p3))
		end,
		getCachedTrending = function(s8: string, s9: string?) -- line: 65
			-- upvalues: v17 (copy), HttpService (copy), t1 (ref)
			local getCachedItem = v17.getCachedItem
			local json = HttpService:JSONEncode({
				momentsSessionId = s8,
				hasCursor = s9 ~= nil,
				cursor = s9 or ""
			})

			t1[json] = {
				momentsSessionId = s8,
				cursor = s9
			}

			return getCachedItem(json)
		end,
		fetchTrending = function(s10: string, s11: string?) -- line: 72
			-- upvalues: v17 (copy), HttpService (copy), t1 (ref)
			local fetchItem = v17.fetchItem
			local json = HttpService:JSONEncode({
				momentsSessionId = s10,
				hasCursor = s11 ~= nil,
				cursor = s11 or ""
			})

			t1[json] = {
				momentsSessionId = s10,
				cursor = s11
			}

			return fetchItem(json)
		end,
		getAndFetchTrending = function(s12: string, s13: string?) -- line: 79
			-- upvalues: v17 (copy), HttpService (copy), t1 (ref)
			local getAndFetchItem = v17.getAndFetchItem
			local json = HttpService:JSONEncode({
				momentsSessionId = s12,
				hasCursor = s13 ~= nil,
				cursor = s13 or ""
			})

			t1[json] = {
				momentsSessionId = s12,
				cursor = s13
			}

			return getAndFetchItem(json)
		end,
		clear = function() -- line: 90
			-- upvalues: t1 (ref), v17 (copy)
			t1 = {}
			v17.clear()
		end,
		dispose = function() -- line: 95
			-- upvalues: t1 (ref), v17 (copy)
			t1 = {}
			v17.dispose()
		end
	}
end

return createMomentsTrendingStore
