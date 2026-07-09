local PromptAssignments = script:FindFirstAncestor("PromptAssignments")
local PromptAssignmentsParent = PromptAssignments.Parent
local addRawValueMethodToEnum = require(script.Parent.addRawValueMethodToEnum)
local enumerate = require(PromptAssignmentsParent.enumerate)
local GetFFlagLuaAppAuthenticatorUpsellPopUpEnabled = require(PromptAssignments.Flags.GetFFlagLuaAppAuthenticatorUpsellPopUpEnabled)
local GetFFlagLuaAppBroaderAuthenticatorUpsellPopUpEnabled = require(PromptAssignments.Flags.GetFFlagLuaAppBroaderAuthenticatorUpsellPopUpEnabled)
local GetFFlagLuaAppAccountRestoresPolicyUpsellPopUpEnabled = require(PromptAssignments.Flags.GetFFlagLuaAppAccountRestoresPolicyUpsellPopUpEnabled)
local t1 = {
	ChangePasswordSuspectedCompromise = "PROMPT_TYPE_CHANGE_PASSWORD__SUSPECTED_COMPROMISE",
	ChangePasswordBreachedCredential = "PROMPT_TYPE_CHANGE_PASSWORD__BREACHED_CREDENTIAL",
	AccountRestoresPolicyUpdate = "PROMPT_TYPE_ACCOUNT_RESTORES_POLICY_UPDATE",
	AccountRestoresPolicyUpdateV2 = "PROMPT_TYPE_ACCOUNT_RESTORES_POLICY_UPDATE_V2",
	AccountRestoresPolicyUpdateV3 = "PROMPT_TYPE_ACCOUNT_RESTORES_POLICY_UPDATE_V3",
	Email2SVUpsell = "PROMPT_TYPE_EMAIL_2SV_UPSELL",
	PasskeyUpsell = "PROMPT_TYPE_PASSKEY_UPSELL",
	AccountRestoresPolicyUpsell = if not GetFFlagLuaAppAccountRestoresPolicyUpsellPopUpEnabled() then nil else "PROMPT_TYPE_ACCOUNT_RESTORES_POLICY_UPSELL",
	AuthenticatorUpsell = if not GetFFlagLuaAppAuthenticatorUpsellPopUpEnabled() then nil else "PROMPT_TYPE_AUTHENTICATOR_UPSELL",
	BroaderAuthenticatorUpsell = if not GetFFlagLuaAppBroaderAuthenticatorUpsellPopUpEnabled() then nil else "PROMPT_TYPE_BROADER_AUTHENTICATOR_UPSELL"
}
local v9 = enumerate(script.Name, t1)

addRawValueMethodToEnum(v9, t1)

return v9
