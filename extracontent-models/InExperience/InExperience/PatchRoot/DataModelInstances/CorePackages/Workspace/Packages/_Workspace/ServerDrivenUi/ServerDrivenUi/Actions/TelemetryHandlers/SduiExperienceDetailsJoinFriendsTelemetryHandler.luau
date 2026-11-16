local Players = game:GetService("Players")

local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local gameJoinFriendsInGame = DiscoveryAnalytics.Events.gameJoinFriendsInGame

local SduiCoreSystem = require(parent.SduiCoreSystem)
local getActionTelemetryFieldValue = SduiCoreSystem.getActionTelemetryFieldValue
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

local function SduiExperienceDetailsJoinFriendsTelemetryHandler(p, p2, p3)
	local actionTelemetryFieldValue = getActionTelemetryFieldValue(p, p2, "placeId")

	if actionTelemetryFieldValue == nil then
		p3.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ message = "ExperienceDetailsJoinFriends telemetry missing placeId" },
			p3.appPage
		)
		return
	end

	local ctx = getActionTelemetryFieldValue(p, p2, "ctx") or "ExperienceDetailsOverflow"
	local localPlayer = Players.LocalPlayer

	if localPlayer == nil then
		return
	end

	gameJoinFriendsInGame(
		{
			ctx = ctx,
			uid = tostring(localPlayer.UserId),
			placeId = tostring(actionTelemetryFieldValue)
		},
		ctx
	)
end

return SduiExperienceDetailsJoinFriendsTelemetryHandler
