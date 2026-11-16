local analyticsFactory = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfileBackground/SocialLuaAnalytics").Analytics.AnalyticsFactory

local DiagActionList = require("@game/CorePackages/Workspace/Packages/_Index/EditProfileBackground/EditProfileBackground/Analytics/DiagActionList")
local EventStreamActionList = require("@game/CorePackages/Workspace/Packages/_Index/EditProfileBackground/EditProfileBackground/Analytics/EventStreamActionList")
local TelemetryActionList = require("@game/CorePackages/Workspace/Packages/_Index/EditProfileBackground/EditProfileBackground/Analytics/TelemetryActionList")

return function(p2)
	return analyticsFactory.setUpAnalyticsFactory({
		eventLists = { EventStream = EventStreamActionList, Diag = DiagActionList, Telemetry = TelemetryActionList },
		analyticsImpl = p2.analytics
	})(p2).fireAnalyticsEvent
end
