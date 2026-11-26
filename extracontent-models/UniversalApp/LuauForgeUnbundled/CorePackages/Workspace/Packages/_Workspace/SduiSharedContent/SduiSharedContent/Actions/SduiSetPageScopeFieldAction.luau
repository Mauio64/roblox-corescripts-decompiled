local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCoreSystem")
local getSduiClientPageScope = SduiCoreSystem.getSduiClientPageScope
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local sduiActionType = SduiCoreSystem.SduiActionType

local sduiActionParams = SduiCoreSystem.SduiActionParams
local getStringParam = sduiActionParams.getStringParam
local getBooleanParam = sduiActionParams.getBooleanParam

local function SduiSetPageScopeFieldAction(p2, p3, data, p4)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		data.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.SetPageScopeField,
				message = "Missing actionParams"
			},
			data.appPage
		)
		return
	end

	local stringParam = getStringParam(actionParams, "fieldName")

	if stringParam == nil or stringParam == "" then
		data.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.SetPageScopeField,
				message = "Missing actionParam: fieldName",
				propName = "fieldName"
			},
			data.appPage
		)
		return
	end

	local stringParam2 = getStringParam(actionParams, "value")

	if stringParam2 == nil and actionParams.value ~= nil then
		data.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.SetPageScopeField,
				message = "actionParam value must be a string",
				propName = "value"
			},
			data.appPage
		)
		return
	end

	local configKey = data.configKey

	if configKey == nil then
		data.dependencies.logger.reportError(
			sduiErrorType.FailedToExecuteAction,
			{
				name = sduiActionType.SetPageScopeField,
				message = "Missing sduiContext.configKey; no client page scope to write to"
			},
			data.appPage
		)
		return
	end

	local sduiClientPageScope = getSduiClientPageScope(configKey)

	if not getBooleanParam(actionParams, "setIfUnset", false) then
		sduiClientPageScope.set(stringParam, stringParam2)
		return
	end

	local v5 = sduiClientPageScope.get(stringParam)

	if v5 == nil or v5 == "" then
		sduiClientPageScope.set(stringParam, stringParam2)
	end
end

return SduiSetPageScopeFieldAction
