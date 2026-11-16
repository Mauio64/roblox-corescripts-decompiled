local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local HttpClient = require(parent.HttpClient)

local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)
require(DataHydration.DataHydrationTypes)
local responseDecoders = require(script.Parent.responseDecoders)
require(script.Parent.types)

local v = { default = "MODEL_TIER_DEFAULT", advanced = "MODEL_TIER_ADVANCED" }

local function createTierQuotaStore(data)
	local dataCache = createDataCache(data.ttlSeconds, data.ttlSeconds)
	local v2 = {}
	local flag = false
	local v3 = string.find(data.quotaSummaryUrl, "?", 1, true) and "&" or "?"
	local dataResolver = createDataResolver({
		cache = dataCache,
		supportsMultiGet = false,
		replaceItems = true,
		ignoreResponsesAfterTimeout = true,
		onBeforeClear = function()
			v2 = {}
		end,
		fetchFn = function(value: string)
			local v4, v5 = string.match(value, "^([^:]+):([^:]+)$")
			return HttpClient.asPromise(HttpClient.fetch({
				method = "GET",
				url = `{data.quotaSummaryUrl}{v3}product={v4}&modelTier={v[v5]}`,
				analyticsKey = "creator-credit.get-quota-summary",
				network = data.network,
				decode = responseDecoders.decodeTierQuotaSummary
			}))
		end
	})

	local function getKey(p, p2) -- 3 equivalent calls inferred from this helper
		assert(not flag, "Creator Credit tier store is disposed")
		assert(p == "PRODUCT_BUILD" or p == "PRODUCT_BUILD_IN_STUDIO", "Invalid quota product")
		assert(v[p2] ~= nil, "Invalid model tier")
		return `{p}:{p2}`
	end

	local function dispose()
		if flag then
			return
		end

		flag = true
		dataResolver.dispose()
	end

	return {
		getTierQuotaSummary = function(p, p2)
			local key = getKey(p, p2) -- inferred equivalent call

			if data.getLocalPlayerUserId() == nil then
				return dataResolver.getCachedItem(key)
			end

			v2[key] = true
			return dataResolver.getAndFetchItem(key)
		end,
		getTierQuotaSummarySignals = function(p, p2)
			return dataResolver.getCachedItem(getKey(p, p2)) -- inferred equivalent call
		end,
		refreshTierQuotaSummary = function(p, p2)
			local key = getKey(p, p2) -- inferred equivalent call

			if data.getLocalPlayerUserId() == nil then
				return dataResolver.getCachedItem(key)
			end

			v2[key] = true
			return dataResolver.fetchItem(key)
		end,
		invalidate = function()
			local v4 = v2
			dataResolver.clear()

			if data.getLocalPlayerUserId() ~= nil then
				v2 = v4

				for k in v4 do
					dataResolver.fetchItem(k)
				end
			end
		end,
		clear = dataResolver.clear,
		dispose = dispose
	}
end

return createTierQuotaStore
