local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Dash")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")

local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")

local fetchPlaceDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/PlaceDetails/fetchPlaceDetails")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/PlaceDetails/PlaceDetailsStoreTypes")

local function createPlaceDetailsStore(options)
	local v5 = options or {}
	local v6 = { network = v5.network, baseUrl = v5.baseUrl }

	local v7 = createDataCache()
	local v8 = createDataResolver({
		cache = v7,
		replaceItems = true,
		requestBatchSize = 50,
		queueProcessDelaySec = v5.queueProcessDelaySec or 0.05,
		fetchFn = function(p2)
			return fetchPlaceDetails(Dash.keys(p2), v6):andThen(function(options2)
				local result = {}

				for k, v9 in options2 or {} do
					if not (v9 and v9.placeId) then
						continue
					end

					local placeId = tostring(v9.placeId)
					local v11 = if v9.universeId then tostring(v9.universeId) else nil
					result[placeId] = { universeId = v11, name = v9.name }
				end

				return result
			end)
		end
	})

	return {
		getPlaceDetails = v8.getCachedItem,
		getAndFetchPlaceDetails = function(p2)
			return (v8.getAndFetchItem(p2))
		end,
		updatePlaceDetails = function(p2, p3)
			v7.replaceItems({ [p2] = p3 })
		end,
		clear = v8.clear,
		dispose = v8.dispose
	}
end

return createPlaceDetailsStore
