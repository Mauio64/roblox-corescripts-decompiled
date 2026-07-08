local SQUAD_URL = require(script.Parent.Parent.SQUAD_URL)

require(script.Parent.Parent.networkingSquadTypes)

return function(p1) -- line: 5
	-- upvalues: SQUAD_URL (copy)
	return (p1.roduxNetworking.POST({
		Name = "ActOnPartyNudge"
	}, function(p2, p3) -- line: 10
		-- upvalues: SQUAD_URL (copy)
		return p2(SQUAD_URL):path("group-up"):path("v1"):path("act-on-party-nudge"):body({
			action = p3.action,
			nudgeId = p3.nudgeId,
			squadId = p3.squadId,
			leaveExisting = p3.leaveExisting,
			partyAttemptId = p3.partyAttemptId,
			squadLocation = p3.squadLocation,
			parentChannelId = p3.parentChannelId,
			universeId = if not (game.GameId > 0) then nil else game.GameId,
			placeId = if not (game.PlaceId > 0) then nil else game.PlaceId,
			gameInstanceId = if game.JobId == "" then nil else game.JobId
		})
	end))
end
