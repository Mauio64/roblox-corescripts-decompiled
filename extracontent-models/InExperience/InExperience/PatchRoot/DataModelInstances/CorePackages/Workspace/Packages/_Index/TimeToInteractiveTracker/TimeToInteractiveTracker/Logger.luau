local parent = script:FindFirstAncestor("TimeToInteractiveTracker").Parent
local Loggers = require(parent.Loggers)
return (Loggers.Logger:new("TimeToInteractiveTracker"))
