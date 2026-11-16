local Players = game:GetService("Players")

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local DiscoveryAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DiscoveryAnalytics")
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local getActionTelemetryFieldValue = SduiCoreSystem.getActionTelemetryFieldValue
local gameDetailsSubpage = DiscoveryAnalytics.Events.gameDetailsSubpage

local fFlagLuaAppAddUniverseIdToGameDetailsEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppAddUniverseIdToGameDetailsEvents

return function(p2, p3, p4)
	local actionTelemetryFieldValue = getActionTelemetryFieldValue(p2, p3, "subpage")
	local actionTelemetryFieldValue2 = getActionTelemetryFieldValue(p2, p3, "universeId")
	local actionTelemetryFieldValue3 = getActionTelemetryFieldValue(p2, p3, "placeId")
	local v5 = getActionTelemetryFieldValue(p2, p3, "eventContext") or "GameInfoRow"

	local v6 = getActionTelemetryFieldValue(p2, p3, "ctx") or v5
	local actionTelemetryFieldValue4 = getActionTelemetryFieldValue(p2, p3, "action")

	if typeof(actionTelemetryFieldValue) ~= "string" or actionTelemetryFieldValue == "" then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = "SduiGameDetailsSubpageTelemetryHandler",
				message = "Missing or non-string `subpage` (server must set this on analyticsData or actionParams)",
				propName = "subpage"
			},
			p4.appPage
		)
		return
	end

	local typeName = typeof(actionTelemetryFieldValue3)

	if typeName ~= "string" and typeName ~= "number" or actionTelemetryFieldValue3 == "" then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = "SduiGameDetailsSubpageTelemetryHandler",
				message = `Invalid placeId (expected string or number, got {typeName})`,
				propName = "placeId"
			},
			p4.appPage
		)
		return
	end

	if fFlagLuaAppAddUniverseIdToGameDetailsEvents then
		local typeName2 = typeof(actionTelemetryFieldValue2)

		if typeName2 ~= "string" and typeName2 ~= "number" or actionTelemetryFieldValue2 == "" then
			p4.dependencies.logger.reportError(
				sduiErrorType.InvalidActionParams,
				{
					name = "SduiGameDetailsSubpageTelemetryHandler",
					message = `Invalid universeId (expected string or number, got {typeName2})`,
					propName = "universeId"
				},
				p4.appPage
			)
			return
		end
	end

	gameDetailsSubpage({
		uid = tostring(not Players.LocalPlayer and "" or Players.LocalPlayer.UserId),
		placeId = tostring(actionTelemetryFieldValue3),
		subpage = actionTelemetryFieldValue,
		universeId = not fFlagLuaAppAddUniverseIdToGameDetailsEvents and "" or tostring(actionTelemetryFieldValue2),
		action = actionTelemetryFieldValue4,
		ctx = v6
	}, v5)
end
