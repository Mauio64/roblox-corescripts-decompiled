local SQUAD_URL = require(script.Parent.Parent.SQUAD_URL)
require(script.Parent.Parent.networkingSquadTypes)

return function(p)
	return (p.roduxNetworking.POST("VoteForExperienceInvite", function(callback, data)
		return callback(SQUAD_URL):path("group-up"):path("v1"):path("vote-for-experience-invite"):body({
			experienceInviteId = data.experienceInviteId,
			membershipEntityId = data.membershipEntityId,
			voteIdentifier = data.voteIdentifier,
			voteType = data.voteType
		})
	end))
end
