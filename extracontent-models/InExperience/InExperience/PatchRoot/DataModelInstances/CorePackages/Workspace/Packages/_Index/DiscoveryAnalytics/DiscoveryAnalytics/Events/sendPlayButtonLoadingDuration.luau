local TelemetryService = game:GetService("TelemetryService")

local parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent

local t = require(parent.t)
local DiscoveryUtils = require(parent.DiscoveryUtils)
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local v = {
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

return function(customFields, eventContext: string?)
	local v2, v3 = strictInterface(customFields)

	if not v2 then
		DiscoveryEventErrorLogger.reportError("PlayButtonLoadingDurationInvalidInterface", v3)
	end

	TelemetryService:LogEvent(v, {
		eventContext = eventContext,
		standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" },
		customFields = customFields
	})
end
