local VirtualEvents = script:FindFirstAncestor("VirtualEvents")

local VirtualEventsState = require(VirtualEvents.Parent.VirtualEventsState)
local enums = VirtualEventsState.enums
local sendEventDeferred = require(script.Parent.sendEventDeferred)

return function(p)
	sendEventDeferred(enums.AnalyticsEvent.EventNotificationEnabled, p)
end
