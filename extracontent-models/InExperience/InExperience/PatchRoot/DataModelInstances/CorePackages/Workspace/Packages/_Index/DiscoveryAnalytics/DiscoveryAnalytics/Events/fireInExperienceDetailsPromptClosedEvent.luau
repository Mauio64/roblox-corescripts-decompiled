local TelemetryService = game:GetService("TelemetryService")
local parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent

local t = require(parent.t)
local DiscoveryUtils = require(parent.DiscoveryUtils)
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppIedpSendPoints = SharedFlags.FFlagLuaAppIedpSendPoints

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

local v = {
	eventName = "inExperienceDetailsPromptClosed",
	backends = FFlagLuaAppIedpSendPoints and { "EventIngest", "Points" } or { "EventIngest" },
	throttlingPercentage = defineFastInt,
	lastUpdated = FFlagLuaAppIedpSendPoints and { 25, 11, 19 } or { 25, 11, 11 },
	description = "Fires when the in-experience details prompt is closed"
}

local function fireInExperienceDetailsPromptClosedEvent(customFields)
	local v2, v3 = strictInterface(customFields)

	if not v2 then
		DiscoveryEventErrorLogger.reportError("InExperienceDetailsPromptClosedInvalidInterface", v3)
	end

	TelemetryService:LogEvent(v, {
		standardizedFields = { "addUniverseId", "addOSInfo" },
		customFields = customFields
	})
end

return fireInExperienceDetailsPromptClosedEvent
