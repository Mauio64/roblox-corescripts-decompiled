local ParentParent = script.Parent.Parent

require(ParentParent.util.Types)

local createLegacyAccessoryMeshPartAssetFormatSchema = require(ParentParent.util.createLegacyAccessoryMeshPartAssetFormatSchema)
local validateSingleInstance = require(ParentParent.validation.validateSingleInstance)
local validateInstanceTree = require(ParentParent.validation.validateInstanceTree)
local validateLegacyAccessoryMeshPartAssetFormatMatch = require(ParentParent.validation.validateLegacyAccessoryMeshPartAssetFormatMatch)
local validateSurfaceAppearances = require(ParentParent.validation.validateSurfaceAppearances)
local validateSurfaceAppearanceTextureSize = require(ParentParent.validation.validateSurfaceAppearanceTextureSize)
local ValidateTexturePack = require(ParentParent.validation.ValidateTexturePack)
local validateSurfaceAppearanceTransparency = require(ParentParent.validation.validateSurfaceAppearanceTransparency)
local ValidatePropertiesSensible = require(ParentParent.validation.ValidatePropertiesSensible)
local getEngineFeatureEngineUGCValidatePropertiesSensible = require(ParentParent.flags.getEngineFeatureEngineUGCValidatePropertiesSensible)
local getFFlagUGCValidateTexturePack = require(ParentParent.flags.getFFlagUGCValidateTexturePack)
local getFFlagUGCValidateMigrateTextureTransparency = require(ParentParent.flags.getFFlagUGCValidateMigrateTextureTransparency)
local getFFlagUGCValidateMigrateSurfaceAppearanceMeshQuality = require(ParentParent.flags.getFFlagUGCValidateMigrateSurfaceAppearanceMeshQuality)

local function validateLegacyAccessoryMeshPartAssetFormat(p1, p2) -- line: 24
	-- upvalues: validateSingleInstance (copy), createLegacyAccessoryMeshPartAssetFormatSchema (copy), validateInstanceTree (copy), getEngineFeatureEngineUGCValidatePropertiesSensible (copy), ValidatePropertiesSensible (copy), getFFlagUGCValidateMigrateSurfaceAppearanceMeshQuality (copy), validateSurfaceAppearances (copy), getFFlagUGCValidateMigrateTextureTransparency (copy), validateSurfaceAppearanceTextureSize (copy), validateSurfaceAppearanceTransparency (copy), getFFlagUGCValidateTexturePack (copy), ValidateTexturePack (copy), validateLegacyAccessoryMeshPartAssetFormatMatch (copy)
	assert(p2.instances ~= nil, "instances required in validationContext for validateLegacyAccessoryMeshPartAssetFormat")

	local instances = p2.instances
	local v19, v20 = validateSingleInstance(instances, p2)

	if not v19 then
		return false, v20
	end

	local v21 = instances[1]
	local Attachment = p1:FindFirstChild("Handle"):FindFirstChildOfClass("Attachment")
	local v23 = createLegacyAccessoryMeshPartAssetFormatSchema(Attachment.Name)
	local v24, v25 = validateInstanceTree(v23, v21, p2)

	if not v24 then
		return false, v25
	end

	if getEngineFeatureEngineUGCValidatePropertiesSensible() then
		local v26, v27 = ValidatePropertiesSensible.validate(v21, p2)

		if not v26 then
			return false, v27
		end
	end

	if not getFFlagUGCValidateMigrateSurfaceAppearanceMeshQuality() then
		local v28, v29 = validateSurfaceAppearances(v21, p2)

		if not v28 then
			return false, v29
		end
	end

	if not getFFlagUGCValidateMigrateTextureTransparency() then
		local v30, v31 = validateSurfaceAppearanceTextureSize(v21, p2)

		if not v30 then
			return false, v31
		end

		local v32, v33 = validateSurfaceAppearanceTransparency(v21, p2)

		if not v32 then
			return false, v33
		end
	end

	if not getFFlagUGCValidateMigrateSurfaceAppearanceMeshQuality() and getFFlagUGCValidateTexturePack() then
		local v34, v35 = ValidateTexturePack.validate(v21, false, p2)

		if not v34 then
			return false, v35
		end
	end

	local v36, v37 = validateLegacyAccessoryMeshPartAssetFormatMatch(v21, p1, p2)

	if not v36 then
		return false, v37
	end

	return true
end

return validateLegacyAccessoryMeshPartAssetFormat
