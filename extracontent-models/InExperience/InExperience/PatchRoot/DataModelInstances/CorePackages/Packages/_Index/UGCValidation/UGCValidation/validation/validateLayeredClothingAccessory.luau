local ParentParent = script.Parent.Parent

require(ParentParent.util.Types)

local Analytics = require(ParentParent.Analytics)
local Constants = require(ParentParent.Constants)
local ConstantsInterface = require(ParentParent.ConstantsInterface)
local validateLCCageQuality = require(ParentParent.validation.validateLCCageQuality)
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
local validateHSR = require(ParentParent.validation.validateHSR)
local validateThumbnailConfiguration = require(ParentParent.validation.validateThumbnailConfiguration)
local validateScaleType = require(ParentParent.validation.validateScaleType)
local validateLayeredClothingInRenderBounds = require(ParentParent.validation.validateLayeredClothingInRenderBounds)
local ValidateMeshSizeProperty = require(ParentParent.validation.ValidateMeshSizeProperty)
local ValidatePropertiesSensible = require(ParentParent.validation.ValidatePropertiesSensible)
local validateDependencies = require(ParentParent.validation.validateDependencies)
local validateSkinningTransfer = require(ParentParent.validation.validateSkinningTransfer)
local validateTotalSurfaceArea = require(ParentParent.validation.validateTotalSurfaceArea)
local validateCoplanarIntersection = require(ParentParent.validation.validateCoplanarIntersection)
local validateMaxCubeDensity = require(ParentParent.validation.validateMaxCubeDensity)
local ValidateHSRData = require(ParentParent.validation.ValidateHSRData)
local validateSurfaceAppearanceTextureSize = require(ParentParent.validation.validateSurfaceAppearanceTextureSize)
local ValidateTexturePack = require(ParentParent.validation.ValidateTexturePack)
local RigidOrLayeredAllowed = require(ParentParent.util.RigidOrLayeredAllowed)
local createLayeredClothingSchema = require(ParentParent.util.createLayeredClothingSchema)
local createEyebrowEyelashSchema = require(ParentParent.util.createEyebrowEyelashSchema)
local getAttachment = require(ParentParent.util.getAttachment)
local getMeshSize = require(ParentParent.util.getMeshSize)
local getEditableMeshFromContext = require(ParentParent.util.getEditableMeshFromContext)
local getEditableImageFromContext = require(ParentParent.util.getEditableImageFromContext)
local getExpectedPartSize = require(ParentParent.util.getExpectedPartSize)
local pcallDeferred = require(ParentParent.util.pcallDeferred)
local getFIntUGCValidationLCHandleScaleOffsetMaximum = require(ParentParent.flags.getFIntUGCValidationLCHandleScaleOffsetMaximum)
local getEngineFeatureEngineUGCValidatePropertiesSensible = require(ParentParent.flags.getEngineFeatureEngineUGCValidatePropertiesSensible)
local getFFlagUGCValidateAccessoryAssetTextureLimit = require(ParentParent.flags.getFFlagUGCValidateAccessoryAssetTextureLimit)
local getFFlagUGCValidateLayeredClothingAssetSurfaceAppearanceTextureLimits = require(ParentParent.flags.getFFlagUGCValidateLayeredClothingAssetSurfaceAppearanceTextureLimits)
local getFFlagUGCValidateTexturePack = require(ParentParent.flags.getFFlagUGCValidateTexturePack)
local getFFlagUGCValidateEyebrowEyelashThumbnailSchema = require(ParentParent.flags.getFFlagUGCValidateEyebrowEyelashThumbnailSchema)
local ValidateMeshPartOnlySkinnedToR15 = require(ParentParent.validation.ValidateMeshPartOnlySkinnedToR15)
local getEngineFeatureEngineUGCValidationConsolidateAccessorySkinning = require(ParentParent.flags.getEngineFeatureEngineUGCValidationConsolidateAccessorySkinning)
local getFFlagUGCValidateMigrateSchemaProperties = require(ParentParent.flags.getFFlagUGCValidateMigrateSchemaProperties)
local getFFlagUGCValidationCombineEntrypointResults = require(ParentParent.flags.getFFlagUGCValidationCombineEntrypointResults)
local getFFlagUGCValidateMigrateTextureTransparency = require(ParentParent.flags.getFFlagUGCValidateMigrateTextureTransparency)
local getFFlagUGCValidateMigrateCageGeometry = require(ParentParent.flags.getFFlagUGCValidateMigrateCageGeometry)

