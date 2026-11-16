local parent = script:FindFirstAncestor("PlaceInfoRodux").Parent

local Http = require(parent.Http)
local Url = Http.Url

return function(callback, placeIds)
	local queryString = Url:makeQueryString({ placeIds = placeIds })
	return callback(string.format("%s/v1/games/multiget-place-details?%s", Url.GAME_URL, queryString), "GET")
end
