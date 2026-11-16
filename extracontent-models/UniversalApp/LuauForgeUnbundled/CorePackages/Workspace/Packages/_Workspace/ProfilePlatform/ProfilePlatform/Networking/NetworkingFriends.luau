local GroupsNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/GroupsNetworking")
local myRoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/myRoduxNetworking")

return (GroupsNetworking.config({ roduxNetworking = myRoduxNetworking }))
