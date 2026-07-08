local Parent = script:FindFirstAncestor("AppChat").Parent
local NetworkingPresence = require(Parent.LuaSocialLibrariesDeps).NetworkingPresence
local RoduxNetworking = require(script.Parent.RoduxNetworking)

return NetworkingPresence.config({
	roduxNetworking = RoduxNetworking
})
