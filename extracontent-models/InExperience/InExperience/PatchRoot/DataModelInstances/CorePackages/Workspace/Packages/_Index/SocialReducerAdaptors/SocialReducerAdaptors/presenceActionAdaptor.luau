local SocialReducerAdaptors = script:FindFirstAncestor("SocialReducerAdaptors")
local llama = require(SocialReducerAdaptors.dependencies).llama

return function(p1) -- line: 17
	-- upvalues: llama (copy)
	local function v4(t1: {[any]: any}) -- line: 18
		-- upvalues: p1 (copy), llama (copy)
		local v6 = p1.Models.Presence.new(llama.Dictionary.join(t1, {
			presence = llama.None,
			userPresenceType = (table.find({
				"OFFLINE",
				"ONLINE",
				"IN_GAME",
				"IN_STUDIO"
			}, t1.presence) or 1) - 1,
			gameInstanceId = llama.None,
			gameId = t1.gameInstanceId,
			lastOnline = DateTime.now() and DateTime.fromUnixTimestamp(t1.lastOnline or 0):ToIsoDate() or "1970-01-01T00:00:00Z",
			type = llama.None
		}))

		return p1.Actions.ReceivedUserPresence(v6)
	end

	return {
		ReceivedUserPresence = function(t2: {[any]: any}) -- line: 45
			-- upvalues: v4 (copy)
			if t2.payload then
				return { t2 }
			end

			return { v4(t2) }
		end
	}
end
