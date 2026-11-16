local parent = script.Parent.Parent

require(parent.util.Types)
local Analytics = require(parent.Analytics)
local Constants = require(parent.Constants)

local validateInstanceTree = require(parent.validation.validateInstanceTree)
local validateTags = require(parent.validation.validateTags)
local validateSingleInstance = require(parent.validation.validateSingleInstance)
local ValidateMeshSizeProperty = require(parent.validation.ValidateMeshSizeProperty)
local ValidatePropertiesSensible = require(parent.validation.ValidatePropertiesSensible)
local validateDependencies = require(parent.validation.validateDependencies)

local createMeshPartAccessorySchema = require(parent.util.createMeshPartAccessorySchema)
local getAttachment = require(parent.util.getAttachment)
local getMeshSize = require(parent.util.getMeshSize)
local FailureReasonsAccumulator = require(parent.util.FailureReasonsAccumulator)
local getEditableMeshFromContext = require(parent.util.getEditableMeshFromContext)
local getEditableImageFromContext = require(parent.util.getEditableImageFromContext)
local pcallDeferred = require(parent.util.pcallDeferred)
local RigidOrLayeredAllowed = require(parent.util.RigidOrLayeredAllowed)

local getEngineFeatureEngineUGCValidatePropertiesSensible = require(parent.flags.getEngineFeatureEngineUGCValidatePropertiesSensible)

local function validateMeshPartAccessory(p)
	assert(p.assetTypeEnum ~= nil, "assetTypeEnum required in validationContext for validateMeshPartAccessory")

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

	local v4, v5 = validateInstanceTree(createMeshPartAccessorySchema(v.attachmentNames), instance, p)

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
	local v8 = {
		fullName = handle:GetFullName(),
		fieldName = "MeshId",
		contentId = handle.MeshId,
		context = instance.Name
	}

	local v9 = FailureReasonsAccumulator.new()

	if handle.DoubleSided then
		v9:updateReasons(false, {
			string.format(
				"MeshPart '%s' is double-sided. Double-sided meshes are not allowed in rigid accessories.",
				handle:GetFullName()
			)
		})

		Analytics.reportFailure(Analytics.ErrorType.validateMeshPartAccessory_DoubleSided, nil, p)
	end

	local editableMeshFromContext, editableMesh = getEditableMeshFromContext(handle, "MeshId", p)

	if not editableMeshFromContext then
		if v8.contentId then
			Analytics.reportFailure(Analytics.ErrorType.validateMeshPartAccessory_FailedToLoadMesh, nil, p)

			return
				false,
				{ string.format(
						"Failed to load mesh for accessory '%s'. Make sure mesh exists and try again.",
						instance.Name
					) }
		end

		Analytics.reportFailure(Analytics.ErrorType.validateMeshPartAccessory_NoMeshId, nil, p)
		v9:updateReasons(false, {
			string.format(
				"Accessory MeshPart '%s' must contain a valid meshId. Make sure the mesh referred to by the meshId exists and try again.",
				handle:GetFullName()
			)
		})
	end

	v8.editableMesh = editableMesh

	local textureID = handle.TextureID
	local v10 = { fullName = handle:GetFullName(), fieldName = "TextureID", contentId = textureID }

	local _, editableImage = getEditableImageFromContext(handle, "TextureID", p)
	v10.editableImage = editableImage

	local v11, _ = pcallDeferred(function()
		return getMeshSize(v8)
	end, p)

	if not v11 then
		Analytics.reportFailure(Analytics.ErrorType.validateMeshPartAccessory_FailedToLoadMesh, nil, p)

		return
			false,
			{ string.format(
					"Failed to load mesh for accessory '%s'. Make sure mesh exists and try again.",
					instance.Name
				) }
	end

	local attachment = getAttachment(handle, v.attachmentNames)
	assert(attachment)

	assert(v.bounds[attachment.Name], "Could not find bounds for " .. attachment.Name)

	v9:updateReasons(validateTags(instance, p))
	v9:updateReasons(ValidateMeshSizeProperty.validateSingleMeshPart(handle, p))

	return v9:getFinalResults()
end

return validateMeshPartAccessory
