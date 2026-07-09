local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local addRawValueMethodToEnum = require(Modules.LuaApp.Enum.AccountSecurity.addRawValueMethodToEnum)
local enumerate = require(CorePackages.Packages.enumerate)
local t1 = {
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
local v6 = enumerate(script.Name, t1)

addRawValueMethodToEnum(v6, t1)

return v6
