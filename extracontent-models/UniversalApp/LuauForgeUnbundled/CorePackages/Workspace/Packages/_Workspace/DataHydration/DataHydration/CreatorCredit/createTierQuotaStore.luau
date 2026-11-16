local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")

local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")
local responseDecoders = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorCredit/responseDecoders")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorCredit/types")

local v5 = { default = "MODEL_TIER_DEFAULT", advanced = "MODEL_TIER_ADVANCED" }

local function createTierQuotaStore(data)
	local v6 = createDataCache(data.ttlSeconds, data.ttlSeconds)
	local v7 = {}
	local flag = false
	local v8 = string.find(data.quotaSummaryUrl, "?", 1, true) and "&" or "?"
	local v9 = createDataResolver({
		cache = v6,
		supportsMultiGet = false,
		replaceItems = true,
		ignoreResponsesAfterTimeout = true,
		onBeforeClear = function()
			v7 = {}
		end,
		fetchFn = function(value)
			local v10, v11 = string.match(value, "^([^:]+):([^:]+)$")
			return HttpClient.asPromise(HttpClient.fetch({
				method = "GET",
				url = `{data.quotaSummaryUrl}{v8}product={v10}&modelTier={v5[v11]}`,
				analyticsKey = "creator-credit.get-quota-summary",
				network = data.network,
				decode = responseDecoders.decodeTierQuotaSummary
			}))
		end
	})

	local function getKey(p2, p3)
		assert(not flag, "Creator Credit tier store is disposed")
		assert(p2 == "PRODUCT_BUILD" or p2 == "PRODUCT_BUILD_IN_STUDIO", "Invalid quota product")
		assert(v5[p3] ~= nil, "Invalid model tier")
		return `{p2}:{p3}`
	end

	local function dispose()
		if flag then
			return
		end

		flag = true
		v9.dispose()
	end

	return {
		getTierQuotaSummary = function(p2, p3)
			assert(not flag, "Creator Credit tier store is disposed")
			assert(p2 == "PRODUCT_BUILD" or p2 == "PRODUCT_BUILD_IN_STUDIO", "Invalid quota product")
			assert(v5[p3] ~= nil, "Invalid model tier")
			local formatted = `{p2}:{p3}`

			if data.getLocalPlayerUserId() == nil then
				return v9.getCachedItem(formatted)
			end

			v7[formatted] = true
			return v9.getAndFetchItem(formatted)
		end,
		getTierQuotaSummarySignals = function(p2, p3)
			local getCachedItem = v9.getCachedItem
			assert(not flag, "Creator Credit tier store is disposed")
			assert(p2 == "PRODUCT_BUILD" or p2 == "PRODUCT_BUILD_IN_STUDIO", "Invalid quota product")
			assert(v5[p3] ~= nil, "Invalid model tier")
			return getCachedItem(`{p2}:{p3}`)
		end,
		refreshTierQuotaSummary = function(p2, p3)
			assert(not flag, "Creator Credit tier store is disposed")
			assert(p2 == "PRODUCT_BUILD" or p2 == "PRODUCT_BUILD_IN_STUDIO", "Invalid quota product")
			assert(v5[p3] ~= nil, "Invalid model tier")
			local formatted = `{p2}:{p3}`

			if data.getLocalPlayerUserId() == nil then
				return v9.getCachedItem(formatted)
			end

			v7[formatted] = true
			return v9.fetchItem(formatted)
		end,
		invalidate = function()
			local v10 = v7
			v9.clear()

			if data.getLocalPlayerUserId() ~= nil then
				v7 = v10

				for k in v10 do
					v9.fetchItem(k)
				end
			end
		end,
		clear = v9.clear,
		dispose = dispose
	}
end

return createTierQuotaStore
