local SocialExperienceJoin = script:FindFirstAncestor("SocialExperienceJoin")
local parent = SocialExperienceJoin.Parent
local Constants = require(SocialExperienceJoin.Common.Constants)
local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)

return LuaSocialLibrariesDeps.RoduxGames.config({
	keyPath = Constants.RODUX_KEY .. ".Games"
})
