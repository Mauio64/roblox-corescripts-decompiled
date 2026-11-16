local SocialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/SocialLuaAnalytics")
local defaultAnalyticsService = SocialLuaAnalytics.Analytics.DefaultAnalyticsService
local analyticsFactory = SocialLuaAnalytics.Analytics.AnalyticsFactory

local TelemetryActionList = require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/Analytics/TelemetryActionList")

return analyticsFactory.setUpAnalyticsFactory({
	eventLists = { Telemetry = TelemetryActionList },
	analyticsImpl = { Telemetry = defaultAnalyticsService.Telemetry }
})
