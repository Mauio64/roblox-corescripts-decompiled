local v = game:GetService("TelemetryService")

local defineFastInt = game:DefineFastInt("PlayerListContextMenuTelemetryThrottleHundredthsPercent", 10000)

require(script.Parent.PlayerListContextMenuTelemetryAction)

local lastUpdated = { 2026, 8, 4 }

local v2 = {
	eventName = "coreui_playerlist_context_menu_action",
	backends = { "EventIngest" },
	throttlingPercentage = defineFastInt,
	lastUpdated = lastUpdated,
	description = "Fired when the PlayerList contextual menu is opened, closed, or an action row is activated."
}

local v3 = {
	eventName = "coreui_playerlist_context_menu_action",
	backends = { "RobloxTelemetryCounter" },
	throttlingPercentage = defineFastInt,
	lastUpdated = lastUpdated,
	description = "Counter for PlayerList contextual menu open / close / action activations."
}
local PlayerListContextMenuTelemetry = {}

function PlayerListContextMenuTelemetry.logAction(action, p)
	local customFields = { action = action }

	if p ~= nil then
		if p.isSelf ~= nil then
			customFields.is_self = tostring(p.isSelf)
		end

		if p.friendStatus ~= nil then
			customFields.friend_status = p.friendStatus
		end
	end

	local v4 = {
		standardizedFields = {
			"addPlaceId",
			"addUniverseId",
			"addSessionInfo",
			"addSessionId",
			"addPlaySessionId"
		},
		customFields = customFields
	}
	v:LogEvent(v2, v4)
	v:LogCounter(v3, v4, 1)
end

function PlayerListContextMenuTelemetry._setServicesForTesting(p)
	v = p
end

return PlayerListContextMenuTelemetry
