local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local ServerDrivenUiParent = ServerDrivenUi.Parent
local SduiCoreSystem = require(ServerDrivenUiParent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local OpenSearchResultsWithQueryBridge = require(ServerDrivenUiParent.ServerDrivenUi).OpenSearchResultsWithQueryBridge
local openSearchResultsWithQueryParams = require(ServerDrivenUi.Actions.openSearchResultsWithQueryParams)

local function reportInvalidParam(p1, s1: string, s2: string?) -- line: 24
	-- upvalues: SduiErrorType (copy), SduiActionType (copy)
	p1.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
		name = SduiActionType.OpenSearchResultsWithQuery,
		message = s1,
		propName = s2
	}, p1.appPage)
end
local function SduiOpenSearchResultsWithQueryAction(p2, _, p4, _) -- line: 32
	-- upvalues: openSearchResultsWithQueryParams (copy), SduiErrorType (copy), SduiActionType (copy), OpenSearchResultsWithQueryBridge (copy)
	local v17 = openSearchResultsWithQueryParams.resolveSearchQuery(p2)

	if v17 == nil then
		p4.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Invalid or missing searchQuery",
			propName = "searchQuery",
			name = SduiActionType.OpenSearchResultsWithQuery
		}, p4.appPage)

		return
	end

	local v18 = openSearchResultsWithQueryParams.resolveSearchType(p2)

	if v18 == nil then
		p4.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Invalid, unknown, or unsupported searchType",
			propName = "searchType",
			name = SduiActionType.OpenSearchResultsWithQuery
		}, p4.appPage)

		return
	end

	OpenSearchResultsWithQueryBridge.run(v17, v18)
end

return SduiOpenSearchResultsWithQueryAction
