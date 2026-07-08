local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local UserProfileSettingsNetworking = require(ProfilePlatformParent.UserProfileSettingsNetworking)
local myRoduxNetworking = require(ProfilePlatform.Networking.myRoduxNetworking)

return (UserProfileSettingsNetworking.config({
	roduxNetworking = myRoduxNetworking
}))
