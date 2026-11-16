local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiActionType = SduiCoreSystem.SduiActionType
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

local openSearchResultsWithQueryBridge = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi").OpenSearchResultsWithQueryBridge
local openSearchResultsWithQueryParams = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/openSearchResultsWithQueryParams")
local fFlagLuaAppSduiSearchAutocomplete = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppSduiSearchAutocomplete
local isAutocompleteSelectionFresh = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/isAutocompleteSelectionFresh")
local getActionTelemetryFieldValue = SduiCoreSystem.getActionTelemetryFieldValue

local function reportInvalidParam(p2, p3, p4)
	p2.dependencies.logger.reportError(
		sduiErrorType.InvalidActionParams,
		{
			name = sduiActionType.OpenSearchResultsWithQuery,
			message = p3,
			propName = p4
		},
		p2.appPage
	)
end

local function SduiOpenSearchResultsWithQueryAction(p2, p3, data, p4)
	local searchQuery = openSearchResultsWithQueryParams.resolveSearchQuery(p2)

	if searchQuery == nil then
		data.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenSearchResultsWithQuery,
				message = "Invalid or missing searchQuery",
				propName = "searchQuery"
			},
			data.appPage
		)

		return
	end

	local searchType = openSearchResultsWithQueryParams.resolveSearchType(p2)

	if searchType == nil then
		data.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenSearchResultsWithQuery,
				message = "Invalid, unknown, or unsupported searchType",
				propName = "searchType"
			},
			data.appPage
		)

		return
	end

	if not (fFlagLuaAppSduiSearchAutocomplete and openSearchResultsWithQueryParams.resolveIsAutocompleteSuggestion(p2)) then
		openSearchResultsWithQueryBridge.run(searchQuery, searchType)
		return
	end

	local actionTelemetryFieldValue = getActionTelemetryFieldValue(p2, p3, "prefix")
	local actionTelemetryFieldValue2 = getActionTelemetryFieldValue(p2, p3, "position")

	if
		typeof(actionTelemetryFieldValue) ~= "string"
		or typeof(actionTelemetryFieldValue2) ~= "number"
		or not isAutocompleteSelectionFresh(data.configKey, actionTelemetryFieldValue, actionTelemetryFieldValue2, searchQuery)
	then
		return
	end

	openSearchResultsWithQueryBridge.run(searchQuery, searchType, true, data.configKey)
end

return SduiOpenSearchResultsWithQueryAction
