local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Cryo")

local Presence = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Rodux/Presence")

local v5 = { "OFFLINE", "ONLINE", "IN_GAME", "IN_STUDIO" }

local function convertFromOldPresenceModel(p2)
	local presence = Presence.Models.Presence.new(Cryo.Dictionary.join(p2, {
		userPresenceType = (table.find(v5, p2.presence) or 1) - 1,
		gameId = p2.gameInstanceId,
		lastOnline = ""
	}))

	return Presence.Actions.ReceivedUserPresence(presence)
end

local v6 = Presence.installReducer()

return function(p2, p3)
	if p3.type == "ReceivedUserPresence" and not p3.payload then
		p3 = convertFromOldPresenceModel(p3)
	end

	return v6(p2, p3)
end
