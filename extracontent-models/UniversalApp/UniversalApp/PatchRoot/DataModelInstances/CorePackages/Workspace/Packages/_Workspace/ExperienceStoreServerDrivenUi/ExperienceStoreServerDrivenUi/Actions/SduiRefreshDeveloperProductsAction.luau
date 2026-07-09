local Parent = script:FindFirstAncestor("ExperienceStoreServerDrivenUi").Parent
local DataHydration = require(Parent.DataHydration)
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiActionType = SduiCoreSystem.SduiActionType
local Players = game:GetService("Players")

local function SduiRefreshDeveloperProductsAction(p1, _, p3) -- line: 16
	-- upvalues: SduiErrorType (copy), SduiActionType (copy), Players (copy), DataHydration (copy)
	local v11 = p1 and p1.actionParams

	if v11 == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing actionParams",
			name = SduiActionType.RefreshDeveloperProducts
		}, p3.appPage)

		return
	end

	local placeId = v11.placeId

	if placeId == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing placeId",
			name = SduiActionType.RefreshDeveloperProducts
		}, p3.appPage)

		return
	end

	local LocalPlayer = Players.LocalPlayer
	local v14 = LocalPlayer and LocalPlayer.UserId

	if v14 == nil then
		return
	end

	DataHydration.Game.getGameDeveloperProductStore(false).fetchStatuses(tostring(v14), (tostring(placeId)))
end

return SduiRefreshDeveloperProductsAction
