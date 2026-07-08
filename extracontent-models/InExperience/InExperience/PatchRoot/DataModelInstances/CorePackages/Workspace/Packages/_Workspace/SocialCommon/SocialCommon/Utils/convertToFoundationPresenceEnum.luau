local SocialCommon = script:FindFirstAncestor("SocialCommon")
local SocialCommonParent = SocialCommon.Parent
local PresenceTypes = require(SocialCommon.Enums.PresenceTypes)
local Foundation = require(SocialCommonParent.Foundation)
local t1 = {
	[PresenceTypes.Offline] = Foundation.Enums.UserPresence.Away,
	[PresenceTypes.Online] = Foundation.Enums.UserPresence.Active,
	[PresenceTypes.InGame] = Foundation.Enums.UserPresence.InExperience,
	[PresenceTypes.InStudio] = Foundation.Enums.UserPresence.Active,
	Offline = Foundation.Enums.UserPresence.Away,
	Online = Foundation.Enums.UserPresence.Active,
	InGame = Foundation.Enums.UserPresence.InExperience,
	InStudio = Foundation.Enums.UserPresence.Active
}

return function(s1: string) -- line: 18
	-- upvalues: t1 (copy), Foundation (copy)
	return t1[s1] or Foundation.Enums.UserPresence.None
end
