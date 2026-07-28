local TelemetryService = game:GetService("TelemetryService")
local Parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent
local t = require(Parent.t)
local DiscoveryEventErrorLogger = require(Parent.DiscoveryUtils).DiscoveryEventErrorLogger
local v5 = game:DefineFastInt("LuaAppPlayButtonLoadingDurationTelemetryThrottleHundredthsPercent", 10000)
local t1 = {
	eventName = "playButtonLoadingDuration",
	description = "Fires when a mounted Play Button leaves the Loading state.",
	backends = {
		"EventIngest",
		"Points"
	},
	throttlingPercentage = v5,
	lastUpdated = {
		26,
		5,
		12
	}
}
local v7 = t.strictInterface({
	universeId = t.string,
	durationMs = t.number,
	endReason = t.string,
	endPlayButtonState = t.optional(t.string),
	endPlayabilityStatus = t.optional(t.string),
	pageName = t.optional(t.string)
})

return function(p1, s1: string?) -- line: 29
	-- upvalues: v7 (copy), DiscoveryEventErrorLogger (copy), TelemetryService (copy), t1 (copy)
	local v10, v11 = v7(p1)

	if not v10 then
		DiscoveryEventErrorLogger.reportError("PlayButtonLoadingDurationInvalidInterface", v11)
	end

	TelemetryService:LogEvent(t1, {
		eventContext = s1,
		standardizedFields = {
			"addSessionInfo",
			"addSessionId",
			"addOSInfo"
		},
		customFields = p1
	})
end
