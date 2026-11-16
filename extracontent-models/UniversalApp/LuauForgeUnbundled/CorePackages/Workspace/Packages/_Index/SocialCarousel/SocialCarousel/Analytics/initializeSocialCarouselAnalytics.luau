local SocialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SocialLuaAnalytics")
local analyticsFactory = SocialLuaAnalytics.Analytics.AnalyticsFactory
local defaultAnalyticsService = SocialLuaAnalytics.Analytics.DefaultAnalyticsService

local EventStreamActionList = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Analytics/EventStreamActionList")
local TelemetryActionList = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Analytics/TelemetryActionList")

return analyticsFactory.setUpAnalyticsFactory({
	eventLists = { EventStream = EventStreamActionList, Telemetry = TelemetryActionList },
	analyticsImpl = {
		EventStream = defaultAnalyticsService.EventStream,
		Telemetry = defaultAnalyticsService.Telemetry
	}
})
