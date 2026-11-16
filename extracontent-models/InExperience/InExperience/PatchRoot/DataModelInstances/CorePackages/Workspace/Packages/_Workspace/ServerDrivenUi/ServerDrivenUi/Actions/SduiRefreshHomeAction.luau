local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local Home = require(parent.Home)
local refreshHomePage = Home.refreshHomePage
local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

local function reportInvalidActionParams(p, message: string, propName: string?) -- 1 equivalent call inferred from this helper
	p.dependencies.logger.reportError(
		SduiErrorType.InvalidActionParams,
		{ name = SduiActionType.RefreshHome, message = message, propName = propName },
		p.appPage
	)
end

local function SduiRefreshHomeAction(p, _, p2)
	local actionParams = p and p.actionParams or nil
	local requestIntent

	if actionParams then
		requestIntent = actionParams.requestIntent
	end

	if requestIntent ~= nil and (typeof(requestIntent) ~= "string" or requestIntent == "") then
		reportInvalidActionParams(p2, `Invalid requestIntent: {tostring(requestIntent)}`, "requestIntent") -- inferred equivalent call
		requestIntent = nil
	end

	return refreshHomePage(requestIntent)
end

return SduiRefreshHomeAction
