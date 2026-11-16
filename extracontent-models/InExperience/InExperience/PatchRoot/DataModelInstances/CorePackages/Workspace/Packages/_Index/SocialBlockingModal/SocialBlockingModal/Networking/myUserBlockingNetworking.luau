local parent = script:FindFirstAncestor("SocialBlockingModal").Parent

local UserBlockingNetworking = require(parent.UserBlockingNetworking)
local myRoduxNetworking = require(script.Parent.myRoduxNetworking)

return (UserBlockingNetworking.config({ roduxNetworking = myRoduxNetworking }))
