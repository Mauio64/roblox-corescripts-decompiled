local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local HttpClient = require(DataHydrationParent.HttpClient)
local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)

require(DataHydration.DataHydrationTypes)
require(script.Parent.MomentsStoreTypes)

local fetchShareLink = require(script.Parent.Requests.fetchShareLink)

local function shouldRefreshCachedShareLink(s1: string?) -- line: 17
	return s1 == nil
end
local function createMomentsShareLinkStore(p1) -- line: 21
	-- upvalues: createDataCache (copy), createDataResolver (copy), HttpClient (copy), fetchShareLink (copy), shouldRefreshCachedShareLink (copy)
	local v11 = p1 or {}
	local t1 = {}
	local t2 = {}
	local v14 = createDataCache()
	local v15 = createDataResolver({
		supportsMultiGet = false,
		replaceItems = true,
		cache = v14,
		fetchFn = function(s2: string, _) -- line: 33
			-- upvalues: HttpClient (copy), fetchShareLink (copy), t1 (ref), t2 (ref), v11 (copy)
			return HttpClient.asPromise(fetchShareLink({
				momentId = s2,
				description = t1[s2],
				title = t2[s2]
			}, v11.network))
		end
	})

	local function setRequestParams(s3: string, s4: string?, s5: string?) -- line: 42
		-- upvalues: t1 (ref), t2 (ref)
		t1[s3] = s4
		t2[s3] = s5

		return s3
	end

	return {
		getCachedShareLink = function(s6: string) -- line: 48
			-- upvalues: v15 (copy)
			return v15.getCachedItem(s6)
		end,
		fetchShareLink = function(s7: string, s8: string?, s9: string?) -- line: 52
			-- upvalues: v15 (copy), t1 (ref), t2 (ref)
			local fetchItem = v15.fetchItem

			t1[s7] = s8
			t2[s7] = s9

			return fetchItem(s7)
		end,
		getAndFetchShareLink = function(s10: string, s11: string?, s12: string?) -- line: 60
			-- upvalues: v15 (copy), t1 (ref), t2 (ref), shouldRefreshCachedShareLink (copy)
			local getAndFetchItem = v15.getAndFetchItem

			t1[s10] = s11
			t2[s10] = s12

			return getAndFetchItem(s10, shouldRefreshCachedShareLink)
		end,
		clear = function() -- line: 68
			-- upvalues: t1 (ref), t2 (ref), v15 (copy)
			t1 = {}
			t2 = {}
			v15.clear()
		end,
		dispose = function() -- line: 74
			-- upvalues: t1 (ref), t2 (ref), v15 (copy)
			t1 = {}
			t2 = {}
			v15.dispose()
		end
	}
end

return createMomentsShareLinkStore
