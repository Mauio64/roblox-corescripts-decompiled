local SduiSharedContent = script:FindFirstAncestor("SduiSharedContent")
local parent = SduiSharedContent.Parent

local SduiCoreSystem = require(parent.SduiCoreSystem)
local ToastRodux = require(parent.ToastRodux)

local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage
local ToastType = ToastRodux.Enums.ToastType

local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiActionType = SduiCoreSystem.SduiActionType
local getSduiActionHandlerRegistry = SduiCoreSystem.getSduiActionHandlerRegistry

local SduiActionParams = SduiCoreSystem.SduiActionParams
local getStringParam = SduiActionParams.getStringParam
local getBooleanParam = SduiActionParams.getBooleanParam

local SduiDismissPromptAction = require(SduiSharedContent.Actions.SduiDismissPromptAction)

local SharedFlags = require(parent.SharedFlags)
local FFlagSduiDismissPromptAction = SharedFlags.FFlagSduiDismissPromptAction
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppSduiMovePromptsActions = SharedFlags2.FFlagLuaAppSduiMovePromptsActions

local function SduiShowToastAction(p, p2, p3, _)
	local actionParams = p and p.actionParams or nil

	if actionParams == nil then
		p3.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = SduiActionType.ShowToast, message = "Missing actionParams" },
			p3.appPage
		)
		return
	end

	local stringParam = getStringParam(actionParams, "toastMessage")

	if stringParam == nil then
		p3.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = SduiActionType.ShowToast,
				message = "Missing actionParam: toastMessage",
				propName = "toastMessage"
			},
			p3.appPage
		)
		return
	end

	local stringParam2 = getStringParam(actionParams, "toastType")
	local toastType

	if stringParam2 and ToastType[stringParam2] then
		toastType = ToastType[stringParam2]
	else
		toastType = ToastType.SuccessConfirmation
	end

	p3.dependencies.dispatch(SetCurrentToastMessage({
		toastMessage = stringParam,
		isLocalized = true,
		toastType = toastType
	}))

	if FFlagSduiDismissPromptAction and getBooleanParam(actionParams, "dismissPrompt", false) then
		local v = {
			actionType = SduiActionType.DismissPrompt,
			actionParams = {
				promptType = actionParams.promptType,
				promptId = actionParams.promptId
			}
		}

		if FFlagLuaAppSduiMovePromptsActions then
			local actionHandlerConfig = getSduiActionHandlerRegistry().getActionHandlerConfig(SduiActionType.DismissPrompt)

			if actionHandlerConfig and actionHandlerConfig.handler then
				actionHandlerConfig.handler(v, p2, p3)
			else
				p3.dependencies.logger.reportError(
					SduiErrorType.FailedToExecuteAction,
					{
						name = SduiActionType.ShowToast,
						message = "DismissPrompt handler is not registered",
						propName = "dismissPrompt"
					},
					p3.appPage
				)
			end
		else
			SduiDismissPromptAction(v, p2, p3)
		end
	end
end

return SduiShowToastAction
