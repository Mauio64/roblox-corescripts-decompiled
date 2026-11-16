local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEventsState/HttpRequest")
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEventsState/RoduxNetworking")
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEventsState/NetworkingVirtualEvents")
local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEventsState/NetworkingGames")
local logger = require("@game/CorePackages/Workspace/Packages/_Index/VirtualEventsState/VirtualEventsState/logger")

local defineFastInt = game:DefineFastInt("VirtualEventsHttpRetryCount", 3)

local config = HttpRequest.config({
	requestFunction = function(p2, p3, p4)
		logger:debug("GET {}", p2)

		return HttpRequest.requestFunctions.RequestInternal(p2, p3, p4)
	end,
	postRequestFunction = function(p2, p3)
		logger:debug("{} {} {}", p2.StatusCode, p3.url, p2.Body)
	end,
	maxRetryCount = defineFastInt
})

local config2 = module2.config({
	keyPath = "VirtualEvents.networkStatus",
	networkImpl = config
})

return {
	RoduxNetworking = config2,
	NetworkingVirtualEvents = module3.config({ roduxNetworking = config2 }),
	NetworkingGames = module4.config({ roduxNetworking = config2 })
}
