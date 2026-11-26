local SQUAD_URL = require("@game/CorePackages/Workspace/Packages/_Index/NetworkingSquads/NetworkingSquads/SQUAD_URL")
require("@game/CorePackages/Workspace/Packages/_Index/NetworkingSquads/NetworkingSquads/networkingSquadTypes")

return function(p2)
	return (p2.roduxNetworking.GET("GetExperienceInvite", function(callback, p3)
		return callback(SQUAD_URL):path("group-up"):path("v1"):path("get-experience-invite-status"):queryArgs({
			membershipEntityId = p3.membershipEntityId,
			experienceInviteId = p3.experienceInviteId
		})
	end))
end
