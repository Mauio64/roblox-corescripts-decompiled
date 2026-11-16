local SocialExperienceJoin = script:FindFirstAncestor("SocialExperienceJoin")
local parent = SocialExperienceJoin.Parent
local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local myRoduxNetworking = require(SocialExperienceJoin.Networking.myRoduxNetworking)

return (LuaSocialLibrariesDeps.NetworkingGames.config({ roduxNetworking = myRoduxNetworking }))
