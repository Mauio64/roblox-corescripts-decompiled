local TelemetryService = game:GetService("TelemetryService")

local t = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/t")
local discoveryEventErrorLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/DiscoveryUtils").DiscoveryEventErrorLogger

local v5 = {
	eventName = "playButtonLoadingDuration",
	backends = { "EventIngest", "Points" },
	throttlingPercentage = game:DefineFastInt(
		"LuaAppPlayButtonLoadingDurationTelemetryThrottleHundredthsPercent",
		10000
	),
	lastUpdated = { 26, 5, 12 },
	description = "Fires when a mounted Play Button leaves the Loading state."
}

local strictInterface = t.strictInterface({
	universeId = t.string,
	durationMs = t.number,
	endReason = t.string,
	endPlayButtonState = t.optional(t.string),
	endPlayabilityStatus = t.optional(t.string),
	pageName = t.optional(t.string)
})

return function(p2, p3)
	local v6, v7 = strictInterface(p2)

	if not v6 then
		discoveryEventErrorLogger.reportError("PlayButtonLoadingDurationInvalidInterface", v7)
	end

	TelemetryService:LogEvent(v5, {
		eventContext = p3,
		standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" },
		customFields = p2
	})
end
