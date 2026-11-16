local Destination = require(script.Destination)
local logBuyRobuxRoutingCallsite = require(script.logBuyRobuxRoutingCallsite)

return {
	fallbackWebUrl = Destination.fallbackWebUrl,
	resolveDestination = Destination.resolveDestination,
	logExposure = Destination.logExposure,
	resolveAndLogDestination = Destination.resolveAndLogDestination,
	logBuyRobuxRoutingCallsite = logBuyRobuxRoutingCallsite,
	["jest.config"] = script["jest.config"]
}
