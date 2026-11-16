local parent = script:FindFirstAncestor("PlayerContextualMenu").Parent
local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local roduxNetworking = LuaSocialLibrariesDeps.RoduxNetworking
local httpRequest = require(script.Parent.httpRequest)

return roduxNetworking.config({
	keyPath = "EventReceievers.NetworkStatus",
	networkImpl = httpRequest
})
