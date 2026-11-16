local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

require(parent.HttpClient)

local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)
require(DataHydration.DataHydrationTypes)
local fetchShareLinkMetadata = require(script.Parent.fetchShareLinkMetadata)
require(script.Parent.ShareLinkMetadataStoreTypes)

local function createShareLinkMetadataStore(options)
	local v = options or {}
	local v2 = {}

	local dataResolver = createDataResolver({
		cache = createDataCache(v.ttlSeconds, v.failedTtlSeconds),
		supportsMultiGet = false,
		replaceItems = true,
		logError = v.logError,
		fetchFn = function(p: string, _)
			local v3 = v2[p]

			if v3 == nil then
				error(`Missing link type for {p}`)
			end

			return fetchShareLinkMetadata(p, v3, { network = v.network, baseUrl = v.baseUrl })
		end
	})

	local function setLinkType(p: string, p2: string) -- 2 equivalent calls inferred from this helper
		v2[p] = p2
		return p
	end

	local function clear()
		v2 = {}
		dataResolver.clear()
	end

	local function dispose()
		v2 = {}
		dataResolver.dispose()
	end

	return {
		getShareLinkMetadata = dataResolver.getCachedItem,
		fetchShareLinkMetadata = function(p, p2)
			return dataResolver.fetchItem(setLinkType(p, p2)) -- inferred equivalent call
		end,
		getAndFetchShareLinkMetadata = function(p, p2)
			return dataResolver.getAndFetchItem(setLinkType(p, p2)) -- inferred equivalent call
		end,
		clear = clear,
		dispose = dispose
	}
end

return createShareLinkMetadataStore
