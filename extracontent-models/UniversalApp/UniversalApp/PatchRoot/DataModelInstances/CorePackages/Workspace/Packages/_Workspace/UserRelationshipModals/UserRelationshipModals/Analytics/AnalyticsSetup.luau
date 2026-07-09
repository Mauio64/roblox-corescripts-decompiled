local Parent = script:FindFirstAncestor("UserRelationshipModals").Parent
local SocialLuaAnalytics = require(Parent.SocialLuaAnalytics)
local AnalyticsFactory = SocialLuaAnalytics.Analytics.AnalyticsFactory
local DefaultAnalyticsService = SocialLuaAnalytics.Analytics.DefaultAnalyticsService
local TelemetryActionList = require(script.Parent.TelemetryActionList)

return AnalyticsFactory.setUpAnalyticsFactory({
	eventLists = {
		Telemetry = TelemetryActionList
	},
	analyticsImpl = {
		Telemetry = DefaultAnalyticsService.Telemetry
	}
})
