local VirtualEvents = script:FindFirstAncestor("VirtualEvents")
local enums = require(VirtualEvents.Parent.VirtualEventsState).enums
local sendEventDeferred = require(script.Parent.sendEventDeferred)

return function(t1: {[any]: any}) -- line: 14
	-- upvalues: sendEventDeferred (copy), enums (copy)
	sendEventDeferred(enums.AnalyticsEvent.ShareVirtualEventIconClicked, t1)
end
