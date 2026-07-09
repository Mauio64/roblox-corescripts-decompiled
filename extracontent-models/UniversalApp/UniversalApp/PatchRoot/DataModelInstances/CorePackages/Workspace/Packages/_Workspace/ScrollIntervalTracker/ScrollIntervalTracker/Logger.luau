local Parent = script:FindFirstAncestor("ScrollIntervalTracker").Parent

return (require(Parent.Loggers).Logger:new("ScrollIntervalTracker"))
