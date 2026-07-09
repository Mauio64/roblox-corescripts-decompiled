local SQUAD_URL = require(script.Parent.Parent.SQUAD_URL)

require(script.Parent.Parent.networkingSquadTypes)

return function(p1) -- line: 5
	-- upvalues: SQUAD_URL (copy)
	return (p1.roduxNetworking.GET({
		Name = "GetExperienceInvite"
	}, function(p2, p3) -- line: 9
		-- upvalues: SQUAD_URL (copy)
		return p2(SQUAD_URL):path("group-up"):path("v1"):path("get-experience-invite-status"):queryArgs({
			membershipEntityId = p3.membershipEntityId,
			experienceInviteId = p3.experienceInviteId
		})
	end))
end
