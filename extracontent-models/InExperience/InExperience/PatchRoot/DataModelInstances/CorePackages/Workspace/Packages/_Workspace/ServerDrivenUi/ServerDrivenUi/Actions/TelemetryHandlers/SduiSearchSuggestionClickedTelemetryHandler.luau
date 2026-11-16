local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local parent = ServerDrivenUi.Parent

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local getActionTelemetryFieldValue = SduiCoreSystem.getActionTelemetryFieldValue
local isAutocompleteSelectionFresh = require(ServerDrivenUi.Actions.isAutocompleteSelectionFresh)
local OpenSearchResultsWithQueryBridge = require(ServerDrivenUi.System.OpenSearchResultsWithQueryBridge)

local function SduiSearchSuggestionClickedTelemetryHandler(p, p2, data)
	local actionTelemetryFieldValue = getActionTelemetryFieldValue(p, p2, "prefix")
	local actionTelemetryFieldValue2 = getActionTelemetryFieldValue(p, p2, "searchQuery")
	local actionTelemetryFieldValue3 = getActionTelemetryFieldValue(p, p2, "position")

	if
		typeof(data.configKey) ~= "string"
		or typeof(actionTelemetryFieldValue) ~= "string"
		or typeof(actionTelemetryFieldValue2) ~= "string"
		or typeof(actionTelemetryFieldValue3) ~= "number"
	then
		data.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = "SearchSuggestionClickedTelemetryHandler",
				message = "Expected string configKey, prefix and searchQuery and numeric position"
			},
			data.appPage
		)
		return
	end

	if not isAutocompleteSelectionFresh(
		data.configKey,
		actionTelemetryFieldValue,
		actionTelemetryFieldValue3,
		actionTelemetryFieldValue2
	) then
		return
	end

	OpenSearchResultsWithQueryBridge.runSuggestionClicked(
		data.configKey,
		actionTelemetryFieldValue,
		actionTelemetryFieldValue2,
		actionTelemetryFieldValue3
	)
end

return SduiSearchSuggestionClickedTelemetryHandler
