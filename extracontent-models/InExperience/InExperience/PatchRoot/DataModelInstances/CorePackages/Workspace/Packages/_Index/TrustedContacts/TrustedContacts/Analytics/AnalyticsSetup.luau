local parent = script:FindFirstAncestor("TrustedContacts").Parent

local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local DefaultAnalyticsService = SocialLuaAnalytics.Analytics.DefaultAnalyticsService
local AnalyticsFactory = SocialLuaAnalytics.Analytics.AnalyticsFactory

local TelemetryActionList = require(script.Parent.TelemetryActionList)

return AnalyticsFactory.setUpAnalyticsFactory({
	eventLists = { Telemetry = TelemetryActionList },
	analyticsImpl = { Telemetry = DefaultAnalyticsService.Telemetry }
})
