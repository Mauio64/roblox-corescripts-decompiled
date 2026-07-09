local UserList = script:FindFirstAncestor("UserList")
local UserListParent = UserList.Parent
local LuaSocialLibrariesDeps = require(UserListParent.LuaSocialLibrariesDeps)
local myRoduxNetworking = require(UserList.Networking.myRoduxNetworking)

return (LuaSocialLibrariesDeps.NetworkingPresence.config({
	roduxNetworking = myRoduxNetworking
}))
