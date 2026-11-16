local analyticsFactory = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/SocialLuaAnalytics").Analytics.AnalyticsFactory

local DiagActionList = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Analytics/DiagActionList")
local EventStreamActionList = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Analytics/EventStreamActionList")
local TelemetryActionList = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Analytics/TelemetryActionList")

return function(p2)
	return analyticsFactory.setUpAnalyticsFactory({
		eventLists = { EventStream = EventStreamActionList, Diag = DiagActionList, Telemetry = TelemetryActionList },
		analyticsImpl = p2.analytics
	})(p2).fireAnalyticsEvent
end
