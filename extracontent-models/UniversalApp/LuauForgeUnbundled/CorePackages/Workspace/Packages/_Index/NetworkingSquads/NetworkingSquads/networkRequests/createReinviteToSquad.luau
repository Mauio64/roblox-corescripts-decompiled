local SQUAD_URL = require("@game/CorePackages/Workspace/Packages/_Index/NetworkingSquads/NetworkingSquads/SQUAD_URL")
require("@game/CorePackages/Workspace/Packages/_Index/NetworkingSquads/NetworkingSquads/networkingSquadTypes")

return function(p2)
	return (p2.roduxNetworking.POST("ReinviteToSquad", function(callback, p3)
		return callback(SQUAD_URL):path("group-up"):path("v1"):path("reinvite"):body({
			groupUpId = p3.squadId
		})
	end))
end
