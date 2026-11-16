local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local UserBlockingNetworking = require(parent.UserBlockingNetworking)
local myRoduxNetworking = require(ProfilePlatform.Networking.myRoduxNetworking)

return (UserBlockingNetworking.config({ roduxNetworking = myRoduxNetworking }))
