local EventIngestService = game:GetService("EventIngestService")

local getPlatformTarget = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/Analytics").getPlatformTarget

return function(p2, p3, options)
	EventIngestService:SendEventDeferred(getPlatformTarget(), p2, p3, options or {})
end
