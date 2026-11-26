local TelemetryService = game:GetService("TelemetryService")

local defineFastInt = game:DefineFastInt("TraversalTelemetryThrottleHundrethsPercent", 0)

local v5 = {
	BackButtonActions = {
		eventName = "coreui_inexp_back_button_actions",
		backends = { "EventIngest" },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 22, 10, 25 },
		description = "Event fired every time the User engages with Traversal Back Button",
		links = "https://github.rbx.com/Roblox/proto-schemas/pull/8339"
	},
	HistoryMenuButtonActions = {
		eventName = "coreui_inexp_history_chevron_clicks",
		backends = { "EventIngest" },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 22, 10, 25 },
		description = "Event fired every time the User engages with Traversal History Menu Button",
		links = "https://github.rbx.com/Roblox/proto-schemas/pull/8339"
	},
	HistoryMenuItemClick = {
		eventName = "coreui_inexp_history_dropdown_clicks",
		backends = { "EventIngest" },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 22, 10, 25 },
		description = "Event fired every time the User engages with Traversal History Menu Items",
		links = "https://github.rbx.com/Roblox/proto-schemas/pull/8339"
	},
	HistoryMenuHistoryClick = {
		eventName = "coreui_inexp_history_landing_entrypoint_clicks",
		backends = { "EventIngest" },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 22, 10, 25 },
		description = "Event fired every time the User engages with Traversal History Menu's History Item",
		links = "https://github.rbx.com/Roblox/proto-schemas/pull/8339"
	},
	HistoryPageBackButtonClick = {
		eventName = "coreui_inexp_history_back_clicks",
		backends = { "EventIngest" },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 22, 10, 25 },
		description = "Event fired every time the User engages with Traversal History Page's Back Button",
		links = "https://github.rbx.com/Roblox/proto-schemas/pull/8339"
	},
	HistoryPageExperienceTileClick = {
		eventName = "coreui_inexp_history_landing_tiles_clicks",
		backends = { "EventIngest" },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 22, 10, 25 },
		description = "Event fired every time the User engages with Traversal History Page Tiles",
		links = "https://github.rbx.com/Roblox/proto-schemas/pull/8339"
	},
	TeleportConfirmationActions = {
		eventName = "coreui_inexp_history_leave_page_actions",
		backends = { "EventIngest" },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 22, 10, 25 },
		description = "Event fired every time the User engages with Traversal History Leave Confirmation",
		links = "https://github.rbx.com/Roblox/proto-schemas/pull/8339"
	}
}

local v6 = {
	placeId = "addPlaceId",
	universeId = "addUniverseId",
	playsessionId = "addPlaySessionId"
}

local v7 = {}
v7.__index = v7

function v7.sendBackButtonActionEvent(p2)
	TelemetryService:LogEvent(v5.BackButtonActions, {
		standardizedFields = { "addPlaceId", "addUniverseId", "addPlaySessionId" },
		customFields = p2
	})
end

function v7.sendHistoryMenuButtonActionEvent(p2)
	TelemetryService:LogEvent(v5.HistoryMenuButtonActions, {
		standardizedFields = { "addPlaceId", "addUniverseId", "addPlaySessionId" },
		customFields = p2
	})
end

function v7.sendHistoryMenuItemClick(p2)
	TelemetryService:LogEvent(v5.HistoryMenuItemClick, {
		standardizedFields = { "addPlaceId", "addUniverseId", "addPlaySessionId" },
		customFields = p2
	})
end

function v7.sendHistoryMenuHistoryClick(p2)
	TelemetryService:LogEvent(v5.HistoryMenuHistoryClick, {
		standardizedFields = { "addPlaceId", "addUniverseId", "addPlaySessionId" },
		customFields = p2
	})
end

function v7.sendHistoryPageBackButtonClick(p2)
	TelemetryService:LogEvent(v5.HistoryPageBackButtonClick, {
		standardizedFields = { "addPlaceId", "addUniverseId", "addPlaySessionId" },
		customFields = p2
	})
end

function v7.sendHistoryPageExperienceTileClick(p2)
	TelemetryService:LogEvent(v5.HistoryPageExperienceTileClick, {
		standardizedFields = { "addPlaceId", "addUniverseId", "addPlaySessionId" },
		customFields = p2
	})
end

function v7.sendTeleportConfirmationActions(p2)
	TelemetryService:LogEvent(v5.TeleportConfirmationActions, {
		standardizedFields = { "addPlaceId", "addUniverseId", "addPlaySessionId" },
		customFields = p2
	})
end

return v7
