local Parent = script:FindFirstAncestor("IntervalPerformanceTracker").Parent

return (require(Parent.Loggers).Logger:new("IntervalPerformanceTracker"))
