local parent = script:FindFirstAncestor("AppChat").Parent
local Loggers = require(parent.Loggers)
return (Loggers.Logger:new("AppChat"))
