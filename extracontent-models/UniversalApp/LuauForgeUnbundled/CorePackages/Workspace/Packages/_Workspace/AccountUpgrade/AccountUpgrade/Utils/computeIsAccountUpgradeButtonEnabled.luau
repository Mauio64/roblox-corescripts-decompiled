local inputValidity = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AuthCommon").Enums.InputValidity
local AccountUpgradeField = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/AccountUpgradeField")

local v5 = { AccountUpgradeField.Birthday, AccountUpgradeField.Username, AccountUpgradeField.Password }

local function computeIsAccountUpgradeButtonEnabled(data): boolean
	if data.isSubmitting then
		return false
	end

	local requiredFields = data.requiredFields or v5
	local requiredFieldSet = {}

	for i, requiredField in ipairs(requiredFields) do
		requiredFieldSet[requiredField] = true
	end

	if requiredFieldSet[AccountUpgradeField.Birthday] and data.birthday == nil then
		return false
	end

	local username = data.username or ""
	local password = data.password or ""
	local email = data.email or ""

	if
		requiredFieldSet[AccountUpgradeField.Username] and (username == "" or data.usernameValid ~= inputValidity.Valid)
		or requiredFieldSet[AccountUpgradeField.Password]
		and (password == "" or data.passwordValid ~= inputValidity.Valid)
	then
		return false
	end

	return email == "" or data.emailValid == true
end

return computeIsAccountUpgradeButtonEnabled
