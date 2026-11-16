local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local Promise = require(parent.Promise)

local DiscoveryUtils = require(parent.DiscoveryUtils)
local logResponseError = DiscoveryUtils.logResponseError
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local SharedFlags = require(parent.SharedFlags)
local FFlagSduiDevStoreSeeAllSupport = SharedFlags.FFlagSduiDevStoreSeeAllSupport
local FFlagEnableHomeGameItemOwnershipUpdate = SharedFlags.FFlagEnableHomeGameItemOwnershipUpdate
local FFlagEnableSearchGameItemOwnershipUpdate = SharedFlags.FFlagEnableSearchGameItemOwnershipUpdate

local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)
require(DataHydration.DataHydrationTypes)

require(script.Parent.GameDeveloperProductStoreTypes)
local fetchGameDeveloperProductStatuses = require(script.Parent.fetchGameDeveloperProductStatuses)

local function buildStatusesKey(p: string, p2: string) -- 1 equivalent call inferred from this helper
	return p .. "|" .. p2
end

local function createGameDeveloperProductStore()
	local dataCache = createDataCache()
	local cache, v

	if
		FFlagSduiDevStoreSeeAllSupport
		or FFlagEnableHomeGameItemOwnershipUpdate
		or FFlagEnableSearchGameItemOwnershipUpdate
	then
		cache = createDataCache()
		v = createDataResolver({
			cache = cache,
			supportsMultiGet = false,
			logError = function(p)
				local statusCode

				if type(p) == "table" and p.StatusCode then
					statusCode = p.StatusCode
				end

				logResponseError("game-transactions/v1/receipts", { StatusCode = statusCode })
				DiscoveryEventErrorLogger.reportError(
					"GameDeveloperProductStore",
					"Failed to fetch developer product statuses",
					{ err = tostring(p) }
				)
			end,
			fetchFn = function(value: string, p)
				local v2, v3 = string.match(value, "^(.-)|(.+)$")

				if v2 == nil or v3 == nil then
					return Promise.reject("Invalid developer product statuses key: " .. tostring(value))
				end

				return fetchGameDeveloperProductStatuses.fetch(v2, v3):andThen(function(p2)
					local v4 = {}

					for k, count in p2.counts do
						v4[k] = { pendingReceiptCount = count }
					end

					local v5 = p and p.data(false)

					if v5 and v5.counts then
						for k in v5.counts do
							if p2.counts[k] == nil then
								v4[k] = { pendingReceiptCount = 0 }
							end
						end
					end

					if next(v4) ~= nil then
						dataCache.updateItems(v4)
					end

					return p2
				end)
			end
		})
	else
		cache = nil
		v = nil
	end

	return {
		getGameDeveloperProductInfo = dataCache.getItem,
		updateGameDeveloperProductInfos = dataCache.updateItems,
		fetchStatuses = function(p: string, p2: string)
			if v then
				v.fetchItem(buildStatusesKey(p, p2)) -- inferred equivalent call
			end
		end,
		clear = function()
			if cache then
				cache.clear()
			end

			if v then
				v.clear()
			end

			dataCache.clear()
		end,
		dispose = function()
			if v then
				v.dispose()
			end

			dataCache.dispose()
		end
	}
end

return createGameDeveloperProductStore
