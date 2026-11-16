local parent = script:FindFirstAncestor("MomentsCreation").Parent
local Loggers = require(parent.Loggers)
return (Loggers.Logger:new("Moments.Upload"))
