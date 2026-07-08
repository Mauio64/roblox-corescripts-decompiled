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
local validateScaleType = require(ParentParent.validation.validateScaleType)
local validateTotalSurfaceArea = require(ParentParent.validation.validateTotalSurfaceArea)
local validateRigidMeshNotSkinned = require(ParentParent.validation.validateRigidMeshNotSkinned)
local validateDependencies = require(ParentParent.validation.validateDependencies)
local ValidatePropertiesSensible = require(ParentParent.validation.ValidatePropertiesSensible)
local RigidOrLayeredAllowed = require(ParentParent.util.RigidOrLayeredAllowed)
local createAccessorySchema = require(ParentParent.util.createAccessorySchema)
local getAttachment = require(ParentParent.util.getAttachment)
local getAccessoryScale = require(ParentParent.util.getAccessoryScale)
local getEditableMeshFromContext = require(ParentParent.util.getEditableMeshFromContext)
local getEditableImageFromContext = require(ParentParent.util.getEditableImageFromContext)
local getEngineFeatureEngineUGCValidateRigidNonSkinned = require(ParentParent.flags.getEngineFeatureEngineUGCValidateRigidNonSkinned)
local getEngineFeatureEngineUGCValidatePropertiesSensible = require(ParentParent.flags.getEngineFeatureEngineUGCValidatePropertiesSensible)
local getFFlagUGCValidateAccessoryAssetTextureLimit = require(ParentParent.flags.getFFlagUGCValidateAccessoryAssetTextureLimit)
local getFFlagUGCValidateMigrateSchemaProperties = require(ParentParent.flags.getFFlagUGCValidateMigrateSchemaProperties)
local getFFlagUGCValidationCombineEntrypointResults = require(ParentParent.flags.getFFlagUGCValidationCombineEntrypointResults)
local getFFlagUGCValidateMigrateTextureTransparency = require(ParentParent.flags.getFFlagUGCValidateMigrateTextureTransparency)
local getFFlagUGCValidateMigrateSurfaceAppearanceMeshQuality = require(ParentParent.flags.getFFlagUGCValidateMigrateSurfaceAppearanceMeshQuality)
local getFFlagUGCValidateMigrateMeshGeometry = require(ParentParent.flags.getFFlagUGCValidateMigrateMeshGeometry)
local v37 = game:DefineFastFlag("LegacyAccessoryCheckAvatarPartScaleType", false)

