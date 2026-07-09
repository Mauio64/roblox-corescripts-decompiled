local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local HttpService = game:GetService("HttpService")
local Promise = require(DataHydrationParent.Promise)
local HttpClient = require(DataHydrationParent.HttpClient)
local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)

require(DataHydration.DataHydrationTypes)
require(script.Parent.MomentsStoreTypes)

local fetchUserMoments = require(script.Parent.Requests.fetchUserMoments)
local FFlagProfileMomentsOrderingAndReactions = require(DataHydrationParent.SharedFlags).FFlagProfileMomentsOrderingAndReactions

local function paramsKey(n1: number, s1: string?) -- line: 28
	-- upvalues: HttpService (copy)
	return HttpService:JSONEncode({
		targetUserId = n1,
		hasCursor = s1 ~= nil,
		cursor = s1 or ""
	})
end
local function createMomentsUserStore(p1) -- line: 36
	-- upvalues: createDataCache (copy), createDataResolver (copy), Promise (copy), HttpClient (copy), fetchUserMoments (copy), HttpService (copy), FFlagProfileMomentsOrderingAndReactions (copy)
	local v15 = p1 or {}
	local t1 = {}
	local t2 = {}
	local v18 = createDataCache()
	local v19 = createDataResolver({
		supportsMultiGet = false,
		replaceItems = true,
		cache = v18,
		fetchFn = function(s2: string, _) -- line: 46
			-- upvalues: t1 (ref), Promise (copy), HttpClient (copy), fetchUserMoments (copy), v15 (copy)
			local v24 = t1[s2]

			if v24 == nil then
				return Promise.reject(`Missing user moments request params for { s2 }`)
			end

			return HttpClient.asPromise(fetchUserMoments(v24.targetUserId, v24.cursor, v15.network))
		end
	})

	local function setParams(n2: number, s3: string?) -- line: 55
		-- upvalues: HttpService (copy), t1 (ref)
		local json = HttpService:JSONEncode({
			targetUserId = n2,
			hasCursor = s3 ~= nil,
			cursor = s3 or ""
		})

		t1[json] = {
			targetUserId = n2,
			cursor = s3
		}

		return json
	end
	local function fetchUserMomentsItem(n3: number, s4: string?) -- line: 71
		-- upvalues: v19 (copy), HttpService (copy), t1 (ref)
		local fetchItem = v19.fetchItem
		local json = HttpService:JSONEncode({
			targetUserId = n3,
			hasCursor = s4 ~= nil,
			cursor = s4 or ""
		})

		t1[json] = {
			targetUserId = n3,
			cursor = s4
		}

		return fetchItem(json)
	end

	return {
		getUserMoments = function(n4: number, s5: string?) -- line: 85
			-- upvalues: FFlagProfileMomentsOrderingAndReactions (copy), HttpClient (copy), fetchUserMoments (copy), v15 (copy), HttpService (copy), t2 (ref)
			if not FFlagProfileMomentsOrderingAndReactions then
				return HttpClient.asPromise(fetchUserMoments(n4, s5, v15.network))
			end

			local json = HttpService:JSONEncode({
				targetUserId = n4,
				hasCursor = s5 ~= nil,
				cursor = s5 or ""
			})
			local v43 = t2[json]

			if v43 ~= nil then
				return v43
			end

			local v44 = HttpClient.asPromise(fetchUserMoments(n4, s5, v15.network))

			t2[json] = v44
			v44:catch(function() -- line: 96
				-- upvalues: t2 (ref), json (copy)
				t2[json] = nil
			end)

			return v44
		end,
		getCachedUserMoments = function(n5: number, s6: string?) -- line: 64
			-- upvalues: v19 (copy), HttpService (copy), t1 (ref)
			local getCachedItem = v19.getCachedItem
			local json = HttpService:JSONEncode({
				targetUserId = n5,
				hasCursor = s6 ~= nil,
				cursor = s6 or ""
			})

			t1[json] = {
				targetUserId = n5,
				cursor = s6
			}

			return getCachedItem(json)
		end,
		fetchUserMoments = fetchUserMomentsItem,
		getAndFetchUserMoments = function(n6: number, s7: string?) -- line: 78
			-- upvalues: v19 (copy), HttpService (copy), t1 (ref)
			local getAndFetchItem = v19.getAndFetchItem
			local json = HttpService:JSONEncode({
				targetUserId = n6,
				hasCursor = s7 ~= nil,
				cursor = s7 or ""
			})

			t1[json] = {
				targetUserId = n6,
				cursor = s7
			}

			return getAndFetchItem(json)
		end,
		clear = function() -- line: 102
			-- upvalues: t1 (ref), FFlagProfileMomentsOrderingAndReactions (copy), t2 (ref), v19 (copy)
			t1 = {}

			if FFlagProfileMomentsOrderingAndReactions then
				t2 = {}
			end

			v19.clear()
		end,
		dispose = function() -- line: 110
			-- upvalues: t1 (ref), FFlagProfileMomentsOrderingAndReactions (copy), t2 (ref), v19 (copy)
			t1 = {}

			if FFlagProfileMomentsOrderingAndReactions then
				t2 = {}
			end

			v19.dispose()
		end
	}
end

return createMomentsUserStore
