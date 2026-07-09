require(script.RccRealtimeTypes)

local RccEventReceiver = require(script.RccEventReceiver)

return {
	["jest.config"] = script["jest.config"],
	RccEventReceiver = RccEventReceiver
}
