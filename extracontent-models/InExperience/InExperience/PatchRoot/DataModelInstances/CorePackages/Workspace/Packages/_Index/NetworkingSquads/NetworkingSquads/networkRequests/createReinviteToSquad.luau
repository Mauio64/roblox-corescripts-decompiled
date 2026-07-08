local SQUAD_URL = require(script.Parent.Parent.SQUAD_URL)

require(script.Parent.Parent.networkingSquadTypes)

return function(p1) -- line: 4
	-- upvalues: SQUAD_URL (copy)
	return (p1.roduxNetworking.POST({
		Name = "ReinviteToSquad"
	}, function(p2, p3) -- line: 9
		-- upvalues: SQUAD_URL (copy)
		return p2(SQUAD_URL):path("group-up"):path("v1"):path("reinvite"):body({
			groupUpId = p3.squadId
		})
	end))
end
