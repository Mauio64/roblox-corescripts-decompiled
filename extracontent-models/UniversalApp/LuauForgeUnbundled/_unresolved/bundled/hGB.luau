local module = require("@luauforge/bundled/hGq")

local llama = module.llama
local roduxPresence = module.RoduxPresence

local v5 = { "OFFLINE", "ONLINE", "IN_GAME", "IN_STUDIO" }

local function convertFromOldPresenceModel(data)
	local presence = roduxPresence.Models.Presence.new(llama.Dictionary.join(data, {
		presence = llama.None,
		userPresenceType = (table.find(v5, data.presence) or 1) - 1,
		gameInstanceId = llama.None,
		gameId = data.gameInstanceId,
		lastOnline = DateTime.now() and DateTime.fromUnixTimestamp(data.lastOnline or 0):ToIsoDate() or "1970-01-01T00:00:00Z"
	}))

	return roduxPresence.Actions.ReceivedUserPresence(presence)
end

local v6 = {
	ReceivedUserPresence = function(p2)
		if p2.payload then
			return p2
		end

		return { convertFromOldPresenceModel(p2) }
	end
}

local v7 = roduxPresence.installReducer()

return function(p2, p3)
	local v8 = v6[p3.type]
	local v9 = not v8 and { p3 } or v8(p3)
	return llama.List.reduce(
		v9,
		v7,
		p2 or { byUserId = {}, byGameId = {}, byGameInstanceId = {}, byPlaceId = {} }
	)
end
