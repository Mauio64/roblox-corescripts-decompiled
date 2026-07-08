local Parent = script:FindFirstAncestor("AppChat").Parent
local UserBlockingNetworking = require(Parent.UserBlockingNetworking)
local RoduxNetworking = require(script.Parent.RoduxNetworking)

return UserBlockingNetworking.config({
	roduxNetworking = RoduxNetworking
})
