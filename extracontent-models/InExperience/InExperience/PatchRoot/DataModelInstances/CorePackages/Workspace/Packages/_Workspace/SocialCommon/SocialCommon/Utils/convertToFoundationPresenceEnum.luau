local SocialCommon = script:FindFirstAncestor("SocialCommon")
local parent = SocialCommon.Parent
local PresenceTypes = require(SocialCommon.Enums.PresenceTypes)

local Foundation = require(parent.Foundation)

local v = {
	[PresenceTypes.Offline] = Foundation.Enums.UserPresence.Away,
	[PresenceTypes.Online] = Foundation.Enums.UserPresence.Active,
	[PresenceTypes.InGame] = Foundation.Enums.UserPresence.InExperience,
	[PresenceTypes.InStudio] = Foundation.Enums.UserPresence.Active,
	Offline = Foundation.Enums.UserPresence.Away,
	Online = Foundation.Enums.UserPresence.Active,
	InGame = Foundation.Enums.UserPresence.InExperience,
	InStudio = Foundation.Enums.UserPresence.Active
}

return function(p: string)
	return v[p] or Foundation.Enums.UserPresence.None
end
