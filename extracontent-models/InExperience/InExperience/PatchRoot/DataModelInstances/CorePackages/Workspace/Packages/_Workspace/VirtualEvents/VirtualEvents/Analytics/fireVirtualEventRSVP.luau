local VirtualEvents = script:FindFirstAncestor("VirtualEvents")

local VirtualEventsState = require(VirtualEvents.Parent.VirtualEventsState)
local enums = VirtualEventsState.enums
require(VirtualEvents.Parent.VirtualEventsState)
local sendEventDeferred = require(script.Parent.sendEventDeferred)

return function(p)
	sendEventDeferred(enums.AnalyticsEvent.VirtualEventRSVP, p)
end
