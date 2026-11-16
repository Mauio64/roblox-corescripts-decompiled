local VirtualEventsState = script:FindFirstAncestor("VirtualEventsState")

local network = require(VirtualEventsState.network)
local networkingVirtualEvents = network.NetworkingVirtualEvents
local eventsimpl = require(script.Parent["events.impl"])

return eventsimpl(networkingVirtualEvents)
