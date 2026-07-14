local UserList = script:FindFirstAncestor("UserList")
local UserListParent = UserList.Parent
local LuaSocialLibrariesDeps = require(UserListParent.LuaSocialLibrariesDeps)
local myRoduxNetworking = require(UserList.Networking.myRoduxNetworking)

if require(UserList.Flags.FFlagUserListPresenceStoreMigration) then
	return nil
end

return (LuaSocialLibrariesDeps.NetworkingPresence.config({
	roduxNetworking = myRoduxNetworking
}))
