local GAMES_URL = require(script.Parent.Parent.GAMES_URL)

return function(p)
	return p.roduxNetworking.GET({ Name = "GetExperienceMedia" }, function(callback, p2)
		return callback(GAMES_URL):path("v2"):path("games"):id(p2):path("media")
	end)
end
