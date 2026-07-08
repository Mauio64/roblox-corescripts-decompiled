local SQUAD_URL = require(script.Parent.Parent.SQUAD_URL)

require(script.Parent.Parent.networkingSquadTypes)

return function(p1) -- line: 5
	-- upvalues: SQUAD_URL (copy)
	return (p1.roduxNetworking.POST({
		Name = "VoteForExperienceInvite"
	}, function(p2, p3) -- line: 9
		-- upvalues: SQUAD_URL (copy)
		return p2(SQUAD_URL):path("group-up"):path("v1"):path("vote-for-experience-invite"):body({
			experienceInviteId = p3.experienceInviteId,
			membershipEntityId = p3.membershipEntityId,
			voteIdentifier = p3.voteIdentifier,
			voteType = p3.voteType
		})
	end))
end
