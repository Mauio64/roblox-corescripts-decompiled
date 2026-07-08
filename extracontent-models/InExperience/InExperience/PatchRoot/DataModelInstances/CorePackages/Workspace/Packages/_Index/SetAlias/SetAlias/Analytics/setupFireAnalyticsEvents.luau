local ParentParent = script.Parent.Parent
local SocialLuaAnalytics = require(ParentParent.dependencies).SocialLuaAnalytics
local TelemetryActionList = require(script.Parent.TelemetryActionList)
local DiagActionList = require(script.Parent.DiagActionList)
local EventStreamActionList = require(script.Parent.EventStreamActionList)
local AnalyticsFactory = SocialLuaAnalytics.Analytics.AnalyticsFactory

return function(t1: {[any]: any}) -- line: 11
	-- upvalues: AnalyticsFactory (copy), EventStreamActionList (copy), DiagActionList (copy), TelemetryActionList (copy)
	return AnalyticsFactory.setUpAnalyticsFactory({
		eventLists = {
			EventStream = EventStreamActionList,
			Diag = DiagActionList,
			Telemetry = TelemetryActionList
		},
		analyticsImpl = t1.analytics
	})(t1).fireAnalyticsEvent
end
