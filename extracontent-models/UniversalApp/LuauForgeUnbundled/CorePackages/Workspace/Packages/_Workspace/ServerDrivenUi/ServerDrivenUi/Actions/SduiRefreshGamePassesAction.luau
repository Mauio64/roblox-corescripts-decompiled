local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DataHydration")

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local sduiActionType = SduiCoreSystem.SduiActionType

local function SduiRefreshGamePassesAction(p2, p3, p4)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.RefreshGamePasses,
				message = "Missing actionParams"
			},
			p4.appPage
		)
		return
	end

	local universeId = actionParams.universeId

	if universeId then
		DataHydration.Game.getGamePassStore(false).fetchPassesForUniverse(universeId)
	end
end

return SduiRefreshGamePassesAction
