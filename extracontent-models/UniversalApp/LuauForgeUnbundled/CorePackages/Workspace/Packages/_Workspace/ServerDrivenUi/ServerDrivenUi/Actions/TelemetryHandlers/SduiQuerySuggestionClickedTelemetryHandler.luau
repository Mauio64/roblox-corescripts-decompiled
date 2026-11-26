local querySuggestionClicked = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DiscoveryAnalytics").Events.querySuggestionClicked

local getActionTelemetryFieldValue = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem").getActionTelemetryFieldValue

local openSearchResultsWithQueryParams = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/openSearchResultsWithQueryParams")

return function(p2, p3, p4)
	local v5 = getActionTelemetryFieldValue(p2, p3, "queryText") or openSearchResultsWithQueryParams.resolveSearchQuery(p2)

	if typeof(v5) ~= "string" or v5 == "" then
		return
	end

	local actionTelemetryFieldValue = getActionTelemetryFieldValue(p2, p3, "itemPosition")
	local actionTelemetryFieldValue2 = getActionTelemetryFieldValue(p2, p3, "collectionPosition")
	local actionTelemetryFieldValue3 = getActionTelemetryFieldValue(p2, p3, "collectionId")

	local appPage = p4.appPage

	if typeof(actionTelemetryFieldValue) ~= "number" then
		actionTelemetryFieldValue = nil
	end

	local v7 = {
		pos = actionTelemetryFieldValue,
		sortPos = tonumber(actionTelemetryFieldValue2),
		sortId = 0,
		queryText = 0,
		componentType = "Pill"
	}
	local v8 = if actionTelemetryFieldValue3 ~= nil then tostring(actionTelemetryFieldValue3) else nil
	v7.sortId = v8
	v7.queryText = v5
	querySuggestionClicked(appPage, v7)
end
