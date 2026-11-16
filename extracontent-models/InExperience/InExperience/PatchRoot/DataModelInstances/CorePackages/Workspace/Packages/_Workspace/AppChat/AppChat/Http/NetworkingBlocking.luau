local parent = script:FindFirstAncestor("AppChat").Parent

local UserBlockingNetworking = require(parent.UserBlockingNetworking)

local RoduxNetworking = require(script.Parent.RoduxNetworking)

return UserBlockingNetworking.config({ roduxNetworking = RoduxNetworking })
