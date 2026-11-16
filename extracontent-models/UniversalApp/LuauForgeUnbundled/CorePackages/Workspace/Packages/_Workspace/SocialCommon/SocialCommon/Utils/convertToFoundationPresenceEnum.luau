local PresenceTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SocialCommon/Enums/PresenceTypes")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/Foundation")

local v5 = {
	[PresenceTypes.Offline] = Foundation.Enums.UserPresence.Away,
	[PresenceTypes.Online] = Foundation.Enums.UserPresence.Active,
	[PresenceTypes.InGame] = Foundation.Enums.UserPresence.InExperience,
	[PresenceTypes.InStudio] = Foundation.Enums.UserPresence.Active,
	Offline = Foundation.Enums.UserPresence.Away,
	Online = Foundation.Enums.UserPresence.Active,
	InGame = Foundation.Enums.UserPresence.InExperience,
	InStudio = Foundation.Enums.UserPresence.Active
}

return function(p2)
	return v5[p2] or Foundation.Enums.UserPresence.None
end
