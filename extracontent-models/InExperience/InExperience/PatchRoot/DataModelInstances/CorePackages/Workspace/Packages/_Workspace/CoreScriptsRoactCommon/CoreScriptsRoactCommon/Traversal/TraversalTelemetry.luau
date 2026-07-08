local TelemetryService = game:GetService("TelemetryService")
local v2 = game:DefineFastInt("TraversalTelemetryThrottleHundrethsPercent", 0)
local t1 = {
	BackButtonActions = {
		eventName = "coreui_inexp_back_button_actions",
		description = "Event fired every time the User engages with Traversal Back Button",
		links = "https://github.rbx.com/Roblox/proto-schemas/pull/8339",
		backends = { "EventIngest" },
		throttlingPercentage = v2,
		lastUpdated = {
			22,
			10,
			25
		}
	},
	HistoryMenuButtonActions = {
		eventName = "coreui_inexp_history_chevron_clicks",
		description = "Event fired every time the User engages with Traversal History Menu Button",
		links = "https://github.rbx.com/Roblox/proto-schemas/pull/8339",
		backends = { "EventIngest" },
		throttlingPercentage = v2,
		lastUpdated = {
			22,
			10,
			25
		}
	},
	HistoryMenuItemClick = {
		eventName = "coreui_inexp_history_dropdown_clicks",
		description = "Event fired every time the User engages with Traversal History Menu Items",
		links = "https://github.rbx.com/Roblox/proto-schemas/pull/8339",
		backends = { "EventIngest" },
		throttlingPercentage = v2,
		lastUpdated = {
			22,
			10,
			25
		}
	},
	HistoryMenuHistoryClick = {
		eventName = "coreui_inexp_history_landing_entrypoint_clicks",
		description = "Event fired every time the User engages with Traversal History Menu's History Item",
		links = "https://github.rbx.com/Roblox/proto-schemas/pull/8339",
		backends = { "EventIngest" },
		throttlingPercentage = v2,
		lastUpdated = {
			22,
			10,
			25
		}
	},
	HistoryPageBackButtonClick = {
		eventName = "coreui_inexp_history_back_clicks",
		description = "Event fired every time the User engages with Traversal History Page's Back Button",
		links = "https://github.rbx.com/Roblox/proto-schemas/pull/8339",
		backends = { "EventIngest" },
		throttlingPercentage = v2,
		lastUpdated = {
			22,
			10,
			25
		}
	},
	HistoryPageExperienceTileClick = {
		eventName = "coreui_inexp_history_landing_tiles_clicks",
		description = "Event fired every time the User engages with Traversal History Page Tiles",
		links = "https://github.rbx.com/Roblox/proto-schemas/pull/8339",
		backends = { "EventIngest" },
		throttlingPercentage = v2,
		lastUpdated = {
			22,
			10,
			25
		}
	},
	TeleportConfirmationActions = {
		eventName = "coreui_inexp_history_leave_page_actions",
		description = "Event fired every time the User engages with Traversal History Leave Confirmation",
		links = "https://github.rbx.com/Roblox/proto-schemas/pull/8339",
		backends = { "EventIngest" },
		throttlingPercentage = v2,
		lastUpdated = {
			22,
			10,
			25
		}
	}
}
local _ = {
	placeId = "addPlaceId",
	universeId = "addUniverseId",
	playsessionId = "addPlaySessionId"
}
local t2 = {}

t2.__index = t2

function t2.sendBackButtonActionEvent(t3: {[any]: any}) -- line: 142
	-- upvalues: TelemetryService (copy), t1 (copy)
	TelemetryService:LogEvent(t1.BackButtonActions, {
		standardizedFields = {
			"addPlaceId",
			"addUniverseId",
			"addPlaySessionId"
		},
		customFields = t3
	})
end
function t2.sendHistoryMenuButtonActionEvent(t4: {[any]: any}) -- line: 149
	-- upvalues: TelemetryService (copy), t1 (copy)
	TelemetryService:LogEvent(t1.HistoryMenuButtonActions, {
		standardizedFields = {
			"addPlaceId",
			"addUniverseId",
			"addPlaySessionId"
		},
		customFields = t4
	})
end
function t2.sendHistoryMenuItemClick(t5: {[any]: any}) -- line: 156
	-- upvalues: TelemetryService (copy), t1 (copy)
	TelemetryService:LogEvent(t1.HistoryMenuItemClick, {
		standardizedFields = {
			"addPlaceId",
			"addUniverseId",
			"addPlaySessionId"
		},
		customFields = t5
	})
end
function t2.sendHistoryMenuHistoryClick(t6: {[any]: any}) -- line: 163
	-- upvalues: TelemetryService (copy), t1 (copy)
	TelemetryService:LogEvent(t1.HistoryMenuHistoryClick, {
		standardizedFields = {
			"addPlaceId",
			"addUniverseId",
			"addPlaySessionId"
		},
		customFields = t6
	})
end
function t2.sendHistoryPageBackButtonClick(t7: {[any]: any}) -- line: 170
	-- upvalues: TelemetryService (copy), t1 (copy)
	TelemetryService:LogEvent(t1.HistoryPageBackButtonClick, {
		standardizedFields = {
			"addPlaceId",
			"addUniverseId",
			"addPlaySessionId"
		},
		customFields = t7
	})
end
function t2.sendHistoryPageExperienceTileClick(t8: {[any]: any}) -- line: 177
	-- upvalues: TelemetryService (copy), t1 (copy)
	TelemetryService:LogEvent(t1.HistoryPageExperienceTileClick, {
		standardizedFields = {
			"addPlaceId",
			"addUniverseId",
			"addPlaySessionId"
		},
		customFields = t8
	})
end
function t2.sendTeleportConfirmationActions(t9: {[any]: any}) -- line: 184
	-- upvalues: TelemetryService (copy), t1 (copy)
	TelemetryService:LogEvent(t1.TeleportConfirmationActions, {
		standardizedFields = {
			"addPlaceId",
			"addUniverseId",
			"addPlaySessionId"
		},
		customFields = t9
	})
end

return t2
