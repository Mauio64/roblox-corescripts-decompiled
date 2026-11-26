local TelemetryService = game:GetService("TelemetryService")

local t = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/t")
local discoveryEventErrorLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/DiscoveryUtils").DiscoveryEventErrorLogger

local fFlagLuaAppPlayButtonLoadingDurationTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/SharedFlags").FFlagLuaAppPlayButtonLoadingDurationTelemetry

local v5 = {
	eventName = "invalidPlayIntent",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("LuaAppInvalidPlayIntentThrottlingHundredthsPercent", 10000),
	lastUpdated = { 26, 3, 18 },
	description = "Fires when the user clicks on a Play Button that is in an invalid state to play (i.e. Loading)"
}

local strictInterface = t.strictInterface
local v6 = {
	universeId = t.string,
	playButtonState = t.string,
	playabilityStatus = t.optional(t.string),
	pageName = 0
}
local v7 = if fFlagLuaAppPlayButtonLoadingDurationTelemetry then t.optional(t.string) else nil
v6.pageName = v7
local v8 = strictInterface(v6)

return function(p2, data)
	local v9, v10 = v8(data)

	if not v9 then
		discoveryEventErrorLogger.reportError("InvalidPlayIntentInvalidInterface", v10)
	end

	TelemetryService:LogEvent(v5, {
		eventContext = p2,
		standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" },
		customFields = not fFlagLuaAppPlayButtonLoadingDurationTelemetry and {
			universeId = data.universeId,
			playButtonState = data.playButtonState,
			playabilityStatus = data.playabilityStatus
		} or data
	})
end
