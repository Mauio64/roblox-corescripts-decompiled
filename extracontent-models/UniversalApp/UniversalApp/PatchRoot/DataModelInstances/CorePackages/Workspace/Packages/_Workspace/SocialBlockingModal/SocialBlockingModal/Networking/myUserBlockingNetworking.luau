local Parent = script:FindFirstAncestor("SocialBlockingModal").Parent
local UserBlockingNetworking = require(Parent.UserBlockingNetworking)
local myRoduxNetworking = require(script.Parent.myRoduxNetworking)

return (UserBlockingNetworking.config({
	roduxNetworking = myRoduxNetworking
}))
