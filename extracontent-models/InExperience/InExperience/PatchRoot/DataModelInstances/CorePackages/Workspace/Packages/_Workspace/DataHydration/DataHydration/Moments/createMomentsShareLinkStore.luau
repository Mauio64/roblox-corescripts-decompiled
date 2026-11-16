local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local HttpClient = require(parent.HttpClient)
local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)
require(DataHydration.DataHydrationTypes)
require(script.Parent.MomentsStoreTypes)
local fetchShareLink = require(script.Parent.Requests.fetchShareLink)

local function shouldRefreshCachedShareLink(p: string?): boolean
	return p == nil
end

local function createMomentsShareLinkStore(options)
	local v = options or {}

	local v2 = {}
	local v3 = {}
	local v4 = {}
	local dataResolver = createDataResolver({
		cache = createDataCache(),
		supportsMultiGet = false,
		replaceItems = true,
		fetchFn = function(momentId: string, _)
			return HttpClient.asPromise(fetchShareLink(
				{
					momentId = momentId,
					feedItemId = v4[momentId],
					description = v2[momentId],
					title = v3[momentId]
				},
				v.network
			))
		end
	})

	local function setRequestParams(p: string, p2: string?, p3: string?, p4: string?) -- 2 equivalent calls inferred from this helper
		v2[p] = p2
		v3[p] = p3
		v4[p] = p4
		return p
	end

	return {
		getCachedShareLink = function(p: string)
			return dataResolver.getCachedItem(p)
		end,
		fetchShareLink = function(p: string, p2: string?, p3: string?, p4: string?)
			return dataResolver.fetchItem(setRequestParams(p, p2, p3, p4)) -- inferred equivalent call
		end,
		getAndFetchShareLink = function(p: string, p2: string?, p3: string?, p4: string?)
			return dataResolver.getAndFetchItem(setRequestParams(p, p2, p3, p4), shouldRefreshCachedShareLink) -- inferred equivalent call
		end,
		clear = function()
			v2 = {}
			v3 = {}
			v4 = {}
			dataResolver.clear()
		end,
		dispose = function()
			v2 = {}
			v3 = {}
			v4 = {}
			dataResolver.dispose()
		end
	}
end

return createMomentsShareLinkStore
