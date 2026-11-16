local refreshHomePage = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Home").refreshHomePage
local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiActionType = SduiCoreSystem.SduiActionType
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

local function reportInvalidActionParams(p2, p3, p4)
	p2.dependencies.logger.reportError(
		sduiErrorType.InvalidActionParams,
		{ name = sduiActionType.RefreshHome, message = p3, propName = p4 },
		p2.appPage
	)
end

local function SduiRefreshHomeAction(p2, p3, p4)
	local actionParams = p2 and p2.actionParams or nil

	local requestIntent = if actionParams then actionParams.requestIntent else nil

	if requestIntent ~= nil and (typeof(requestIntent) ~= "string" or requestIntent == "") then
		local formatted = `Invalid requestIntent: {tostring(requestIntent)}`
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.RefreshHome,
				message = formatted,
				propName = "requestIntent"
			},
			p4.appPage
		)
		requestIntent = nil
	end

	return refreshHomePage(requestIntent)
end

return SduiRefreshHomeAction
