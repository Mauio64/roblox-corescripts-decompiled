local Parent = script:FindFirstAncestor("AppChat").Parent
local NetworkingUsers = require(Parent.LuaSocialLibrariesDeps).NetworkingUsers
local RoduxNetworking = require(script.Parent.RoduxNetworking)

return NetworkingUsers.config({
	roduxNetworking = RoduxNetworking
})
