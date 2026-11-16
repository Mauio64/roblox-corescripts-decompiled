local parent = script:FindFirstAncestor("DataHydration").Parent

local HttpClient = require(parent.HttpClient)
local Http = require(parent.Http)
local Url = Http.Url

require(script.Parent.PlaceDetailsStoreTypes)

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local function placeDetailsUrl(baseUrl: string, list) -- 1 equivalent call inferred from this helper
	return ("%sv1/games/multiget-place-details?placeIds=%s"):format(baseUrl, table.concat(list, "&placeIds="))
end

local function fetchPlaceDetails(list, options)
	local v = options or {}
	return asPromise((fetch({
		network = v.network,
		method = "GET",
		url = placeDetailsUrl(v.baseUrl or Url.GAME_URL, list), -- inferred equivalent call
		analyticsKey = "place-details.multiget",
		legacy = true,
		decode = function(p)
			return p
		end
	})))
end

return fetchPlaceDetails
