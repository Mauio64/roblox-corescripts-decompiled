local SocialExperienceJoin = script:FindFirstAncestor("SocialExperienceJoin")
local SocialExperienceJoinParent = SocialExperienceJoin.Parent
local LuaSocialLibrariesDeps = require(SocialExperienceJoinParent.LuaSocialLibrariesDeps)
local myRoduxNetworking = require(SocialExperienceJoin.Networking.myRoduxNetworking)

return (LuaSocialLibrariesDeps.NetworkingGames.config({
	roduxNetworking = myRoduxNetworking
}))
