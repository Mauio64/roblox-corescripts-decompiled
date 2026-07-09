local UserSearch = script:FindFirstAncestor("UserSearch")
local UserSearchParent = UserSearch.Parent
local LuaSocialLibrariesDeps = require(UserSearchParent.LuaSocialLibrariesDeps)
local myRoduxNetworking = require(UserSearch.Networking.myRoduxNetworking)

return (LuaSocialLibrariesDeps.NetworkingPresence.config({
	roduxNetworking = myRoduxNetworking
}))
