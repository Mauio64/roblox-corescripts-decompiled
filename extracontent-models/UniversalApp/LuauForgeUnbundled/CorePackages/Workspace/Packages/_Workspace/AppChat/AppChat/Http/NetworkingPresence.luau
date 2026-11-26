local networkingPresence = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/LuaSocialLibrariesDeps").NetworkingPresence

local RoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Http/RoduxNetworking")

if require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatPresenceStoreMigration") then
	return nil
end

return networkingPresence.config({ roduxNetworking = RoduxNetworking })
