local parent = script:FindFirstAncestor("ProfilePlatform").Parent

local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local AnalyticsFactory = SocialLuaAnalytics.Analytics.AnalyticsFactory
local DefaultAnalyticsService = SocialLuaAnalytics.Analytics.DefaultAnalyticsService

local EventStreamActionList = require(script.Parent.EventStreamActionList)
local TelemetryActionList = require(script.Parent.TelemetryActionList)

return AnalyticsFactory.setUpAnalyticsFactory({
	eventLists = { EventStream = EventStreamActionList, Telemetry = TelemetryActionList },
	analyticsImpl = {
		EventStream = DefaultAnalyticsService.EventStream,
		Telemetry = DefaultAnalyticsService.Telemetry
	}
})
