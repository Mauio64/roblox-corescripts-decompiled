local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local OpenEmailUpsellModal = require(Modules.LuaApp.Thunks.Verification.OpenEmailUpsellModal)

local function noop() -- line: 14
end

local SduiActionParams = SduiCoreSystem.SduiActionParams
local getStringParam = SduiActionParams.getStringParam
local getBooleanParam = SduiActionParams.getBooleanParam
local getCallbackParam = SduiActionParams.getCallbackParam

local function SduiOpenEmailUpsellModalAction(p1, _, p3, _) -- line: 21
	-- upvalues: getCallbackParam (copy), noop (copy), getStringParam (copy), getBooleanParam (copy), OpenEmailUpsellModal (copy)
	local v15 = p1 and p1.actionParams or {}
	local t1 = {
		successCallback = getCallbackParam(v15, "onSuccess", noop),
		failureCallback = getCallbackParam(v15, "onFailure", noop),
		addEmailOver13TextKey = getStringParam(v15, "addEmailOver13TextKey", nil),
		addEmailTitleKey = getStringParam(v15, "addEmailTitleKey", nil),
		isEmailModalCalledFromHomePage = getBooleanParam(v15, "isEmailModalCalledFromHomePage", false),
		eventContext = getStringParam(v15, "eventContext", nil),
		origin = getStringParam(v15, "origin", "unknown"),
		section = getStringParam(v15, "section", nil)
	}

	p3.dependencies.dispatch(OpenEmailUpsellModal(t1))
end

return SduiOpenEmailUpsellModalAction
