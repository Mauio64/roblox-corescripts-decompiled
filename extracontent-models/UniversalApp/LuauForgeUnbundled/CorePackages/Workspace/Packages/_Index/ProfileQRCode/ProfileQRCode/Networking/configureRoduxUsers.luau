local NetworkingUsers = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/NetworkingUsers")
local configuredRoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Networking/configuredRoduxNetworking")

return NetworkingUsers.config({ roduxNetworking = configuredRoduxNetworking })
