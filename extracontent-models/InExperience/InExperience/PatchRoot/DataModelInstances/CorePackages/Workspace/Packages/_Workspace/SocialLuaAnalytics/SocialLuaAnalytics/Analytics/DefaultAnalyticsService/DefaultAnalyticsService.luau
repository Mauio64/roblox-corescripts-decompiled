local parent = script:FindFirstAncestor("SocialLuaAnalytics").Parent
local LoggingProtocol = require(parent.LoggingProtocol)
local EventIngestService = game:GetService("EventIngestService")

local Analytics = require(parent.Analytics)
local analytics = Analytics.Analytics.new(game:GetService("RbxAnalyticsService"))
local setupSetRbxEventStream = require(script.Parent.setupSetRbxEventStream)
local setupSendEventDeferred = require(script.Parent.setupSendEventDeferred)
local default = LoggingProtocol.default

return {
	EventStream = {
		setRBXEventStream = setupSetRbxEventStream(EventIngestService),
		sendEventDeferred = setupSendEventDeferred(EventIngestService)
	},
	Diag = analytics.Diag,
	Telemetry = default
}
