local roduxNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerContextualMenu/LuaSocialLibrariesDeps").RoduxNetworking
local httpRequest = require("@game/CorePackages/Workspace/Packages/_Index/PlayerContextualMenu/PlayerContextualMenu/Http/httpRequest")

return roduxNetworking.config({
	keyPath = "EventReceievers.NetworkStatus",
	networkImpl = httpRequest
})
