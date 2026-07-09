local TelemetryService = game:GetService("TelemetryService")
local Parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent
local t = require(Parent.t)
local DiscoveryEventErrorLogger = require(Parent.DiscoveryUtils).DiscoveryEventErrorLogger
local FFlagLuaAppIedpSendPoints = require(Parent.SharedFlags).FFlagLuaAppIedpSendPoints
local v6 = game:DefineFastInt("InExperienceDetailsPromptOpenedHundredthsPercent", 0)
local v7 = t.strictInterface({
	targetUniverseId = t.string
})
local t1 = {
	eventName = "inExperienceDetailsPromptOpened",
	description = "Fires when the in-experience details prompt is opened",
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

local function fireInExperienceDetailsPromptOpenedEvent(p1) -- line: 24
	-- upvalues: v7 (copy), DiscoveryEventErrorLogger (copy), TelemetryService (copy), t1 (copy)
	local v11, v12 = v7(p1)

	if not v11 then
		DiscoveryEventErrorLogger.reportError("InExperienceDetailsPromptOpenedInvalidInterface", v12)
	end

	TelemetryService:LogEvent(t1, {
		standardizedFields = {
			"addUniverseId",
			"addOSInfo"
		},
		customFields = p1
	})
end

return fireInExperienceDetailsPromptOpenedEvent
