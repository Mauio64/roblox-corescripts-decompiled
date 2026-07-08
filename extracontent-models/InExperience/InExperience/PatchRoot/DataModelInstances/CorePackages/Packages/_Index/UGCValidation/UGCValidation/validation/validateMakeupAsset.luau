local ParentParent = script.Parent.Parent

require(ParentParent.util.Types)

local validateInstanceTree = require(ParentParent.validation.validateInstanceTree)
local validateModeration = require(ParentParent.validation.validateModeration)
local validateTags = require(ParentParent.validation.validateTags)
local validatePropertyRequirements = require(ParentParent.validation.validatePropertyRequirements)
local validateAttributes = require(ParentParent.validation.validateAttributes)
local validateSingleInstance = require(ParentParent.validation.validateSingleInstance)
local validateMakeupDecal = require(ParentParent.validation.validateMakeupDecal)
local validateWrapTextureTransfer = require(ParentParent.validation.validateWrapTextureTransfer)
local ValidatePropertiesSensible = require(ParentParent.validation.ValidatePropertiesSensible)
local validateDependencies = require(ParentParent.validation.validateDependencies)
local createMakeupSchema = require(ParentParent.util.createMakeupSchema)
local FailureReasonsAccumulator = require(ParentParent.util.FailureReasonsAccumulator)
local getEngineFeatureEngineUGCValidatePropertiesSensible = require(ParentParent.flags.getEngineFeatureEngineUGCValidatePropertiesSensible)
local getFFlagUGCValidateMigrateSchemaProperties = require(ParentParent.flags.getFFlagUGCValidateMigrateSchemaProperties)
local getFFlagUGCValidationCombineEntrypointResults = require(ParentParent.flags.getFFlagUGCValidationCombineEntrypointResults)
local getFFlagUGCValidateMigrateWrapAndMakeup = require(ParentParent.flags.getFFlagUGCValidateMigrateWrapAndMakeup)

local function validateMakeupAsset(p1) -- line: 24
	-- upvalues: validateSingleInstance (copy), createMakeupSchema (copy), getFFlagUGCValidateMigrateSchemaProperties (copy), getFFlagUGCValidationCombineEntrypointResults (copy), validateInstanceTree (copy), getEngineFeatureEngineUGCValidatePropertiesSensible (copy), ValidatePropertiesSensible (copy), validateDependencies (copy), FailureReasonsAccumulator (copy), validatePropertyRequirements (copy), validateTags (copy), validateAttributes (copy), validateModeration (copy), getFFlagUGCValidateMigrateWrapAndMakeup (copy), validateMakeupDecal (copy), validateWrapTextureTransfer (copy)
	local instances = p1.instances
	local v21, v22 = validateSingleInstance(instances, p1)

	if not v21 then
		return false, v22
	end

	local v23 = instances[1]
	local v24 = createMakeupSchema()

	if not getFFlagUGCValidateMigrateSchemaProperties() or not getFFlagUGCValidationCombineEntrypointResults() then
		local v25, v26 = validateInstanceTree(v24, v23, p1)

		if not v25 then
			return false, v26
		end
	end

	if (not getFFlagUGCValidateMigrateSchemaProperties() or not getFFlagUGCValidationCombineEntrypointResults()) and getEngineFeatureEngineUGCValidatePropertiesSensible() then
		local v27, v28 = ValidatePropertiesSensible.validate(v23, p1)

		if not v27 then
			return false, v28
		end
	end

	local t1 = {
		skipExistenceCheck = getFFlagUGCValidateMigrateSchemaProperties() and getFFlagUGCValidationCombineEntrypointResults(),
		skipOwnershipCheck = getFFlagUGCValidateMigrateSchemaProperties() and getFFlagUGCValidationCombineEntrypointResults()
	}
	local v30, v31 = validateDependencies(v23, p1, t1)

	if not v30 then
		return false, v31
	end

	local v32 = FailureReasonsAccumulator.new()

	if not getFFlagUGCValidateMigrateSchemaProperties() or not getFFlagUGCValidationCombineEntrypointResults() then
		v32:updateReasons(validatePropertyRequirements(v23, nil, p1))
	end

	v32:updateReasons(validateTags(v23, p1))

	if not getFFlagUGCValidateMigrateSchemaProperties() or not getFFlagUGCValidationCombineEntrypointResults() then
		v32:updateReasons(validateAttributes(v23, p1))
	end

	if not getFFlagUGCValidateMigrateSchemaProperties() or not getFFlagUGCValidationCombineEntrypointResults() then
		v32:updateReasons(validateModeration(v23, {}, p1))
	end

	if not getFFlagUGCValidateMigrateWrapAndMakeup() then
		v32:updateReasons(validateMakeupDecal(v23, p1))
	end

	if not getFFlagUGCValidateMigrateWrapAndMakeup() then
		v32:updateReasons(validateWrapTextureTransfer(v23, p1))
	end

	return v32:getFinalResults()
end

return validateMakeupAsset
