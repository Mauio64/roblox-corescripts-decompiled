local ParentParent = script.Parent.Parent
local Analytics = require(ParentParent.Analytics)
local getFFlagDebugUGCDisableSurfaceAppearanceTests = require(ParentParent.flags.getFFlagDebugUGCDisableSurfaceAppearanceTests)
local validateBodyPartMeshBounds = require(ParentParent.validation.validateBodyPartMeshBounds)
local validateAssetBounds = require(ParentParent.validation.validateAssetBounds)
local validateAccurateBoundingBoxRasterMethod = require(ParentParent.validation.validateAccurateBoundingBoxRasterMethod)
local validateBodyPartChildAttachmentBounds = require(ParentParent.validation.validateBodyPartChildAttachmentBounds)
local validateBodyPartChildAttachmentOrientations = require(ParentParent.validation.validateBodyPartChildAttachmentOrientations)
local validateBodyPartExtentsRelativeToParent = require(ParentParent.validation.validateBodyPartExtentsRelativeToParent)
local validateDependencies = require(ParentParent.validation.validateDependencies)
local validateDescendantMeshMetrics = require(ParentParent.validation.validateDescendantMeshMetrics)
local validateDescendantTextureMetrics = require(ParentParent.validation.validateDescendantTextureMetrics)
local validateSurfaceAppearances = require(ParentParent.validation.validateSurfaceAppearances)
local validateMaterials = require(ParentParent.validation.validateMaterials)
local validateTags = require(ParentParent.validation.validateTags)
local validatePropertyRequirements = require(ParentParent.validation.validatePropertyRequirements)
local validateAttributes = require(ParentParent.validation.validateAttributes)
local validateHSR = require(ParentParent.validation.validateHSR)
local validateBodyPartCollisionFidelity = require(ParentParent.validation.validateBodyPartCollisionFidelity)
local validateModeration = require(ParentParent.validation.validateModeration)
local validateAssetTransparency = require(ParentParent.validation.validateAssetTransparency)
local validatePose = require(ParentParent.validation.validatePose)
local ValidateBodyBlockingTests = require(ParentParent.util.ValidateBodyBlockingTests)
local ValidateMeshSizeProperty = require(ParentParent.validation.ValidateMeshSizeProperty)
local ValidatePropertiesSensible = require(ParentParent.validation.ValidatePropertiesSensible)
local ValidateLegsSeparation = require(ParentParent.validation.ValidateLegsSeparation)
local ValidateTexturePack = require(ParentParent.validation.ValidateTexturePack)
local validateWithSchema = require(ParentParent.util.validateWithSchema)
local FailureReasonsAccumulator = require(ParentParent.util.FailureReasonsAccumulator)
local ValidateMeshPartOnlySkinnedToR15 = require(ParentParent.validation.ValidateMeshPartOnlySkinnedToR15)
local bodyAssetMasksRenderer = require(ParentParent.util.bodyAssetMasksRenderer)
local getEngineFeatureEngineUGCValidatePropertiesSensible = require(ParentParent.flags.getEngineFeatureEngineUGCValidatePropertiesSensible)
local getFFlagUGCValidateTexturePack = require(ParentParent.flags.getFFlagUGCValidateTexturePack)
local getFFlagUGCValidationEnableR15plusSkinning = require(ParentParent.flags.getFFlagUGCValidationEnableR15plusSkinning)
local resetPhysicsData = require(ParentParent.util.resetPhysicsData)

require(ParentParent.util.Types)

local getFFlagUGCValidateMigrateSchemaProperties = require(ParentParent.flags.getFFlagUGCValidateMigrateSchemaProperties)
local getFFlagUGCValidationCombineEntrypointResults = require(ParentParent.flags.getFFlagUGCValidationCombineEntrypointResults)
local getFFlagUGCValidateMigrateTextureTransparency = require(ParentParent.flags.getFFlagUGCValidateMigrateTextureTransparency)
local getFFlagUGCValidateMigrateBodyPartBounds = require(ParentParent.flags.getFFlagUGCValidateMigrateBodyPartBounds)
local getFFlagUGCValidateMigratePoseBlocking = require(ParentParent.flags.getFFlagUGCValidateMigratePoseBlocking)
local getFFlagUGCValidateMigrateSurfaceAppearanceMeshQuality = require(ParentParent.flags.getFFlagUGCValidateMigrateSurfaceAppearanceMeshQuality)

