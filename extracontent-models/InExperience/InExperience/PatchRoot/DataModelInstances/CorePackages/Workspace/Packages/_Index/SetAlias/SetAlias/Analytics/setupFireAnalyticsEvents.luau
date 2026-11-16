local parent = script.Parent.Parent

local dependencies = require(parent.dependencies)
local socialLuaAnalytics = dependencies.SocialLuaAnalytics

local TelemetryActionList = require(script.Parent.TelemetryActionList)
local DiagActionList = require(script.Parent.DiagActionList)
local EventStreamActionList = require(script.Parent.EventStreamActionList)
local analyticsFactory = socialLuaAnalytics.Analytics.AnalyticsFactory

return function(p)
	return analyticsFactory.setUpAnalyticsFactory({
		eventLists = {
			EventStream = EventStreamActionList,
			Diag = DiagActionList,
			Telemetry = TelemetryActionList
		},
		analyticsImpl = p.analytics
	})(p).fireAnalyticsEvent
end
