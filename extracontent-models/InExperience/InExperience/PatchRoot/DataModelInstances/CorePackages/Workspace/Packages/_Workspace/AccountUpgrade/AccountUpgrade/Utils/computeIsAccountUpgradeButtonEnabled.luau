local AccountUpgrade = script:FindFirstAncestor("AccountUpgrade")
local parent = AccountUpgrade.Parent

local AuthCommon = require(parent.AuthCommon)
local InputValidity = AuthCommon.Enums.InputValidity
local AccountUpgradeField = require(AccountUpgrade.AccountUpgradeField)

local v = { AccountUpgradeField.Birthday, AccountUpgradeField.Username, AccountUpgradeField.Password }

local function computeIsAccountUpgradeButtonEnabled(data): boolean
	if data.isSubmitting then
		return false
	end

	local requiredFields = data.requiredFields or v
	local requiredFieldSet = {}

	for _, requiredField in ipairs(requiredFields) do
		requiredFieldSet[requiredField] = true
	end

	if requiredFieldSet[AccountUpgradeField.Birthday] and data.birthday == nil then
		return false
	end

	local username = data.username or ""
	local password = data.password or ""
	local email = data.email or ""

	if
		requiredFieldSet[AccountUpgradeField.Username] and (username == "" or data.usernameValid ~= InputValidity.Valid)
		or requiredFieldSet[AccountUpgradeField.Password]
		and (password == "" or data.passwordValid ~= InputValidity.Valid)
	then
		return false
	end

	return email == "" or data.emailValid == true
end

return computeIsAccountUpgradeButtonEnabled
