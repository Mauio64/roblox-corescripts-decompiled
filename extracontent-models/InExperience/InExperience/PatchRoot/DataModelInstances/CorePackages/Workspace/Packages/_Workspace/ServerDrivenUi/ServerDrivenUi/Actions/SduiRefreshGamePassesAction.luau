local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local DataHydration = require(parent.DataHydration)

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiActionType = SduiCoreSystem.SduiActionType

local function SduiRefreshGamePassesAction(p, _, p2)
	local actionParams = p and p.actionParams or nil

	if actionParams == nil then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = SduiActionType.RefreshGamePasses, message = "Missing actionParams" },
			p2.appPage
		)
		return
	end

	local universeId = actionParams.universeId

	if universeId then
		DataHydration.Game.getGamePassStore(false).fetchPassesForUniverse(universeId)
	end
end

return SduiRefreshGamePassesAction
