local Parent = script:FindFirstAncestor("PlayerContextualMenu").Parent
local RoduxNetworking = require(Parent.LuaSocialLibrariesDeps).RoduxNetworking
local httpRequest = require(script.Parent.httpRequest)

return RoduxNetworking.config({
	keyPath = "EventReceievers.NetworkStatus",
	networkImpl = httpRequest
})