local function validateLegacyAccessory(p1) -- line: 50
	-- upvalues: RigidOrLayeredAllowed (copy), Analytics (copy), Constants (copy), validateSingleInstance (copy), createAccessorySchema (copy), validateInstanceTree (copy), getEngineFeatureEngineUGCValidatePropertiesSensible (copy), ValidatePropertiesSensible (copy), getFFlagUGCValidateMigrateSchemaProperties (copy), getFFlagUGCValidationCombineEntrypointResults (copy), validateDependencies (copy), getAttachment (copy), getEditableMeshFromContext (copy), getEditableImageFromContext (copy), validateMaterials (copy), validatePropertyRequirements (copy), validateTags (copy), validateAttributes (copy), getFFlagUGCValidateMigrateTextureTransparency (copy), getFFlagUGCValidateAccessoryAssetTextureLimit (copy), ConstantsInterface (copy), validateTextureSize (copy), validateScaleType (copy), validateThumbnailConfiguration (copy), validateModeration (copy), getFFlagUGCValidateMigrateMeshGeometry (copy), validateTotalSurfaceArea (copy), v37 (copy), getAccessoryScale (copy), validateMeshBounds (copy), validateMeshTriangles (copy), getFFlagUGCValidateMigrateSurfaceAppearanceMeshQuality (copy), validateMeshVertColors (copy), validateCoplanarIntersection (copy), getEngineFeatureEngineUGCValidateRigidNonSkinned (copy), validateRigidMeshNotSkinned (copy)
	local instances = p1.instances
	local assetTypeEnum = p1.assetTypeEnum
	local isServer = p1.isServer
	local allowUnreviewedAssets = p1.allowUnreviewedAssets

	if not RigidOrLayeredAllowed.isRigidAccessoryAllowed(assetTypeEnum) then
		Analytics.reportFailure(Analytics.ErrorType.validateLegacyAccessory_AssetTypeNotAllowedAsRigidAccessory, nil, p1)

		return false, { string.format("Asset type '%s' is not a rigid accessory category. It can only be used with layered clothing.", assetTypeEnum.Name) }
	end

	local v44 = Constants.ASSET_TYPE_INFO[assetTypeEnum]
	local v45, v46 = validateSingleInstance(instances, p1)

	if not v45 then
		return false, v46
	end

	local v47 = instances[1]
	local v48 = createAccessorySchema(v44.attachmentNames)
	local v49, v50 = validateInstanceTree(v48, v47, p1)

	if not v49 then
		return false, v50
	end

	if getEngineFeatureEngineUGCValidatePropertiesSensible() then
		local v51, v52 = ValidatePropertiesSensible.validate(v47, p1)

		if not v51 then
			return false, v52
		end
	end

	local t1 = {
		skipExistenceCheck = getFFlagUGCValidateMigrateSchemaProperties() and getFFlagUGCValidationCombineEntrypointResults(),
		skipOwnershipCheck = getFFlagUGCValidateMigrateSchemaProperties() and getFFlagUGCValidationCombineEntrypointResults()
	}
	local v54, v55 = validateDependencies(v47, p1, t1)

	if not v54 then
		return false, v55
	end

	local Handle = v47:FindFirstChild("Handle")
	local SpecialMesh = Handle:FindFirstChildOfClass("SpecialMesh")
	local t2 = {
		fieldName = "MeshId",
		fullName = SpecialMesh:GetFullName(),
		contentId = SpecialMesh.MeshId,
		context = v47.Name
	}
	local SpecialMeshScale = SpecialMesh.Scale
	local v60 = getAttachment(Handle, v44.attachmentNames)
	local v61 = assert(v44.bounds[v60.Name], "Could not find bounds for " .. v60.Name)
	local v62 = true
	local t3 = {}

	if t2.contentId ~= nil then
		if t2.contentId == "" then
		end
	end

	local v64, v65 = getEditableMeshFromContext(SpecialMesh, "MeshId", p1)

	if not v64 then
		if t2.contentId then
			return false, { string.format("Failed to load mesh for legacy accessory '%s'. Make sure mesh exists and try again.", v47.Name) }
		end

		v62 = false
		table.insert(t3, { string.format("Missing meshId on legacy accessory '%s'. Make sure you are using a valid meshId and try again.\n", v47.Name) })
	end

	t2.editableMesh = v65

	local t4 = {
		fieldName = "TextureId",
		fullName = SpecialMesh:GetFullName(),
		contentId = SpecialMesh.TextureId
	}
	local v67, v68 = getEditableImageFromContext(SpecialMesh, "TextureId", p1)

	if not v67 then
		return false, { string.format("Failed to load texture for legacy accessory '%s'. Make sure texture exists and try again.", v47.Name) }
	end

	t4.editableImage = v68

	if not getFFlagUGCValidateMigrateSchemaProperties() or not getFFlagUGCValidationCombineEntrypointResults() then
		local v69, v70 = validateMaterials(v47, p1)

		if not v69 then
			table.insert(t3, table.concat(v70, "\n"))
			v62 = false
		end

		local v71, v72 = validatePropertyRequirements(v47, nil, p1)

		if not v71 then
			table.insert(t3, table.concat(v72, "\n"))
			v62 = false
		end
	end

	local v73, v74 = validateTags(v47, p1)

	if not v73 then
		table.insert(t3, table.concat(v74, "\n"))
		v62 = false
	end

	if not getFFlagUGCValidateMigrateSchemaProperties() or not getFFlagUGCValidationCombineEntrypointResults() then
		local v75, v76 = validateAttributes(v47, p1)

		if not v75 then
			table.insert(t3, table.concat(v76, "\n"))
			v62 = false
		end
	end

	if not getFFlagUGCValidateMigrateTextureTransparency() then
		local v77 = nil

		if getFFlagUGCValidateAccessoryAssetTextureLimit() then
			v77 = ConstantsInterface.getTextureLimit(assetTypeEnum, SpecialMesh, t4.fieldName)
		end

		local v78, v79 = validateTextureSize(t4, nil, p1, v77)

		if not v78 then
			table.insert(t3, table.concat(v79, "\n"))
			v62 = false
		end
	end

	local AvatarPartScaleType = Handle:FindFirstChild("AvatarPartScaleType")

	if AvatarPartScaleType and AvatarPartScaleType:IsA("StringValue") then
		local v81, v82 = validateScaleType(AvatarPartScaleType, p1)

		if not v81 then
			table.insert(t3, table.concat(v82, "\n"))
			v62 = false
		end
	end

	local v83, v84 = validateThumbnailConfiguration(v47, Handle, t2, SpecialMeshScale, p1)

	if not v83 then
		table.insert(t3, table.concat(v84, "\n"))
		v62 = false
	end

	if not getFFlagUGCValidateMigrateSchemaProperties() or not getFFlagUGCValidationCombineEntrypointResults() then
		local v85 = not isServer

		if allowUnreviewedAssets then
			v85 = false
		end

		if v85 then
			local v86, v87 = validateModeration(v47, {}, p1)

			if not v86 then
				table.insert(t3, table.concat(v87, "\n"))
				v62 = false
			end
		end
	end

	if true then
		if not getFFlagUGCValidateMigrateMeshGeometry() then
			local v88, v89 = validateTotalSurfaceArea(t2, SpecialMeshScale, p1)

			if not v88 then
				table.insert(t3, table.concat(v89, "\n"))
				v62 = false
			end
		end

		if v37 and Handle:FindFirstChild("AvatarPartScaleType") then
			local v90 = getAccessoryScale(Handle, v60)

			v61 = {
				size = v61.size / v90,
				offset = if not v61.offset then nil else v61.offset / v90
			}
		end

		if not getFFlagUGCValidateMigrateMeshGeometry() then
			local v91, v92 = validateMeshBounds(Handle, v60, t2, SpecialMeshScale, v61, assetTypeEnum.Name, p1)

			if not v91 then
				table.insert(t3, table.concat(v92, "\n"))
				v62 = false
			end
		end

		if not getFFlagUGCValidateMigrateMeshGeometry() then
			local v93, v94 = validateMeshTriangles(t2, nil, p1)

			if not v93 then
				table.insert(t3, table.concat(v94, "\n"))
				v62 = false
			end
		end

		if not getFFlagUGCValidateMigrateSurfaceAppearanceMeshQuality() then
			local v95, v96 = validateMeshVertColors(t2, false, p1)

			if not v95 then
				table.insert(t3, table.concat(v96, "\n"))
				v62 = false
			end
		end

		if not getFFlagUGCValidateMigrateSurfaceAppearanceMeshQuality() then
			local v97, v98 = validateCoplanarIntersection(t2, SpecialMeshScale, p1)

			if not v97 then
				table.insert(t3, table.concat(v98, "\n"))
				v62 = false
			end
		end

		if getEngineFeatureEngineUGCValidateRigidNonSkinned() then
			local v99, v100 = validateRigidMeshNotSkinned(t2.contentId, p1)

			if not v99 then
				table.insert(t3, table.concat(v100, "\n"))
				v62 = false
			end
		end
	end

	return v62, t3
end

return validateLegacyAccessory
