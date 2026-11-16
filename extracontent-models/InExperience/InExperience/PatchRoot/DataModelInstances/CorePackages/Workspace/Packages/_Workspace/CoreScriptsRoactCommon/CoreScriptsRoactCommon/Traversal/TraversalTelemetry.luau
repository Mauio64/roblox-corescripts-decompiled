local TelemetryService = game:GetService("TelemetryService")

local defineFastInt = game:DefineFastInt("TraversalTelemetryThrottleHundrethsPercent", 0)

local v = {
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

local _ = {
	placeId = "addPlaceId",
	universeId = "addUniverseId",
	playsessionId = "addPlaySessionId"
}

local TraversalTelemetry = {}
TraversalTelemetry.__index = TraversalTelemetry

function TraversalTelemetry.sendBackButtonActionEvent(customFields)
	TelemetryService:LogEvent(v.BackButtonActions, {
		standardizedFields = { "addPlaceId", "addUniverseId", "addPlaySessionId" },
		customFields = customFields
	})
end

function TraversalTelemetry.sendHistoryMenuButtonActionEvent(customFields)
	TelemetryService:LogEvent(v.HistoryMenuButtonActions, {
		standardizedFields = { "addPlaceId", "addUniverseId", "addPlaySessionId" },
		customFields = customFields
	})
end

function TraversalTelemetry.sendHistoryMenuItemClick(customFields)
	TelemetryService:LogEvent(v.HistoryMenuItemClick, {
		standardizedFields = { "addPlaceId", "addUniverseId", "addPlaySessionId" },
		customFields = customFields
	})
end

function TraversalTelemetry.sendHistoryMenuHistoryClick(customFields)
	TelemetryService:LogEvent(v.HistoryMenuHistoryClick, {
		standardizedFields = { "addPlaceId", "addUniverseId", "addPlaySessionId" },
		customFields = customFields
	})
end

function TraversalTelemetry.sendHistoryPageBackButtonClick(customFields)
	TelemetryService:LogEvent(v.HistoryPageBackButtonClick, {
		standardizedFields = { "addPlaceId", "addUniverseId", "addPlaySessionId" },
		customFields = customFields
	})
end

function TraversalTelemetry.sendHistoryPageExperienceTileClick(customFields)
	TelemetryService:LogEvent(v.HistoryPageExperienceTileClick, {
		standardizedFields = { "addPlaceId", "addUniverseId", "addPlaySessionId" },
		customFields = customFields
	})
end

function TraversalTelemetry.sendTeleportConfirmationActions(customFields)
	TelemetryService:LogEvent(v.TeleportConfirmationActions, {
		standardizedFields = { "addPlaceId", "addUniverseId", "addPlaySessionId" },
		customFields = customFields
	})
end

return TraversalTelemetry
