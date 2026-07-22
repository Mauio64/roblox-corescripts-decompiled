local SocialExperienceJoin = script:FindFirstAncestor("SocialExperienceJoin")
local SocialExperienceJoinParent = SocialExperienceJoin.Parent
local Constants = require(SocialExperienceJoin.Common.Constants)
local LuaSocialLibrariesDeps = require(SocialExperienceJoinParent.LuaSocialLibrariesDeps)

if require(SocialExperienceJoin.Flags.FFlagSocialExperienceJoinPresenceStoreMigration) then
	return nil
end

return (LuaSocialLibrariesDeps.RoduxPresence.config({
	keyPath = Constants.RODUX_KEY .. ".Presence"
}))
