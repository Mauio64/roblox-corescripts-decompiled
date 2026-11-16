local Players = game:GetService("Players")

local networkingVirtualEvents = require("@game/CorePackages/Workspace/Packages/_Index/VirtualEventsState/VirtualEventsState/network").NetworkingVirtualEvents
return require("@game/CorePackages/Workspace/Packages/_Index/VirtualEventsState/VirtualEventsState/Reducers/rsvps.impl")(networkingVirtualEvents, Players)
