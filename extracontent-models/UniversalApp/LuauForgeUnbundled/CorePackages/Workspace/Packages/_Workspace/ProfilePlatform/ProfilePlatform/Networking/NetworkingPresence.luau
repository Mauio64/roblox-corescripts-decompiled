local LuaSocialLibrariesDeps = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/LuaSocialLibrariesDeps")
local myRoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Networking/myRoduxNetworking")

if require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Flags/FFlagUserListPresenceStoreMigration") then
	return nil
end

return (LuaSocialLibrariesDeps.NetworkingPresence.config({ roduxNetworking = myRoduxNetworking }))
