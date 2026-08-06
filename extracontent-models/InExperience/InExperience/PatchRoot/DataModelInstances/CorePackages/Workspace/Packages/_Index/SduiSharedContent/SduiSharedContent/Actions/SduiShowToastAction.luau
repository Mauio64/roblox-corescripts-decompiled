local SduiSharedContent = script:FindFirstAncestor("SduiSharedContent")
local SduiSharedContentParent = SduiSharedContent.Parent
local SduiCoreSystem = require(SduiSharedContentParent.SduiCoreSystem)
local ToastRodux = require(SduiSharedContentParent.ToastRodux)
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage
local ToastType = ToastRodux.Enums.ToastType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiActionParams = SduiCoreSystem.SduiActionParams
local getStringParam = SduiActionParams.getStringParam
local getBooleanParam = SduiActionParams.getBooleanParam
local FFlagSduiDismissPromptAction = require(SduiSharedContentParent.SharedFlags).FFlagSduiDismissPromptAction
local SduiDismissPromptAction = require(SduiSharedContent.Actions.SduiDismissPromptAction)

local function SduiShowToastAction(p1, p2, p3, _) -- line: 24
	-- upvalues: SduiErrorType (copy), SduiActionType (copy), getStringParam (copy), ToastType (copy), SetCurrentToastMessage (copy), FFlagSduiDismissPromptAction (copy), getBooleanParam (copy), SduiDismissPromptAction (copy)
	local v19 = p1 and p1.actionParams or nil

	if v19 == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing actionParams",
			name = SduiActionType.ShowToast
		}, p3.appPage)

		return
	end

	local v20 = getStringParam(v19, "toastMessage")

	if v20 == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing actionParam: toastMessage",
			propName = "toastMessage",
			name = SduiActionType.ShowToast
		}, p3.appPage)

		return
	end

	local v21 = getStringParam(v19, "toastType")
	local v22 = if not v21 or not ToastType[v21] then ToastType.SuccessConfirmation else ToastType[v21]

	p3.dependencies.dispatch(SetCurrentToastMessage({
		isLocalized = true,
		toastMessage = v20,
		toastType = v22
	}))

	if FFlagSduiDismissPromptAction and getBooleanParam(v19, "dismissPrompt", false) then
		local t1 = {
			actionType = SduiActionType.DismissPrompt,
			actionParams = {
				promptType = v19.promptType,
				promptId = v19.promptId
			}
		}

		SduiDismissPromptAction(t1, p2, p3)
	end
end

return SduiShowToastAction
