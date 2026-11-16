local telemetry = script:FindFirstAncestor("AppChat").Telemetry
local createReactTelemetryLayer = require(telemetry.createReactTelemetryLayer)
local AppTelemetryLayer = require(telemetry.Layers.AppTelemetryLayer)

return (createReactTelemetryLayer(AppTelemetryLayer.Context, {}))
