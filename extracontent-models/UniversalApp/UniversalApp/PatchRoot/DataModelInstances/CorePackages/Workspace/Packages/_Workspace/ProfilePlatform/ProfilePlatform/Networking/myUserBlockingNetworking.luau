local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local UserBlockingNetworking = require(ProfilePlatformParent.UserBlockingNetworking)
local myRoduxNetworking = require(ProfilePlatform.Networking.myRoduxNetworking)

return (UserBlockingNetworking.config({
	roduxNetworking = myRoduxNetworking
}))
