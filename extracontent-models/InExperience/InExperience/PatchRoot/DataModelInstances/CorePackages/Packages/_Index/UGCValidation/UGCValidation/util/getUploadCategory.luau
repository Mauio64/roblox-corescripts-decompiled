local ParentParent = script.Parent.Parent
local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local Constants = require(ParentParent.Constants)
local ConstantsInterface = require(ParentParent.ConstantsInterface)
local getFStringUGCLCAllowedAssetTypeIds = require(ParentParent.flags.getFStringUGCLCAllowedAssetTypeIds)
local getFFlagUGCValidationAnimationPackSupport = require(ParentParent.flags.getFFlagUGCValidationAnimationPackSupport)
local parts = string.split(getFStringUGCLCAllowedAssetTypeIds(), ",")

local function getUploadCategory(p1, p2, p3) -- line: 9
	-- upvalues: ValidationEnums (copy), getFFlagUGCValidationAnimationPackSupport (copy), Constants (copy), parts (copy), ConstantsInterface (copy)
	if p3 ~= nil then
		if p3 == Enum.BundleType.BodyParts then
			return ValidationEnums.UploadCategory.FULL_BODY
		end

		if getFFlagUGCValidationAnimationPackSupport() and p3 == Enum.BundleType.Animations then
			return ValidationEnums.UploadCategory.ANIMATION_PACK
		end

		return ValidationEnums.UploadCategory.BOTH_SHOES
	end

	assert(p2)

	local EMOTE_ANIMATION = nil

	if p2 == Enum.AssetType.EmoteAnimation then
		EMOTE_ANIMATION = ValidationEnums.UploadCategory.EMOTE_ANIMATION
	elseif Constants.ASSET_TYPE_INFO[p2] and Constants.ASSET_TYPE_INFO[p2].isBodyPart then
		EMOTE_ANIMATION = p2 == Enum.AssetType.DynamicHead and ValidationEnums.UploadCategory.DYNAMIC_HEAD or ValidationEnums.UploadCategory.TORSO_AND_LIMBS
	elseif table.find(parts, (tostring(p2.Value))) then
		EMOTE_ANIMATION = ValidationEnums.UploadCategory.LAYERED_CLOTHING
	elseif Constants.ASSET_TYPE_INFO[p2] and Constants.ASSET_TYPE_INFO[p2].rigidAllowed then
		EMOTE_ANIMATION = ValidationEnums.UploadCategory.RIGID_ACCESSORY
	elseif ConstantsInterface.isMakeupAsset(p2) then
		EMOTE_ANIMATION = ValidationEnums.UploadCategory.MAKEUP
	elseif getFFlagUGCValidationAnimationPackSupport() and Constants.ANIMATION_ASSET_INFO and Constants.ANIMATION_ASSET_INFO[p2] then
		EMOTE_ANIMATION = ValidationEnums.UploadCategory.ANIMATION
	end

	if EMOTE_ANIMATION == nil then
		error(`No assigned validation category for { p1.Name }, { p2 }, { p3 } `)
	end

	return EMOTE_ANIMATION
end

return getUploadCategory
