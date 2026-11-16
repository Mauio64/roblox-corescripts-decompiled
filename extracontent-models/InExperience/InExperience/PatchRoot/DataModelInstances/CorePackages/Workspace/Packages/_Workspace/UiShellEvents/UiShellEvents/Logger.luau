local parent = script:FindFirstAncestor("UiShellEvents").Parent
local Loggers = require(parent.Loggers)
local logger = Loggers.Logger
return (logger.new(logger, "UiShellEvents"))
