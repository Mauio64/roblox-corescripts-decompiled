local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/fyX")
local enumerate = require(CorePackages.Packages.enumerate)

local v5 = {
	ChangePasswordIntro = "CHANGE_PASSWORD_INTRO",
	ChangePasswordForm = "CHANGE_PASSWORD_FORM",
	ChangePasswordConfirmation = "CHANGE_PASSWORD_CONFIRMATION",
	ChangePasswordDismissConfirmation = "CHANGE_PASSWORD_DISMISS_CONFIRMATION",
	AccountPinForm = "ACCOUNT_PIN_FORM",
	AccountPinFormExpired = "ACCOUNT_PIN_FORM_EXPIRED",
	AuthenticatorUpsellIntro = "AUTHENTICATOR_UPSELL",
	AuthenticatorUpsellInstallApps = "AUTHENTICATOR_INSTALL_APPS",
	AccountRestoresPolicyUpsell = "ACCOUNT_RESTORES_POLICY_UPSELL",
	Email2SVUpsell = "EMAIL_2SV_UPSELL"
}

local v6 = enumerate("ModalState", v5)

module(v6, v5)

return v6
