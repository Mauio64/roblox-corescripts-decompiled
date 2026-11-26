local SocialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperienceJoin/SocialLuaAnalytics")
local analyticsFactory = SocialLuaAnalytics.Analytics.AnalyticsFactory
local defaultAnalyticsService = SocialLuaAnalytics.Analytics.DefaultAnalyticsService

local getEventStreamActionList = require("@game/CorePackages/Workspace/Packages/_Index/SocialExperienceJoin/SocialExperienceJoin/Analytics/getEventStreamActionList")
local TelemetryActionList = require("@game/CorePackages/Workspace/Packages/_Index/SocialExperienceJoin/SocialExperienceJoin/Analytics/TelemetryActionList")

return function(p2)
	local v5 = getEventStreamActionList(p2)
	return analyticsFactory.setUpAnalyticsFactory({
		eventLists = { EventStream = v5, Telemetry = TelemetryActionList },
		analyticsImpl = {
			EventStream = defaultAnalyticsService.EventStream,
			Telemetry = defaultAnalyticsService.Telemetry
		}
	})()
end
