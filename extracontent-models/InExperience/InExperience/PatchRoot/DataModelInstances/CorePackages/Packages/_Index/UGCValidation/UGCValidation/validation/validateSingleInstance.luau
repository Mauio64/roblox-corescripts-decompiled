local ParentParent = script.Parent.Parent
local Analytics = require(ParentParent.Analytics)

require(ParentParent.util.Types)

local function validateSingleInstance(t1: {[any]: any}, p1) -- line: 7
	-- upvalues: Analytics (copy)
	local assetTypeEnum = p1.assetTypeEnum

	if #t1 == 0 then
		Analytics.reportFailure(Analytics.ErrorType.validateSingleInstance_ZeroInstances, nil, p1)

		return false, { string.format("Failed to find an instance of the asset type '%s'. Make sure one exists and try again.", assetTypeEnum.Name) }
	end

	if #t1 > 1 then
		Analytics.reportFailure(Analytics.ErrorType.validateSingleInstance_MultipleInstances, nil, p1)

		return false, { string.format("Selected more than one instance of type '%s'. Please, select a single instance of this type and try again.", assetTypeEnum.Name) }
	end

	return true
end

return validateSingleInstance
