local presenceType = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Rodux/Presence").Enums.PresenceType
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")

local v5 = {
	[presenceType.Offline] = Enums.PresenceTypes.Offline,
	[presenceType.Online] = Enums.PresenceTypes.Online,
	[presenceType.InGame] = Enums.PresenceTypes.InGame,
	[presenceType.InStudio] = Enums.PresenceTypes.InStudio,
	Offline = Enums.PresenceTypes.Offline,
	Online = Enums.PresenceTypes.Online,
	InGame = Enums.PresenceTypes.InGame,
	InStudio = Enums.PresenceTypes.InStudio
}

return function(p2, p3)
	local v6 = v5[p2] or Enums.PresenceTypes.Offline

	if v6 == Enums.PresenceTypes.InGame and p3 == nil then
		return Enums.PresenceTypes.Online
	end

	return v6
end
