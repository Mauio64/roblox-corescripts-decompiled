local LocalizationService = game:GetService("LocalizationService")

local parent = script:FindFirstAncestor("FlyoutSidePanel").Parent
local LoggingProtocol = require(parent.LoggingProtocol)

local FlyoutContentSettings = require(script.Parent.Parent.Config.FlyoutContentSettings)

local default = LoggingProtocol.default

local defineFastFlag = game:DefineFastFlag("FlyoutRemoveAddSessionInfo", false)

local v = {
	eventName = "coreui_flyout_side_panel_open",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("FlyoutSidePanelOpenEventThrottleHunderedthsPercent", 10000),
	lastUpdated = { 2025, 10, 30 },
	description = "FlyoutSidePanel open event, source can be Home, Chat, or Charts",
	links = "https://roblox.atlassian.net/browse/APPEXP-3739"
}

local v2 = {
	eventName = "coreui_flyout_side_panel_close",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("FlyoutSidePanelCloseEventThrottleHunderedthsPercent", 10000),
	lastUpdated = { 2025, 10, 30 },
	description = "FlyoutSidePanel close event, source can be click, swipe, or shield",
	links = "https://github.rbx.com/Roblox/proto-schemas/pull/8500"
}

local v3 = {
	eventName = "coreui_flyout_tooltip_show",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("FlyoutTooltipShowEventThrottleHunderedthsPercent", 10000),
	lastUpdated = { 2026, 1, 21 },
	description = "Flyout tooltip show event",
	links = "https://github.rbx.com/Roblox/proto-schemas/pull/9318"
}

local v4 = {
	eventName = "coreui_flyout_tooltip_dismiss",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("FlyoutTooltipDismissEventThrottleHunderedthsPercent", 10000),
	lastUpdated = { 2025, 10, 30 },
	description = "Flyout tooltip dismiss event, source can be click or shield",
	links = "https://github.rbx.com/Roblox/proto-schemas/pull/8500"
}

local v5 = {
	eventName = "coreui_flyout_content_item_click",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("FlyoutContentItemClickEventThrottleHunderedthsPercent", 10000),
	lastUpdated = { 2025, 10, 30 },
	description = "FlyoutSidePanel content item click event",
	links = "https://github.rbx.com/Roblox/proto-schemas/pull/8500"
}

local v6 = {
	eventName = "coreui_flyout_content_item_impression",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("FlyoutContentItemImpressionEventThrottleHunderedthsPercent", 10000),
	lastUpdated = { 2026, 9, 3 },
	description = "FlyoutSidePanel content item impression event",
	links = "https://roblox.atlassian.net/browse/MKTUJ-5174"
}

local v7 = {
	eventName = "coreui_flyout_switch_account_click",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("FlyoutSwitchAccountClickEventThrottleHunderedthsPercent", 10000),
	lastUpdated = { 2026, 11, 5 },
	description = "Flyout switch account click",
	links = ""
}

local function checkEventNameMappings(value: string?) -- 2 equivalent calls inferred from this helper
	if value and FlyoutContentSettings.EventNameMappings[value] then
		return FlyoutContentSettings.EventNameMappings[value]
	end

	return value or ""
end

local function logEventHelper(p, p2: string, data)
	default:logRobloxTelemetryEvent(
		p,
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
			integration_id = checkEventNameMappings(data.integrationId), -- inferred equivalent call
			source = data.source,
			local_timestamp = os.time(),
			count = data.count
		},
		p2
	)
end

local function onFlyoutSidePanelClosed(p) -- 1 equivalent call inferred from this helper
	logEventHelper(v2, "flyout_close", p)
end

local function onFlyoutContentItemClicked(p) -- 1 equivalent call inferred from this helper
	logEventHelper(v5, "flyout_item_click", p)
	onFlyoutSidePanelClosed(p) -- inferred equivalent call
end

local function sendMoreGridItemClickEvent_legacy(object, itemType, localUserId, url) -- 1 equivalent call inferred from this helper
	object:setRBXEventStream("moreGridItem", "moreGridItemClick", {
		itemType = itemType,
		localUserId = localUserId,
		url = url
	})
end

local FlyoutAnalytics = {}
FlyoutAnalytics.onFlyoutSidePanelClosed = onFlyoutSidePanelClosed

function FlyoutAnalytics.onFlyoutTooltipShown(p)
	logEventHelper(v3, "flyout_tooltip_show", p)
end

function FlyoutAnalytics.onFlyoutTooltipDismissed(p)
	logEventHelper(v4, "flyout_tooltip_dismiss", p)
end

FlyoutAnalytics.onFlyoutContentItemClicked = onFlyoutContentItemClicked

function FlyoutAnalytics.onFlyoutContentItemImpressed(p)
	logEventHelper(v6, "flyout_item_impression", p)
end

function FlyoutAnalytics.onFlyoutSwitchAccountClicked(p)
	logEventHelper(v7, "flyout_switch_account_click", p)
end

function FlyoutAnalytics.sendMoreLegacyAndFlyoutItemClickEvent(object, value, localUserId, url)
	local integrationId = checkEventNameMappings(value) -- inferred equivalent call
	onFlyoutContentItemClicked({ integrationId = integrationId, source = "click" }) -- inferred equivalent call
	sendMoreGridItemClickEvent_legacy(object, integrationId, localUserId, url) -- inferred equivalent call
end

function FlyoutAnalytics.sendPageLoadEvent(object, p: string?)
	object:setRBXEventStream("AppRouter", "luaPageLoad", {
		locale = LocalizationService.RobloxLocaleId,
		page = "more",
		rootPageTitle = p
	})
	logEventHelper(v, "flyout_open", { source = p })
end

return FlyoutAnalytics
