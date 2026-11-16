local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local GroupsNetworking = require(parent.GroupsNetworking)
local myRoduxNetworking = require(ProfilePlatform.Networking.myRoduxNetworking)

return (GroupsNetworking.config({ roduxNetworking = myRoduxNetworking }))
