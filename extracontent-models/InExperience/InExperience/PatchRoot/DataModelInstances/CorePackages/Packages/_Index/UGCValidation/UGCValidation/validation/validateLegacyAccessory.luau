local parent = script.Parent.Parent

require(parent.util.Types)
local Analytics = require(parent.Analytics)
local Constants = require(parent.Constants)

local validateInstanceTree = require(parent.validation.validateInstanceTree)
local validateTags = require(parent.validation.validateTags)
local validateSingleInstance = require(parent.validation.validateSingleInstance)
local validateThumbnailConfiguration = require(parent.validation.validateThumbnailConfiguration)
local validateScaleType = require(parent.validation.validateScaleType)
local validateDependencies = require(parent.validation.validateDependencies)
local ValidatePropertiesSensible = require(parent.validation.ValidatePropertiesSensible)

local RigidOrLayeredAllowed = require(parent.util.RigidOrLayeredAllowed)
local createAccessorySchema = require(parent.util.createAccessorySchema)
local getAttachment = require(parent.util.getAttachment)
local getEditableMeshFromContext = require(parent.util.getEditableMeshFromContext)
local getEditableImageFromContext = require(parent.util.getEditableImageFromContext)

local getEngineFeatureEngineUGCValidatePropertiesSensible = require(parent.flags.getEngineFeatureEngineUGCValidatePropertiesSensible)

local function validateLegacyAccessory(p)
	local instances = p.instances
	local assetTypeEnum = p.assetTypeEnum

	if not RigidOrLayeredAllowed.isRigidAccessoryAllowed(assetTypeEnum) then
		Analytics.reportFailure(Analytics.ErrorType.validateLegacyAccessory_AssetTypeNotAllowedAsRigidAccessory, nil, p)

		return
			false,
			{ string.format(
					"Asset type '%s' is not a rigid accessory category. It can only be used with layered clothing.",
					assetTypeEnum.Name
				) }
	end

	local v = Constants.ASSET_TYPE_INFO[assetTypeEnum]

	local v2, v3 = validateSingleInstance(instances, p)

	if not v2 then
		return false, v3
	end

	local instance = instances[1]

	local v4, v5 = validateInstanceTree(createAccessorySchema(v.attachmentNames), instance, p)

	if not v4 then
		return false, v5
	end

	if getEngineFeatureEngineUGCValidatePropertiesSensible() then
		local v6, v7 = ValidatePropertiesSensible.validate(instance, p)

		if not v6 then
			return false, v7
		end
	end

	local v6, v7 = validateDependencies(instance, p, {
		skipExistenceCheck = true,
		skipOwnershipCheck = true
	})

	if not v6 then
		return false, v7
	end

	local handle = instance:FindFirstChild("Handle")
	local specialMesh = handle:FindFirstChildOfClass("SpecialMesh")
	local v8 = {
		fullName = specialMesh:GetFullName(),
		fieldName = "MeshId",
		contentId = specialMesh.MeshId,
		context = instance.Name
	}

	local scale = specialMesh.Scale
	local attachment = getAttachment(handle, v.attachmentNames)

	assert(v.bounds[attachment.Name], "Could not find bounds for " .. attachment.Name)

	local v9 = {}

	local editableMeshFromContext, editableMesh = getEditableMeshFromContext(specialMesh, "MeshId", p)
	local v10

	if editableMeshFromContext then
		v10 = true
	else
		if v8.contentId then
			return
				false,
				{ string.format(
						"Failed to load mesh for legacy accessory '%s'. Make sure mesh exists and try again.",
						instance.Name
					) }
		end

		table.insert(v9, {
			string.format(
				"Missing meshId on legacy accessory '%s'. Make sure you are using a valid meshId and try again.\n",
				instance.Name
			)
		})
		v10 = false
	end

	v8.editableMesh = editableMesh

	local v11 = {
		fullName = specialMesh:GetFullName(),
		fieldName = "TextureId",
		contentId = specialMesh.TextureId
	}

	local editableImageFromContext, editableImage = getEditableImageFromContext(specialMesh, "TextureId", p)

	if not editableImageFromContext then
		return
			false,
			{ string.format(
					"Failed to load texture for legacy accessory '%s'. Make sure texture exists and try again.",
					instance.Name
				) }
	end

	v11.editableImage = editableImage

	local v12, v13 = validateTags(instance, p)

	if not v12 then
		table.insert(v9, table.concat(v13, "\n"))
		v10 = false
	end

	local avatarPartScaleType = handle:FindFirstChild("AvatarPartScaleType")

	if avatarPartScaleType and avatarPartScaleType:IsA("StringValue") then
		local v14, v15 = validateScaleType(avatarPartScaleType, p)

		if not v14 then
			table.insert(v9, table.concat(v15, "\n"))
			v10 = false
		end
	end

	local v14, v15 = validateThumbnailConfiguration(instance, handle, v8, scale, p)

	if not v14 then
		table.insert(v9, table.concat(v15, "\n"))
		v10 = false
	end

	return v10, v9
end

return validateLegacyAccessory
