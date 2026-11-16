local AccountUpgrade = script:FindFirstAncestor("AccountUpgrade")

local AccountUpgradeField = require(AccountUpgrade.AccountUpgradeField)
local AccountUpgradeFlow = require(AccountUpgrade.AccountUpgradeFlow)

local v = {
	[AccountUpgradeFlow.Pioneer] = {
		requiredFields = { AccountUpgradeField.Birthday, AccountUpgradeField.Username, AccountUpgradeField.Password },
		optionalFields = { AccountUpgradeField.Email, AccountUpgradeField.Gender },
		canDismiss = true,
		signsOutOnDismiss = false,
		upgradeType = "Pioneer",
		titleTextKey = "Authentication.SignUp.Header.SetUpYourRobloxAccount",
		subtitleTextKey = "Authentication.SignUp.Subtitle.YourProgressCarriesOver",
		submitTextKey = "Authentication.Login.Action.Save"
	},
	[AccountUpgradeFlow.PioneerU13] = {
		requiredFields = { AccountUpgradeField.Username, AccountUpgradeField.Password },
		optionalFields = { AccountUpgradeField.Gender },
		canDismiss = false,
		signsOutOnDismiss = false,
		upgradeType = "PioneerU13",
		titleTextKey = "Authentication.SignUp.Header.SetUpYourRobloxAccount",
		subtitleTextKey = "Authentication.SignUp.Subtitle.YourProgressCarriesOver",
		submitTextKey = "Authentication.Login.Action.Save"
	},
	[AccountUpgradeFlow.OAuth] = {
		requiredFields = { AccountUpgradeField.Birthday, AccountUpgradeField.Username },
		optionalFields = { AccountUpgradeField.Gender },
		canDismiss = true,
		signsOutOnDismiss = true,
		upgradeType = "OAuth",
		titleTextKey = "Authentication.SignUp.Header.OneLastThing",
		subtitleTextKey = "Authentication.SignUp.Subtitle.AddYourBirthday",
		submitTextKey = "Authentication.SignUp.Action.CreateAccountSentenceCase",
		legalTextKey = "Authentication.SignUp.Description.SignUpAgreement.CreateAnAccount",
		fitsDialogToContent = true,
		showsMarketingConsent = true
	},
	[AccountUpgradeFlow.Signup] = {
		requiredFields = { AccountUpgradeField.Birthday, AccountUpgradeField.Username, AccountUpgradeField.Password },
		optionalFields = { AccountUpgradeField.Gender },
		canDismiss = true,
		signsOutOnDismiss = false,
		upgradeType = "Signup",
		titleTextKey = "Authentication.SignUp.Action.CreateAccountSentenceCase",
		subtitleTextKey = nil,
		submitTextKey = "Authentication.SignUp.Action.Create",
		legalTextKey = "Authentication.SignUp.Description.SignUpAgreement.CreateAnAccount",
		linkedAccountLegalTextKey = "Authentication.SignUp.Description.VerificationLinkingText.VariableButtonName",
		boldFieldLabels = true,
		capturesAuditContent = true,
		hostReportsSubmit = true
	}
}

local function getFlowSpec(p)
	return v[p]
end

return getFlowSpec
