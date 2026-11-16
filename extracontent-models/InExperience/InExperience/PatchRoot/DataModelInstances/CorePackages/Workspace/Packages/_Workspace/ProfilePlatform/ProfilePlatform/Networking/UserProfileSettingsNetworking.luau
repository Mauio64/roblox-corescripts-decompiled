local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local UserProfileSettingsNetworking = require(parent.UserProfileSettingsNetworking)
local myRoduxNetworking = require(ProfilePlatform.Networking.myRoduxNetworking)

return (UserProfileSettingsNetworking.config({ roduxNetworking = myRoduxNetworking }))
