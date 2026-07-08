local Parent = script:FindFirstAncestor("AppChat").Parent
local RoduxNetworking = require(script.Parent.RoduxNetworking)

return require(Parent.ShareLinksNetworking).config({
	roduxNetworking = RoduxNetworking
})
