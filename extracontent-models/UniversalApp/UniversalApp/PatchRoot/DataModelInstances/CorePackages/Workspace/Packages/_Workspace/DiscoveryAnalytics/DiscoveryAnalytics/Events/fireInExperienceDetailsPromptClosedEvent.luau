local TelemetryService = game:GetService("TelemetryService")
local Parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent
local t = require(Parent.t)
local DiscoveryEventErrorLogger = require(Parent.DiscoveryUtils).DiscoveryEventErrorLogger
local FFlagLuaAppIedpSendPoints = require(Parent.SharedFlags).FFlagLuaAppIedpSendPoints
local v6 = game:DefineFastInt("InExperienceDetailsPromptClosedHundredthsPercent", 0)
local v7 = t.strictInterface({
	targetUniverseId = t.string,
	closeReason = t.string,
	isFullyLoaded = t.boolean,
	targetRootPlaceId = t.optional(t.number),
	gameInfoErrorType = t.optional(t.string),
	isPlayable = t.optional(t.boolean),
	playabilityStatus = t.optional(t.string)
})
local t1 = {
	eventName = "inExperienceDetailsPromptClosed",
	description = "Fires when the in-experience details prompt is closed",
	backends = if not FFlagLuaAppIedpSendPoints then { "EventIngest" } else {
		"EventIngest",
		"Points"
	},
	throttlingPercentage = v6,
	lastUpdated = if not FFlagLuaAppIedpSendPoints then {
		25,
		11,
		11
	} else {
		25,
		11,
		19
	}
}

local function fireInExperienceDetailsPromptClosedEvent(p1) -- line: 30
	-- upvalues: v7 (copy), DiscoveryEventErrorLogger (copy), TelemetryService (copy), t1 (copy)
	local v11, v12 = v7(p1)

	if not v11 then
		DiscoveryEventErrorLogger.reportError("InExperienceDetailsPromptClosedInvalidInterface", v12)
	end

	TelemetryService:LogEvent(t1, {
		standardizedFields = {
			"addUniverseId",
			"addOSInfo"
		},
		customFields = p1
	})
end

return fireInExperienceDetailsPromptClosedEvent
