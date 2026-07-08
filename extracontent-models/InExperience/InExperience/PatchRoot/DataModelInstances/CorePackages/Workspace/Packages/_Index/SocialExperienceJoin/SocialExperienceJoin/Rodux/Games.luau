local SocialExperienceJoin = script:FindFirstAncestor("SocialExperienceJoin")
local SocialExperienceJoinParent = SocialExperienceJoin.Parent
local Constants = require(SocialExperienceJoin.Common.Constants)

return require(SocialExperienceJoinParent.LuaSocialLibrariesDeps).RoduxGames.config({
	keyPath = Constants.RODUX_KEY .. ".Games"
})
