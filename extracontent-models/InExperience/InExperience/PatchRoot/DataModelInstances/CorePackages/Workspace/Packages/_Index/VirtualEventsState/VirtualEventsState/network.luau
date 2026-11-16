local VirtualEventsState = script:FindFirstAncestor("VirtualEventsState")

local HttpRequest = require(VirtualEventsState.Parent.HttpRequest)
local RoduxNetworking = require(VirtualEventsState.Parent.RoduxNetworking)
local NetworkingVirtualEvents = require(VirtualEventsState.Parent.NetworkingVirtualEvents)
local NetworkingGames = require(VirtualEventsState.Parent.NetworkingGames)
local logger = require(VirtualEventsState.logger)

local defineFastInt = game:DefineFastInt("VirtualEventsHttpRetryCount", 3)

local config = HttpRequest.config({
	requestFunction = function(p, p2, p3)
		logger:debug("GET {}", p)

		return HttpRequest.requestFunctions.RequestInternal(p, p2, p3)
	end,
	postRequestFunction = function(p, p2)
		logger:debug("{} {} {}", p.StatusCode, p2.url, p.Body)
	end,
	maxRetryCount = defineFastInt
})

local config2 = RoduxNetworking.config({
	keyPath = "VirtualEvents.networkStatus",
	networkImpl = config
})

return {
	RoduxNetworking = config2,
	NetworkingVirtualEvents = NetworkingVirtualEvents.config({ roduxNetworking = config2 }),
	NetworkingGames = NetworkingGames.config({ roduxNetworking = config2 })
}
