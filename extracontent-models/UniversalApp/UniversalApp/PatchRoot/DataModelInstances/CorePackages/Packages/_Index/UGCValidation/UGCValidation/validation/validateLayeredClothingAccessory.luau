local parent = script.Parent.Parent

require(parent.util.Types)
local Analytics = require(parent.Analytics)
local Constants = require(parent.Constants)

local validateLCCageQuality = require(parent.validation.validateLCCageQuality)
local validateInstanceTree = require(parent.validation.validateInstanceTree)
local validateMeshTriangles = require(parent.validation.validateMeshTriangles)
local validateTags = require(parent.validation.validateTags)
local validateMeshBounds = require(parent.validation.validateMeshBounds)
local validateMeshVertColors = require(parent.validation.validateMeshVertColors)
local validateSingleInstance = require(parent.validation.validateSingleInstance)
local ValidateMeshSizeProperty = require(parent.validation.ValidateMeshSizeProperty)
local ValidatePropertiesSensible = require(parent.validation.ValidatePropertiesSensible)
local validateDependencies = require(parent.validation.validateDependencies)
local validateSkinningTransfer = require(parent.validation.validateSkinningTransfer)

local validateTotalSurfaceArea = require(parent.validation.validateTotalSurfaceArea)
local validateCoplanarIntersection = require(parent.validation.validateCoplanarIntersection)
local validateMaxCubeDensity = require(parent.validation.validateMaxCubeDensity)
local ValidateTexturePack = require(parent.validation.ValidateTexturePack)

local RigidOrLayeredAllowed = require(parent.util.RigidOrLayeredAllowed)
local createLayeredClothingSchema = require(parent.util.createLayeredClothingSchema)
local createEyebrowEyelashSchema = require(parent.util.createEyebrowEyelashSchema)
local getAttachment = require(parent.util.getAttachment)
local getMeshSize = require(parent.util.getMeshSize)
local getEditableMeshFromContext = require(parent.util.getEditableMeshFromContext)
local getEditableImageFromContext = require(parent.util.getEditableImageFromContext)
local getExpectedPartSize = require(parent.util.getExpectedPartSize)
local pcallDeferred = require(parent.util.pcallDeferred)

local getFIntUGCValidationLCHandleScaleOffsetMaximum = require(parent.flags.getFIntUGCValidationLCHandleScaleOffsetMaximum)

local getEngineFeatureEngineUGCValidatePropertiesSensible = require(parent.flags.getEngineFeatureEngineUGCValidatePropertiesSensible)
local getFFlagUGCValidateTexturePack = require(parent.flags.getFFlagUGCValidateTexturePack)

local getFFlagUGCValidateEyebrowEyelashThumbnailSchema = require(parent.flags.getFFlagUGCValidateEyebrowEyelashThumbnailSchema)

local ValidateMeshPartOnlySkinnedToR15 = require(parent.validation.ValidateMeshPartOnlySkinnedToR15)

local getEngineFeatureEngineUGCValidationConsolidateAccessorySkinning = require(parent.flags.getEngineFeatureEngineUGCValidationConsolidateAccessorySkinning)

