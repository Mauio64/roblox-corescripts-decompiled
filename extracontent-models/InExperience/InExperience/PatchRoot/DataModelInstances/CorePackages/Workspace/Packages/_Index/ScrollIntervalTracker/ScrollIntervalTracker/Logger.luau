local parent = script:FindFirstAncestor("ScrollIntervalTracker").Parent
local Loggers = require(parent.Loggers)
return (Loggers.Logger:new("ScrollIntervalTracker"))
