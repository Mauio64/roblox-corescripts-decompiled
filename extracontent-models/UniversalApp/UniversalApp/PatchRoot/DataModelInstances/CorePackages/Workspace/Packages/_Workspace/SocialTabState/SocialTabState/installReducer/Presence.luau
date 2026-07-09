local SocialTabState = script:FindFirstAncestor("SocialTabState")
local dependencies = require(SocialTabState.dependencies)
local llama = dependencies.llama
local RoduxPresence = dependencies.RoduxPresence
local t1 = {
	"OFFLINE",
	"ONLINE",
	"IN_GAME",
	"IN_STUDIO"
}

local function convertFromOldPresenceModel(p1) -- line: 17
	-- upvalues: RoduxPresence (copy), llama (copy), t1 (copy)
	local v10 = RoduxPresence.Models.Presence.new(llama.Dictionary.join(p1, {
		presence = llama.None,
		userPresenceType = (table.find(t1, p1.presence) or 1) - 1,
		gameInstanceId = llama.None,
		gameId = p1.gameInstanceId,
		lastOnline = DateTime.now() and DateTime.fromUnixTimestamp(p1.lastOnline or 0):ToIsoDate() or "1970-01-01T00:00:00Z"
	}))

	return RoduxPresence.Actions.ReceivedUserPresence(v10)
end

local t2 = {
	ReceivedUserPresence = function(p2) -- line: 34
		-- upvalues: convertFromOldPresenceModel (copy)
		if p2.payload then
			return p2
		end

		return { convertFromOldPresenceModel(p2) }
	end
}
local v8 = RoduxPresence.installReducer()

return function(p3, p4) -- line: 45
	-- upvalues: t2 (copy), llama (copy), v8 (copy)
	local v14 = p3 or {
		byUserId = {},
		byGameId = {},
		byGameInstanceId = {},
		byPlaceId = {}
	}
	local t3 = { p4 }
	local v16 = t2[p4.type]

	if v16 then
		t3 = v16(p4)
	end

	return llama.List.reduce(t3, v8, v14)
end
