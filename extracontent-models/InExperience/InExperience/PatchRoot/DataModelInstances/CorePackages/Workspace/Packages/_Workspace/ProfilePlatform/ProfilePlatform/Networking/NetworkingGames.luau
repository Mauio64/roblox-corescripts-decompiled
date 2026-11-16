local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local myRoduxNetworking = require(ProfilePlatform.Networking.myRoduxNetworking)

return (LuaSocialLibrariesDeps.NetworkingGames.config({ roduxNetworking = myRoduxNetworking }))
