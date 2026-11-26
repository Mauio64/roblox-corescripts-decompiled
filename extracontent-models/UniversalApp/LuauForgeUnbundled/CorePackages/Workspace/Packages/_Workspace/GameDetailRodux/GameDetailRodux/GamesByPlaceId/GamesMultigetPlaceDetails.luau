local url = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/Http").Url

return function(callback, p2)
	local queryString = url:makeQueryString({ placeIds = p2 })
	return callback(
		string.format("%s/v1/games/multiget-place-details?%s", url.GAME_URL, queryString),
		"GET"
	)
end
