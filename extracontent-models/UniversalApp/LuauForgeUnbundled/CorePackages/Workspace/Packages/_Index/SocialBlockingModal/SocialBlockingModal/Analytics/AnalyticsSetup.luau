local SocialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialBlockingModal/SocialLuaAnalytics")
local defaultAnalyticsService = SocialLuaAnalytics.Analytics.DefaultAnalyticsService
local analyticsFactory = SocialLuaAnalytics.Analytics.AnalyticsFactory

local TelemetryActionList = require("@game/CorePackages/Workspace/Packages/_Index/SocialBlockingModal/SocialBlockingModal/Analytics/TelemetryActionList")

return analyticsFactory.setUpAnalyticsFactory({
	eventLists = { Telemetry = TelemetryActionList },
	analyticsImpl = { Telemetry = defaultAnalyticsService.Telemetry }
})
