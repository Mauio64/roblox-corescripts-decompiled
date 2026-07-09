local Parent = script:FindFirstAncestor("SquadsCore").Parent
local RoduxNetworking = require(script.Parent.RoduxNetworking)

return require(Parent.NetworkingSquads).config({
	roduxNetworking = RoduxNetworking
})
