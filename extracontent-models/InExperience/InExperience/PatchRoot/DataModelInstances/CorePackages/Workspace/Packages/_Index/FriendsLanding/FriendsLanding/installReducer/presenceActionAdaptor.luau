local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)
local llama = dependencies.llama
local RoduxPresence = dependencies.RoduxPresence
local t1 = {
	"OFFLINE",
	"ONLINE",
	"IN_GAME",
	"IN_STUDIO"
}

local function convertFromOldPresenceModel(t2: {[any]: any}) -- line: 28
	-- upvalues: RoduxPresence (copy), llama (copy), t1 (copy)
	local v8 = RoduxPresence.Models.Presence.new(llama.Dictionary.join(t2, {
		presence = llama.None,
		userPresenceType = (table.find(t1, t2.presence) or 1) - 1,
		gameInstanceId = llama.None,
		gameId = t2.gameInstanceId,
		lastOnline = DateTime.now() and DateTime.fromUnixTimestamp(t2.lastOnline or 0):ToIsoDate() or "1970-01-01T00:00:00Z"
	}))

	return RoduxPresence.Actions.ReceivedUserPresence(v8)
end

return {
	ReceivedUserPresence = function(p1) -- line: 45
		-- upvalues: convertFromOldPresenceModel (copy)
		if p1.payload then
			return p1
		end

		return { convertFromOldPresenceModel(p1) }
	end
}
