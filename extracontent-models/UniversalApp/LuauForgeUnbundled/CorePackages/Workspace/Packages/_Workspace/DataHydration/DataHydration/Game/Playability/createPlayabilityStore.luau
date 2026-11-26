local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Dash")

local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")
local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/Playability/fetchPlayability")
local PlayabilityStoreTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/Playability/PlayabilityStoreTypes")

local DiscoveryUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DiscoveryUtils")
local logResponseError = DiscoveryUtils.logResponseError
local discoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local fIntLuaAppThrottleRefreshPlayabilityIntervalSeconds = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").GetFIntLuaAppThrottleRefreshPlayabilityIntervalSeconds()

local function createPlayabilityStore()
	local v5 = createDataCache(fIntLuaAppThrottleRefreshPlayabilityIntervalSeconds)
	local v6 = createDataResolver({
		cache = v5,
		logError = function(data)
			if type(data) == "table" then
				if data.responseCode then
					logResponseError("v1/games/multiget-playability-status", {
						StatusCode = tonumber(data.responseCode)
					})
				end

				if data.errorType and data.errorMessage then
					discoveryEventErrorLogger.reportError(
						data.errorType,
						data.errorMessage,
						data.customFields
					)
				end
			else
				discoveryEventErrorLogger.reportError("FetchPlayabilityError", (tostring(data)))
			end
		end,
		fetchFn = function(p2)
			local keys = Dash.keys(p2)
			return module4(keys):andThen(function(p3)
				if not (p3 and p3.responseBody) then
					error({
						responseCode = p3 and p3.responseCode,
						errorType = "FetchPlayabilityResponseError",
						errorMessage = p3 and "Missing response body" or "No response",
						customFields = { universeIds = keys }
					})
				end

				local playabilityResponseValidator, v7 = PlayabilityStoreTypes.playabilityResponseValidator(p3.responseBody)

				if not playabilityResponseValidator then
					error({
						responseCode = p3.responseCode,
						errorType = "FetchPlayabilityResponseInvalidInterface",
						errorMessage = v7,
						customFields = { universeIds = keys }
					})
				end

				local result = {}

				for k, v8 in p3.responseBody do
					result[tostring(v8.universeId)] = {
						isPlayable = v8.isPlayable,
						playabilityStatus = v8.playabilityStatus
					}
				end

				return result
			end):catch(function(message)
				error(message)
			end)
		end
	})

	return {
		fetchPlayability = v6.fetchItem,
		getPlayability = v6.getCachedItem,
		getAndFetchPlayability = v6.getAndFetchItem,
		updatePlayability = v5.updateItem,
		updatePlayabilities = v5.updateItems,
		clear = v6.clear,
		dispose = v6.dispose
	}
end

return createPlayabilityStore
