local Parent = script:FindFirstAncestor("AppChat").Parent
local NetworkingChat = require(Parent.LuaSocialLibrariesDeps).NetworkingChat
local RoduxNetworking = require(script.Parent.RoduxNetworking)

return NetworkingChat.config({
	roduxNetworking = RoduxNetworking
})
