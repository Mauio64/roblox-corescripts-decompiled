local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local OpenPhoneUpsellModal = require(Modules.LuaApp.Thunks.Verification.OpenPhoneUpsellModal)

local function noop() -- line: 14
end

local SduiActionParams = SduiCoreSystem.SduiActionParams
local getStringParam = SduiActionParams.getStringParam
local getBooleanParam = SduiActionParams.getBooleanParam
local getCallbackParam = SduiActionParams.getCallbackParam

local function SduiOpenPhoneUpsellModalAction(p1, _, p3, _) -- line: 21
	-- upvalues: getBooleanParam (copy), getCallbackParam (copy), noop (copy), getStringParam (copy), OpenPhoneUpsellModal (copy)
	local v15 = p1 and p1.actionParams or {}
	local v16 = getBooleanParam(v15, "voiceOptIn", false)
	local t1 = {
		onSuccess = getCallbackParam(v15, "onSuccess", noop),
		onCancelled = getCallbackParam(v15, "onCancelled", noop),
		onFailure = getCallbackParam(v15, "onFailure", noop),
		eventContext = getStringParam(v15, "eventContext", nil),
		origin = getStringParam(v15, "origin", "unknown"),
		shouldAutofillAndroidPhoneNumberAtLaunch = getBooleanParam(v15, "shouldAutofillAndroidPhoneNumberAtLaunch", true),
		addPhoneDescriptionKey = getStringParam(v15, "addPhoneDescriptionKey", nil)
	}

	p3.dependencies.dispatch(OpenPhoneUpsellModal(t1, v16))
end

return SduiOpenPhoneUpsellModalAction
