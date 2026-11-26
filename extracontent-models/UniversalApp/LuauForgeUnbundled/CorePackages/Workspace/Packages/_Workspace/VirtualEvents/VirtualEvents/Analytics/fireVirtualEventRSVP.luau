local enums = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEventsState").enums
require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEventsState")
local sendEventDeferred = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Analytics/sendEventDeferred")

return function(p2)
	sendEventDeferred(enums.AnalyticsEvent.VirtualEventRSVP, p2)
end
