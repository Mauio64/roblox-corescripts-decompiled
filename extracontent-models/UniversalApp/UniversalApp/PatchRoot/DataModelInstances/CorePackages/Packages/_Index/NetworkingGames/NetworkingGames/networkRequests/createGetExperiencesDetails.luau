local GAMES_URL = require(script.Parent.Parent.GAMES_URL)

return function(p)
	return p.roduxNetworking.GET({ Name = "GetExperiencesDetails" }, function(callback, p2)
		return callback(GAMES_URL):path("v1"):path("games"):expandedQueryArgsWithIds("universeIds", p2)
	end)
end
