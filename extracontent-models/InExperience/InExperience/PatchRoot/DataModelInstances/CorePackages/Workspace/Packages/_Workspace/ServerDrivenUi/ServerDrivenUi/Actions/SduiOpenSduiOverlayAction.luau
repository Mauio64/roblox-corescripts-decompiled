local parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

local RobloxAppEnums = require(parent.RobloxAppEnums)
local CentralOverlayType = RobloxAppEnums.CentralOverlayType
local CentralOverlay = require(parent.CentralOverlay)
local SetCentralOverlay = CentralOverlay.Actions.SetCentralOverlay

local function SduiOpenSduiOverlayAction(p, _, p2)
	local actionParams = p and p.actionParams or nil

	if actionParams == nil then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = SduiActionType.OpenSduiOverlay, message = "Missing actionParams" },
			p2.appPage
		)
		return
	end

	assert(actionParams, "actionParams must exist")
	local configKey = actionParams.configKey
	local identifier = actionParams.identifier

	if not configKey then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = SduiActionType.OpenSduiOverlay,
				message = "Missing configKey in action params"
			},
			p2.appPage
		)
	elseif identifier then
		p2.dependencies.dispatch(SetCentralOverlay(CentralOverlayType.SduiOverlay, {
			configKey = configKey,
			identifier = identifier,
			appPage = p2.appPage
		}))
	else
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = SduiActionType.OpenSduiOverlay,
				message = "Missing identifier in action params"
			},
			p2.appPage
		)
	end
end

return SduiOpenSduiOverlayAction
