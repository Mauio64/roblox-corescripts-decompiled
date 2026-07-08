local Parent = script:FindFirstAncestor("SocialLuaAnalytics").Parent
local LoggingProtocol = require(Parent.LoggingProtocol)
local EventIngestService = game:GetService("EventIngestService")
local v4 = require(Parent.Analytics).Analytics.new(game:GetService("RbxAnalyticsService"))
local setupSetRbxEventStream = require(script.Parent.setupSetRbxEventStream)
local setupSendEventDeferred = require(script.Parent.setupSendEventDeferred)
local default = LoggingProtocol.default

return {
	EventStream = {
		setRBXEventStream = setupSetRbxEventStream(EventIngestService),
		sendEventDeferred = setupSendEventDeferred(EventIngestService)
	},
	Diag = v4.Diag,
	Telemetry = default
}
