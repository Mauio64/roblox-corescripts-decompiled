local SQUAD_URL = require("@game/CorePackages/Workspace/Packages/_Index/NetworkingSquads/NetworkingSquads/SQUAD_URL")
require("@game/CorePackages/Workspace/Packages/_Index/NetworkingSquads/NetworkingSquads/networkingSquadTypes")

return function(p2)
	return (p2.roduxNetworking.POST("ActOnPartyNudge", function(callback, data)
		local path = callback(SQUAD_URL):path("group-up"):path("v1"):path("act-on-party-nudge")
		local v5 = {
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
		local v6 = if game.GameId > 0 then game.GameId else nil
		v5.universeId = v6
		local v7 = if game.PlaceId > 0 then game.PlaceId else nil
		v5.placeId = v7
		local v8 = if game.JobId ~= "" then game.JobId else nil
		v5.gameInstanceId = v8
		return path:body(v5)
	end))
end
