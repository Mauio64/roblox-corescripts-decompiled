local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local GameDetailRodux = require(parent.GameDetailRodux)
local FetchGamePlayabilityAndProductInfo = GameDetailRodux.FetchGamePlayabilityAndProductInfo
local GamePlayButton = require(parent.GamePlayButton)

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiActionType = SduiCoreSystem.SduiActionType

local function SduiRefreshPlayabilityAction(p, _, p2)
	local actionParams = p and p.actionParams or nil

	if actionParams == nil then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = SduiActionType.RefreshPlayability, message = "Missing actionParams" },
			p2.appPage
		)
		return
	end

	local universeId = actionParams.universeId

	if universeId == nil or GamePlayButton.Flags.GetFFlagLuaAppFetchPlayabilityKillSwitch() then
		return
	end

	local networking = p2.dependencies.networking

	if networking == nil then
		p2.dependencies.logger.reportError(
			SduiErrorType.GetNilDependencies,
			{
				message = "RefreshPlayability requires networking dependency",
				name = SduiActionType.RefreshPlayability
			},
			p2.appPage
		)
	else
		p2.dependencies.dispatch(FetchGamePlayabilityAndProductInfo.Fetch(networking, universeId))
	end
end

return SduiRefreshPlayabilityAction
