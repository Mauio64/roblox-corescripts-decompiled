local SocialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/UserRelationshipModals/SocialLuaAnalytics")
local defaultAnalyticsService = SocialLuaAnalytics.Analytics.DefaultAnalyticsService
local analyticsFactory = SocialLuaAnalytics.Analytics.AnalyticsFactory

local TelemetryActionList = require("@game/CorePackages/Workspace/Packages/_Workspace/UserRelationshipModals/UserRelationshipModals/Analytics/TelemetryActionList")

return analyticsFactory.setUpAnalyticsFactory({
	eventLists = { Telemetry = TelemetryActionList },
	analyticsImpl = { Telemetry = defaultAnalyticsService.Telemetry }
})
