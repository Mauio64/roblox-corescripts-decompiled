local module = require("@luauforge/bundled/eUd")
local myRoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/myRoduxNetworking")

return (module.NetworkingUsers.config({ roduxNetworking = myRoduxNetworking }))
