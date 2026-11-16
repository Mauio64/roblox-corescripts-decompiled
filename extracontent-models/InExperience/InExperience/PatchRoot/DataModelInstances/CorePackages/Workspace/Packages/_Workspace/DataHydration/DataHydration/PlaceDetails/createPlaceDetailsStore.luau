local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local Dash = require(parent.Dash)
require(parent.HttpClient)

local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)
require(DataHydration.DataHydrationTypes)

local fetchPlaceDetails = require(script.Parent.fetchPlaceDetails)
require(script.Parent.PlaceDetailsStoreTypes)

local function createPlaceDetailsStore(options)
	local v = options or {}
	local v2 = { network = v.network, baseUrl = v.baseUrl }

	local dataCache = createDataCache()
	local dataResolver = createDataResolver({
		cache = dataCache,
		replaceItems = true,
		requestBatchSize = 50,
		queueProcessDelaySec = v.queueProcessDelaySec or 0.05,
		fetchFn = function(p)
			return fetchPlaceDetails(Dash.keys(p), v2):andThen(function(options2)
				local result = {}

				for _, v3 in options2 or {} do
					if not (v3 and v3.placeId) then
						continue
					end

					local placeId = tostring(v3.placeId)
					local universeId

					if v3.universeId then
						universeId = tostring(v3.universeId)
					end

					result[placeId] = { universeId = universeId, name = v3.name }
				end

				return result
			end)
		end
	})

	return {
		getPlaceDetails = dataResolver.getCachedItem,
		getAndFetchPlaceDetails = function(p: string)
			return (dataResolver.getAndFetchItem(p))
		end,
		updatePlaceDetails = function(p: string, p2)
			dataCache.replaceItems({ [p] = p2 })
		end,
		clear = dataResolver.clear,
		dispose = dataResolver.dispose
	}
end

return createPlaceDetailsStore
