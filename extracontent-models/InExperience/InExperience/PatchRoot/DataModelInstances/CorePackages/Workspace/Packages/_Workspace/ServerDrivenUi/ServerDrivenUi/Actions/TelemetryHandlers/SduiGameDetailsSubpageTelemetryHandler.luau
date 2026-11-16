local Players = game:GetService("Players")
local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local SduiCoreSystem = require(parent.SduiCoreSystem)
local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local getActionTelemetryFieldValue = SduiCoreSystem.getActionTelemetryFieldValue
local gameDetailsSubpage = DiscoveryAnalytics.Events.gameDetailsSubpage

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppAddUniverseIdToGameDetailsEvents = SharedFlags.FFlagLuaAppAddUniverseIdToGameDetailsEvents

return function(p, p2, p3)
	local actionTelemetryFieldValue = getActionTelemetryFieldValue(p, p2, "subpage")
	local actionTelemetryFieldValue2 = getActionTelemetryFieldValue(p, p2, "universeId")
	local actionTelemetryFieldValue3 = getActionTelemetryFieldValue(p, p2, "placeId")
	local v = getActionTelemetryFieldValue(p, p2, "eventContext") or "GameInfoRow"

	local ctx = getActionTelemetryFieldValue(p, p2, "ctx") or v
	local actionTelemetryFieldValue4 = getActionTelemetryFieldValue(p, p2, "action")

	if typeof(actionTelemetryFieldValue) ~= "string" or actionTelemetryFieldValue == "" then
		p3.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = "SduiGameDetailsSubpageTelemetryHandler",
				message = "Missing or non-string `subpage` (server must set this on analyticsData or actionParams)",
				propName = "subpage"
			},
			p3.appPage
		)
		return
	end

	local typeName = typeof(actionTelemetryFieldValue3)

	if typeName ~= "string" and typeName ~= "number" or actionTelemetryFieldValue3 == "" then
		p3.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = "SduiGameDetailsSubpageTelemetryHandler",
				message = `Invalid placeId (expected string or number, got {typeName})`,
				propName = "placeId"
			},
			p3.appPage
		)
		return
	end

	if FFlagLuaAppAddUniverseIdToGameDetailsEvents then
		local typeName2 = typeof(actionTelemetryFieldValue2)

		if typeName2 ~= "string" and typeName2 ~= "number" or actionTelemetryFieldValue2 == "" then
			p3.dependencies.logger.reportError(
				SduiErrorType.InvalidActionParams,
				{
					name = "SduiGameDetailsSubpageTelemetryHandler",
					message = `Invalid universeId (expected string or number, got {typeName2})`,
					propName = "universeId"
				},
				p3.appPage
			)
			return
		end
	end

	gameDetailsSubpage({
		uid = tostring(not Players.LocalPlayer and "" or Players.LocalPlayer.UserId),
		placeId = tostring(actionTelemetryFieldValue3),
		subpage = actionTelemetryFieldValue,
		universeId = not FFlagLuaAppAddUniverseIdToGameDetailsEvents and "" or tostring(actionTelemetryFieldValue2),
		action = actionTelemetryFieldValue4,
		ctx = ctx
	}, v)
end
