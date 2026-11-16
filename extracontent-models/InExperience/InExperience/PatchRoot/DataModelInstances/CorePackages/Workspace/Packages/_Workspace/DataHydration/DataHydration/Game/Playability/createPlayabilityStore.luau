local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent
local Dash = require(parent.Dash)

local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)
require(DataHydration.DataHydrationTypes)
local fetchPlayability = require(script.Parent.fetchPlayability)
local PlayabilityStoreTypes = require(script.Parent.PlayabilityStoreTypes)

local DiscoveryUtils = require(parent.DiscoveryUtils)
local logResponseError = DiscoveryUtils.logResponseError
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local SharedFlags = require(parent.SharedFlags)
local fIntLuaAppThrottleRefreshPlayabilityIntervalSeconds = SharedFlags.GetFIntLuaAppThrottleRefreshPlayabilityIntervalSeconds()

local function createPlayabilityStore()
	local dataCache = createDataCache(fIntLuaAppThrottleRefreshPlayabilityIntervalSeconds)
	local dataResolver = createDataResolver({
		cache = dataCache,
		logError = function(data)
			if type(data) == "table" then
				if data.responseCode then
					logResponseError("v1/games/multiget-playability-status", {
						StatusCode = tonumber(data.responseCode)
					})
				end

				if data.errorType and data.errorMessage then
					DiscoveryEventErrorLogger.reportError(data.errorType, data.errorMessage, data.customFields)
				end
			else
				DiscoveryEventErrorLogger.reportError("FetchPlayabilityError", (tostring(data)))
			end
		end,
		fetchFn = function(p)
			local keys = Dash.keys(p)
			return fetchPlayability(keys):andThen(function(p2)
				if not (p2 and p2.responseBody) then
					error({
						responseCode = p2 and p2.responseCode,
						errorType = "FetchPlayabilityResponseError",
						errorMessage = p2 and "Missing response body" or "No response",
						customFields = { universeIds = keys }
					})
				end

				local playabilityResponseValidator, errorMessage = PlayabilityStoreTypes.playabilityResponseValidator(p2.responseBody)

				if not playabilityResponseValidator then
					error({
						responseCode = p2.responseCode,
						errorType = "FetchPlayabilityResponseInvalidInterface",
						errorMessage = errorMessage,
						customFields = { universeIds = keys }
					})
				end

				local result = {}

				for _, v in p2.responseBody do
					result[tostring(v.universeId)] = {
						isPlayable = v.isPlayable,
						playabilityStatus = v.playabilityStatus
					}
				end

				return result
			end):catch(function(message)
				error(message)
			end)
		end
	})

	return {
		fetchPlayability = dataResolver.fetchItem,
		getPlayability = dataResolver.getCachedItem,
		getAndFetchPlayability = dataResolver.getAndFetchItem,
		updatePlayability = dataCache.updateItem,
		updatePlayabilities = dataCache.updateItems,
		clear = dataResolver.clear,
		dispose = dataResolver.dispose
	}
end

return createPlayabilityStore
