local VirtualEvents = script:FindFirstAncestor("VirtualEvents")
local enums = require(VirtualEvents.Parent.VirtualEventsState).enums

require(VirtualEvents.Parent.VirtualEventsState)

local sendEventDeferred = require(script.Parent.sendEventDeferred)

return function(t1: {[any]: any}) -- line: 16
	-- upvalues: sendEventDeferred (copy), enums (copy)
	sendEventDeferred(enums.AnalyticsEvent.VirtualEventRSVP, t1)
end
