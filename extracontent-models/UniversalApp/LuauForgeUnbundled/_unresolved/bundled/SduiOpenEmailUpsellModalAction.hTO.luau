local module = require("@luauforge/bundled/hTI")
local centralOverlayType = require("@luauforge/bundled/hTK").CentralOverlayType
local module2 = require("@luauforge/bundled/hTE")
local setCentralOverlay = module.Actions.SetCentralOverlay

local function noop() end

local sduiActionParams = module2.SduiActionParams
local getStringParam = sduiActionParams.getStringParam
local getBooleanParam = sduiActionParams.getBooleanParam
local getCallbackParam = sduiActionParams.getCallbackParam

local function SduiOpenEmailUpsellModalAction(p2, p3, p4, p5)
	local actionParams = p2 and p2.actionParams or {}
	local v5 = {
		successCallback = getCallbackParam(actionParams, "onSuccess", noop),
		failureCallback = getCallbackParam(actionParams, "onFailure", noop),
		addEmailOver13TextKey = getStringParam(actionParams, "addEmailOver13TextKey", nil),
		addEmailTitleKey = getStringParam(actionParams, "addEmailTitleKey", nil),
		isEmailModalCalledFromHomePage = getBooleanParam(
			actionParams,
			"isEmailModalCalledFromHomePage",
			false
		),
		eventContext = getStringParam(actionParams, "eventContext", nil),
		origin = getStringParam(actionParams, "origin", "unknown"),
		section = getStringParam(actionParams, "section", nil)
	}

	p4.dependencies.dispatch(setCentralOverlay(centralOverlayType.EmailVerificationUpsellOverlay, v5))
end

return SduiOpenEmailUpsellModalAction
