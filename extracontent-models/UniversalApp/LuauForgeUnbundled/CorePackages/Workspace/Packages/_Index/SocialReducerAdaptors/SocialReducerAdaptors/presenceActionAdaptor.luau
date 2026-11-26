local llama = require("@game/CorePackages/Workspace/Packages/_Index/SocialReducerAdaptors/SocialReducerAdaptors/dependencies").llama

return function(p2)
	local function fn(data)
		local presence = p2.Models.Presence.new(llama.Dictionary.join(data, {
			presence = llama.None,
			userPresenceType = (table.find({
				"OFFLINE",
				"ONLINE",
				"IN_GAME",
				"IN_STUDIO"
			}, data.presence) or 1) - 1,
			gameInstanceId = llama.None,
			gameId = data.gameInstanceId,
			lastOnline = DateTime.now() and DateTime.fromUnixTimestamp(data.lastOnline or 0):ToIsoDate() or "1970-01-01T00:00:00Z",
			type = llama.None
		}))

		return p2.Actions.ReceivedUserPresence(presence)
	end

	return {
		ReceivedUserPresence = function(p3)
			if p3.payload then
				return { p3 }
			end

			return { fn(p3) }
		end
	}
end
