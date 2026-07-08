local Events = require(script.Events)

require(script.Types)

local v2 = require(script.initializeStopwatch)()

return {
	["jest.config"] = script["jest.config"],
	Events = Events,
	Stopwatch = v2,
	TestUtils = {
		resetStopwatchState = v2._unsafeClearEventLog
	}
}
