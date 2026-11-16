local SQUAD_URL = require(script.Parent.Parent.SQUAD_URL)
require(script.Parent.Parent.networkingSquadTypes)

return function(p)
	return (p.roduxNetworking.GET("GetExperienceInvite", function(callback, p2)
		return callback(SQUAD_URL):path("group-up"):path("v1"):path("get-experience-invite-status"):queryArgs({
			membershipEntityId = p2.membershipEntityId,
			experienceInviteId = p2.experienceInviteId
		})
	end))
end
