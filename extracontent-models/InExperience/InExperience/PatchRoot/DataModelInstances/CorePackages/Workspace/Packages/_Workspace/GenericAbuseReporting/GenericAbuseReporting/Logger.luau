local parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local RobloxAppLoggers = require(parent.RobloxAppLoggers)
return RobloxAppLoggers.Logger:new("AbuseReport")
