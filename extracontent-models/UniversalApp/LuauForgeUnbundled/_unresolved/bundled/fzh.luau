local module = require("@luauforge/bundled/fzi")
local module2 = require("@luauforge/bundled/fzj")

local module3 = require("@luauforge/bundled/fzk")

local module4 = require("@luauforge/bundled/fzl")

local v5 = {
	ChangePasswordSuspectedCompromise = "PROMPT_TYPE_CHANGE_PASSWORD__SUSPECTED_COMPROMISE",
	ChangePasswordBreachedCredential = "PROMPT_TYPE_CHANGE_PASSWORD__BREACHED_CREDENTIAL",
	AccountRestoresPolicyUpdate = "PROMPT_TYPE_ACCOUNT_RESTORES_POLICY_UPDATE",
	AccountRestoresPolicyUpdateV2 = "PROMPT_TYPE_ACCOUNT_RESTORES_POLICY_UPDATE_V2",
	AccountRestoresPolicyUpsell = require("@luauforge/bundled/fzm")() and "PROMPT_TYPE_ACCOUNT_RESTORES_POLICY_UPSELL" or nil,
	AccountRestoresPolicyUpdateV3 = "PROMPT_TYPE_ACCOUNT_RESTORES_POLICY_UPDATE_V3",
	AuthenticatorUpsell = module3() and "PROMPT_TYPE_AUTHENTICATOR_UPSELL" or nil,
	BroaderAuthenticatorUpsell = module4() and "PROMPT_TYPE_BROADER_AUTHENTICATOR_UPSELL" or nil,
	Email2SVUpsell = "PROMPT_TYPE_EMAIL_2SV_UPSELL",
	PasskeyUpsell = "PROMPT_TYPE_PASSKEY_UPSELL"
}

local v6 = module2("PromptType", v5)

module(v6, v5)

return v6
