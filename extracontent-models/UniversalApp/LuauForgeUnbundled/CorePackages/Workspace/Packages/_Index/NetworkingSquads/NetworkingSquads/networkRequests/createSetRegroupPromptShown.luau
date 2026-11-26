local SQUAD_URL = require("@game/CorePackages/Workspace/Packages/_Index/NetworkingSquads/NetworkingSquads/SQUAD_URL")
require("@game/CorePackages/Workspace/Packages/_Index/NetworkingSquads/NetworkingSquads/networkingSquadTypes")

return function(p2)
	return (p2.roduxNetworking.POST("SetRegroupPromptShown", function(callback, p3)
		return callback(SQUAD_URL):path("group-up"):path("v1"):path("set-regroup-prompt-shown"):body({
			groupUpId = p3.groupUpId
		})
	end))
end
