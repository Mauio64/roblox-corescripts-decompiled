local AccountUpgrade = script:FindFirstAncestor("AccountUpgrade")

local AccountUpgradeError = require(AccountUpgrade.AccountUpgradeError)

local set = {
	[AccountUpgradeError.AccountUpgradeDisabled] = true,
	[AccountUpgradeError.NotEligible] = true,
	[AccountUpgradeError.InvalidUpgradeType] = true,
	[AccountUpgradeError.FieldNotAllowedForUpgradeType] = true,
	[AccountUpgradeError.BirthdayRequired] = true,
	[AccountUpgradeError.AccountAlreadyUpgraded] = true
}

local function isAccountUpgradeErrorUnrecoverable(p: number?): boolean
	return p ~= nil and set[p] == true
end

return isAccountUpgradeErrorUnrecoverable
