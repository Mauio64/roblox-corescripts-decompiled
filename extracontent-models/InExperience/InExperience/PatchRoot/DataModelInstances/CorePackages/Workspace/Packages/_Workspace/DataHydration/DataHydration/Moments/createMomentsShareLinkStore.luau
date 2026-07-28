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
	local t3 = {}
	local v15 = createDataCache()
	local v16 = createDataResolver({
		supportsMultiGet = false,
		replaceItems = true,
		cache = v15,
		fetchFn = function(s2: string, _) -- line: 34
			-- upvalues: HttpClient (copy), fetchShareLink (copy), t3 (ref), t1 (ref), t2 (ref), v11 (copy)
			return HttpClient.asPromise(fetchShareLink({
				momentId = s2,
				feedItemId = t3[s2],
				description = t1[s2],
				title = t2[s2]
			}, v11.network))
		end
	})

	local function setRequestParams(s3: string, s4: string?, s5: string?, s6: string?) -- line: 46
		-- upvalues: t1 (ref), t2 (ref), t3 (ref)
		t1[s3] = s4
		t2[s3] = s5
		t3[s3] = s6

		return s3
	end

	return {
		getCachedShareLink = function(s7: string) -- line: 53
			-- upvalues: v16 (copy)
			return v16.getCachedItem(s7)
		end,
		fetchShareLink = function(s8: string, s9: string?, s10: string?, s11: string?) -- line: 57
			-- upvalues: v16 (copy), t1 (ref), t2 (ref), t3 (ref)
			local fetchItem = v16.fetchItem

			t1[s8] = s9
			t2[s8] = s10
			t3[s8] = s11

			return fetchItem(s8)
		end,
		getAndFetchShareLink = function(s12: string, s13: string?, s14: string?, s15: string?) -- line: 66
			-- upvalues: v16 (copy), t1 (ref), t2 (ref), t3 (ref), shouldRefreshCachedShareLink (copy)
			local getAndFetchItem = v16.getAndFetchItem

			t1[s12] = s13
			t2[s12] = s14
			t3[s12] = s15

			return getAndFetchItem(s12, shouldRefreshCachedShareLink)
		end,
		clear = function() -- line: 78
			-- upvalues: t1 (ref), t2 (ref), t3 (ref), v16 (copy)
			t1 = {}
			t2 = {}
			t3 = {}
			v16.clear()
		end,
		dispose = function() -- line: 85
			-- upvalues: t1 (ref), t2 (ref), t3 (ref), v16 (copy)
			t1 = {}
			t2 = {}
			t3 = {}
			v16.dispose()
		end
	}
end

return createMomentsShareLinkStore
