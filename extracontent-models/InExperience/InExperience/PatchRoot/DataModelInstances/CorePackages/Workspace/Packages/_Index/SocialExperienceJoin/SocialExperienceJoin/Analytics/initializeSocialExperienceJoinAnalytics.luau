local parent = script:FindFirstAncestor("SocialExperienceJoin").Parent

local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local AnalyticsFactory = SocialLuaAnalytics.Analytics.AnalyticsFactory
local DefaultAnalyticsService = SocialLuaAnalytics.Analytics.DefaultAnalyticsService

local getEventStreamActionList = require(script.Parent.getEventStreamActionList)
local TelemetryActionList = require(script.Parent.TelemetryActionList)

return function(p)
	local eventStreamActionList = getEventStreamActionList(p)
	return AnalyticsFactory.setUpAnalyticsFactory({
		eventLists = { EventStream = eventStreamActionList, Telemetry = TelemetryActionList },
		analyticsImpl = {
			EventStream = DefaultAnalyticsService.EventStream,
			Telemetry = DefaultAnalyticsService.Telemetry
		}
	})()
end
