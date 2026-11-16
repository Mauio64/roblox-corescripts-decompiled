local VirtualEvents = script:FindFirstAncestor("VirtualEvents")

local RobloxAppLoggers = require(VirtualEvents.Parent.RobloxAppLoggers)

return (RobloxAppLoggers.Logger:new("VirtualEvents"))