local function validateMeshPartBodyPart(p1, p2, p3) -- line: 58
	-- upvalues: validateWithSchema (copy), Analytics (copy), getFFlagUGCValidateMigrateSurfaceAppearanceMeshQuality (copy), getFFlagDebugUGCDisableSurfaceAppearanceTests (copy), validateSurfaceAppearances (copy), getFFlagUGCValidateMigrateSchemaProperties (copy), getFFlagUGCValidationCombineEntrypointResults (copy), validateDependencies (copy), resetPhysicsData (copy), getEngineFeatureEngineUGCValidatePropertiesSensible (copy), ValidatePropertiesSensible (copy), getFFlagUGCValidateMigratePoseBlocking (copy), ValidateBodyBlockingTests (copy), getFFlagUGCValidateMigrateBodyPartBounds (copy), ValidateMeshSizeProperty (copy), FailureReasonsAccumulator (copy), validateBodyPartMeshBounds (copy), getFFlagUGCValidateTexturePack (copy), ValidateTexturePack (copy), validateBodyPartChildAttachmentBounds (copy), validateBodyPartExtentsRelativeToParent (copy), validateBodyPartChildAttachmentOrientations (copy), validatePose (copy), validateAssetBounds (copy), ValidateLegsSeparation (copy), validateAccurateBoundingBoxRasterMethod (copy), bodyAssetMasksRenderer (copy), validateDescendantMeshMetrics (copy), getFFlagUGCValidateMigrateTextureTransparency (copy), validateDescendantTextureMetrics (copy), validateHSR (copy), validateAssetTransparency (copy), validateMaterials (copy), validatePropertyRequirements (copy), validateBodyPartCollisionFidelity (copy), validateAttributes (copy), validateTags (copy), getFFlagUGCValidationEnableR15plusSkinning (copy), ValidateMeshPartOnlySkinnedToR15 (copy), validateModeration (copy)
	local isServer = p3.isServer
	local assetTypeEnum = p3.assetTypeEnum
	local allowUnreviewedAssets = p3.allowUnreviewedAssets
	local restrictedUserIds = p3.restrictedUserIds
	local v50 = validateWithSchema(p2, p1, p3)

	if not v50.success then
		Analytics.reportFailure(Analytics.ErrorType.validateMeshPartBodyPart_ValidateWithSchema, nil, p3)

		return false, {
			string.format("Body part '%s' does not follow R15 schema. The specific issues are: ", p1.Name),
			v50.message
		}
	end

	if not getFFlagUGCValidateMigrateSurfaceAppearanceMeshQuality() and not getFFlagDebugUGCDisableSurfaceAppearanceTests() then
		local v51, v52 = validateSurfaceAppearances(p1, p3)

		if not v51 then
			return v51, v52
		end
	end

	local t1 = {
		skipExistenceCheck = getFFlagUGCValidateMigrateSchemaProperties() and getFFlagUGCValidationCombineEntrypointResults(),
		skipOwnershipCheck = getFFlagUGCValidateMigrateSchemaProperties() and getFFlagUGCValidationCombineEntrypointResults()
	}
	local v54, v55 = validateDependencies(p1, p3, t1)

	if not v54 then
		return v54, v55
	end

	local v56, v57 = resetPhysicsData({ p1 }, p3)

	if not v56 then
		return false, { v57 }
	end

	if getEngineFeatureEngineUGCValidatePropertiesSensible() then
		local v58, v59 = ValidatePropertiesSensible.validate(p1, p3)

		if not v58 then
			return false, v59
		end
	end

	if not getFFlagUGCValidateMigratePoseBlocking() then
		local v60, v61 = ValidateBodyBlockingTests.validate(p1, p3)

		if not v60 then
			return false, v61
		end
	end

	if not getFFlagUGCValidateMigrateBodyPartBounds() then
		local v62, v63 = ValidateMeshSizeProperty.validateBodyAsset(p1, p3)

		if not v62 then
			return false, v63
		end
	end

	local v64 = FailureReasonsAccumulator.new()

	if not getFFlagUGCValidateMigrateBodyPartBounds() then
		v64:updateReasons(validateBodyPartMeshBounds(p1, p3))
	end

	if not getFFlagUGCValidateMigrateSurfaceAppearanceMeshQuality() and getFFlagUGCValidateTexturePack() then
		v64:updateReasons(ValidateTexturePack.validate(p1, true, p3))
	end

	if not getFFlagUGCValidateMigrateSchemaProperties() or not getFFlagUGCValidationCombineEntrypointResults() then
		v64:updateReasons(validateBodyPartChildAttachmentBounds(p1, p3))
	end

	if not getFFlagUGCValidateMigrateBodyPartBounds() then
		v64:updateReasons(validateBodyPartExtentsRelativeToParent.runValidation(p1, p3))
	end

	if not getFFlagUGCValidateMigrateSchemaProperties() or not getFFlagUGCValidationCombineEntrypointResults() then
		v64:updateReasons(validateBodyPartChildAttachmentOrientations.runValidation(p1, p3))
	end

	if not getFFlagUGCValidateMigratePoseBlocking() then
		v64:updateReasons(validatePose(p1, p3))
	end

	if not getFFlagUGCValidateMigrateBodyPartBounds() then
		v64:updateReasons(validateAssetBounds(nil, p1, p3))
	end

	if not getFFlagUGCValidateMigratePoseBlocking() then
		v64:updateReasons(ValidateLegsSeparation.validateAsset(p1, p3))
	end

	if not getFFlagUGCValidateMigratePoseBlocking() then
		local v65 = validateAccurateBoundingBoxRasterMethod.getBoundsViewsForAssetType(assetTypeEnum)
		local v66, v67 = bodyAssetMasksRenderer.new(p1, v65, p3)

		if v66 then
			v64:updateReasons(validateAccurateBoundingBoxRasterMethod.validate(p1, v67, p3))
		else
			v64:updateReasons(v66, v67)
		end
	end

	v64:updateReasons(validateDescendantMeshMetrics(p1, p3))

	if not getFFlagUGCValidateMigrateTextureTransparency() then
		v64:updateReasons(validateDescendantTextureMetrics(p1, p3))
	end

	if not getFFlagUGCValidateMigrateSchemaProperties() or not getFFlagUGCValidationCombineEntrypointResults() then
		v64:updateReasons(validateHSR(p1, p3))
	end

	if not getFFlagUGCValidateMigrateTextureTransparency() then
		local timestamp = tick()

		v64:updateReasons(validateAssetTransparency(p1, p3))
		Analytics.recordScriptTime("validateAssetTransparency", timestamp, p3)
	end

	if not getFFlagUGCValidateMigrateSchemaProperties() or not getFFlagUGCValidationCombineEntrypointResults() then
		v64:updateReasons(validateMaterials(p1, p3))
		v64:updateReasons(validatePropertyRequirements(p1, assetTypeEnum, p3))
		v64:updateReasons(validateBodyPartCollisionFidelity(p1, p3))
		v64:updateReasons(validateAttributes(p1, p3))
	end

	v64:updateReasons(validateTags(p1, p3))

	if not getFFlagUGCValidationEnableR15plusSkinning() and assetTypeEnum ~= Enum.AssetType.DynamicHead then
		v64:updateReasons(ValidateMeshPartOnlySkinnedToR15.validateBodyParts(p1, p3))
	end

	if not getFFlagUGCValidateMigrateSchemaProperties() or not getFFlagUGCValidationCombineEntrypointResults() then
		local v69 = not isServer

		if allowUnreviewedAssets then
			v69 = false
		end

		if v69 then
			v64:updateReasons(validateModeration(p1, restrictedUserIds, p3))
		end
	end

	return v64:getFinalResults()
end

return validateMeshPartBodyPart
