local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local parent = ServerDrivenUi.Parent

local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local querySuggestionClicked = DiscoveryAnalytics.Events.querySuggestionClicked

local SduiCoreSystem = require(parent.SduiCoreSystem)
local getActionTelemetryFieldValue = SduiCoreSystem.getActionTelemetryFieldValue

local openSearchResultsWithQueryParams = require(ServerDrivenUi.Actions.openSearchResultsWithQueryParams)

return function(p, p2, p3)
	local queryText = getActionTelemetryFieldValue(p, p2, "queryText")
		or openSearchResultsWithQueryParams.resolveSearchQuery(p)

	if typeof(queryText) ~= "string" or queryText == "" then
		return
	end

	local actionTelemetryFieldValue = getActionTelemetryFieldValue(p, p2, "itemPosition")
	local actionTelemetryFieldValue2 = getActionTelemetryFieldValue(p, p2, "collectionPosition")
	local actionTelemetryFieldValue3 = getActionTelemetryFieldValue(p, p2, "collectionId")

	local appPage = p3.appPage

	if typeof(actionTelemetryFieldValue) ~= "number" then
		actionTelemetryFieldValue = nil
	end

	local v = {
		pos = actionTelemetryFieldValue,
		sortPos = tonumber(actionTelemetryFieldValue2),
		sortId = 0,
		queryText = 0,
		componentType = "Pill"
	}
	local sortId

	if actionTelemetryFieldValue3 ~= nil then
		sortId = tostring(actionTelemetryFieldValue3)
	end

	v.sortId = sortId
	v.queryText = queryText
	querySuggestionClicked(appPage, v)
end
