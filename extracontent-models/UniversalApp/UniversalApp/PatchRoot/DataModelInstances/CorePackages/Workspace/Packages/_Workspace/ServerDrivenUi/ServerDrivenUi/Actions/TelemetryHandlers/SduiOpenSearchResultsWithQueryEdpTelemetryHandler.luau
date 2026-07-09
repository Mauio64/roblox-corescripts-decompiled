local Players = game:GetService("Players")
local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local ServerDrivenUiParent = ServerDrivenUi.Parent
local gameDetailsSubpage = require(ServerDrivenUiParent.DiscoveryAnalytics).Events.gameDetailsSubpage
local SduiCoreSystem = require(ServerDrivenUiParent.SduiCoreSystem)
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local getActionTelemetryFieldValue = SduiCoreSystem.getActionTelemetryFieldValue
local FFlagLuaAppAddUniverseIdToGameDetailsEvents = require(ServerDrivenUiParent.SharedFlags).FFlagLuaAppAddUniverseIdToGameDetailsEvents
local openSearchResultsWithQueryParams = require(ServerDrivenUi.Actions.openSearchResultsWithQueryParams)
local SduiOpenSearchResultsWithQueryTelemetryHandler = require(ServerDrivenUi.Actions.TelemetryHandlers.SduiOpenSearchResultsWithQueryTelemetryHandler)

return function(p1, p2, p3) -- line: 31
	-- upvalues: openSearchResultsWithQueryParams (copy), getActionTelemetryFieldValue (copy), SduiErrorType (copy), FFlagLuaAppAddUniverseIdToGameDetailsEvents (copy), SduiOpenSearchResultsWithQueryTelemetryHandler (copy), gameDetailsSubpage (copy), Players (copy)
	local v14 = openSearchResultsWithQueryParams.resolveSearchQuery(p1)
	local v15 = openSearchResultsWithQueryParams.resolveSearchType(p1)

	if v14 == nil or v15 == nil then
		return
	end

	local v16 = getActionTelemetryFieldValue(p1, p2, "subpage")
	local v17 = getActionTelemetryFieldValue(p1, p2, "universeId")
	local v18 = getActionTelemetryFieldValue(p1, p2, "placeId")
	local v19 = getActionTelemetryFieldValue(p1, p2, "eventContext")

	if typeof(v19) == "string" and v19 ~= "" then
	else
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			name = "SduiOpenSearchResultsWithQueryEdpTelemetryHandler",
			message = "Missing or non-string `eventContext` (set on analyticsData for EDP subpage taps)",
			propName = "eventContext"
		}, p3.appPage)
		v19 = ""
	end

	if typeof(v16) ~= "string" or v16 == "" then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			name = "SduiOpenSearchResultsWithQueryEdpTelemetryHandler",
			message = "Missing or non-string `subpage` (set on analyticsData for EDP subpage taps)",
			propName = "subpage"
		}, p3.appPage)

		return
	end

	if typeof(v18) ~= "string" and typeof(v18) ~= "number" or v18 == "" then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			name = "SduiOpenSearchResultsWithQueryEdpTelemetryHandler",
			propName = "placeId",
			message = `Invalid placeId (expected string or number, got { typeof(v18) })`
		}, p3.appPage)
		v18 = ""
	end

	if FFlagLuaAppAddUniverseIdToGameDetailsEvents and (typeof(v17) ~= "string" and typeof(v17) ~= "number" or v17 == "") then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			name = "SduiOpenSearchResultsWithQueryEdpTelemetryHandler",
			propName = "universeId",
			message = `Invalid universeId (expected string or number, got { typeof(v17) })`
		}, p3.appPage)
		v17 = ""
	end

	SduiOpenSearchResultsWithQueryTelemetryHandler(p1, p2, p3)
	gameDetailsSubpage({
		ctx = "OpenSearchResultsWithQuery",
		uid = tostring(not Players.LocalPlayer and "" or Players.LocalPlayer.UserId),
		placeId = tostring(v18),
		subpage = v16,
		universeId = not FFlagLuaAppAddUniverseIdToGameDetailsEvents and "" or tostring(v17),
		action = v14
	}, v19)
end
