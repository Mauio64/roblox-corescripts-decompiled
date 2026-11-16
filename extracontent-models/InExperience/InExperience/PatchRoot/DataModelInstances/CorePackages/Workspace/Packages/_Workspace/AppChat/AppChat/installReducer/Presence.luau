local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local llama = LuaSocialLibrariesDeps.llama
local RoduxPresence = require(AppChat.Http.RoduxPresence)

local FFlagAppChatPresenceStoreMigration = require(AppChat.Flags.FFlagAppChatPresenceStoreMigration)

if FFlagAppChatPresenceStoreMigration then
	return nil
end

local v = { "OFFLINE", "ONLINE", "IN_GAME", "IN_STUDIO" }

local function convertFromOldPresenceModel(data)
	local presence = RoduxPresence.Models.Presence.new(llama.Dictionary.join(data, {
		presence = llama.None,
		userPresenceType = (table.find(v, data.presence) or 1) - 1,
		gameInstanceId = llama.None,
		gameId = data.gameInstanceId,
		lastOnline = DateTime.now() and DateTime.fromUnixTimestamp(data.lastOnline or 0):ToIsoDate() or "1970-01-01T00:00:00Z"
	}))

	return RoduxPresence.Actions.ReceivedUserPresence(presence)
end

local v2 = {
	ReceivedUserPresence = function(p)
		if p.payload then
			return p
		end

		return { convertFromOldPresenceModel(p) }
	end
}

local v3 = RoduxPresence.installReducer()

return function(p, p2)
	local v4 = v2[p2.type]
	local v5 = not v4 and { p2 } or v4(p2)
	return llama.List.reduce(v5, v3, p or {
		byUserId = {},
		byGameId = {},
		byGameInstanceId = {},
		byPlaceId = {}
	})
end
