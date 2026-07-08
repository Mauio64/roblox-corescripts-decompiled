local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local Dash = require(DataHydrationParent.Dash)
local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)

require(DataHydration.DataHydrationTypes)

local fetchPlayability = require(script.Parent.fetchPlayability)
local PlayabilityStoreTypes = require(script.Parent.PlayabilityStoreTypes)
local DiscoveryUtils = require(DataHydrationParent.DiscoveryUtils)
local logResponseError = DiscoveryUtils.logResponseError
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger
local v11 = require(DataHydrationParent.SharedFlags).GetFIntLuaAppThrottleRefreshPlayabilityIntervalSeconds()

local function createPlayabilityStore() -- line: 23
	-- upvalues: createDataCache (copy), v11 (copy), createDataResolver (copy), logResponseError (copy), DiscoveryEventErrorLogger (copy), Dash (copy), fetchPlayability (copy), PlayabilityStoreTypes (copy)
	local v13 = createDataCache(v11)
	local v14 = createDataResolver({
		cache = v13,
		logError = function(p1) -- line: 28
			-- upvalues: logResponseError (copy), DiscoveryEventErrorLogger (copy)
			if type(p1) == "table" then
				if p1.responseCode then
					logResponseError("v1/games/multiget-playability-status", {
						StatusCode = tonumber(p1.responseCode)
					})
				end

				if p1.errorType and p1.errorMessage then
					DiscoveryEventErrorLogger.reportError(p1.errorType, p1.errorMessage, p1.customFields)

					return
				end
			else
				DiscoveryEventErrorLogger.reportError("FetchPlayabilityError", (tostring(p1)))
			end
		end,
		fetchFn = function(t1: {[any]: any}) -- line: 48
			-- upvalues: Dash (copy), fetchPlayability (copy), PlayabilityStoreTypes (copy)
			local v17 = Dash.keys(t1)

			return fetchPlayability(v17):andThen(function(p2) -- line: 53
				-- upvalues: v17 (copy), PlayabilityStoreTypes (copy)
				if not p2 or not p2.responseBody then
					error({
						errorType = "FetchPlayabilityResponseError",
						responseCode = p2 and p2.responseCode,
						errorMessage = not p2 and "No response" or "Missing response body",
						customFields = {
							universeIds = v17
						}
					})
				end

				local v19, v20 = PlayabilityStoreTypes.playabilityResponseValidator(p2.responseBody)

				if not v19 then
					error({
						errorType = "FetchPlayabilityResponseInvalidInterface",
						responseCode = p2.responseCode,
						errorMessage = v20,
						customFields = {
							universeIds = v17
						}
					})
				end

				local t2 = {}

				for _, v23 in p2.responseBody do
					t2[tostring(v23.universeId)] = {
						isPlayable = v23.isPlayable,
						playabilityStatus = v23.playabilityStatus
					}
				end

				return t2
			end):catch(function(p3) -- line: 85
				error(p3)
			end)
		end
	})

	return {
		fetchPlayability = v14.fetchItem,
		getPlayability = v14.getCachedItem,
		getAndFetchPlayability = v14.getAndFetchItem,
		updatePlayability = v13.updateItem,
		updatePlayabilities = v13.updateItems,
		clear = v14.clear,
		dispose = v14.dispose
	}
end

return createPlayabilityStore
