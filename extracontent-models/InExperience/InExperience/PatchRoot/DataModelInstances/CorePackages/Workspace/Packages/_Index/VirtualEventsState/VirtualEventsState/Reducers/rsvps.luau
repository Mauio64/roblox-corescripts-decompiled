local VirtualEventsState = script:FindFirstAncestor("VirtualEventsState")
local Players = game:GetService("Players")
local NetworkingVirtualEvents = require(VirtualEventsState.network).NetworkingVirtualEvents

return require(script.Parent["rsvps.impl"])(NetworkingVirtualEvents, Players)
