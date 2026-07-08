local IntervalPerformanceTracker = require(script.IntervalPerformanceTracker)
local createScrollIntervalPerformanceTracker = require(script.createScrollIntervalPerformanceTracker)

return {
	IntervalPerformanceTracker = IntervalPerformanceTracker,
	createScrollIntervalPerformanceTracker = createScrollIntervalPerformanceTracker,
	["jest.config"] = script["jest.config"]
}
