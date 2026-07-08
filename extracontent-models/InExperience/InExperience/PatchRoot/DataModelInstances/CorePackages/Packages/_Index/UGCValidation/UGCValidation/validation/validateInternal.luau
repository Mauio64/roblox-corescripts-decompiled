local ParentParent = script.Parent.Parent

require(ParentParent.util.Types)

local Constants = require(ParentParent.Constants)
local ConstantsInterface = require(ParentParent.ConstantsInterface)
local getFFlagUGCValidationAnimationPackSupport = require(ParentParent.flags.getFFlagUGCValidationAnimationPackSupport)
local isMeshPartAccessory = require(ParentParent.util.isMeshPartAccessory)
local isLayeredClothing = require(ParentParent.util.isLayeredClothing)
local validateLayeredClothingAccessory = require(ParentParent.validation.validateLayeredClothingAccessory)
local validateLegacyAccessory = require(ParentParent.validation.validateLegacyAccessory)
local validateMeshPartAccessory = require(ParentParent.validation.validateMeshPartAccessory)
local validateMakeupAsset = require(ParentParent.validation.validateMakeupAsset)
local validateLimbsAndTorso = require(ParentParent.validation.validateLimbsAndTorso)
local validateDynamicHeadMeshPartFormat = require(ParentParent.validation.validateDynamicHeadMeshPartFormat)
local validatePackage = require(ParentParent.validation.validatePackage)
local ValidateEmoteAnimation = require(ParentParent.validation.ValidateEmoteAnimation)

local function validateBodyPartInternal(p1) -- line: 21
	-- upvalues: ConstantsInterface (copy), validateDynamicHeadMeshPartFormat (copy), validateLimbsAndTorso (copy)
	local assetTypeEnum = p1.assetTypeEnum

	assert(assetTypeEnum ~= nil, "assetTypeEnum is required in validateBodyPartInternal")
	assert(ConstantsInterface.isBodyPart(assetTypeEnum))

	if assetTypeEnum == Enum.AssetType.DynamicHead then
		return validateDynamicHeadMeshPartFormat(p1)
	end

	return validateLimbsAndTorso(p1)
end
local function validateInternal(p2) -- line: 32
	-- upvalues: getFFlagUGCValidationAnimationPackSupport (copy), Constants (copy), ValidateEmoteAnimation (copy), ConstantsInterface (copy), validateMakeupAsset (copy), validateBodyPartInternal (copy), validatePackage (copy), isMeshPartAccessory (copy), isLayeredClothing (copy), validateLayeredClothingAccessory (copy), validateMeshPartAccessory (copy), validateLegacyAccessory (copy)
	assert(p2.instances ~= nil, "instances required in validationContext for validateInternal")
	assert(p2.assetTypeEnum ~= nil, "assetTypeEnum required in validationContext for validateInternal")

	local instances = p2.instances
	local assetTypeEnum = p2.assetTypeEnum
	local validateMeshPartAccessories = p2.validateMeshPartAccessories

	if getFFlagUGCValidationAnimationPackSupport() and Constants.ANIMATION_ASSET_INFO and Constants.ANIMATION_ASSET_INFO[assetTypeEnum] then
		return true
	end

	if assetTypeEnum == Enum.AssetType.EmoteAnimation then
		return ValidateEmoteAnimation.validate(p2)
	end

	if ConstantsInterface.isMakeupAsset(assetTypeEnum) then
		return validateMakeupAsset(p2)
	end

	if ConstantsInterface.isBodyPart(assetTypeEnum) then
		return validateBodyPartInternal(p2)
	end

	if assetTypeEnum == Enum.AssetType.Model then
		return validatePackage(p2)
	end

	if validateMeshPartAccessories then
		local v23 = instances[1]

		if isMeshPartAccessory(v23) then
			if isLayeredClothing(v23) then
				return validateLayeredClothingAccessory(p2)
			end

			return validateMeshPartAccessory(p2)
		end

		return validateLegacyAccessory(p2)
	end

	if isLayeredClothing(instances[1]) then
		return validateLayeredClothingAccessory(p2)
	end

	return validateLegacyAccessory(p2)
end

return validateInternal
