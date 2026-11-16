local telemetry = script:FindFirstAncestor("AppChat").Telemetry
local createReactTelemetryLayer = require(telemetry.createReactTelemetryLayer)
local ChatConversationTelemetryLayer = require(telemetry.Layers.ChatConversationTelemetryLayer)

return (createReactTelemetryLayer(ChatConversationTelemetryLayer.Context, {}))
