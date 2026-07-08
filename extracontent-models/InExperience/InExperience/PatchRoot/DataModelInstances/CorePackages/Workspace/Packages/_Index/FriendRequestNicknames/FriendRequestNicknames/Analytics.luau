local Parent = script:FindFirstAncestor("FriendRequestNicknames").Parent
local SocialLuaAnalytics = require(Parent.SocialLuaAnalytics)
local AnalyticsFactory = SocialLuaAnalytics.Analytics.AnalyticsFactory
local DefaultAnalyticsService = SocialLuaAnalytics.Analytics.DefaultAnalyticsService
local EventStreamActionList = require(script.EventStreamActionList)
local TelemetryActionList = require(script.TelemetryActionList)

return {
	EventNames = require(script.EventNames),
	Analytics = AnalyticsFactory.setUpAnalyticsFactory({
		eventLists = {
			EventStream = EventStreamActionList,
			Telemetry = TelemetryActionList
		},
		analyticsImpl = {
			EventStream = DefaultAnalyticsService.EventStream,
			Telemetry = DefaultAnalyticsService.Telemetry
		}
	})
}
