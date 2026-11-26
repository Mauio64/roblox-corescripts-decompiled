require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Friends/createFriendsStore")
local module = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Friends/Requests")

return {
	Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Friends/Enums"),
	FriendsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Friends/FriendsStore"),
	httpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Friends/Networking/myHttpRequest"),
	Requests = module
}
