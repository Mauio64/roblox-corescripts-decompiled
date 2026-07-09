local EventIngestService = game:GetService("EventIngestService")
local Parent = script:FindFirstAncestor("ProfileShareLinks").Parent
local SocialLuaAnalytics = require(Parent.SocialLuaAnalytics)
local AnalyticsFactory = SocialLuaAnalytics.Analytics.AnalyticsFactory
local DefaultAnalyticsService = SocialLuaAnalytics.Analytics.DefaultAnalyticsService
local EventStreamActionList = require(script.Parent.EventStreamActionList)
local TelemetryActionList = require(script.Parent.TelemetryActionList)
local setupSendEventDeferred = require(script.Parent.setupSendEventDeferred)
local setupSetRbxEventStream = require(script.Parent.setupSetRbxEventStream)

return AnalyticsFactory.setUpAnalyticsFactory({
	eventLists = {
		EventStream = EventStreamActionList,
		Telemetry = TelemetryActionList
	},
	analyticsImpl = {
		EventStream = {
			sendEventDeferred = setupSendEventDeferred(EventIngestService),
			setRBXEventStream = setupSetRbxEventStream(EventIngestService)
		},
		Telemetry = DefaultAnalyticsService.Telemetry
	}
})
