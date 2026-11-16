local RoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Http/RoduxNetworking")

local LuaSocialLibrariesDeps = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/LuaSocialLibrariesDeps")

if require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Flags/FFlagSquadsPresenceStoreMigration") then
	return nil
end

return (LuaSocialLibrariesDeps.NetworkingPresence.config({ roduxNetworking = RoduxNetworking }))
