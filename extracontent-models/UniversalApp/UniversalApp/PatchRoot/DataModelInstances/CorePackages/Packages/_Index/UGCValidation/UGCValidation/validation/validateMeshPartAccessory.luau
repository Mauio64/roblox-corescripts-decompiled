local ParentParent = script.Parent.Parent

require(ParentParent.util.Types)

local Analytics = require(ParentParent.Analytics)
local Constants = require(ParentParent.Constants)
local ConstantsInterface = require(ParentParent.ConstantsInterface)
local validateCoplanarIntersection = require(ParentParent.validation.validateCoplanarIntersection)
local validateInstanceTree = require(ParentParent.validation.validateInstanceTree)
local validateMeshTriangles = require(ParentParent.validation.validateMeshTriangles)
local validateModeration = require(ParentParent.validation.validateModeration)
local validateMaterials = require(ParentParent.validation.validateMaterials)
local validateTags = require(ParentParent.validation.validateTags)
local validateMeshBounds = require(ParentParent.validation.validateMeshBounds)
local validateTextureSize = require(ParentParent.validation.validateTextureSize)
local validatePropertyRequirements = require(ParentParent.validation.validatePropertyRequirements)
local validateAttributes = require(ParentParent.validation.validateAttributes)
local validateMeshVertColors = require(ParentParent.validation.validateMeshVertColors)
local validateSingleInstance = require(ParentParent.validation.validateSingleInstance)
local validateThumbnailConfiguration = require(ParentParent.validation.validateThumbnailConfiguration)
local validateSurfaceAppearances = require(ParentParent.validation.validateSurfaceAppearances)
local validateSurfaceAppearanceTextureSize = require(ParentParent.validation.validateSurfaceAppearanceTextureSize)
local ValidateTexturePack = require(ParentParent.validation.ValidateTexturePack)
local validateSurfaceAppearanceTransparency = require(ParentParent.validation.validateSurfaceAppearanceTransparency)
local validateScaleType = require(ParentParent.validation.validateScaleType)
local validateTotalSurfaceArea = require(ParentParent.validation.validateTotalSurfaceArea)
local validateRigidMeshNotSkinned = require(ParentParent.validation.validateRigidMeshNotSkinned)
local ValidateMeshSizeProperty = require(ParentParent.validation.ValidateMeshSizeProperty)
local ValidatePropertiesSensible = require(ParentParent.validation.ValidatePropertiesSensible)
local validateDependencies = require(ParentParent.validation.validateDependencies)
local createMeshPartAccessorySchema = require(ParentParent.util.createMeshPartAccessorySchema)
local getAttachment = require(ParentParent.util.getAttachment)
local getMeshSize = require(ParentParent.util.getMeshSize)
local FailureReasonsAccumulator = require(ParentParent.util.FailureReasonsAccumulator)
local getEditableMeshFromContext = require(ParentParent.util.getEditableMeshFromContext)
local getEditableImageFromContext = require(ParentParent.util.getEditableImageFromContext)
local getExpectedPartSize = require(ParentParent.util.getExpectedPartSize)
local pcallDeferred = require(ParentParent.util.pcallDeferred)
local getAccessoryScale = require(ParentParent.util.getAccessoryScale)
local RigidOrLayeredAllowed = require(ParentParent.util.RigidOrLayeredAllowed)
local getEngineFeatureEngineUGCValidateRigidNonSkinned = require(ParentParent.flags.getEngineFeatureEngineUGCValidateRigidNonSkinned)
local getEngineFeatureEngineUGCValidatePropertiesSensible = require(ParentParent.flags.getEngineFeatureEngineUGCValidatePropertiesSensible)
local getFFlagUGCValidateAccessoryAssetTextureLimit = require(ParentParent.flags.getFFlagUGCValidateAccessoryAssetTextureLimit)
local getFFlagUGCValidateTexturePack = require(ParentParent.flags.getFFlagUGCValidateTexturePack)
local getFFlagUGCValidateMigrateSchemaProperties = require(ParentParent.flags.getFFlagUGCValidateMigrateSchemaProperties)
local getFFlagUGCValidationCombineEntrypointResults = require(ParentParent.flags.getFFlagUGCValidationCombineEntrypointResults)
local getFFlagUGCValidateMigrateTextureTransparency = require(ParentParent.flags.getFFlagUGCValidateMigrateTextureTransparency)
local getFFlagUGCValidateMigrateSurfaceAppearanceMeshQuality = require(ParentParent.flags.getFFlagUGCValidateMigrateSurfaceAppearanceMeshQuality)
local getFFlagUGCValidateMigrateMeshGeometry = require(ParentParent.flags.getFFlagUGCValidateMigrateMeshGeometry)
local v47 = game:DefineFastFlag("MeshpartAccessoryCheckAvatarPartScaleType", false)

