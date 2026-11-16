local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local SduiCoreSystem = require(parent.SduiCoreSystem)
local getSduiClientPageScope = SduiCoreSystem.getSduiClientPageScope
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiActionType = SduiCoreSystem.SduiActionType

local SduiActionParams = SduiCoreSystem.SduiActionParams
local getStringParam = SduiActionParams.getStringParam
local getBooleanParam = SduiActionParams.getBooleanParam

local function SduiSetPageScopeFieldAction(p, _, data, _)
	local actionParams = p and p.actionParams or nil

	if actionParams == nil then
		data.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = SduiActionType.SetPageScopeField, message = "Missing actionParams" },
			data.appPage
		)
		return
	end

	local stringParam = getStringParam(actionParams, "fieldName")

	if stringParam == nil or stringParam == "" then
		data.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = SduiActionType.SetPageScopeField,
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
			SduiErrorType.InvalidActionParams,
			{
				name = SduiActionType.SetPageScopeField,
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
			SduiErrorType.FailedToExecuteAction,
			{
				name = SduiActionType.SetPageScopeField,
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

	local v = sduiClientPageScope.get(stringParam)

	if v == nil or v == "" then
		sduiClientPageScope.set(stringParam, stringParam2)
	end
end

return SduiSetPageScopeFieldAction
