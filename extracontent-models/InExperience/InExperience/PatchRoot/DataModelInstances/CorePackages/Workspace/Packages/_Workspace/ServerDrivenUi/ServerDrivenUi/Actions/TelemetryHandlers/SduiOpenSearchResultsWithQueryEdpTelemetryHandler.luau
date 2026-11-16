local Players = game:GetService("Players")
local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local parent = ServerDrivenUi.Parent

local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local gameDetailsSubpage = DiscoveryAnalytics.Events.gameDetailsSubpage

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local getActionTelemetryFieldValue = SduiCoreSystem.getActionTelemetryFieldValue

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppAddUniverseIdToGameDetailsEvents = SharedFlags.FFlagLuaAppAddUniverseIdToGameDetailsEvents

local openSearchResultsWithQueryParams = require(ServerDrivenUi.Actions.openSearchResultsWithQueryParams)

local SduiOpenSearchResultsWithQueryTelemetryHandler = require(ServerDrivenUi.Actions.TelemetryHandlers.SduiOpenSearchResultsWithQueryTelemetryHandler)

return function(p, p2, p3)
	local searchQuery = openSearchResultsWithQueryParams.resolveSearchQuery(p)
	local searchType = openSearchResultsWithQueryParams.resolveSearchType(p)

	if searchQuery == nil or searchType == nil then
		return
	end

	local actionTelemetryFieldValue = getActionTelemetryFieldValue(p, p2, "subpage")
	local v = getActionTelemetryFieldValue(p, p2, "universeId")
	local v2 = getActionTelemetryFieldValue(p, p2, "placeId")
	local v3 = getActionTelemetryFieldValue(p, p2, "eventContext")

	if typeof(v3) ~= "string" or v3 == "" then
		p3.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = "SduiOpenSearchResultsWithQueryEdpTelemetryHandler",
				message = "Missing or non-string `eventContext` (set on analyticsData for EDP subpage taps)",
				propName = "eventContext"
			},
			p3.appPage
		)
		v3 = ""
	end

	if typeof(actionTelemetryFieldValue) ~= "string" or actionTelemetryFieldValue == "" then
		p3.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = "SduiOpenSearchResultsWithQueryEdpTelemetryHandler",
				message = "Missing or non-string `subpage` (set on analyticsData for EDP subpage taps)",
				propName = "subpage"
			},
			p3.appPage
		)
		return
	end

	if typeof(v2) ~= "string" and typeof(v2) ~= "number" or v2 == "" then
		p3.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = "SduiOpenSearchResultsWithQueryEdpTelemetryHandler",
				message = `Invalid placeId (expected string or number, got {typeof(v2)})`,
				propName = "placeId"
			},
			p3.appPage
		)
		v2 = ""
	end

	if FFlagLuaAppAddUniverseIdToGameDetailsEvents and (typeof(v) ~= "string" and typeof(v) ~= "number" or v == "") then
		p3.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = "SduiOpenSearchResultsWithQueryEdpTelemetryHandler",
				message = `Invalid universeId (expected string or number, got {typeof(v)})`,
				propName = "universeId"
			},
			p3.appPage
		)
		v = ""
	end

	SduiOpenSearchResultsWithQueryTelemetryHandler(p, p2, p3)

	gameDetailsSubpage({
		uid = tostring(not Players.LocalPlayer and "" or Players.LocalPlayer.UserId),
		placeId = tostring(v2),
		subpage = actionTelemetryFieldValue,
		universeId = not FFlagLuaAppAddUniverseIdToGameDetailsEvents and "" or tostring(v),
		action = searchQuery,
		ctx = "OpenSearchResultsWithQuery"
	}, v3)
end
