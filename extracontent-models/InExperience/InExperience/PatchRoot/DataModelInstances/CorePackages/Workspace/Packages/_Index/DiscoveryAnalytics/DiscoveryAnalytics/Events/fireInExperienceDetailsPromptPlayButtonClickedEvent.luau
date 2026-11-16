local TelemetryService = game:GetService("TelemetryService")
local parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent

local t = require(parent.t)
local DiscoveryUtils = require(parent.DiscoveryUtils)
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppIedpSendPoints = SharedFlags.FFlagLuaAppIedpSendPoints

local defineFastInt = game:DefineFastInt("InExperienceDetailsPromptPlayClickedHundredthsPercent", 0)

local strictInterface = t.strictInterface({
	targetUniverseId = t.string,
	targetRootPlaceId = t.optional(t.number),
	playabilityRetrievalStatus = t.optional(t.string)
})

local v = {
	eventName = "inExperienceDetailsPromptPlayButtonClicked",
	backends = FFlagLuaAppIedpSendPoints and { "EventIngest", "Points" } or { "EventIngest" },
	throttlingPercentage = defineFastInt,
	lastUpdated = FFlagLuaAppIedpSendPoints and { 25, 11, 19 } or { 25, 11, 11 },
	description = "Fires when the play button is clicked in the in-experience details prompt"
}

local function fireInExperienceDetailsPromptPlayButtonClickedEvent(customFields)
	local v2, v3 = strictInterface(customFields)

	if not v2 then
		DiscoveryEventErrorLogger.reportError("InExperienceDetailsPromptPlayClickedInvalidInterface", v3)
	end

	TelemetryService:LogEvent(v, {
		standardizedFields = { "addUniverseId", "addOSInfo" },
		customFields = customFields
	})
end

return fireInExperienceDetailsPromptPlayButtonClickedEvent
