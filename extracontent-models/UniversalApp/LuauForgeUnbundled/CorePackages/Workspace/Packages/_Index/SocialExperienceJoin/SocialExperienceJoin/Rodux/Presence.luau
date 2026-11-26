local Constants = require("@game/CorePackages/Workspace/Packages/_Index/SocialExperienceJoin/SocialExperienceJoin/Common/Constants")
local LuaSocialLibrariesDeps = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperienceJoin/LuaSocialLibrariesDeps")

if require("@game/CorePackages/Workspace/Packages/_Index/SocialExperienceJoin/SocialExperienceJoin/Flags/FFlagSocialExperienceJoinPresenceStoreMigration") then
	return nil
end

return (LuaSocialLibrariesDeps.RoduxPresence.config({
	keyPath = Constants.RODUX_KEY .. ".Presence"
}))