local function validateLayeredClothingAccessory(p)
	local instances = p.instances
	local assetTypeEnum = p.assetTypeEnum

	if not RigidOrLayeredAllowed.isLayeredClothingAllowed(assetTypeEnum) then
		Analytics.reportFailure(
			Analytics.ErrorType.validateLayeredClothingAccessory_AssetTypeNotAllowedAsLayeredClothing,
			nil,
			p
		)

		return
			false,
			{ string.format(
					"Asset type '%s' is not a layered clothing category. It can only be used with rigid accessories.",
					assetTypeEnum.Name
				) }
	end

	local v = Constants.ASSET_TYPE_INFO[assetTypeEnum]

	local v2, v3 = validateSingleInstance(instances, p)

	if not v2 then
		return false, v3
	end

	local instance = instances[1]
	local v4

	if getFFlagUGCValidateEyebrowEyelashThumbnailSchema() then
		v4 = assetTypeEnum == Enum.AssetType.EyebrowAccessory or assetTypeEnum == Enum.AssetType.EyelashAccessory
	else
		v4 = false
	end

	local v5

	if v4 then
		v5 = createEyebrowEyelashSchema(v.attachmentNames)
	else
		v5 = createLayeredClothingSchema(v.attachmentNames)
	end

	local v6, v7 = validateInstanceTree(v5, instance, p)

	if not v6 then
		return false, v7
	end

	if getEngineFeatureEngineUGCValidatePropertiesSensible() then
		local v8, v9 = ValidatePropertiesSensible.validate(instance, p)

		if not v8 then
			return false, v9
		end
	end

	local v8, v9 = validateDependencies(instance, p, {
		skipExistenceCheck = true,
		skipOwnershipCheck = true
	})

	if not v8 then
		return false, v9
	end

	local v10 = true
	local result = {}

	local handle = instance:FindFirstChild("Handle")
	local v11 = {
		fullName = handle:GetFullName(),
		fieldName = "MeshId",
		contentId = handle.MeshId,
		context = instance.Name
	}

	if v11.contentId ~= nil then
		local _ = v11.contentId == ""
	end

	local editableMeshFromContext, editableMesh = getEditableMeshFromContext(handle, "MeshId", p)

	if not editableMeshFromContext then
		if v11.contentId then
			Analytics.reportFailure(Analytics.ErrorType.validateLayeredClothingAccessory_FailedToLoadMesh, nil, p)

			return
				false,
				{ string.format(
						"Failed to load mesh for layered clothing accessory '%s'. Make sure mesh exists and try again.",
						instance.Name
					) }
		end

		Analytics.reportFailure(Analytics.ErrorType.validateLayeredClothingAccessory_NoMeshId, nil, p)

		table.insert(result, {
			string.format(
				"Missing meshId on layered clothing accessory '%s'. Make sure you are using a valid meshId and try again.\n",
				instance.Name
			)
		})
		v10 = false
	end

	v11.editableMesh = editableMesh

	local textureID = handle.TextureID
	local v12 = { fullName = handle:GetFullName(), fieldName = "TextureID", contentId = textureID }

	if textureID ~= "" then
		local editableImageFromContext, editableImage = getEditableImageFromContext(handle, "TextureID", p)

		if not editableImageFromContext then
			return
				false,
				{ string.format(
						"Failed to load texture for layered clothing accessory '%s'. Make sure texture exists and try again.",
						instance.Name
					) }
		end

		v12.editableImage = editableImage
	end

	local v13, v14 = pcallDeferred(function()
		return getMeshSize(v11)
	end, p)

	if not v13 then
		Analytics.reportFailure(Analytics.ErrorType.validateLayeredClothingAccessory_FailedToLoadMesh, nil, p)

		return
			false,
			{ string.format(
					"Failed to load mesh for layered clothing accessory '%s'. Make sure mesh exists and try again.",
					instance.Name
				) }
	end

	local vector = getExpectedPartSize(handle, p) / v14

	if not vector:FuzzyEq(Vector3.new(1, 1, 1), getFIntUGCValidationLCHandleScaleOffsetMaximum() / 1000) then
		Analytics.reportFailure(Analytics.ErrorType.validateLayeredClothingAccessory_HandleIsScaled, nil, p)

		table.insert(
			result,
			string.format(
				"%s has been scaled, but mesh parts with wrap layers do not support scaling. You need to change the Size property to match the MeshSize property.",
				handle.Name
			)
		)
		v10 = false
	end

	local attachment = getAttachment(handle, v.attachmentNames)

	local bound = v.bounds[attachment.Name]

	local v15, v16 = validateTags(instance, p)

	if not v15 then
		table.insert(result, table.concat(v16, "\n"))
		v10 = false
	end

	if handle:FindFirstChildOfClass("WrapLayer") == nil then
		Analytics.reportFailure(Analytics.ErrorType.validateLayeredClothingAccessory_NoWrapLayer, nil, p)

		table.insert(
			result,
			string.format(
				"Missing WrapLayer on layered clothing accessory %s. You need to create a child WrapLayer and try again.",
				instance.Name
			)
		)
		v10 = false
	end

	do
		local v17, v18 = validateTotalSurfaceArea(v11, vector, p)

		if not v17 then
			table.insert(result, table.concat(v18, "\n"))
			v10 = false
		end

		local v19, v20 = ValidateMeshSizeProperty.validateSingleMeshPart(handle, p)

		if not v19 then
			table.insert(result, table.concat(v20, "\n"))
			v10 = false
		end

		local v21, v22 = validateMeshBounds(handle, attachment, v11, vector, bound, assetTypeEnum.Name, p)

		if not v21 then
			table.insert(result, table.concat(v22, "\n"))
			v10 = false
		end

		local v23, v24 = validateMeshTriangles(v11, nil, p)

		if not v23 then
			table.insert(result, table.concat(v24, "\n"))
			v10 = false
		end

		local v25, v26 = validateMeshVertColors(v11, false, p)

		if not v25 then
			table.insert(result, table.concat(v26, "\n"))
			v10 = false
		end

		local v27, v28 = validateCoplanarIntersection(v11, vector, p)

		if not v27 then
			table.insert(result, table.concat(v28, "\n"))
			v10 = false
		end
	end

	local v17, v18 = validateMaxCubeDensity(v11, p, vector)

	if not v17 then
		table.insert(result, table.concat(v18, "\n"))
		v10 = false
	end

	local v19, v20 = validateLCCageQuality(instance, v11, p)

	if not v19 then
		for _, v21 in v20 do
			table.insert(result, v21)
		end

		v10 = false
	end

	if getFFlagUGCValidateTexturePack() then
		local v21, v22 = ValidateTexturePack.validate(instance, false, p)

		if not v21 then
			table.insert(result, table.concat(v22, "\n"))
			v10 = false
		end
	end

	if getEngineFeatureEngineUGCValidationConsolidateAccessorySkinning() then
		return v10, result
	end

	local v21, v22 = validateSkinningTransfer(handle, p)

	if not v21 then
		table.insert(result, table.concat(v22, "\n"))
		v10 = false
	end

	if Constants.SkinningTransferRequiredTypes[assetTypeEnum] then
		return v10, result
	end

	local v23, v24 = ValidateMeshPartOnlySkinnedToR15.validateMeshPart(handle, p)

	if not v23 then
		table.insert(result, table.concat(v24, "\n"))
		v10 = false
	end

	return v10, result
end

return validateLayeredClothingAccessory
