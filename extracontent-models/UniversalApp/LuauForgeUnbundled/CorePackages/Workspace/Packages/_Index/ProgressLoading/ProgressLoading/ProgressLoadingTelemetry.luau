local TelemetryService = game:GetService("TelemetryService")

local default = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/LoggingProtocol").default

local defineFastInt = game:DefineFastInt("ProgressLoadingTelemetryThrottleHundredthsPercent", 10000)

local v5 = {
	eventName = "progress_loading_assets_activated",
	backends = { "RobloxTelemetryCounter" },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 2026, 4, 8 },
	description = "Counter for deferred asset loading screen activations"
}

local v6 = {
	eventName = "progress_loading_assets_deactivated",
	backends = { "RobloxTelemetryCounter" },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 2026, 4, 8 },
	description = "Counter for deferred asset loading screen deactivations"
}

local v7 = {
	eventName = "progress_loading_assets_duration_ms",
	backends = { "RobloxTelemetryStat" },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 2026, 4, 8 },
	description = "Duration in ms that the deferred asset loading screen was shown"
}

local lastTime = nil

return {
	logLoadingAssetsActivated = function()
		lastTime = os.clock()
		TelemetryService:LogCounter(v5, {}, 1)
		default:logEvent("progress_loading_assets_activated")
	end,
	logLoadingAssetsDeactivated = function()
		assert(
			lastTime ~= nil,
			"logLoadingAssetsDeactivated called without a prior logLoadingAssetsActivated"
		)
		local v8 = math.floor((os.clock() - lastTime) * 1000)
		lastTime = nil
		TelemetryService:LogCounter(v6, {}, 1)
		TelemetryService:LogStat(v7, {}, v8)
		default:logEvent("progress_loading_assets_deactivated")
	end
}
