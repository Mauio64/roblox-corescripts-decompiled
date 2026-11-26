local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/SetAlias/SetAlias/dependencies")

local EventIngestService = game:GetService("EventIngestService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local analytics = dependencies.Analytics
local analytics2 = analytics.Analytics.new(RbxAnalyticsService)
local getPlatformTarget = analytics.getPlatformTarget

return {
	Diag = analytics2.Diag,
	EventStream = {
		setRBXEventStream = function(self, p3, p4, options)
			EventIngestService:SetRBXEventStream(getPlatformTarget(), p3, p4, options or {})
		end
	}
}
