local module = require("@luauforge/bundled/hTE")
local module2 = require("@luauforge/bundled/hTH")

local function noop() end

local sduiActionParams = module.SduiActionParams
local getStringParam = sduiActionParams.getStringParam
local getBooleanParam = sduiActionParams.getBooleanParam
local getCallbackParam = sduiActionParams.getCallbackParam

local function SduiOpenPhoneUpsellModalAction(p2, p3, p4, p5)
	local actionParams = p2 and p2.actionParams or {}
	local booleanParam = getBooleanParam(actionParams, "voiceOptIn", false)

	local v5 = {
		onSuccess = getCallbackParam(actionParams, "onSuccess", noop),
		onCancelled = getCallbackParam(actionParams, "onCancelled", noop),
		onFailure = getCallbackParam(actionParams, "onFailure", noop),
		eventContext = getStringParam(actionParams, "eventContext", nil),
		origin = getStringParam(actionParams, "origin", "unknown"),
		shouldAutofillAndroidPhoneNumberAtLaunch = getBooleanParam(
			actionParams,
			"shouldAutofillAndroidPhoneNumberAtLaunch",
			true
		),
		addPhoneDescriptionKey = getStringParam(actionParams, "addPhoneDescriptionKey", nil)
	}

	p4.dependencies.dispatch(module2(v5, booleanParam))
end

return SduiOpenPhoneUpsellModalAction
