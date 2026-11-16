local VirtualEventsState = script:FindFirstAncestor("VirtualEventsState")

local Players = game:GetService("Players")

local network = require(VirtualEventsState.network)
local networkingVirtualEvents = network.NetworkingVirtualEvents
local rsvpsimpl = require(script.Parent["rsvps.impl"])

return rsvpsimpl(networkingVirtualEvents, Players)
