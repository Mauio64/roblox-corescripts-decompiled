local parent = script:FindFirstAncestor("SquadsCore").Parent

local RoduxNetworking = require(script.Parent.RoduxNetworking)

local UserBlockingNetworking = require(parent.UserBlockingNetworking)

return (UserBlockingNetworking.config({ roduxNetworking = RoduxNetworking }))
