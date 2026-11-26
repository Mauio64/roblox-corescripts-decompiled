local TelemetryService = game:GetService("TelemetryService")

local t = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/t")
local discoveryEventErrorLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/DiscoveryUtils").DiscoveryEventErrorLogger

local fFlagLuaAppIedpSendPoints = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/SharedFlags").FFlagLuaAppIedpSendPoints

local defineFastInt = game:DefineFastInt("InExperienceDetailsPromptOpenedHundredthsPercent", 0)

local strictInterface = t.strictInterface({ targetUniverseId = t.string })

local v5 = {
	eventName = "inExperienceDetailsPromptOpened",
	backends = fFlagLuaAppIedpSendPoints and { "EventIngest", "Points" } or { "EventIngest" },
	throttlingPercentage = defineFastInt,
	lastUpdated = fFlagLuaAppIedpSendPoints and { 25, 11, 19 } or { 25, 11, 11 },
	description = "Fires when the in-experience details prompt is opened"
}

local function fireInExperienceDetailsPromptOpenedEvent(p2)
	local v6, v7 = strictInterface(p2)

	if not v6 then
		discoveryEventErrorLogger.reportError("InExperienceDetailsPromptOpenedInvalidInterface", v7)
	end

	TelemetryService:LogEvent(v5, {
		standardizedFields = { "addUniverseId", "addOSInfo" },
		customFields = p2
	})
end

return fireInExperienceDetailsPromptOpenedEvent
