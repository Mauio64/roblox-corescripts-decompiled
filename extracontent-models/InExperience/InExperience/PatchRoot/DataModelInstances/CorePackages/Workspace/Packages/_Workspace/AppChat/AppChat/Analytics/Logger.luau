local parent = script:FindFirstAncestor("AppChat").Parent

local Loggers = require(parent.Loggers)
local logger = Loggers.Logger
return (logger.new(logger, "AppChat Analytics"))
