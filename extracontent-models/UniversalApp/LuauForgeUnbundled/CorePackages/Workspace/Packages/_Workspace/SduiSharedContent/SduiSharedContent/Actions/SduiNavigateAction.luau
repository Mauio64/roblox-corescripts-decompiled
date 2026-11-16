local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCoreSystem")
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/RobloxAppEnums").AppPage

local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local sduiActionType = SduiCoreSystem.SduiActionType

local getStringParam = SduiCoreSystem.SduiActionParams.getStringParam

local function SduiNavigateAction(p2, p3, p4, p5)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{ name = sduiActionType.Navigate, message = "Missing actionParams" },
			p4.appPage
		)
		return
	end

	local stringParam = getStringParam(actionParams, "destination")

	if stringParam == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.Navigate,
				message = "Missing actionParam: destination",
				propName = "destination"
			},
			p4.appPage
		)
		return
	end

	local v5 = appPage[stringParam]

	if v5 == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.Navigate,
				message = `Unknown destination: {stringParam}`,
				propName = "destination"
			},
			p4.appPage
		)
	else
		p4.dependencies.getNavigation().navigate(v5)
	end
end

return SduiNavigateAction
