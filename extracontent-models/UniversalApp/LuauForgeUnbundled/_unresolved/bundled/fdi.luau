local module = require("@luauforge/bundled/eUd")
local myRoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/myRoduxNetworking")

if require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformPresenceStoreMigration") then
	return nil
end

return (module.NetworkingPresence.config({ roduxNetworking = myRoduxNetworking }))
