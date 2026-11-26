local socialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/SetAlias/SetAlias/dependencies").SocialLuaAnalytics

local TelemetryActionList = require("@game/CorePackages/Workspace/Packages/_Index/SetAlias/SetAlias/Analytics/TelemetryActionList")
local DiagActionList = require("@game/CorePackages/Workspace/Packages/_Index/SetAlias/SetAlias/Analytics/DiagActionList")
local EventStreamActionList = require("@game/CorePackages/Workspace/Packages/_Index/SetAlias/SetAlias/Analytics/EventStreamActionList")
local analyticsFactory = socialLuaAnalytics.Analytics.AnalyticsFactory

return function(p2)
	return analyticsFactory.setUpAnalyticsFactory({
		eventLists = { EventStream = EventStreamActionList, Diag = DiagActionList, Telemetry = TelemetryActionList },
		analyticsImpl = p2.analytics
	})(p2).fireAnalyticsEvent
end
