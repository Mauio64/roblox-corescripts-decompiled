local TelemetryService = game:GetService("TelemetryService")

local parent = script:FindFirstAncestor("ProgressLoading").Parent

local LoggingProtocol = require(parent.LoggingProtocol)

local default = LoggingProtocol.default

local defineFastInt = game:DefineFastInt("ProgressLoadingTelemetryThrottleHundredthsPercent", 10000)

local v = {
	eventName = "progress_loading_assets_activated",
	backends = { "RobloxTelemetryCounter" },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 2026, 4, 8 },
	description = "Counter for deferred asset loading screen activations"
}

local v2 = {
	eventName = "progress_loading_assets_deactivated",
	backends = { "RobloxTelemetryCounter" },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 2026, 4, 8 },
	description = "Counter for deferred asset loading screen deactivations"
}

local v3 = {
	eventName = "progress_loading_assets_duration_ms",
	backends = { "RobloxTelemetryStat" },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 2026, 4, 8 },
	description = "Duration in ms that the deferred asset loading screen was shown"
}

local lastTime = nil
local ProgressLoadingTelemetry = {}

function ProgressLoadingTelemetry.logLoadingAssetsActivated()
	lastTime = os.clock()
	TelemetryService:LogCounter(v, {}, 1)
	default:logEvent("progress_loading_assets_activated")
end

function ProgressLoadingTelemetry.logLoadingAssetsDeactivated()
	assert(lastTime ~= nil, "logLoadingAssetsDeactivated called without a prior logLoadingAssetsActivated")
	local v4 = math.floor((os.clock() - lastTime) * 1000)
	lastTime = nil
	TelemetryService:LogCounter(v2, {}, 1)
	TelemetryService:LogStat(v3, {}, v4)
	default:logEvent("progress_loading_assets_deactivated")
end

return ProgressLoadingTelemetry
