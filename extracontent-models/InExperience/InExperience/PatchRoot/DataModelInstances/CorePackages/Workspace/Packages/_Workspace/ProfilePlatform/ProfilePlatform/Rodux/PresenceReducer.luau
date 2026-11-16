local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local Cryo = require(parent.Cryo)

local Presence = require(ProfilePlatform.Rodux.Presence)

local v = { "OFFLINE", "ONLINE", "IN_GAME", "IN_STUDIO" }

local function convertFromOldPresenceModel(p)
	local presence = Presence.Models.Presence.new(Cryo.Dictionary.join(p, {
		userPresenceType = (table.find(v, p.presence) or 1) - 1,
		gameId = p.gameInstanceId,
		lastOnline = ""
	}))

	return Presence.Actions.ReceivedUserPresence(presence)
end

local v2 = Presence.installReducer()

return function(p, p2)
	if p2.type == "ReceivedUserPresence" and not p2.payload then
		p2 = convertFromOldPresenceModel(p2)
	end

	return v2(p, p2)
end
