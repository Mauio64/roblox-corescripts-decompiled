local parent = script.Parent.Parent

local Analytics = require(parent.Analytics)

require(parent.util.Types)

local function validateSingleInstance(list, p)
	local assetTypeEnum = p.assetTypeEnum

	if #list == 0 then
		Analytics.reportFailure(Analytics.ErrorType.validateSingleInstance_ZeroInstances, nil, p)

		return
			false,
			{ string.format(
					"Failed to find an instance of the asset type '%s'. Make sure one exists and try again.",
					assetTypeEnum.Name
				) }
	end

	if #list > 1 then
		Analytics.reportFailure(Analytics.ErrorType.validateSingleInstance_MultipleInstances, nil, p)

		return
			false,
			{ string.format(
					"Selected more than one instance of type '%s'. Please, select a single instance of this type and try again.",
					assetTypeEnum.Name
				) }
	end

	return true
end

return validateSingleInstance
