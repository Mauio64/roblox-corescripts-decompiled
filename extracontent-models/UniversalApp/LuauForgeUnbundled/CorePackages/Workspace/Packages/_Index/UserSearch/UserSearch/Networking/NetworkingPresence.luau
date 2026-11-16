local LuaSocialLibrariesDeps = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/LuaSocialLibrariesDeps")
local myRoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Networking/myRoduxNetworking")

if require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Flags/FFlagUserSearchPresenceStoreMigration") then
	return nil
end

return (LuaSocialLibrariesDeps.NetworkingPresence.config({ roduxNetworking = myRoduxNetworking }))
