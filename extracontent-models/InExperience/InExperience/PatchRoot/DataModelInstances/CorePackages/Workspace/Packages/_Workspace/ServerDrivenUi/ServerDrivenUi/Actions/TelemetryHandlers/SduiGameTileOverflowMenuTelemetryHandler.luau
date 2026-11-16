local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local SduiCoreSystem = require(parent.SduiCoreSystem)
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiGameTileDirectAction = SharedFlags.FFlagSduiGameTileDirectAction

local findAnalyticsFieldInAncestors = SduiCoreSystem.findAnalyticsFieldInAncestors
local gameTileOverflowMenuAction = DiscoveryAnalytics.Events.gameTileOverflowMenuAction
local getActionTelemetryFieldValue = SduiCoreSystem.getActionTelemetryFieldValue

local function SduiGameTileOverflowMenuTelemetryHandler(p, p2, p3)
	local actionTelemetryFieldValue = getActionTelemetryFieldValue(p, p2, "menuItemId")

	if typeof(actionTelemetryFieldValue) ~= "string" or actionTelemetryFieldValue == "" then
		return
	end

	local actionTelemetryFieldValue2 = getActionTelemetryFieldValue(p, p2, "universeId")
	local actionTelemetryFieldValue3 = getActionTelemetryFieldValue(p, p2, "collectionId")

	local actionTelemetryFieldValue4 = getActionTelemetryFieldValue(
		p,
		p2,
		"availableMenuItemIds",
		actionTelemetryFieldValue
	)
	local isDirectAction

	if FFlagSduiGameTileDirectAction then
		isDirectAction = findAnalyticsFieldInAncestors("isDirectAction", p2)
	end

	local appPage = p3.appPage or "Unknown"

	if typeof(actionTelemetryFieldValue4) ~= "string" then
		actionTelemetryFieldValue4 = nil
	end

	if typeof(isDirectAction) ~= "boolean" then
		isDirectAction = nil
	end

	gameTileOverflowMenuAction({
		universeId = actionTelemetryFieldValue2,
		sortId = actionTelemetryFieldValue3,
		actionType = "GameTileOverflowMenuItemActivated",
		menuItem = actionTelemetryFieldValue,
		availableMenuItems = actionTelemetryFieldValue4,
		isDirectAction = isDirectAction
	}, appPage)
end

return SduiGameTileOverflowMenuTelemetryHandler
