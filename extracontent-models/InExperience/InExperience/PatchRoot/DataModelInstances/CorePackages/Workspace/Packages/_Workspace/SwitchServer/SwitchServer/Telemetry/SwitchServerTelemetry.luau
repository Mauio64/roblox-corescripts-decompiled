local TelemetryService = game:GetService("TelemetryService")

local defineFastInt = game:DefineFastInt("SwitchServerTelemetryThrottleHundrethsPercent", 10000)

local v = {
	SwitchServerButtonActions = {
		eventName = "coreui_switch_server_button_actions",
		backends = { "EventIngest" },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 7, 15, 26 },
		description = "Event fired every time the User engages with the People tab switch server button",
		links = "https://roblox.atlassian.net/wiki/spaces/APEX/pages/4906123766/Switch+Server+Tech+Spec"
	},
	SwitchServerConfirmationActions = {
		eventName = "coreui_switch_server_confirmation_actions",
		backends = { "EventIngest" },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 7, 15, 26 },
		description = "Event fired every time the User engages with the switch server confirmation screen",
		links = "https://roblox.atlassian.net/wiki/spaces/APEX/pages/4906123766/Switch+Server+Tech+Spec"
	}
}

local _ = {
	placeId = "addPlaceId",
	universeId = "addUniverseId",
	playsessionId = "addPlaySessionId",
	sessionInfo = "addSessionInfo"
}

local SwitchServerTelemetry = {}
SwitchServerTelemetry.__index = SwitchServerTelemetry

function SwitchServerTelemetry.sendSwitchServerButtonActions(customFields)
	TelemetryService:LogEvent(v.SwitchServerButtonActions, {
		standardizedFields = { "addPlaceId", "addUniverseId", "addPlaySessionId", "addSessionInfo" },
		customFields = customFields
	})
end

function SwitchServerTelemetry.sendSwitchServerConfirmationActions(customFields)
	TelemetryService:LogEvent(v.SwitchServerConfirmationActions, {
		standardizedFields = { "addPlaceId", "addUniverseId", "addPlaySessionId", "addSessionInfo" },
		customFields = customFields
	})
end

return SwitchServerTelemetry
