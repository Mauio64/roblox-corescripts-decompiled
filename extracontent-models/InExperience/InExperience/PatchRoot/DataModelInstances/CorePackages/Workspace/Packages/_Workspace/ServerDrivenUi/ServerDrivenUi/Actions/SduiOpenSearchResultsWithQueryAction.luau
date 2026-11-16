local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local parent = ServerDrivenUi.Parent

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

local ServerDrivenUi2 = require(parent.ServerDrivenUi)
local OpenSearchResultsWithQueryBridge = ServerDrivenUi2.OpenSearchResultsWithQueryBridge
local openSearchResultsWithQueryParams = require(ServerDrivenUi.Actions.openSearchResultsWithQueryParams)
local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppSduiSearchAutocomplete = SharedFlags.FFlagLuaAppSduiSearchAutocomplete
local isAutocompleteSelectionFresh = require(ServerDrivenUi.Actions.isAutocompleteSelectionFresh)
local getActionTelemetryFieldValue = SduiCoreSystem.getActionTelemetryFieldValue

local function reportInvalidParam(p, message: string, propName: string?) -- 2 equivalent calls inferred from this helper
	p.dependencies.logger.reportError(
		SduiErrorType.InvalidActionParams,
		{ name = SduiActionType.OpenSearchResultsWithQuery, message = message, propName = propName },
		p.appPage
	)
end

local function SduiOpenSearchResultsWithQueryAction(p, p2, p3, _)
	local searchQuery = openSearchResultsWithQueryParams.resolveSearchQuery(p)

	if searchQuery == nil then
		reportInvalidParam(p3, "Invalid or missing searchQuery", "searchQuery") -- inferred equivalent call
		return
	end

	local searchType = openSearchResultsWithQueryParams.resolveSearchType(p)

	if searchType == nil then
		reportInvalidParam(p3, "Invalid, unknown, or unsupported searchType", "searchType") -- inferred equivalent call
		return
	end

	if not (FFlagLuaAppSduiSearchAutocomplete and openSearchResultsWithQueryParams.resolveIsAutocompleteSuggestion(p)) then
		OpenSearchResultsWithQueryBridge.run(searchQuery, searchType)
		return
	end

	local actionTelemetryFieldValue = getActionTelemetryFieldValue(p, p2, "prefix")
	local actionTelemetryFieldValue2 = getActionTelemetryFieldValue(p, p2, "position")

	if
		typeof(actionTelemetryFieldValue) ~= "string"
		or typeof(actionTelemetryFieldValue2) ~= "number"
		or not isAutocompleteSelectionFresh(
			p3.configKey,
			actionTelemetryFieldValue,
			actionTelemetryFieldValue2,
			searchQuery
		)
	then
		return
	end

	OpenSearchResultsWithQueryBridge.run(searchQuery, searchType, true, p3.configKey)
end

return SduiOpenSearchResultsWithQueryAction
