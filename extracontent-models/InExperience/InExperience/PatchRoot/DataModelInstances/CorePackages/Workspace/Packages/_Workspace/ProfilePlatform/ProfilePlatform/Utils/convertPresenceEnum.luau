local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")

local Presence = require(ProfilePlatform.Rodux.Presence)
local PresenceType = Presence.Enums.PresenceType
local Enums = require(ProfilePlatform.Common.Enums)

local v = {
	[PresenceType.Offline] = Enums.PresenceTypes.Offline,
	[PresenceType.Online] = Enums.PresenceTypes.Online,
	[PresenceType.InGame] = Enums.PresenceTypes.InGame,
	[PresenceType.InStudio] = Enums.PresenceTypes.InStudio,
	Offline = Enums.PresenceTypes.Offline,
	Online = Enums.PresenceTypes.Online,
	InGame = Enums.PresenceTypes.InGame,
	InStudio = Enums.PresenceTypes.InStudio
}

return function(p: string, p2: number?)
	local selected = v[p] or Enums.PresenceTypes.Offline

	if selected == Enums.PresenceTypes.InGame and p2 == nil then
		return Enums.PresenceTypes.Online
	end

	return selected
end
