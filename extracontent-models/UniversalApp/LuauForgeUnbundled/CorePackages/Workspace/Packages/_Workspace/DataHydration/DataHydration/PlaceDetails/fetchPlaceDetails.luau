local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Http").Url

require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/PlaceDetails/PlaceDetailsStoreTypes")

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local function placeDetailsUrl(p2, list)
	return ("%sv1/games/multiget-place-details?placeIds=%s"):format(p2, table.concat(list, "&placeIds="))
end

local function fetchPlaceDetails(list, options)
	local v5 = options or {}
	return asPromise((fetch({
		network = v5.network,
		method = "GET",
		url = ("%sv1/games/multiget-place-details?placeIds=%s"):format(
			v5.baseUrl or url.GAME_URL,
			table.concat(list, "&placeIds=")
		),
		analyticsKey = "place-details.multiget",
		legacy = true,
		decode = function(p2)
			return p2
		end
	})))
end

return fetchPlaceDetails
