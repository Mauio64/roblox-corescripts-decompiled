local SQUAD_URL = require(script.Parent.Parent.SQUAD_URL)
require(script.Parent.Parent.networkingSquadTypes)

return function(p)
	return (p.roduxNetworking.POST("SetRegroupPromptShown", function(callback, p2)
		return callback(SQUAD_URL):path("group-up"):path("v1"):path("set-regroup-prompt-shown"):body({
			groupUpId = p2.groupUpId
		})
	end))
end
