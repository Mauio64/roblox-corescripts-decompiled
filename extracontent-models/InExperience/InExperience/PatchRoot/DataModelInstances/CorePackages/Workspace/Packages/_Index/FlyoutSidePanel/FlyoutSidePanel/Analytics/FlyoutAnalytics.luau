local LocalizationService = game:GetService("LocalizationService")
local Parent = script:FindFirstAncestor("FlyoutSidePanel").Parent
local LoggingProtocol = require(Parent.LoggingProtocol)
local FlyoutContentSettings = require(script.Parent.Parent.Config.FlyoutContentSettings)
local default = LoggingProtocol.default
local v6 = game:DefineFastFlag("FlyoutRemoveAddSessionInfo", false)
local t1 = {
	eventName = "coreui_flyout_side_panel_open",
	description = "FlyoutSidePanel open event, source can be Home, Chat, or Charts",
	links = "https://roblox.atlassian.net/browse/APPEXP-3739",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("FlyoutSidePanelOpenEventThrottleHunderedthsPercent", 10000),
	lastUpdated = {
		2025,
		10,
		30
	}
}
local t2 = {
	eventName = "coreui_flyout_side_panel_close",
	description = "FlyoutSidePanel close event, source can be click, swipe, or shield",
	links = "https://github.rbx.com/Roblox/proto-schemas/pull/8500",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("FlyoutSidePanelCloseEventThrottleHunderedthsPercent", 10000),
	lastUpdated = {
		2025,
		10,
		30
	}
}
local t3 = {
	eventName = "coreui_flyout_tooltip_show",
	description = "Flyout tooltip show event",
	links = "https://github.rbx.com/Roblox/proto-schemas/pull/9318",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("FlyoutTooltipShowEventThrottleHunderedthsPercent", 10000),
	lastUpdated = {
		2026,
		1,
		21
	}
}
local t4 = {
	eventName = "coreui_flyout_tooltip_dismiss",
	description = "Flyout tooltip dismiss event, source can be click or shield",
	links = "https://github.rbx.com/Roblox/proto-schemas/pull/8500",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("FlyoutTooltipDismissEventThrottleHunderedthsPercent", 10000),
	lastUpdated = {
		2025,
		10,
		30
	}
}
local t5 = {
	eventName = "coreui_flyout_content_item_click",
	description = "FlyoutSidePanel content item click event",
	links = "https://github.rbx.com/Roblox/proto-schemas/pull/8500",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("FlyoutContentItemClickEventThrottleHunderedthsPercent", 10000),
	lastUpdated = {
		2025,
		10,
		30
	}
}

local function checkEventNameMappings(s1: string?) -- line: 64
	-- upvalues: FlyoutContentSettings (copy)
	if s1 and FlyoutContentSettings.EventNameMappings[s1] then
		return FlyoutContentSettings.EventNameMappings[s1]
	end

	return s1 or ""
end
local function logEventHelper(p1, s2: string, t6: {[any]: any}) -- line: 71
	-- upvalues: v6 (copy), FlyoutContentSettings (copy), default (copy)
	local v19 = if not v6 then {
		"addPlaceId",
		"addUniverseId",
		"addPlaceInstanceId",
		"addSessionId",
		"addSessionInfo",
		"addOsInfo"
	} else {
		"addPlaceId",
		"addUniverseId",
		"addPlaceInstanceId",
		"addSessionId",
		"addOsInfo"
	}
	local integrationId = t6.integrationId
	local t7 = {
		integration_id = if not integrationId or not FlyoutContentSettings.EventNameMappings[integrationId] then integrationId or "" else FlyoutContentSettings.EventNameMappings[integrationId],
		source = t6.source,
		local_timestamp = os.time(),
		count = t6.count
	}

	default:logRobloxTelemetryEvent(p1, v19, t7, s2)
end
local function sendMoreGridItemClickEvent_legacy(p2, p3, p4, p5) -- line: 111
	p2:setRBXEventStream("moreGridItem", "moreGridItemClick", {
		itemType = p3,
		localUserId = p4,
		url = p5
	})
end

return {
	onFlyoutSidePanelClosed = function(t8: {[any]: any}) -- line: 93
		-- upvalues: logEventHelper (copy), t2 (copy)
		logEventHelper(t2, "flyout_close", t8)
	end,
	onFlyoutTooltipShown = function(t9: {[any]: any}) -- line: 97
		-- upvalues: logEventHelper (copy), t3 (copy)
		logEventHelper(t3, "flyout_tooltip_show", t9)
	end,
	onFlyoutTooltipDismissed = function(t10: {[any]: any}) -- line: 101
		-- upvalues: logEventHelper (copy), t4 (copy)
		logEventHelper(t4, "flyout_tooltip_dismiss", t10)
	end,
	onFlyoutContentItemClicked = function(t11: {[any]: any}) -- line: 105
		-- upvalues: logEventHelper (copy), t5 (copy), t2 (copy)
		logEventHelper(t5, "flyout_item_click", t11)
		logEventHelper(t2, "flyout_close", t11)
	end,
	sendMoreLegacyAndFlyoutItemClickEvent = function(p6, p7, p8, p9) -- line: 119
		-- upvalues: FlyoutContentSettings (copy), logEventHelper (copy), t5 (copy), t2 (copy)
		local v34 = if not p7 or not FlyoutContentSettings.EventNameMappings[p7] then p7 or "" else FlyoutContentSettings.EventNameMappings[p7]
		local t12 = {
			source = "click",
			integrationId = v34
		}

		logEventHelper(t5, "flyout_item_click", t12)
		logEventHelper(t2, "flyout_close", t12)
		p6:setRBXEventStream("moreGridItem", "moreGridItemClick", {
			itemType = v34,
			localUserId = p8,
			url = p9
		})
	end,
	sendPageLoadEvent = function(p10, s3: string?) -- line: 125
		-- upvalues: LocalizationService (copy), logEventHelper (copy), t1 (copy)
		local RobloxLocaleId = LocalizationService.RobloxLocaleId

		p10:setRBXEventStream("AppRouter", "luaPageLoad", {
			page = "more",
			locale = RobloxLocaleId,
			rootPageTitle = s3
		})
		logEventHelper(t1, "flyout_open", {
			source = s3
		})
	end
}
