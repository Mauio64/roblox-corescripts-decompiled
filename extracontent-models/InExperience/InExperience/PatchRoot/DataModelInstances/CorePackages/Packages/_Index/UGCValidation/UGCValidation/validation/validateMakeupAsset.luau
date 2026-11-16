local parent = script.Parent.Parent

require(parent.util.Types)

local validateTags = require(parent.validation.validateTags)
local validateSingleInstance = require(parent.validation.validateSingleInstance)
local validateDependencies = require(parent.validation.validateDependencies)

local FailureReasonsAccumulator = require(parent.util.FailureReasonsAccumulator)
local getFFlagUGCValidateMakeupCategoryParity = require(parent.flags.getFFlagUGCValidateMakeupCategoryParity)

local function validateMakeupAsset(p)
	local instances = p.instances

	if not getFFlagUGCValidateMakeupCategoryParity() then
		local v, v2 = validateSingleInstance(instances, p)

		if not v then
			return false, v2
		end
	end

	local instance = instances[1]

	local v, v2 = validateDependencies(instance, p, {
		skipExistenceCheck = true,
		skipOwnershipCheck = true
	})

	if not v then
		return false, v2
	end

	local v3 = FailureReasonsAccumulator.new()

	if not getFFlagUGCValidateMakeupCategoryParity() then
		v3:updateReasons(validateTags(instance, p))
	end

	return v3:getFinalResults()
end

return validateMakeupAsset
