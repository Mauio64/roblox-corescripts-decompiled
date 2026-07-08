local Parent = script:FindFirstAncestor("EditProfileBackground").Parent
local AnalyticsFactory = require(Parent.SocialLuaAnalytics).Analytics.AnalyticsFactory
local DiagActionList = require(script.Parent.DiagActionList)
local EventStreamActionList = require(script.Parent.EventStreamActionList)
local TelemetryActionList = require(script.Parent.TelemetryActionList)

return function(t1: {[any]: any}) -- line: 10
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
