local NetworkingShareLinks = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileShareLinks/NetworkingShareLinks")

local configuredRoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Index/ProfileShareLinks/ProfileShareLinks/Networking/configuredRoduxNetworking")

return {
	ShareLinksNetworking = NetworkingShareLinks.config({ roduxNetworking = configuredRoduxNetworking })
}
