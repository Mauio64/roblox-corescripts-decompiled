local AccountUpgradeError = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/AccountUpgradeError")

local v5 = {
	[AccountUpgradeError.InvalidBirthday] = "Authentication.SignUp.Response.InvalidBirthday",
	[AccountUpgradeError.InvalidUsername] = "Authentication.SignUp.Label.ErrorsWithUsername",
	[AccountUpgradeError.InvalidPassword] = "Authentication.SignUp.Response.PasswordComplexity",
	[AccountUpgradeError.InvalidEmailAddress] = "Authentication.SignUp.Response.InvalidEmail"
}

local function getAccountUpgradeErrorTextKey(p2)
	if p2 == nil then
		return "Authentication.SignUp.Response.ErrorTryAgain2"
	end

	return v5[p2] or "Authentication.SignUp.Response.ErrorTryAgain2"
end

return getAccountUpgradeErrorTextKey
