local parent = script:FindFirstAncestor("ExperienceStoreServerDrivenUi").Parent

local DataHydration = require(parent.DataHydration)

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiActionType = SduiCoreSystem.SduiActionType

local Players = game:GetService("Players")

local function SduiRefreshDeveloperProductsAction(p, _, p2)
	local actionParams = p and p.actionParams

	if actionParams == nil then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = SduiActionType.RefreshDeveloperProducts, message = "Missing actionParams" },
			p2.appPage
		)
		return
	end

	local placeId = actionParams.placeId

	if placeId == nil then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = SduiActionType.RefreshDeveloperProducts, message = "Missing placeId" },
			p2.appPage
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
