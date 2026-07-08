local TelemetryService = game:GetService("TelemetryService")
local Parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent
local t = require(Parent.t)
local DiscoveryEventErrorLogger = require(Parent.DiscoveryUtils).DiscoveryEventErrorLogger
local FFlagLuaAppPlayButtonLoadingDurationTelemetry = require(Parent.SharedFlags).FFlagLuaAppPlayButtonLoadingDurationTelemetry
local v6 = game:DefineFastInt("LuaAppInvalidPlayIntentThrottlingHundredthsPercent", 10000)
local t1 = {
	eventName = "invalidPlayIntent",
	description = "Fires when the user clicks on a Play Button that is in an invalid state to play (i.e. Loading)",
	backends = { "EventIngest" },
	throttlingPercentage = v6,
	lastUpdated = {
		26,
		3,
		18
	}
}
local v8 = t.strictInterface({
	universeId = t.string,
	playButtonState = t.string,
	playabilityStatus = t.optional(t.string),
	pageName = if not FFlagLuaAppPlayButtonLoadingDurationTelemetry then nil else t.optional(t.string)
})

return function(s1: string, p1) -- line: 30
	-- upvalues: v8 (copy), DiscoveryEventErrorLogger (copy), TelemetryService (copy), t1 (copy), FFlagLuaAppPlayButtonLoadingDurationTelemetry (copy)
	local v11, v12 = v8(p1)

	if not v11 then
		DiscoveryEventErrorLogger.reportError("InvalidPlayIntentInvalidInterface", v12)
	end

	TelemetryService:LogEvent(t1, {
		eventContext = s1,
		standardizedFields = {
			"addSessionInfo",
			"addSessionId",
			"addOSInfo"
		},
		customFields = if not FFlagLuaAppPlayButtonLoadingDurationTelemetry then {
			universeId = p1.universeId,
			playButtonState = p1.playButtonState,
			playabilityStatus = p1.playabilityStatus
		} else p1
	})
end
