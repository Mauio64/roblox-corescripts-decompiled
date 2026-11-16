local AccountUpgrade = script:FindFirstAncestor("AccountUpgrade")

local AccountUpgradeError = require(AccountUpgrade.AccountUpgradeError)

local v = {
	[AccountUpgradeError.InvalidBirthday] = "Authentication.SignUp.Response.InvalidBirthday",
	[AccountUpgradeError.InvalidUsername] = "Authentication.SignUp.Label.ErrorsWithUsername",
	[AccountUpgradeError.InvalidPassword] = "Authentication.SignUp.Response.PasswordComplexity",
	[AccountUpgradeError.InvalidEmailAddress] = "Authentication.SignUp.Response.InvalidEmail"
}

local function getAccountUpgradeErrorTextKey(p: number?)
	if p == nil then
		return "Authentication.SignUp.Response.ErrorTryAgain2"
	end

	return v[p] or "Authentication.SignUp.Response.ErrorTryAgain2"
end

return getAccountUpgradeErrorTextKey
