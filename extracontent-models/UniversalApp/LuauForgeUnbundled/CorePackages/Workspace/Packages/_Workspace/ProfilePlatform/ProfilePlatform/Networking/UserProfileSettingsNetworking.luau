local UserProfileSettingsNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UserProfileSettingsNetworking")
local myRoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/myRoduxNetworking")

return (UserProfileSettingsNetworking.config({ roduxNetworking = myRoduxNetworking }))
