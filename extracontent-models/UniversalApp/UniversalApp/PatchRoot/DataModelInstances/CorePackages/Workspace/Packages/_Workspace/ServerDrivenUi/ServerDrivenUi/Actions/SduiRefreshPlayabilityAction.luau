local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local FetchGamePlayabilityAndProductInfo = require(Parent.GameDetailRodux).FetchGamePlayabilityAndProductInfo
local GamePlayButton = require(Parent.GamePlayButton)
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiActionType = SduiCoreSystem.SduiActionType

local function SduiRefreshPlayabilityAction(p1, _, p3) -- line: 15
	-- upvalues: SduiErrorType (copy), SduiActionType (copy), GamePlayButton (copy), FetchGamePlayabilityAndProductInfo (copy)
	local v11 = p1 and p1.actionParams or nil

	if v11 == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing actionParams",
			name = SduiActionType.RefreshPlayability
		}, p3.appPage)

		return
	end

	local universeId = v11.universeId

	if universeId == nil then
		return
	end

	if GamePlayButton.Flags.GetFFlagLuaAppFetchPlayabilityKillSwitch() then
		return
	end

	local networking = p3.dependencies.networking

	if networking == nil then
		p3.dependencies.logger.reportError(SduiErrorType.GetNilDependencies, {
			message = "RefreshPlayability requires networking dependency",
			name = SduiActionType.RefreshPlayability
		}, p3.appPage)

		return
	end

	p3.dependencies.dispatch(FetchGamePlayabilityAndProductInfo.Fetch(networking, universeId))
end

return SduiRefreshPlayabilityAction
