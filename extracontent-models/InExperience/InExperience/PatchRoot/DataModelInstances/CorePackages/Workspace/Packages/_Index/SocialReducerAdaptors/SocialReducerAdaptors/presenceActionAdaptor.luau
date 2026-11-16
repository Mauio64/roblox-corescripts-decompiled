local SocialReducerAdaptors = script:FindFirstAncestor("SocialReducerAdaptors")
local dependencies = require(SocialReducerAdaptors.dependencies)
local llama = dependencies.llama

return function(p)
	local function fn(data)
		local presence = p.Models.Presence.new(llama.Dictionary.join(data, {
			presence = llama.None,
			userPresenceType = (table.find({ "OFFLINE", "ONLINE", "IN_GAME", "IN_STUDIO" }, data.presence) or 1) - 1,
			gameInstanceId = llama.None,
			gameId = data.gameInstanceId,
			lastOnline = DateTime.now() and DateTime.fromUnixTimestamp(data.lastOnline or 0):ToIsoDate() or "1970-01-01T00:00:00Z",
			type = llama.None
		}))

		return p.Actions.ReceivedUserPresence(presence)
	end

	return {
		ReceivedUserPresence = function(p2)
			if p2.payload then
				return { p2 }
			end

			return { fn(p2) }
		end
	}
end
