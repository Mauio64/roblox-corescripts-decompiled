local parent = script:FindFirstAncestor("NotificationsCommon").Parent

local Loggers = require(parent.Loggers)
return Loggers.Logger:new("NotificationsCommon")
