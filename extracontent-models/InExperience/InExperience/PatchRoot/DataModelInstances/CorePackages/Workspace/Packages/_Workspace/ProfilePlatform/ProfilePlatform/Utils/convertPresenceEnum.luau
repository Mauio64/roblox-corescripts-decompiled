local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local PresenceType = require(ProfilePlatform.Rodux.Presence).Enums.PresenceType
local Enums = require(ProfilePlatform.Common.Enums)
local t1 = {
	[PresenceType.Offline] = Enums.PresenceTypes.Offline,
	[PresenceType.Online] = Enums.PresenceTypes.Online,
	[PresenceType.InGame] = Enums.PresenceTypes.InGame,
	[PresenceType.InStudio] = Enums.PresenceTypes.InStudio,
	Offline = Enums.PresenceTypes.Offline,
	Online = Enums.PresenceTypes.Online,
	InGame = Enums.PresenceTypes.InGame,
	InStudio = Enums.PresenceTypes.InStudio
}

return function(s1: string, n1: number?) -- line: 18
	-- upvalues: t1 (copy), Enums (copy)
	local v7 = t1[s1] or Enums.PresenceTypes.Offline

	if v7 == Enums.PresenceTypes.InGame and n1 == nil then
		return Enums.PresenceTypes.Online
	end

	return v7
end
