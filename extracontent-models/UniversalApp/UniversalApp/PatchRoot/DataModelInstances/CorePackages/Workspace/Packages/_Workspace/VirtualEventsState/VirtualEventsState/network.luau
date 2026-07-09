local VirtualEventsState = script:FindFirstAncestor("VirtualEventsState")
local HttpRequest = require(VirtualEventsState.Parent.HttpRequest)
local RoduxNetworking = require(VirtualEventsState.Parent.RoduxNetworking)
local NetworkingVirtualEvents = require(VirtualEventsState.Parent.NetworkingVirtualEvents)
local NetworkingGames = require(VirtualEventsState.Parent.NetworkingGames)
local logger = require(VirtualEventsState.logger)
local v7 = game:DefineFastInt("VirtualEventsHttpRetryCount", 3)
local v8 = HttpRequest.config({
	requestFunction = function(p1, p2, p3) -- line: 12
		-- upvalues: logger (copy), HttpRequest (copy)
		logger:debug("GET {}", p1)

		return HttpRequest.requestFunctions.RequestInternal(p1, p2, p3)
	end,
	postRequestFunction = function(p4, p5) -- line: 21
		-- upvalues: logger (copy)
		logger:debug("{} {} {}", p4.StatusCode, p5.url, p4.Body)
	end,
	maxRetryCount = v7
})
local v9 = RoduxNetworking.config({
	keyPath = "VirtualEvents.networkStatus",
	networkImpl = v8
})
local v10 = NetworkingVirtualEvents.config({
	roduxNetworking = v9
})
local v11 = NetworkingGames.config({
	roduxNetworking = v9
})

return {
	RoduxNetworking = v9,
	NetworkingVirtualEvents = v10,
	NetworkingGames = v11
}
