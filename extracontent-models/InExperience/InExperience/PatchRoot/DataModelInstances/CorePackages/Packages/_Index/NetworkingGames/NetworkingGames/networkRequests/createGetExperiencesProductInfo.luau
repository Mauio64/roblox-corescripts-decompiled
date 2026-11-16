local GAMES_URL = require(script.Parent.Parent.GAMES_URL)

return function(p)
	return p.roduxNetworking.GET({ Name = "GetExperiencesProductInfo" }, function(callback, p2)
		return callback(GAMES_URL):path("v1"):path("games"):path("games-product-info"):expandedQueryArgsWithIds(
			"universeIds",
			p2
		)
	end)
end
