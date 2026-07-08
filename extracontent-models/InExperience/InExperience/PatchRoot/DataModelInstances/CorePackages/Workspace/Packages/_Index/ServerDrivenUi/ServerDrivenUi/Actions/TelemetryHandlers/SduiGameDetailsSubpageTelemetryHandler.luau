local Players = game:GetService("Players")
local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local DiscoveryAnalytics = require(Parent.DiscoveryAnalytics)
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local getActionTelemetryFieldValue = SduiCoreSystem.getActionTelemetryFieldValue
local gameDetailsSubpage = DiscoveryAnalytics.Events.gameDetailsSubpage
local FFlagLuaAppAddUniverseIdToGameDetailsEvents = require(Parent.SharedFlags).FFlagLuaAppAddUniverseIdToGameDetailsEvents

return function(p1, p2, p3) -- line: 21
	-- upvalues: getActionTelemetryFieldValue (copy), SduiErrorType (copy), FFlagLuaAppAddUniverseIdToGameDetailsEvents (copy), gameDetailsSubpage (copy), Players (copy)
	local v12 = getActionTelemetryFieldValue(p1, p2, "subpage")
	local v13 = getActionTelemetryFieldValue(p1, p2, "universeId")
	local v14 = getActionTelemetryFieldValue(p1, p2, "placeId")
	local v15 = getActionTelemetryFieldValue(p1, p2, "eventContext") or "GameInfoRow"
	local v16 = getActionTelemetryFieldValue(p1, p2, "ctx") or v15
	local v17 = getActionTelemetryFieldValue(p1, p2, "action")

	if typeof(v12) ~= "string" or v12 == "" then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			name = "SduiGameDetailsSubpageTelemetryHandler",
			message = "Missing or non-string `subpage` (server must set this on analyticsData or actionParams)",
			propName = "subpage"
		}, p3.appPage)

		return
	end

	local v18 = typeof(v14)

	if v18 ~= "string" and v18 ~= "number" or v14 == "" then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			name = "SduiGameDetailsSubpageTelemetryHandler",
			propName = "placeId",
			message = `Invalid placeId (expected string or number, got { v18 })`
		}, p3.appPage)

		return
	end

	if FFlagLuaAppAddUniverseIdToGameDetailsEvents then
		local v19 = typeof(v13)

		if v19 ~= "string" and v19 ~= "number" or v13 == "" then
			p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
				name = "SduiGameDetailsSubpageTelemetryHandler",
				propName = "universeId",
				message = `Invalid universeId (expected string or number, got { v19 })`
			}, p3.appPage)

			return
		end
	end

	gameDetailsSubpage({
		uid = tostring(not Players.LocalPlayer and "" or Players.LocalPlayer.UserId),
		placeId = tostring(v14),
		subpage = v12,
		universeId = not FFlagLuaAppAddUniverseIdToGameDetailsEvents and "" or tostring(v13),
		action = v17,
		ctx = v16
	}, v15)
end
