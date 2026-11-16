local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/ExperienceStoreServerDrivenUi/DataHydration")

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ExperienceStoreServerDrivenUi/SduiCoreSystem")
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local sduiActionType = SduiCoreSystem.SduiActionType

local Players = game:GetService("Players")

local function SduiRefreshDeveloperProductsAction(p2, p3, p4)
	local actionParams = p2 and p2.actionParams

	if actionParams == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.RefreshDeveloperProducts,
				message = "Missing actionParams"
			},
			p4.appPage
		)
		return
	end

	local placeId = actionParams.placeId

	if placeId == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.RefreshDeveloperProducts,
				message = "Missing placeId"
			},
			p4.appPage
		)
		return
	end

	local localPlayer = Players.LocalPlayer
	local userId = localPlayer and localPlayer.UserId

	if userId == nil then
		return
	end

	DataHydration.Game.getGameDeveloperProductStore(false).fetchStatuses(tostring(userId), (tostring(placeId)))
end

return SduiRefreshDeveloperProductsAction
