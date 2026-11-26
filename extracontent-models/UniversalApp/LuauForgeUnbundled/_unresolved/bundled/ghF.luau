local module = require("@luauforge/bundled/ghf")
local centralOverlayType = module.RobloxAppEnums.CentralOverlayType
local setCentralOverlay = module.CentralOverlay.Actions.SetCentralOverlay
local closeCentralOverlay = module.CentralOverlay.Thunks.CloseCentralOverlay
local buttonVariant = module.Foundation.Enums.ButtonVariant

local v5 = {
	invalidStoredSession = "Authentication.AccountSwitch.Description.StaleSessionSignInAgain",
	switchError = "Authentication.AccountSwitch.Description.SomethingWentWrongSignInAgain"
}

return function(p2, callback)
	return function(object)
		object:dispatch(setCentralOverlay(centralOverlayType.AccountSwitchingErrorOverlay, {
			titleTextKey = "Authentication.AccountSwitch.Header.CantSwitchAccountsSentenceCase",
			bodyTextKey = v5[p2],
			primaryButtonTextKey = "Authentication.AccountSwitch.Action.SignIn",
			primaryButtonCallback = function()
				object:dispatch(closeCentralOverlay())
				callback()
			end,
			primaryButtonVariant = buttonVariant.Emphasis,
			errorType = p2
		}))
	end
end
