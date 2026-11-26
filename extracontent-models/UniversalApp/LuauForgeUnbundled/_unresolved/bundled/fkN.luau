local module = require("@luauforge/bundled/fbc")
local myRoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/myRoduxNetworking")

return (module.NetworkingGames.config({ roduxNetworking = myRoduxNetworking }))
