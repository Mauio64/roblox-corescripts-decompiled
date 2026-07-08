local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local Cryo = require(ProfilePlatformParent.Cryo)
local Presence = require(ProfilePlatform.Rodux.Presence)
local t1 = {
	"OFFLINE",
	"ONLINE",
	"IN_GAME",
	"IN_STUDIO"
}

local function convertFromOldPresenceModel(p1) -- line: 16
	-- upvalues: Presence (copy), Cryo (copy), t1 (copy)
	local v9 = Presence.Models.Presence.new(Cryo.Dictionary.join(p1, {
		lastOnline = "",
		userPresenceType = (table.find(t1, p1.presence) or 1) - 1,
		gameId = p1.gameInstanceId
	}))

	return Presence.Actions.ReceivedUserPresence(v9)
end

local v7 = Presence.installReducer()

return function(p2, p3) -- line: 28
	-- upvalues: convertFromOldPresenceModel (copy), v7 (copy)
	if p3.type == "ReceivedUserPresence" and not p3.payload then
		p3 = convertFromOldPresenceModel(p3)
	end

	return v7(p2, p3)
end
