local GAMES_URL = require(script.Parent.Parent.GAMES_URL)

return function(p1) -- line: 5
	-- upvalues: GAMES_URL (copy)
	return p1.roduxNetworking.GET({
		Name = "GetExperienceMedia"
	}, function(p2, p3) -- line: 10
		-- upvalues: GAMES_URL (copy)
		return p2(GAMES_URL):path("v2"):path("games"):id(p3):path("media")
	end)
end
