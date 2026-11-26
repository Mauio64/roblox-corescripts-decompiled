local SQUAD_URL = require("@game/CorePackages/Workspace/Packages/_Index/NetworkingSquads/NetworkingSquads/SQUAD_URL")
require("@game/CorePackages/Workspace/Packages/_Index/NetworkingSquads/NetworkingSquads/networkingSquadTypes")

return function(p2)
	return (p2.roduxNetworking.POST("VoteForExperienceInvite", function(callback, data)
		return callback(SQUAD_URL):path("group-up"):path("v1"):path("vote-for-experience-invite"):body({
			experienceInviteId = data.experienceInviteId,
			membershipEntityId = data.membershipEntityId,
			voteIdentifier = data.voteIdentifier,
			voteType = data.voteType
		})
	end))
end
