local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local getActionTelemetryFieldValue = SduiCoreSystem.getActionTelemetryFieldValue
local isAutocompleteSelectionFresh = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/isAutocompleteSelectionFresh")
local OpenSearchResultsWithQueryBridge = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/System/OpenSearchResultsWithQueryBridge")

local function SduiSearchSuggestionClickedTelemetryHandler(p2, p3, data)
	local actionTelemetryFieldValue = getActionTelemetryFieldValue(p2, p3, "prefix")
	local actionTelemetryFieldValue2 = getActionTelemetryFieldValue(p2, p3, "searchQuery")
	local actionTelemetryFieldValue3 = getActionTelemetryFieldValue(p2, p3, "position")

	if
		typeof(data.configKey) ~= "string"
		or typeof(actionTelemetryFieldValue) ~= "string"
		or typeof(actionTelemetryFieldValue2) ~= "string"
		or typeof(actionTelemetryFieldValue3) ~= "number"
	then
		data.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
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
