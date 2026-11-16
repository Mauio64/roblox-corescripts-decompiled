local EventIngestService = game:GetService("EventIngestService")

local SocialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileShareLinks/SocialLuaAnalytics")
local analyticsFactory = SocialLuaAnalytics.Analytics.AnalyticsFactory
local defaultAnalyticsService = SocialLuaAnalytics.Analytics.DefaultAnalyticsService

local EventStreamActionList = require("@game/CorePackages/Workspace/Packages/_Index/ProfileShareLinks/ProfileShareLinks/Analytics/EventStreamActionList")
local TelemetryActionList = require("@game/CorePackages/Workspace/Packages/_Index/ProfileShareLinks/ProfileShareLinks/Analytics/TelemetryActionList")
local setupSendEventDeferred = require("@game/CorePackages/Workspace/Packages/_Index/ProfileShareLinks/ProfileShareLinks/Analytics/setupSendEventDeferred")
local setupSetRbxEventStream = require("@game/CorePackages/Workspace/Packages/_Index/ProfileShareLinks/ProfileShareLinks/Analytics/setupSetRbxEventStream")

return analyticsFactory.setUpAnalyticsFactory({
	eventLists = { EventStream = EventStreamActionList, Telemetry = TelemetryActionList },
	analyticsImpl = {
		EventStream = {
			sendEventDeferred = setupSendEventDeferred(EventIngestService),
			setRBXEventStream = setupSetRbxEventStream(EventIngestService)
		},
		Telemetry = defaultAnalyticsService.Telemetry
	}
})
