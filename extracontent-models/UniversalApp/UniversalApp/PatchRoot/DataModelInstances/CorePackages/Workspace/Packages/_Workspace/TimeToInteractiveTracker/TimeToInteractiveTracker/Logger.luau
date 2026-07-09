local Parent = script:FindFirstAncestor("TimeToInteractiveTracker").Parent

return (require(Parent.Loggers).Logger:new("TimeToInteractiveTracker"))
