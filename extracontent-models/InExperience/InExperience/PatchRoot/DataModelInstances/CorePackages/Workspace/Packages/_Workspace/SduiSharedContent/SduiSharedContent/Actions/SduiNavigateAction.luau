local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local SduiCoreSystem = require(parent.SduiCoreSystem)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage

local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiActionType = SduiCoreSystem.SduiActionType

local getStringParam = SduiCoreSystem.SduiActionParams.getStringParam

local function SduiNavigateAction(p, _, p2, _)
	local actionParams = p and p.actionParams or nil

	if actionParams == nil then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = SduiActionType.Navigate, message = "Missing actionParams" },
			p2.appPage
		)
		return
	end

	local stringParam = getStringParam(actionParams, "destination")

	if stringParam == nil then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = SduiActionType.Navigate,
				message = "Missing actionParam: destination",
				propName = "destination"
			},
			p2.appPage
		)
		return
	end

	local v = AppPage[stringParam]

	if v == nil then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = SduiActionType.Navigate,
				message = `Unknown destination: {stringParam}`,
				propName = "destination"
			},
			p2.appPage
		)
	else
		p2.dependencies.getNavigation().navigate(v)
	end
end

return SduiNavigateAction
