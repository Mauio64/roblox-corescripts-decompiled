local SQUAD_URL = require(script.Parent.Parent.SQUAD_URL)
require(script.Parent.Parent.networkingSquadTypes)

return function(p)
	return (p.roduxNetworking.POST("ActOnPartyNudge", function(callback, data)
		local path = callback(SQUAD_URL):path("group-up"):path("v1"):path("act-on-party-nudge")
		local v = {
			action = data.action,
			nudgeId = data.nudgeId,
			squadId = data.squadId,
			leaveExisting = data.leaveExisting,
			partyAttemptId = data.partyAttemptId,
			squadLocation = data.squadLocation,
			parentChannelId = data.parentChannelId,
			universeId = 0,
			placeId = 0,
			gameInstanceId = 0
		}
		local universeId

		if game.GameId > 0 then
			universeId = game.GameId
		end

		v.universeId = universeId
		local placeId

		if game.PlaceId > 0 then
			placeId = game.PlaceId
		end

		v.placeId = placeId
		local gameInstanceId

		if game.JobId ~= "" then
			gameInstanceId = game.JobId
		end

		v.gameInstanceId = gameInstanceId
		return path:body(v)
	end))
end
