local AccountUpgradeError = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/AccountUpgradeError")

local set = {
	[AccountUpgradeError.AccountUpgradeDisabled] = true,
	[AccountUpgradeError.NotEligible] = true,
	[AccountUpgradeError.InvalidUpgradeType] = true,
	[AccountUpgradeError.FieldNotAllowedForUpgradeType] = true,
	[AccountUpgradeError.BirthdayRequired] = true,
	[AccountUpgradeError.AccountAlreadyUpgraded] = true
}

local function isAccountUpgradeErrorUnrecoverable(p2): boolean
	return p2 ~= nil and set[p2] == true
end

return isAccountUpgradeErrorUnrecoverable
