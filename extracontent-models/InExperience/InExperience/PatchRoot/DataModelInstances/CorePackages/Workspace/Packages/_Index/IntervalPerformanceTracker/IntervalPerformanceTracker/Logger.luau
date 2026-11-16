local parent = script:FindFirstAncestor("IntervalPerformanceTracker").Parent
local Loggers = require(parent.Loggers)
return (Loggers.Logger:new("IntervalPerformanceTracker"))
