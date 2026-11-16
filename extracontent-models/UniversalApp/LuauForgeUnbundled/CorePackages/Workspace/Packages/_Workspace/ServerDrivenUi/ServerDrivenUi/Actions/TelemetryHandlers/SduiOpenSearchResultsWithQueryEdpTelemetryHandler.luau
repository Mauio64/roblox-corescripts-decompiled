local Players = game:GetService("Players")

local gameDetailsSubpage = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DiscoveryAnalytics").Events.gameDetailsSubpage

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local getActionTelemetryFieldValue = SduiCoreSystem.getActionTelemetryFieldValue

local fFlagLuaAppAddUniverseIdToGameDetailsEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppAddUniverseIdToGameDetailsEvents

local openSearchResultsWithQueryParams = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/openSearchResultsWithQueryParams")

local SduiOpenSearchResultsWithQueryTelemetryHandler = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/TelemetryHandlers/SduiOpenSearchResultsWithQueryTelemetryHandler")

return function(p2, p3, p4)
	local searchQuery = openSearchResultsWithQueryParams.resolveSearchQuery(p2)
	local searchType = openSearchResultsWithQueryParams.resolveSearchType(p2)

	if searchQuery == nil or searchType == nil then
		return
	end

	local actionTelemetryFieldValue = getActionTelemetryFieldValue(p2, p3, "subpage")
	local v5 = getActionTelemetryFieldValue(p2, p3, "universeId")
	local v6 = getActionTelemetryFieldValue(p2, p3, "placeId")
	local v7 = getActionTelemetryFieldValue(p2, p3, "eventContext")

	if typeof(v7) ~= "string" or v7 == "" then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = "SduiOpenSearchResultsWithQueryEdpTelemetryHandler",
				message = "Missing or non-string `eventContext` (set on analyticsData for EDP subpage taps)",
				propName = "eventContext"
			},
			p4.appPage
		)
		v7 = ""
	end

	if typeof(actionTelemetryFieldValue) ~= "string" or actionTelemetryFieldValue == "" then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = "SduiOpenSearchResultsWithQueryEdpTelemetryHandler",
				message = "Missing or non-string `subpage` (set on analyticsData for EDP subpage taps)",
				propName = "subpage"
			},
			p4.appPage
		)
		return
	end

	if typeof(v6) ~= "string" and typeof(v6) ~= "number" or v6 == "" then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = "SduiOpenSearchResultsWithQueryEdpTelemetryHandler",
				message = `Invalid placeId (expected string or number, got {typeof(v6)})`,
				propName = "placeId"
			},
			p4.appPage
		)
		v6 = ""
	end

	if
		fFlagLuaAppAddUniverseIdToGameDetailsEvents
		and (typeof(v5) ~= "string" and typeof(v5) ~= "number" or v5 == "")
	then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = "SduiOpenSearchResultsWithQueryEdpTelemetryHandler",
				message = `Invalid universeId (expected string or number, got {typeof(v5)})`,
				propName = "universeId"
			},
			p4.appPage
		)
		v5 = ""
	end

	SduiOpenSearchResultsWithQueryTelemetryHandler(p2, p3, p4)

	gameDetailsSubpage({
		uid = tostring(not Players.LocalPlayer and "" or Players.LocalPlayer.UserId),
		placeId = tostring(v6),
		subpage = actionTelemetryFieldValue,
		universeId = not fFlagLuaAppAddUniverseIdToGameDetailsEvents and "" or tostring(v5),
		action = searchQuery,
		ctx = "OpenSearchResultsWithQuery"
	}, v7)
end