local function validateMeshPartAccessory(p1) -- line: 59
	-- upvalues: RigidOrLayeredAllowed (copy), Analytics (copy), Constants (copy), validateSingleInstance (copy), createMeshPartAccessorySchema (copy), validateInstanceTree (copy), getEngineFeatureEngineUGCValidatePropertiesSensible (copy), ValidatePropertiesSensible (copy), getFFlagUGCValidateMigrateSchemaProperties (copy), getFFlagUGCValidationCombineEntrypointResults (copy), validateDependencies (copy), FailureReasonsAccumulator (copy), getEditableMeshFromContext (copy), getEditableImageFromContext (copy), pcallDeferred (copy), getMeshSize (copy), getExpectedPartSize (copy), getAttachment (copy), validateMaterials (copy), validatePropertyRequirements (copy), validateTags (copy), validateAttributes (copy), getFFlagUGCValidateMigrateTextureTransparency (copy), getFFlagUGCValidateAccessoryAssetTextureLimit (copy), ConstantsInterface (copy), validateTextureSize (copy), validateThumbnailConfiguration (copy), validateModeration (copy), v47 (copy), getAccessoryScale (copy), getFFlagUGCValidateMigrateMeshGeometry (copy), validateTotalSurfaceArea (copy), ValidateMeshSizeProperty (copy), validateMeshBounds (copy), validateMeshTriangles (copy), getFFlagUGCValidateMigrateSurfaceAppearanceMeshQuality (copy), validateMeshVertColors (copy), validateCoplanarIntersection (copy), validateSurfaceAppearances (copy), validateSurfaceAppearanceTextureSize (copy), validateSurfaceAppearanceTransparency (copy), getFFlagUGCValidateTexturePack (copy), ValidateTexturePack (copy), getEngineFeatureEngineUGCValidateRigidNonSkinned (copy), validateRigidMeshNotSkinned (copy), validateScaleType (copy)
	assert(p1.assetTypeEnum ~= nil, "assetTypeEnum required in validationContext for validateMeshPartAccessory")

	local instances = p1.instances
	local assetTypeEnum = p1.assetTypeEnum
	local isServer = p1.isServer
	local allowUnreviewedAssets = p1.allowUnreviewedAssets

	if not RigidOrLayeredAllowed.isRigidAccessoryAllowed(assetTypeEnum) then
		Analytics.reportFailure(Analytics.ErrorType.validateLegacyAccessory_AssetTypeNotAllowedAsRigidAccessory, nil, p1)

		return false, { string.format("Asset type '%s' is not a rigid accessory category. It can only be used with layered clothing.", assetTypeEnum.Name) }
	end

	local v54 = Constants.ASSET_TYPE_INFO[assetTypeEnum]
	local v55, v56 = validateSingleInstance(instances, p1)

	if not v55 then
		return false, v56
	end

	local v57 = instances[1]
	local v58 = createMeshPartAccessorySchema(v54.attachmentNames)
	local v59, v60 = validateInstanceTree(v58, v57, p1)

	if not v59 then
		return false, v60
	end

	if getEngineFeatureEngineUGCValidatePropertiesSensible() then
		local v61, v62 = ValidatePropertiesSensible.validate(v57, p1)

		if not v61 then
			return false, v62
		end
	end

	local t1 = {
		skipExistenceCheck = getFFlagUGCValidateMigrateSchemaProperties() and getFFlagUGCValidationCombineEntrypointResults(),
		skipOwnershipCheck = getFFlagUGCValidateMigrateSchemaProperties() and getFFlagUGCValidationCombineEntrypointResults()
	}
	local v64, v65 = validateDependencies(v57, p1, t1)

	if not v64 then
		return false, v65
	end

	local Handle = v57:FindFirstChild("Handle")
	local t2 = {
		fieldName = "MeshId",
		fullName = Handle:GetFullName(),
		contentId = Handle.MeshId,
		context = v57.Name
	}
	local v68 = FailureReasonsAccumulator.new()

	if Handle.DoubleSided then
		v68:updateReasons(false, { string.format("MeshPart '%s' is double-sided. Double-sided meshes are not allowed in rigid accessories.", Handle:GetFullName()) })
		Analytics.reportFailure(Analytics.ErrorType.validateMeshPartAccessory_DoubleSided, nil, p1)
	end

	if t2.contentId ~= nil then
		if t2.contentId == "" then
		end
	end

	local v69, v70 = getEditableMeshFromContext(Handle, "MeshId", p1)

	if not v69 then
		if t2.contentId then
			Analytics.reportFailure(Analytics.ErrorType.validateMeshPartAccessory_FailedToLoadMesh, nil, p1)

			return false, { string.format("Failed to load mesh for accessory '%s'. Make sure mesh exists and try again.", v57.Name) }
		end

		Analytics.reportFailure(Analytics.ErrorType.validateMeshPartAccessory_NoMeshId, nil, p1)
		v68:updateReasons(false, { string.format("Accessory MeshPart '%s' must contain a valid meshId. Make sure the mesh referred to by the meshId exists and try again.", Handle:GetFullName()) })
	end

	t2.editableMesh = v70

	local TextureID = Handle.TextureID
	local t3 = {
		fieldName = "TextureID",
		fullName = Handle:GetFullName(),
		contentId = TextureID
	}
	local _, v74 = getEditableImageFromContext(Handle, "TextureID", p1)

	t3.editableImage = v74

	local v75, v76 = pcallDeferred(function() -- line: 183
		-- upvalues: getMeshSize (copy), t2 (copy)
		return getMeshSize(t2)
	end, p1)

	if not v75 then
		Analytics.reportFailure(Analytics.ErrorType.validateMeshPartAccessory_FailedToLoadMesh, nil, p1)

		return false, { string.format("Failed to load mesh for accessory '%s'. Make sure mesh exists and try again.", v57.Name) }
	end

	local v77 = getExpectedPartSize(Handle, p1) / v76
	local v78 = getAttachment(Handle, v54.attachmentNames)

	assert(v78)

	local v79 = assert(v54.bounds[v78.Name], "Could not find bounds for " .. v78.Name)

	if not getFFlagUGCValidateMigrateSchemaProperties() or not getFFlagUGCValidationCombineEntrypointResults() then
		v68:updateReasons(validateMaterials(v57, p1))
		v68:updateReasons(validatePropertyRequirements(v57, nil, p1))
	end

	v68:updateReasons(validateTags(v57, p1))

	if not getFFlagUGCValidateMigrateSchemaProperties() or not getFFlagUGCValidationCombineEntrypointResults() then
		v68:updateReasons(validateAttributes(v57, p1))
	end

	if not getFFlagUGCValidateMigrateTextureTransparency() then
		local v80 = nil

		if getFFlagUGCValidateAccessoryAssetTextureLimit() then
			v80 = ConstantsInterface.getTextureLimit(assetTypeEnum, Handle, t3.fieldName)
		end

		v68:updateReasons(validateTextureSize(t3, true, p1, v80))
	end

	if not getFFlagUGCValidateMigrateSchemaProperties() or not getFFlagUGCValidationCombineEntrypointResults() then
		v68:updateReasons(validateThumbnailConfiguration(v57, Handle, t2, v77, p1))
	end

	if not getFFlagUGCValidateMigrateSchemaProperties() or not getFFlagUGCValidationCombineEntrypointResults() then
		local v81 = not isServer

		if allowUnreviewedAssets then
			v81 = false
		end

		if v81 then
			v68:updateReasons(validateModeration(v57, {}, p1))
		end
	end

	if v47 and Handle:FindFirstChild("AvatarPartScaleType") then
		local v82 = getAccessoryScale(Handle, v78)

		v79 = {
			size = v79.size / v82,
			offset = if not v79.offset then nil else v79.offset / v82
		}
	end

	if true then
		if not getFFlagUGCValidateMigrateMeshGeometry() then
			v68:updateReasons(validateTotalSurfaceArea(t2, v77, p1))
		end

		v68:updateReasons(ValidateMeshSizeProperty.validateSingleMeshPart(Handle, p1))

		if not getFFlagUGCValidateMigrateMeshGeometry() then
			v68:updateReasons(validateMeshBounds(Handle, v78, t2, v77, v79, assetTypeEnum.Name, p1))
		end

		if not getFFlagUGCValidateMigrateMeshGeometry() then
			v68:updateReasons(validateMeshTriangles(t2, nil, p1))
		end

		if not getFFlagUGCValidateMigrateSurfaceAppearanceMeshQuality() then
			v68:updateReasons(validateMeshVertColors(t2, false, p1))
		end

		if not getFFlagUGCValidateMigrateSurfaceAppearanceMeshQuality() then
			v68:updateReasons(validateCoplanarIntersection(t2, v77, p1))
		end
	end

	if not getFFlagUGCValidateMigrateSurfaceAppearanceMeshQuality() then
		v68:updateReasons(validateSurfaceAppearances(v57, p1))
	end

	if not getFFlagUGCValidateMigrateTextureTransparency() then
		v68:updateReasons(validateSurfaceAppearanceTextureSize(v57, p1))
		v68:updateReasons(validateSurfaceAppearanceTransparency(v57, p1))
	end

	if not getFFlagUGCValidateMigrateSurfaceAppearanceMeshQuality() and getFFlagUGCValidateTexturePack() then
		v68:updateReasons(ValidateTexturePack.validate(v57, false, p1))
	end

	if getEngineFeatureEngineUGCValidateRigidNonSkinned() and not p1.allowEditableInstances then
		v68:updateReasons(validateRigidMeshNotSkinned(t2.contentId, p1))
	end

	if not getFFlagUGCValidateMigrateSchemaProperties() or not getFFlagUGCValidationCombineEntrypointResults() then
		local AvatarPartScaleType = Handle:FindFirstChild("AvatarPartScaleType")

		if AvatarPartScaleType and AvatarPartScaleType:IsA("StringValue") then
			v68:updateReasons(validateScaleType(AvatarPartScaleType, p1))
		end
	end

	return v68:getFinalResults()
end

return validateMeshPartAccessory
