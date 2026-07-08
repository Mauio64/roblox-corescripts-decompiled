local Parent = script:FindFirstAncestor("SocialExperienceJoin").Parent
local SocialLuaAnalytics = require(Parent.SocialLuaAnalytics)
local AnalyticsFactory = SocialLuaAnalytics.Analytics.AnalyticsFactory
local DefaultAnalyticsService = SocialLuaAnalytics.Analytics.DefaultAnalyticsService
local getEventStreamActionList = require(script.Parent.getEventStreamActionList)
local TelemetryActionList = require(script.Parent.TelemetryActionList)

return function(p1) -- line: 11
	-- upvalues: getEventStreamActionList (copy), AnalyticsFactory (copy), TelemetryActionList (copy), DefaultAnalyticsService (copy)
	local v8 = getEventStreamActionList(p1)

	return AnalyticsFactory.setUpAnalyticsFactory({
		eventLists = {
			EventStream = v8,
			Telemetry = TelemetryActionList
		},
		analyticsImpl = {
			EventStream = DefaultAnalyticsService.EventStream,
			Telemetry = DefaultAnalyticsService.Telemetry
		}
	})()
end
