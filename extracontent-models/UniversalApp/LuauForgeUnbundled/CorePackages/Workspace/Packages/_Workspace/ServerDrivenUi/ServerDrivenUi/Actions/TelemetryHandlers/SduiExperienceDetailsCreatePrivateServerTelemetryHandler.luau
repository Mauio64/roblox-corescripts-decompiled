local Players = game:GetService("Players")

local gameCreatePrivateGame = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DiscoveryAnalytics").Events.gameCreatePrivateGame

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local getActionTelemetryFieldValue = SduiCoreSystem.getActionTelemetryFieldValue
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

local function SduiExperienceDetailsCreatePrivateServerTelemetryHandler(p2, p3, p4)
	local actionTelemetryFieldValue = getActionTelemetryFieldValue(p2, p3, "placeId")

	if actionTelemetryFieldValue == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				message = "ExperienceDetailsCreatePrivateServer telemetry missing placeId"
			},
			p4.appPage
		)
		return
	end

	local v5 = getActionTelemetryFieldValue(p2, p3, "ctx") or "ExperienceDetailsOverflow"
	local localPlayer = Players.LocalPlayer

	if localPlayer == nil then
		return
	end

	gameCreatePrivateGame(
		{
			ctx = v5,
			uid = tostring(localPlayer.UserId),
			placeId = tostring(actionTelemetryFieldValue)
		},
		v5
	)
end

return SduiExperienceDetailsCreatePrivateServerTelemetryHandler
