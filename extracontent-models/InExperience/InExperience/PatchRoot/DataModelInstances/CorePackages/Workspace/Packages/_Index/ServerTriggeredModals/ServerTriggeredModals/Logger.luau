local parent = script:FindFirstAncestor("ServerTriggeredModals").Parent

local Loggers = require(parent.Loggers)
return (Loggers.Logger:new("ServerTriggeredModals"))
