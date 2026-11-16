local parent = script.Parent.Parent

local Analytics = require(parent.Analytics)

local validateDependencies = require(parent.validation.validateDependencies)
local validateDescendantMeshMetrics = require(parent.validation.validateDescendantMeshMetrics)
local validateTags = require(parent.validation.validateTags)
local ValidatePropertiesSensible = require(parent.validation.ValidatePropertiesSensible)

local validateWithSchema = require(parent.util.validateWithSchema)
local FailureReasonsAccumulator = require(parent.util.FailureReasonsAccumulator)
local ValidateMeshPartOnlySkinnedToR15 = require(parent.validation.ValidateMeshPartOnlySkinnedToR15)

local getEngineFeatureEngineUGCValidatePropertiesSensible = require(parent.flags.getEngineFeatureEngineUGCValidatePropertiesSensible)
local getFFlagUGCValidationEnableR15plusSkinning = require(parent.flags.getFFlagUGCValidationEnableR15plusSkinning)

local resetPhysicsData = require(parent.util.resetPhysicsData)
require(parent.util.Types)

local function validateMeshPartBodyPart(p, p2, p3)
	local assetTypeEnum = p3.assetTypeEnum

	local v = validateWithSchema(p2, p, p3)

	if not v.success then
		Analytics.reportFailure(Analytics.ErrorType.validateMeshPartBodyPart_ValidateWithSchema, nil, p3)

		return
			false,
			{ string.format("Body part '%s' does not follow R15 schema. The specific issues are: ", p.Name), v.message }
	end

	local v2, v3 = validateDependencies(p, p3, {
		skipExistenceCheck = true,
		skipOwnershipCheck = true
	})

	if not v2 then
		return v2, v3
	end

	local v4, v5 = resetPhysicsData({ p }, p3)

	if not v4 then
		return false, { v5 }
	end

	if getEngineFeatureEngineUGCValidatePropertiesSensible() then
		local v6, v7 = ValidatePropertiesSensible.validate(p, p3)

		if not v6 then
			return false, v7
		end
	end

	local v6 = FailureReasonsAccumulator.new()

	v6:updateReasons(validateDescendantMeshMetrics(p, p3))

	v6:updateReasons(validateTags(p, p3))

	if not getFFlagUGCValidationEnableR15plusSkinning() and assetTypeEnum ~= Enum.AssetType.DynamicHead then
		v6:updateReasons(ValidateMeshPartOnlySkinnedToR15.validateBodyParts(p, p3))
	end

	return v6:getFinalResults()
end

return validateMeshPartBodyPart
