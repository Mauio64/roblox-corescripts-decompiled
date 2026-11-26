local LocalizationService = game:GetService("LocalizationService")

local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/LoggingProtocol")

local FlyoutContentSettings = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Config/FlyoutContentSettings")

local default = LoggingProtocol.default

local defineFastFlag = game:DefineFastFlag("FlyoutRemoveAddSessionInfo", false)

local v5 = {
	eventName = "coreui_flyout_side_panel_open",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("FlyoutSidePanelOpenEventThrottleHunderedthsPercent", 10000),
	lastUpdated = { 2025, 10, 30 },
	description = "FlyoutSidePanel open event, source can be Home, Chat, or Charts",
	links = "https://roblox.atlassian.net/browse/APPEXP-3739"
}

local v6 = {
	eventName = "coreui_flyout_side_panel_close",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("FlyoutSidePanelCloseEventThrottleHunderedthsPercent", 10000),
	lastUpdated = { 2025, 10, 30 },
	description = "FlyoutSidePanel close event, source can be click, swipe, or shield",
	links = "https://github.rbx.com/Roblox/proto-schemas/pull/8500"
}

local v7 = {
	eventName = "coreui_flyout_tooltip_show",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("FlyoutTooltipShowEventThrottleHunderedthsPercent", 10000),
	lastUpdated = { 2026, 1, 21 },
	description = "Flyout tooltip show event",
	links = "https://github.rbx.com/Roblox/proto-schemas/pull/9318"
}

local v8 = {
	eventName = "coreui_flyout_tooltip_dismiss",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("FlyoutTooltipDismissEventThrottleHunderedthsPercent", 10000),
	lastUpdated = { 2025, 10, 30 },
	description = "Flyout tooltip dismiss event, source can be click or shield",
	links = "https://github.rbx.com/Roblox/proto-schemas/pull/8500"
}

local v9 = {
	eventName = "coreui_flyout_content_item_click",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt(
		"FlyoutContentItemClickEventThrottleHunderedthsPercent",
		10000
	),
	lastUpdated = { 2025, 10, 30 },
	description = "FlyoutSidePanel content item click event",
	links = "https://github.rbx.com/Roblox/proto-schemas/pull/8500"
}

local v10 = {
	eventName = "coreui_flyout_content_item_impression",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt(
		"FlyoutContentItemImpressionEventThrottleHunderedthsPercent",
		10000
	),
	lastUpdated = { 2026, 9, 3 },
	description = "FlyoutSidePanel content item impression event",
	links = "https://roblox.atlassian.net/browse/MKTUJ-5174"
}

local v11 = {
	eventName = "coreui_flyout_switch_account_click",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt(
		"FlyoutSwitchAccountClickEventThrottleHunderedthsPercent",
		10000
	),
	lastUpdated = { 2026, 11, 5 },
	description = "Flyout switch account click",
	links = ""
}

local function checkEventNameMappings(value)
	if value and FlyoutContentSettings.EventNameMappings[value] then
		return FlyoutContentSettings.EventNameMappings[value]
	end

	return value or ""
end

local function logEventHelper(p2, p3, data)
	local integrationId = data.integrationId
	default:logRobloxTelemetryEvent(
		p2,
		defineFastFlag and {
			"addPlaceId",
			"addUniverseId",
			"addPlaceInstanceId",
			"addSessionId",
			"addOsInfo"
		} or {
			"addPlaceId",
			"addUniverseId",
			"addPlaceInstanceId",
			"addSessionId",
			"addSessionInfo",
			"addOsInfo"
		},
		{
			integration_id = not (integrationId and FlyoutContentSettings.EventNameMappings[integrationId]) and (integrationId or "") or FlyoutContentSettings.EventNameMappings[integrationId],
			source = data.source,
			local_timestamp = os.time(),
			count = data.count
		},
		p3
	)
end

local function sendMoreGridItemClickEvent_legacy(object, p2, p3, p4)
	object:setRBXEventStream("moreGridItem", "moreGridItemClick", {
		itemType = p2,
		localUserId = p3,
		url = p4
	})
end

return {
	onFlyoutSidePanelClosed = function(p2)
		logEventHelper(v6, "flyout_close", p2)
	end,
	onFlyoutTooltipShown = function(p2)
		logEventHelper(v7, "flyout_tooltip_show", p2)
	end,
	onFlyoutTooltipDismissed = function(p2)
		logEventHelper(v8, "flyout_tooltip_dismiss", p2)
	end,
	onFlyoutContentItemClicked = function(p2)
		logEventHelper(v9, "flyout_item_click", p2)
		logEventHelper(v6, "flyout_close", p2)
	end,
	onFlyoutContentItemImpressed = function(p2)
		logEventHelper(v10, "flyout_item_impression", p2)
	end,
	onFlyoutSwitchAccountClicked = function(p2)
		logEventHelper(v11, "flyout_switch_account_click", p2)
	end,
	sendMoreLegacyAndFlyoutItemClickEvent = function(object, value, p2, p3)
		local v12 = not (value and FlyoutContentSettings.EventNameMappings[value]) and (value or "")
			or FlyoutContentSettings.EventNameMappings[value]

		local v13 = { integrationId = v12, source = "click" }
		logEventHelper(v9, "flyout_item_click", v13)
		logEventHelper(v6, "flyout_close", v13)

		object:setRBXEventStream("moreGridItem", "moreGridItemClick", {
			itemType = v12,
			localUserId = p2,
			url = p3
		})
	end,
	sendPageLoadEvent = function(object, p2)
		object:setRBXEventStream("AppRouter", "luaPageLoad", {
			locale = LocalizationService.RobloxLocaleId,
			page = "more",
			rootPageTitle = p2
		})
		logEventHelper(v5, "flyout_open", { source = p2 })
	end
}
