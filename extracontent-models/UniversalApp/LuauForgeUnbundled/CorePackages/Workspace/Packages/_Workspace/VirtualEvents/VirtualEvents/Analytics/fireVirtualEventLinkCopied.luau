local enums = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEventsState").enums
local sendEventDeferred = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Analytics/sendEventDeferred")

return function(p2)
	sendEventDeferred(enums.AnalyticsEvent.VirtualEventLinkCopied, p2)
end
