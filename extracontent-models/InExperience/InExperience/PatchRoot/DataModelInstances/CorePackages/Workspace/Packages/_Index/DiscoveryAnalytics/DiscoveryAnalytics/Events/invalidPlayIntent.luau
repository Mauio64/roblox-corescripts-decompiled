local TelemetryService = game:GetService("TelemetryService")

local parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent

local t = require(parent.t)
local DiscoveryUtils = require(parent.DiscoveryUtils)
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppPlayButtonLoadingDurationTelemetry = SharedFlags.FFlagLuaAppPlayButtonLoadingDurationTelemetry

local v = {
	eventName = "invalidPlayIntent",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("LuaAppInvalidPlayIntentThrottlingHundredthsPercent", 10000),
	lastUpdated = { 26, 3, 18 },
	description = "Fires when the user clicks on a Play Button that is in an invalid state to play (i.e. Loading)"
}

local strictInterface = t.strictInterface
local v2 = {
	universeId = t.string,
	playButtonState = t.string,
	playabilityStatus = t.optional(t.string),
	pageName = 0
}
local pageName

if FFlagLuaAppPlayButtonLoadingDurationTelemetry then
	pageName = t.optional(t.string)
end

v2.pageName = pageName
local v3 = strictInterface(v2)

return function(eventContext: string, data)
	local v4, v5 = v3(data)

	if not v4 then
		DiscoveryEventErrorLogger.reportError("InvalidPlayIntentInvalidInterface", v5)
	end

	TelemetryService:LogEvent(v, {
		eventContext = eventContext,
		standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" },
		customFields = not FFlagLuaAppPlayButtonLoadingDurationTelemetry and {
			universeId = data.universeId,
			playButtonState = data.playButtonState,
			playabilityStatus = data.playabilityStatus
		} or data
	})
end
