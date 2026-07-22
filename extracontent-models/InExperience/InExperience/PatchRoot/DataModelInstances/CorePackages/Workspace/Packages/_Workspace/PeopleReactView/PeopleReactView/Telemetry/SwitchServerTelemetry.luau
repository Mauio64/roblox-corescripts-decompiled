local TelemetryService = game:GetService("TelemetryService")
local v2 = game:DefineFastInt("SwitchServerTelemetryThrottleHundrethsPercent", 10000)
local t1 = {
	SwitchServerButtonActions = {
		eventName = "coreui_switch_server_button_actions",
		description = "Event fired every time the User engages with the People tab switch server button",
		links = "https://roblox.atlassian.net/wiki/spaces/APEX/pages/4906123766/Switch+Server+Tech+Spec",
		backends = { "EventIngest" },
		throttlingPercentage = v2,
		lastUpdated = {
			7,
			15,
			26
		}
	},
	SwitchServerConfirmationActions = {
		eventName = "coreui_switch_server_confirmation_actions",
		description = "Event fired every time the User engages with the switch server confirmation screen",
		links = "https://roblox.atlassian.net/wiki/spaces/APEX/pages/4906123766/Switch+Server+Tech+Spec",
		backends = { "EventIngest" },
		throttlingPercentage = v2,
		lastUpdated = {
			7,
			15,
			26
		}
	}
}
local _ = {
	placeId = "addPlaceId",
	universeId = "addUniverseId",
	playsessionId = "addPlaySessionId",
	sessionInfo = "addSessionInfo"
}
local t2 = {}

t2.__index = t2

function t2.sendSwitchServerButtonActions(t3: {[any]: any}) -- line: 57
	-- upvalues: TelemetryService (copy), t1 (copy)
	TelemetryService:LogEvent(t1.SwitchServerButtonActions, {
		standardizedFields = {
			"addPlaceId",
			"addUniverseId",
			"addPlaySessionId",
			"addSessionInfo"
		},
		customFields = t3
	})
end
function t2.sendSwitchServerConfirmationActions(t4: {[any]: any}) -- line: 64
	-- upvalues: TelemetryService (copy), t1 (copy)
	TelemetryService:LogEvent(t1.SwitchServerConfirmationActions, {
		standardizedFields = {
			"addPlaceId",
			"addUniverseId",
			"addPlaySessionId",
			"addSessionInfo"
		},
		customFields = t4
	})
end

return t2
