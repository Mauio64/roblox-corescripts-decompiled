local parent = script.Parent.Parent

require(parent.util.Types)
local Constants = require(parent.Constants)
local ConstantsInterface = require(parent.ConstantsInterface)

local isMeshPartAccessory = require(parent.util.isMeshPartAccessory)
local isLayeredClothing = require(parent.util.isLayeredClothing)

local validateLayeredClothingAccessory = require(parent.validation.validateLayeredClothingAccessory)
local validateLegacyAccessory = require(parent.validation.validateLegacyAccessory)
local validateMeshPartAccessory = require(parent.validation.validateMeshPartAccessory)
local validateMakeupAsset = require(parent.validation.validateMakeupAsset)
local validateLimbsAndTorso = require(parent.validation.validateLimbsAndTorso)
local validateDynamicHeadMeshPartFormat = require(parent.validation.validateDynamicHeadMeshPartFormat)
local validatePackage = require(parent.validation.validatePackage)
local ValidateEmoteAnimation = require(parent.validation.ValidateEmoteAnimation)

local function validateBodyPartInternal(data)
	local assetTypeEnum = data.assetTypeEnum
	assert(assetTypeEnum ~= nil, "assetTypeEnum is required in validateBodyPartInternal")
	assert(ConstantsInterface.isBodyPart(assetTypeEnum))

	if Enum.AssetType.DynamicHead == assetTypeEnum then
		return validateDynamicHeadMeshPartFormat(data)
	end

	return validateLimbsAndTorso(data)
end

local function validateInternal(data)
	assert(data.instances ~= nil, "instances required in validationContext for validateInternal")
	assert(data.assetTypeEnum ~= nil, "assetTypeEnum required in validationContext for validateInternal")
	local instances = data.instances
	local assetTypeEnum = data.assetTypeEnum
	local validateMeshPartAccessories = data.validateMeshPartAccessories

	if Constants.ANIMATION_ASSET_INFO and Constants.ANIMATION_ASSET_INFO[assetTypeEnum] then
		return true
	end

	if assetTypeEnum == Enum.AssetType.EmoteAnimation then
		return ValidateEmoteAnimation.validate(data)
	end

	if ConstantsInterface.isMakeupAsset(assetTypeEnum) then
		return validateMakeupAsset(data)
	end

	if ConstantsInterface.isBodyPart(assetTypeEnum) then
		return validateBodyPartInternal(data)
	end

	if assetTypeEnum == Enum.AssetType.Model then
		return validatePackage(data)
	end

	if validateMeshPartAccessories then
		local instance = instances[1]

		if not isMeshPartAccessory(instance) then
			return validateLegacyAccessory(data)
		end

		if isLayeredClothing(instance) then
			return validateLayeredClothingAccessory(data)
		end

		return validateMeshPartAccessory(data)
	elseif isLayeredClothing(instances[1]) then
		return validateLayeredClothingAccessory(data)
	else
		return validateLegacyAccessory(data)
	end
end

return validateInternal
