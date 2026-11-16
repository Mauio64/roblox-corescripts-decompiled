local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/LoggingProtocol")
local EventIngestService = game:GetService("EventIngestService")

local analytics = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/Analytics").Analytics.new(game:GetService("RbxAnalyticsService"))
local setupSetRbxEventStream = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/DefaultAnalyticsService/setupSetRbxEventStream")
local setupSendEventDeferred = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/DefaultAnalyticsService/setupSendEventDeferred")
local default = LoggingProtocol.default

return {
	EventStream = {
		setRBXEventStream = setupSetRbxEventStream(EventIngestService),
		sendEventDeferred = setupSendEventDeferred(EventIngestService)
	},
	Diag = analytics.Diag,
	Telemetry = default
}
