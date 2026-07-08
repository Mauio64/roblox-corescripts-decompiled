local Parent = script:FindFirstAncestor("PlayerContextualMenu").Parent
local RoduxNetworking = require(script.Parent.RoduxNetworking)

return require(Parent.FriendsNetworking).config({
	roduxNetworking = RoduxNetworking
})
