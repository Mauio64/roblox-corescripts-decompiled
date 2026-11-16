local EventIngestService = game:GetService("EventIngestService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local Analytics = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerContextualMenu/Analytics")

local analytics = Analytics.Analytics.new(RbxAnalyticsService)
local getPlatformTarget = Analytics.getPlatformTarget

return {
	Diag = analytics.Diag,
	EventStream = {
		setRBXEventStream = function(self, p3, p4, options)
			EventIngestService:SetRBXEventStream(getPlatformTarget(), p3, p4, options or {})
		end,
		sendEventDeferred = function(p2, p3, p4, options)
			EventIngestService:SendEventDeferred(getPlatformTarget(), p3, p4, options or {})
		end
	}
}
