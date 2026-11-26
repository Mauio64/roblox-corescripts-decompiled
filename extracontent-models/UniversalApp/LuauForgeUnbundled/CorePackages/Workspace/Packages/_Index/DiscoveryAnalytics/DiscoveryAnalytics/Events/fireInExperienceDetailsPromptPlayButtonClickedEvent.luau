local TelemetryService = game:GetService("TelemetryService")

local t = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/t")
local discoveryEventErrorLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/DiscoveryUtils").DiscoveryEventErrorLogger

local fFlagLuaAppIedpSendPoints = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/SharedFlags").FFlagLuaAppIedpSendPoints

local defineFastInt = game:DefineFastInt("InExperienceDetailsPromptPlayClickedHundredthsPercent", 0)

local strictInterface = t.strictInterface({
	targetUniverseId = t.string,
	targetRootPlaceId = t.optional(t.number),
	playabilityRetrievalStatus = t.optional(t.string)
})

local v5 = {
	eventName = "inExperienceDetailsPromptPlayButtonClicked",
	backends = fFlagLuaAppIedpSendPoints and { "EventIngest", "Points" } or { "EventIngest" },
	throttlingPercentage = defineFastInt,
	lastUpdated = fFlagLuaAppIedpSendPoints and { 25, 11, 19 } or { 25, 11, 11 },
	description = "Fires when the play button is clicked in the in-experience details prompt"
}

local function fireInExperienceDetailsPromptPlayButtonClickedEvent(p2)
	local v6, v7 = strictInterface(p2)

	if not v6 then
		discoveryEventErrorLogger.reportError("InExperienceDetailsPromptPlayClickedInvalidInterface", v7)
	end

	TelemetryService:LogEvent(v5, {
		standardizedFields = { "addUniverseId", "addOSInfo" },
		customFields = p2
	})
end

return fireInExperienceDetailsPromptPlayButtonClickedEvent
