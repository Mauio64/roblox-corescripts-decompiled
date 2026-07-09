local SQUAD_URL = require(script.Parent.Parent.SQUAD_URL)

require(script.Parent.Parent.networkingSquadTypes)

return function(p1) -- line: 5
	-- upvalues: SQUAD_URL (copy)
	return (p1.roduxNetworking.POST({
		Name = "SetRegroupPromptShown"
	}, function(p2, p3) -- line: 10
		-- upvalues: SQUAD_URL (copy)
		return p2(SQUAD_URL):path("group-up"):path("v1"):path("set-regroup-prompt-shown"):body({
			groupUpId = p3.groupUpId
		})
	end))
end
