local VirtualEventsState = script:FindFirstAncestor("VirtualEventsState")

local RobloxAppLoggers = require(VirtualEventsState.Parent.RobloxAppLoggers)

return (RobloxAppLoggers.Logger:new("VirtualEventsState"))
