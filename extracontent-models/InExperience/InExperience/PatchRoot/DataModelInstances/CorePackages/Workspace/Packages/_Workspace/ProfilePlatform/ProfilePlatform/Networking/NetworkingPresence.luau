local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local LuaSocialLibrariesDeps = require(ProfilePlatformParent.LuaSocialLibrariesDeps)
local myRoduxNetworking = require(ProfilePlatform.Networking.myRoduxNetworking)

if require(ProfilePlatform.Flags.FFlagProfilePlatformPresenceStoreMigration) then
	return nil
end

return (LuaSocialLibrariesDeps.NetworkingPresence.config({
	roduxNetworking = myRoduxNetworking
}))
