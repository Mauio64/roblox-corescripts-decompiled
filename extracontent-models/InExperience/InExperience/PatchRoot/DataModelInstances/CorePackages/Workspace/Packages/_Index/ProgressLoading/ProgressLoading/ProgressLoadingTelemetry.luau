local TelemetryService = game:GetService("TelemetryService")
local Parent = script:FindFirstAncestor("ProgressLoading").Parent
local default = require(Parent.LoggingProtocol).default
local v4 = game:DefineFastInt("ProgressLoadingTelemetryThrottleHundredthsPercent", 10000)
local t1 = {
	eventName = "progress_loading_assets_activated",
	description = "Counter for deferred asset loading screen activations",
	backends = { "RobloxTelemetryCounter" },
	throttlingPercentage = v4,
	lastUpdated = {
		2026,
		4,
		8
	}
}
local t2 = {
	eventName = "progress_loading_assets_deactivated",
	description = "Counter for deferred asset loading screen deactivations",
	backends = { "RobloxTelemetryCounter" },
	throttlingPercentage = v4,
	lastUpdated = {
		2026,
		4,
		8
	}
}
local t3 = {
	eventName = "progress_loading_assets_duration_ms",
	description = "Duration in ms that the deferred asset loading screen was shown",
	backends = { "RobloxTelemetryStat" },
	throttlingPercentage = v4,
	lastUpdated = {
		2026,
		4,
		8
	}
}
local elapsed = nil

return {
	logLoadingAssetsActivated = function() -- line: 41
		-- upvalues: elapsed (ref), TelemetryService (copy), t1 (copy), default (copy)
		elapsed = os.clock()
		TelemetryService:LogCounter(t1, {}, 1)
		default:logEvent("progress_loading_assets_activated")
	end,
	logLoadingAssetsDeactivated = function() -- line: 47
		-- upvalues: elapsed (ref), TelemetryService (copy), t2 (copy), t3 (copy), default (copy)
		assert(elapsed ~= nil, "logLoadingAssetsDeactivated called without a prior logLoadingAssetsActivated")

		local v9 = math.floor((os.clock() - elapsed) * 1000)

		elapsed = nil
		TelemetryService:LogCounter(t2, {}, 1)
		TelemetryService:LogStat(t3, {}, v9)
		default:logEvent("progress_loading_assets_deactivated")
	end
}
