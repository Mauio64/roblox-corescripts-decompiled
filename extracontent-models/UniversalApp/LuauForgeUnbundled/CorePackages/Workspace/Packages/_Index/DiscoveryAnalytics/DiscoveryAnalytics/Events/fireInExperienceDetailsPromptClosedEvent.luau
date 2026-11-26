local TelemetryService = game:GetService("TelemetryService")

local t = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/t")
local discoveryEventErrorLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/DiscoveryUtils").DiscoveryEventErrorLogger

local fFlagLuaAppIedpSendPoints = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/SharedFlags").FFlagLuaAppIedpSendPoints

local defineFastInt = game:DefineFastInt("InExperienceDetailsPromptClosedHundredthsPercent", 0)

local strictInterface = t.strictInterface({
	targetUniverseId = t.string,
	closeReason = t.string,
	isFullyLoaded = t.boolean,
	targetRootPlaceId = t.optional(t.number),
	gameInfoErrorType = t.optional(t.string),
	isPlayable = t.optional(t.boolean),
	playabilityStatus = t.optional(t.string)
})

local v5 = {
	eventName = "inExperienceDetailsPromptClosed",
	backends = fFlagLuaAppIedpSendPoints and { "EventIngest", "Points" } or { "EventIngest" },
	throttlingPercentage = defineFastInt,
	lastUpdated = fFlagLuaAppIedpSendPoints and { 25, 11, 19 } or { 25, 11, 11 },
	description = "Fires when the in-experience details prompt is closed"
}

local function fireInExperienceDetailsPromptClosedEvent(p2)
	local v6, v7 = strictInterface(p2)

	if not v6 then
		discoveryEventErrorLogger.reportError("InExperienceDetailsPromptClosedInvalidInterface", v7)
	end

	TelemetryService:LogEvent(v5, {
		standardizedFields = { "addUniverseId", "addOSInfo" },
		customFields = p2
	})
end

return fireInExperienceDetailsPromptClosedEvent
