local VirtualEventsState = script:FindFirstAncestor("VirtualEventsState")
local NetworkingVirtualEvents = require(VirtualEventsState.network).NetworkingVirtualEvents

return require(script.Parent["events.impl"])(NetworkingVirtualEvents)
