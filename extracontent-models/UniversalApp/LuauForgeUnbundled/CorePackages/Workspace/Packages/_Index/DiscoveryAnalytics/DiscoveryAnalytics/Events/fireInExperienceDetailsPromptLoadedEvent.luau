local TelemetryService = game:GetService("TelemetryService")

local t = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/t")
local discoveryEventErrorLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/DiscoveryUtils").DiscoveryEventErrorLogger

local fFlagLuaAppIedpSendPoints = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/SharedFlags").FFlagLuaAppIedpSendPoints

local defineFastInt = game:DefineFastInt("InExperienceDetailsPromptLoadedHundredthsPercent", 0)

local strictInterface = t.strictInterface({
	targetUniverseId = t.string,
	gameInfoRetrievalStatus = t.string,
	playabilityRetrievalStatus = t.string,
	targetRootPlaceId = t.optional(t.number),
	isPlayable = t.optional(t.boolean),
	playabilityStatus = t.optional(t.string),
	gameInfoErrorType = t.optional(t.string)
})

local v5 = {
	eventName = "inExperienceDetailsPromptLoaded",
	backends = fFlagLuaAppIedpSendPoints and { "EventIngest", "Points" } or { "EventIngest" },
	throttlingPercentage = defineFastInt,
	lastUpdated = fFlagLuaAppIedpSendPoints and { 25, 11, 19 } or { 25, 11, 11 },
	description = "Fires when the in-experience details prompt gameInfo and playability are loaded"
}

local function fireInExperienceDetailsPromptLoadedEvent(p2)
	local v6, v7 = strictInterface(p2)

	if not v6 then
		discoveryEventErrorLogger.reportError("InExperienceDetailsPromptLoadedInvalidInterface", v7)
	end

	TelemetryService:LogEvent(v5, {
		standardizedFields = { "addUniverseId", "addOSInfo" },
		customFields = p2
	})
end

return fireInExperienceDetailsPromptLoadedEvent
