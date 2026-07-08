local Players = game:GetService("Players")
local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local gameJoinFriendsInGame = require(Parent.DiscoveryAnalytics).Events.gameJoinFriendsInGame
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local getActionTelemetryFieldValue = SduiCoreSystem.getActionTelemetryFieldValue
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

local function SduiExperienceDetailsJoinFriendsTelemetryHandler(p1, p2, p3) -- line: 19
	-- upvalues: getActionTelemetryFieldValue (copy), SduiErrorType (copy), Players (copy), gameJoinFriendsInGame (copy)
	local v11 = getActionTelemetryFieldValue(p1, p2, "placeId")

	if v11 == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "ExperienceDetailsJoinFriends telemetry missing placeId"
		}, p3.appPage)

		return
	end

	local v12 = getActionTelemetryFieldValue(p1, p2, "ctx") or "ExperienceDetailsOverflow"
	local LocalPlayer = Players.LocalPlayer

	if LocalPlayer == nil then
		return
	end

	gameJoinFriendsInGame({
		ctx = v12,
		uid = tostring(LocalPlayer.UserId),
		placeId = tostring(v11)
	}, v12)
end

return SduiExperienceDetailsJoinFriendsTelemetryHandler
