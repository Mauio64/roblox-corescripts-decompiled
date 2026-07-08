local GAMES_URL = require(script.Parent.Parent.GAMES_URL)

return function(p1) -- line: 9
	-- upvalues: GAMES_URL (copy)
	return p1.roduxNetworking.GET({
		Name = "GetExperiencesPlayabilityStatus"
	}, function(p2, t1: {[any]: any}) -- line: 12
		-- upvalues: GAMES_URL (copy)
		return p2(GAMES_URL):path("v1"):path("games"):path("multiget-playability-status"):expandedQueryArgsWithIds("universeIds", t1)
	end)
end
