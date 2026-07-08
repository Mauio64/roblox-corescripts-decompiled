local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local myRoduxNetworking = require(ProfilePlatform.Networking.myRoduxNetworking)

return (require(ProfilePlatformParent.FriendsNetworking).config({
	roduxNetworking = myRoduxNetworking
}))
