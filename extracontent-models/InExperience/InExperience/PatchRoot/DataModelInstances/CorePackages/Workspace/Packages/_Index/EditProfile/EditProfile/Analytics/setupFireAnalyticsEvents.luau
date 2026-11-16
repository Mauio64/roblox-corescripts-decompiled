local parent = script:FindFirstAncestor("EditProfile").Parent
local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local AnalyticsFactory = SocialLuaAnalytics.Analytics.AnalyticsFactory

local DiagActionList = require(script.Parent.DiagActionList)
local EventStreamActionList = require(script.Parent.EventStreamActionList)
local TelemetryActionList = require(script.Parent.TelemetryActionList)

return function(p)
	return AnalyticsFactory.setUpAnalyticsFactory({
		eventLists = {
			EventStream = EventStreamActionList,
			Diag = DiagActionList,
			Telemetry = TelemetryActionList
		},
		analyticsImpl = p.analytics
	})(p).fireAnalyticsEvent
end
