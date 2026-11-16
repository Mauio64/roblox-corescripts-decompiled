local AccountUpgrade = script:FindFirstAncestor("AccountUpgrade")

require(AccountUpgrade.AccountUpgradeField)
require(AccountUpgrade.FlowSpec)

local function resolveFieldStates(p)
	local fieldStates = {}

	for _, optionalField in ipairs(p.spec.optionalFields) do
		fieldStates[optionalField] = { isUnlocked = true, blockingField = nil }
	end

	local blockingField = nil

	for _, requiredField in ipairs(p.spec.requiredFields) do
		fieldStates[requiredField] = {
			isUnlocked = blockingField == nil,
			blockingField = blockingField
		}

		if p.isSatisfied[requiredField] or blockingField ~= nil then
			continue
		end

		blockingField = requiredField
	end

	return fieldStates
end

return resolveFieldStates
