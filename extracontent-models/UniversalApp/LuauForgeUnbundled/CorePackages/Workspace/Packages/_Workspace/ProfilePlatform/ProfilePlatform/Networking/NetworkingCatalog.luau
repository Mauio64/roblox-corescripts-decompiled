local UserBlockingNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UserBlockingNetworking")
local myRoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/myRoduxNetworking")

return (UserBlockingNetworking.config({ roduxNetworking = myRoduxNetworking }))
