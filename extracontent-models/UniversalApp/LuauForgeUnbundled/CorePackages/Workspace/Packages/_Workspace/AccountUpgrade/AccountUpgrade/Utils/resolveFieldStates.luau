require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/AccountUpgradeField")
require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/FlowSpec")

local function resolveFieldStates(p2)
	local fieldStates = {}

	for i, optionalField in ipairs(p2.spec.optionalFields) do
		fieldStates[optionalField] = { isUnlocked = true, blockingField = nil }
	end

	local v5 = nil

	for i, requiredField in ipairs(p2.spec.requiredFields) do
		fieldStates[requiredField] = {
			isUnlocked = v5 == nil,
			blockingField = v5
		}

		if p2.isSatisfied[requiredField] or v5 ~= nil then
			continue
		end

		v5 = requiredField
	end

	return fieldStates
end

return resolveFieldStates