local function validateLayeredClothingAccessory(p1) -- line: 66
	-- upvalues: RigidOrLayeredAllowed (copy), Analytics (copy), Constants (copy), validateSingleInstance (copy), getFFlagUGCValidateEyebrowEyelashThumbnailSchema (copy), createEyebrowEyelashSchema (copy), createLayeredClothingSchema (copy), validateInstanceTree (copy), getEngineFeatureEngineUGCValidatePropertiesSensible (copy), ValidatePropertiesSensible (copy), getFFlagUGCValidateMigrateSchemaProperties (copy), getFFlagUGCValidationCombineEntrypointResults (copy), validateDependencies (copy), getEditableMeshFromContext (copy), getEditableImageFromContext (copy), pcallDeferred (copy), getMeshSize (copy), getExpectedPartSize (copy), getFIntUGCValidationLCHandleScaleOffsetMaximum (copy), getAttachment (copy), validateMaterials (copy), validatePropertyRequirements (copy), validateTags (copy), validateAttributes (copy), getFFlagUGCValidateMigrateTextureTransparency (copy), getFFlagUGCValidateAccessoryAssetTextureLimit (copy), ConstantsInterface (copy), validateTextureSize (copy), getFFlagUGCValidateLayeredClothingAssetSurfaceAppearanceTextureLimits (copy), validateSurfaceAppearanceTextureSize (copy), validateScaleType (copy), validateThumbnailConfiguration (copy), validateHSR (copy), ValidateHSRData (copy), validateModeration (copy), validateTotalSurfaceArea (copy), ValidateMeshSizeProperty (copy), validateMeshBounds (copy), validateMeshTriangles (copy), validateMeshVertColors (copy), validateCoplanarIntersection (copy), validateMaxCubeDensity (copy), validateLCCageQuality (copy), getFFlagUGCValidateMigrateCageGeometry (copy), validateLayeredClothingInRenderBounds (copy), getFFlagUGCValidateTexturePack (copy), ValidateTexturePack (copy), getEngineFeatureEngineUGCValidationConsolidateAccessorySkinning (copy), validateSkinningTransfer (copy), ValidateMeshPartOnlySkinnedToR15 (copy)
	local instances = p1.instances
	local assetTypeEnum = p1.assetTypeEnum
	local isServer = p1.isServer
	local allowUnreviewedAssets = p1.allowUnreviewedAssets

	if not RigidOrLayeredAllowed.isLayeredClothingAllowed(assetTypeEnum) then
		Analytics.reportFailure(Analytics.ErrorType.validateLayeredClothingAccessory_AssetTypeNotAllowedAsLayeredClothing, nil, p1)

		return false, { string.format("Asset type '%s' is not a layered clothing category. It can only be used with rigid accessories.", assetTypeEnum.Name) }
	end

	local v58 = Constants.ASSET_TYPE_INFO[assetTypeEnum]
	local v59, v60 = validateSingleInstance(instances, p1)

	if not v59 then
		return false, v60
	end

	local v61 = instances[1]
	local v62 = not not getFFlagUGCValidateEyebrowEyelashThumbnailSchema() and (assetTypeEnum == Enum.AssetType.EyebrowAccessory or assetTypeEnum == Enum.AssetType.EyelashAccessory)
	local v63 = if not v62 then createLayeredClothingSchema(v58.attachmentNames) else createEyebrowEyelashSchema(v58.attachmentNames)
	local v64, v65 = validateInstanceTree(v63, v61, p1)

	if not v64 then
		return false, v65
	end

	if getEngineFeatureEngineUGCValidatePropertiesSensible() then
		local v66, v67 = ValidatePropertiesSensible.validate(v61, p1)

		if not v66 then
			return false, v67
		end
	end

	local t1 = {
		skipExistenceCheck = getFFlagUGCValidateMigrateSchemaProperties() and getFFlagUGCValidationCombineEntrypointResults(),
		skipOwnershipCheck = getFFlagUGCValidateMigrateSchemaProperties() and getFFlagUGCValidationCombineEntrypointResults()
	}
	local v69, v70 = validateDependencies(v61, p1, t1)

	if not v69 then
		return false, v70
	end

	local v71 = true
	local t2 = {}
	local Handle = v61:FindFirstChild("Handle")
	local t3 = {
		fieldName = "MeshId",
		fullName = Handle:GetFullName(),
		contentId = Handle.MeshId,
		context = v61.Name
	}

	if t3.contentId ~= nil then
		if t3.contentId == "" then
		end
	end

	local v75, v76 = getEditableMeshFromContext(Handle, "MeshId", p1)

	if not v75 then
		if t3.contentId then
			Analytics.reportFailure(Analytics.ErrorType.validateLayeredClothingAccessory_FailedToLoadMesh, nil, p1)

			return false, { string.format("Failed to load mesh for layered clothing accessory '%s'. Make sure mesh exists and try again.", v61.Name) }
		end

		Analytics.reportFailure(Analytics.ErrorType.validateLayeredClothingAccessory_NoMeshId, nil, p1)
		v71 = false
		table.insert(t2, { string.format("Missing meshId on layered clothing accessory '%s'. Make sure you are using a valid meshId and try again.\n", v61.Name) })
	end

	t3.editableMesh = v76

	local TextureID = Handle.TextureID
	local t4 = {
		fieldName = "TextureID",
		fullName = Handle:GetFullName(),
		contentId = TextureID
	}

	if TextureID ~= "" then
		local v79, v80 = getEditableImageFromContext(Handle, "TextureID", p1)

		if not v79 then
			return false, { string.format("Failed to load texture for layered clothing accessory '%s'. Make sure texture exists and try again.", v61.Name) }
		end

		t4.editableImage = v80
	end

	local v81, v82 = pcallDeferred(function() -- line: 200
		-- upvalues: getMeshSize (copy), t3 (copy)
		return getMeshSize(t3)
	end, p1)

	if not v81 then
		Analytics.reportFailure(Analytics.ErrorType.validateLayeredClothingAccessory_FailedToLoadMesh, nil, p1)

		return false, { string.format("Failed to load mesh for layered clothing accessory '%s'. Make sure mesh exists and try again.", v61.Name) }
	end

	local v83 = getExpectedPartSize(Handle, p1) / v82

	if not v83:FuzzyEq(Vector3.new(1, 1, 1), getFIntUGCValidationLCHandleScaleOffsetMaximum() / 1000) then
		Analytics.reportFailure(Analytics.ErrorType.validateLayeredClothingAccessory_HandleIsScaled, nil, p1)
		table.insert(t2, string.format("%s has been scaled, but mesh parts with wrap layers do not support scaling. You need to change the Size property to match the MeshSize property.", Handle.Name))
		v71 = false
	end

	local v84 = getAttachment(Handle, v58.attachmentNames)
	local v85 = v58.bounds[v84.Name]

	if not getFFlagUGCValidateMigrateSchemaProperties() or not getFFlagUGCValidationCombineEntrypointResults() then
		local v86, v87 = validateMaterials(v61, p1)

		if not v86 then
			table.insert(t2, table.concat(v87, "\n"))
			v71 = false
		end

		local v88, v89 = validatePropertyRequirements(v61, nil, p1)

		if not v88 then
			table.insert(t2, table.concat(v89, "\n"))
			v71 = false
		end
	end

	local v90, v91 = validateTags(v61, p1)

	if not v90 then
		table.insert(t2, table.concat(v91, "\n"))
		v71 = false
	end

	if not getFFlagUGCValidateMigrateSchemaProperties() or not getFFlagUGCValidationCombineEntrypointResults() then
		local v92, v93 = validateAttributes(v61, p1)

		if not v92 then
			table.insert(t2, table.concat(v93, "\n"))
			v71 = false
		end
	end

	if not getFFlagUGCValidateMigrateTextureTransparency() then
		local v94 = nil

		if getFFlagUGCValidateAccessoryAssetTextureLimit() then
			v94 = ConstantsInterface.getTextureLimit(assetTypeEnum, Handle, t4.fieldName)
		end

		local v95, v96 = validateTextureSize(t4, true, p1, v94)

		if not v95 then
			table.insert(t2, table.concat(v96, "\n"))
			v71 = false
		end

		if getFFlagUGCValidateLayeredClothingAssetSurfaceAppearanceTextureLimits() then
			local v97, v98 = validateSurfaceAppearanceTextureSize(v61, p1)

			if not v97 then
				table.insert(t2, table.concat(v98, "\n"))
				v71 = false
			end
		end
	end

	if not getFFlagUGCValidateMigrateSchemaProperties() or not getFFlagUGCValidationCombineEntrypointResults() then
		local AvatarPartScaleType = Handle:FindFirstChild("AvatarPartScaleType")

		if AvatarPartScaleType and AvatarPartScaleType:IsA("StringValue") then
			local v100, v101 = validateScaleType(AvatarPartScaleType, p1)

			if not v100 then
				table.insert(t2, table.concat(v101, "\n"))
				v71 = false
			end
		end
	end

	if (not getFFlagUGCValidateMigrateSchemaProperties() or not getFFlagUGCValidationCombineEntrypointResults()) and not v62 then
		local v102, v103 = validateThumbnailConfiguration(v61, Handle, t3, v83, p1)

		if not v102 then
			table.insert(t2, table.concat(v103, "\n"))
			v71 = false
		end
	end

	local WrapLayer = Handle:FindFirstChildOfClass("WrapLayer")

	if WrapLayer == nil then
		Analytics.reportFailure(Analytics.ErrorType.validateLayeredClothingAccessory_NoWrapLayer, nil, p1)
		table.insert(t2, string.format("Missing WrapLayer on layered clothing accessory %s. You need to create a child WrapLayer and try again.", v61.Name))
		v71 = false
	else
		if not getFFlagUGCValidateMigrateSchemaProperties() or not getFFlagUGCValidationCombineEntrypointResults() then
			local v105, v106 = validateHSR(WrapLayer, p1)

			if not v105 then
				table.insert(t2, table.concat(v106, "\n"))
				v71 = false
			end
		end

		if (not getFFlagUGCValidateMigrateSchemaProperties() or not getFFlagUGCValidationCombineEntrypointResults()) and not p1.allowEditableInstances then
			local v107, v108 = ValidateHSRData.validate(WrapLayer, p1)

			if not v107 then
				table.insert(t2, table.concat(v108, "\n"))
				v71 = false
			end
		end
	end

	if not getFFlagUGCValidateMigrateSchemaProperties() or not getFFlagUGCValidationCombineEntrypointResults() then
		local v109 = not isServer

		if allowUnreviewedAssets then
			v109 = false
		end

		if v109 then
			local v110, v111 = validateModeration(v61, {}, p1)

			if not v110 then
				table.insert(t2, table.concat(v111, "\n"))
				v71 = false
			end
		end
	end

	if true then
		local v112, v113 = validateTotalSurfaceArea(t3, v83, p1)

		if not v112 then
			table.insert(t2, table.concat(v113, "\n"))
			v71 = false
		end

		local v114, v115 = ValidateMeshSizeProperty.validateSingleMeshPart(Handle, p1)

		if not v114 then
			table.insert(t2, table.concat(v115, "\n"))
			v71 = false
		end

		local v116, v117 = validateMeshBounds(Handle, v84, t3, v83, v85, assetTypeEnum.Name, p1)

		if not v116 then
			table.insert(t2, table.concat(v117, "\n"))
			v71 = false
		end

		local v118, v119 = validateMeshTriangles(t3, nil, p1)

		if not v118 then
			table.insert(t2, table.concat(v119, "\n"))
			v71 = false
		end

		local v120, v121 = validateMeshVertColors(t3, false, p1)

		if not v120 then
			table.insert(t2, table.concat(v121, "\n"))
			v71 = false
		end

		local v122, v123 = validateCoplanarIntersection(t3, v83, p1)

		if not v122 then
			table.insert(t2, table.concat(v123, "\n"))
			v71 = false
		end
	end

	local v124, v125 = validateMaxCubeDensity(t3, p1, v83)

	if not v124 then
		table.insert(t2, table.concat(v125, "\n"))
		v71 = false
	end

	local v126, v127 = validateLCCageQuality(v61, t3, p1)

	if not v126 then
		for _, v129 in v127 do
			table.insert(t2, v129)
		end

		v71 = false
	end

	if not getFFlagUGCValidateMigrateCageGeometry() then
		local v130, v131 = validateLayeredClothingInRenderBounds(v61, p1)

		if not v130 then
			table.insert(t2, table.concat(v131, "\n"))
			v71 = false
		end
	end

	if getFFlagUGCValidateTexturePack() then
		local v132, v133 = ValidateTexturePack.validate(v61, false, p1)

		if not v132 then
			table.insert(t2, table.concat(v133, "\n"))
			v71 = false
		end
	end

	if not getEngineFeatureEngineUGCValidationConsolidateAccessorySkinning() then
		local v134, v135 = validateSkinningTransfer(Handle, p1)

		if not v134 then
			table.insert(t2, table.concat(v135, "\n"))
			v71 = false
		end

		if not Constants.SkinningTransferRequiredTypes[assetTypeEnum] then
			local v136, v137 = ValidateMeshPartOnlySkinnedToR15.validateMeshPart(Handle, p1)

			if not v136 then
				table.insert(t2, table.concat(v137, "\n"))
				v71 = false
			end
		end
	end

	return v71, t2
end

return validateLayeredClothingAccessory
