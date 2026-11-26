local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCoreSystem")
local ToastRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/ToastRodux")

local setCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage
local toastType = ToastRodux.Enums.ToastType

local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local sduiActionType = SduiCoreSystem.SduiActionType
local getSduiActionHandlerRegistry = SduiCoreSystem.getSduiActionHandlerRegistry

local sduiActionParams = SduiCoreSystem.SduiActionParams
local getStringParam = sduiActionParams.getStringParam
local getBooleanParam = sduiActionParams.getBooleanParam

local SduiDismissPromptAction = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Actions/SduiDismissPromptAction")

local fFlagSduiDismissPromptAction = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagSduiDismissPromptAction
local fFlagLuaAppSduiMovePromptsActions = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagLuaAppSduiMovePromptsActions

local function SduiShowToastAction(p2, p3, p4, p5)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{ name = sduiActionType.ShowToast, message = "Missing actionParams" },
			p4.appPage
		)
		return
	end

	local stringParam = getStringParam(actionParams, "toastMessage")

	if stringParam == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.ShowToast,
				message = "Missing actionParam: toastMessage",
				propName = "toastMessage"
			},
			p4.appPage
		)
		return
	end

	local stringParam2 = getStringParam(actionParams, "toastType")
	local v5 = if stringParam2 and toastType[stringParam2] then toastType[stringParam2] else toastType.SuccessConfirmation

	p4.dependencies.dispatch(setCurrentToastMessage({
		toastMessage = stringParam,
		isLocalized = true,
		toastType = v5
	}))

	if fFlagSduiDismissPromptAction and getBooleanParam(actionParams, "dismissPrompt", false) then
		local v6 = {
			actionType = sduiActionType.DismissPrompt,
			actionParams = {
				promptType = actionParams.promptType,
				promptId = actionParams.promptId
			}
		}

		if fFlagLuaAppSduiMovePromptsActions then
			local actionHandlerConfig = getSduiActionHandlerRegistry().getActionHandlerConfig(sduiActionType.DismissPrompt)

			if actionHandlerConfig and actionHandlerConfig.handler then
				actionHandlerConfig.handler(v6, p3, p4)
			else
				p4.dependencies.logger.reportError(
					sduiErrorType.FailedToExecuteAction,
					{
						name = sduiActionType.ShowToast,
						message = "DismissPrompt handler is not registered",
						propName = "dismissPrompt"
					},
					p4.appPage
				)
			end
		else
			SduiDismissPromptAction(v6, p3, p4)
		end
	end
end

return SduiShowToastAction
