local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local myRoduxNetworking = require(ProfilePlatform.Networking.myRoduxNetworking)

local FriendsNetworking = require(parent.FriendsNetworking)
return (FriendsNetworking.config({ roduxNetworking = myRoduxNetworking }))
