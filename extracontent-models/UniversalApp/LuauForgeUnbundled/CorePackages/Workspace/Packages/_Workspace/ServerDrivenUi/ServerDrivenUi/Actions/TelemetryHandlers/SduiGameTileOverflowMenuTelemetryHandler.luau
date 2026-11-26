local DiscoveryAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DiscoveryAnalytics")
local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local fFlagSduiGameTileDirectAction = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSduiGameTileDirectAction

local findAnalyticsFieldInAncestors = SduiCoreSystem.findAnalyticsFieldInAncestors
local gameTileOverflowMenuAction = DiscoveryAnalytics.Events.gameTileOverflowMenuAction
local getActionTelemetryFieldValue = SduiCoreSystem.getActionTelemetryFieldValue

local function SduiGameTileOverflowMenuTelemetryHandler(p2, p3, p4)
	local actionTelemetryFieldValue = getActionTelemetryFieldValue(p2, p3, "menuItemId")

	if typeof(actionTelemetryFieldValue) ~= "string" or actionTelemetryFieldValue == "" then
		return
	end

	local actionTelemetryFieldValue2 = getActionTelemetryFieldValue(p2, p3, "universeId")
	local actionTelemetryFieldValue3 = getActionTelemetryFieldValue(p2, p3, "collectionId")

	local actionTelemetryFieldValue4 = getActionTelemetryFieldValue(
		p2,
		p3,
		"availableMenuItemIds",
		actionTelemetryFieldValue
	)
	local v5

	if fFlagSduiGameTileDirectAction then
		v5 = findAnalyticsFieldInAncestors("isDirectAction", p3)
	end

	local appPage = p4.appPage or "Unknown"

	if typeof(actionTelemetryFieldValue4) ~= "string" then
		actionTelemetryFieldValue4 = nil
	end

	if typeof(v5) ~= "boolean" then
		v5 = nil
	end

	gameTileOverflowMenuAction({
		universeId = actionTelemetryFieldValue2,
		sortId = actionTelemetryFieldValue3,
		actionType = "GameTileOverflowMenuItemActivated",
		menuItem = actionTelemetryFieldValue,
		availableMenuItems = actionTelemetryFieldValue4,
		isDirectAction = v5
	}, appPage)
end

return SduiGameTileOverflowMenuTelemetryHandler
