local Events = require(script.Events)
require(script.Types)

local initializeStopwatch = require(script.initializeStopwatch)
local stopwatch = initializeStopwatch()

return {
	["jest.config"] = script["jest.config"],
	Events = Events,
	Stopwatch = stopwatch,
	TestUtils = { resetStopwatchState = stopwatch._unsafeClearEventLog }
}
