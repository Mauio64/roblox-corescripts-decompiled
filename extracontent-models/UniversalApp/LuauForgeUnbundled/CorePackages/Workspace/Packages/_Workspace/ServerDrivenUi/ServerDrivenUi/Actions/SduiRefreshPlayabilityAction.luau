local fetchGamePlayabilityAndProductInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/GameDetailRodux").FetchGamePlayabilityAndProductInfo
local GamePlayButton = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/GamePlayButton")

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local sduiActionType = SduiCoreSystem.SduiActionType

local function SduiRefreshPlayabilityAction(p2, p3, p4)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.RefreshPlayability,
				message = "Missing actionParams"
			},
			p4.appPage
		)
		return
	end

	local universeId = actionParams.universeId

	if universeId == nil or GamePlayButton.Flags.GetFFlagLuaAppFetchPlayabilityKillSwitch() then
		return
	end

	local networking = p4.dependencies.networking

	if networking == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.GetNilDependencies,
			{
				message = "RefreshPlayability requires networking dependency",
				name = sduiActionType.RefreshPlayability
			},
			p4.appPage
		)
	else
		p4.dependencies.dispatch(fetchGamePlayabilityAndProductInfo.Fetch(networking, universeId))
	end
end

return SduiRefreshPlayabilityAction
