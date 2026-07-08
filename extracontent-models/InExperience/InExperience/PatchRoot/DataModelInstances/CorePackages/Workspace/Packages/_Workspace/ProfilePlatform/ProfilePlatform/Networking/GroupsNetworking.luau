local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local GroupsNetworking = require(ProfilePlatformParent.GroupsNetworking)
local myRoduxNetworking = require(ProfilePlatform.Networking.myRoduxNetworking)

return (GroupsNetworking.config({
	roduxNetworking = myRoduxNetworking
}))
