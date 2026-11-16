local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiActionType = SduiCoreSystem.SduiActionType
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

local centralOverlayType = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RobloxAppEnums").CentralOverlayType
local setCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/CentralOverlay").Actions.SetCentralOverlay

local function SduiOpenSduiOverlayAction(p2, p3, p4)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{ name = sduiActionType.OpenSduiOverlay, message = "Missing actionParams" },
			p4.appPage
		)
		return
	end

	assert(actionParams, "actionParams must exist")
	local configKey = actionParams.configKey
	local identifier = actionParams.identifier

	if not configKey then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenSduiOverlay,
				message = "Missing configKey in action params"
			},
			p4.appPage
		)
	elseif identifier then
		p4.dependencies.dispatch(setCentralOverlay(centralOverlayType.SduiOverlay, {
			configKey = configKey,
			identifier = identifier,
			appPage = p4.appPage
		}))
	else
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenSduiOverlay,
				message = "Missing identifier in action params"
			},
			p4.appPage
		)
	end
end

return SduiOpenSduiOverlayAction
