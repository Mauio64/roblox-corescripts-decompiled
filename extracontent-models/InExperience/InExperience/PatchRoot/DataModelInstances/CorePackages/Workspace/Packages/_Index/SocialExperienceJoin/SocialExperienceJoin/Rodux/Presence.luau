local SocialExperienceJoin = script:FindFirstAncestor("SocialExperienceJoin")
local parent = SocialExperienceJoin.Parent
local Constants = require(SocialExperienceJoin.Common.Constants)
local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)

local FFlagSocialExperienceJoinPresenceStoreMigration = require(SocialExperienceJoin.Flags.FFlagSocialExperienceJoinPresenceStoreMigration)

if FFlagSocialExperienceJoinPresenceStoreMigration then
	return nil
end

return (LuaSocialLibrariesDeps.RoduxPresence.config({
	keyPath = Constants.RODUX_KEY .. ".Presence"
}))
