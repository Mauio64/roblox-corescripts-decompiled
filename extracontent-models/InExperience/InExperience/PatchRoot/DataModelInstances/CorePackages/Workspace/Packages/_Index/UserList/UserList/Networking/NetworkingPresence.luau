local UserList = script:FindFirstAncestor("UserList")
local parent = UserList.Parent
local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local myRoduxNetworking = require(UserList.Networking.myRoduxNetworking)

local FFlagUserListPresenceStoreMigration = require(UserList.Flags.FFlagUserListPresenceStoreMigration)

if FFlagUserListPresenceStoreMigration then
	return nil
end

return (LuaSocialLibrariesDeps.NetworkingPresence.config({ roduxNetworking = myRoduxNetworking }))
