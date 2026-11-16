local parent = script:FindFirstAncestor("InlineRichText").Parent
local Loggers = require(parent.Loggers)
return (Loggers.Logger:new("InlineRichText"))
