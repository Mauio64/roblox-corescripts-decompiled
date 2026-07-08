local TelemetryService = game:GetService("TelemetryService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local ParentParent = script.Parent.Parent
local FFlagLoggingGamepadOpenExpControlsMenu = require(ParentParent.Flags.FFlagLoggingGamepadOpenExpControlsMenu)
local v5 = game:DefineFastInt("GamepadOpenExperienceControlsMenuThrottleHundrethsPercent", 0)
local EngineFeature = game:GetEngineFeature("TelemetryServicePlaySessionInfoEnabled")
local t1 = {
	eventName = "coreui_gamepad_toggle_exp_controls",
	description = "Event fired from the client every time Experience Controls Menu is toggled open/closed",
	links = "https://github.rbx.com/Roblox/proto-schemas/pull/5750",
	backends = { "EventIngest" },
	throttlingPercentage = v5,
	lastUpdated = {
		25,
		4,
		25
	}
}

return function(b1: boolean) -- line: 24
	-- upvalues: FFlagLoggingGamepadOpenExpControlsMenu (copy), EngineFeature (copy), RbxAnalyticsService (copy), TelemetryService (copy), t1 (copy)
	if not FFlagLoggingGamepadOpenExpControlsMenu then
		return
	end

	local t2, t3

	if EngineFeature then
		t2 = {
			"addPlaceId",
			"addUniverseId",
			"addPlaySessionId",
			"addSessionInfo"
		}
		t3 = {
			is_toggle_open = tostring(b1)
		}
	else
		t2 = {
			"addPlaceId",
			"addUniverseId",
			"addSessionInfo"
		}
		t3 = {
			is_toggle_open = tostring(b1),
			playsessionid = RbxAnalyticsService:GetPlaySessionId()
		}
	end

	TelemetryService:LogEvent(t1, {
		standardizedFields = t2,
		customFields = t3
	})
end
