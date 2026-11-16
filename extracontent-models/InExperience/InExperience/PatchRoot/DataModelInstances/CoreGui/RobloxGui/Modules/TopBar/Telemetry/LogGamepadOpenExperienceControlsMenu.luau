local TelemetryService = game:GetService("TelemetryService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local parent = script.Parent.Parent

local FFlagLoggingGamepadOpenExpControlsMenu = require(parent.Flags.FFlagLoggingGamepadOpenExpControlsMenu)
local defineFastInt = game:DefineFastInt("GamepadOpenExperienceControlsMenuThrottleHundrethsPercent", 0)
local engineFeature = game:GetEngineFeature("TelemetryServicePlaySessionInfoEnabled")

local v = {
	eventName = "coreui_gamepad_toggle_exp_controls",
	backends = { "EventIngest" },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 25, 4, 25 },
	description = "Event fired from the client every time Experience Controls Menu is toggled open/closed",
	links = "https://github.rbx.com/Roblox/proto-schemas/pull/5750"
}

return function(flag: boolean)
	if not FFlagLoggingGamepadOpenExpControlsMenu then
		return
	end

	local customFields, standardizedFields

	if engineFeature then
		customFields = { is_toggle_open = tostring(flag) }
		standardizedFields = { "addPlaceId", "addUniverseId", "addPlaySessionId", "addSessionInfo" }
	else
		customFields = {
			is_toggle_open = tostring(flag),
			playsessionid = RbxAnalyticsService:GetPlaySessionId()
		}
		standardizedFields = { "addPlaceId", "addUniverseId", "addSessionInfo" }
	end

	TelemetryService:LogEvent(v, {
		standardizedFields = standardizedFields,
		customFields = customFields
	})
end
