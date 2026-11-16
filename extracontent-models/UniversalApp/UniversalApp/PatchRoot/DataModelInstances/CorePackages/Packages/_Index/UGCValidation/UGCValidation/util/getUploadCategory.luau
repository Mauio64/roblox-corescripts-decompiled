local parent = script.Parent.Parent
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local Constants = require(parent.Constants)
local ConstantsInterface = require(parent.ConstantsInterface)
local getFStringUGCLCAllowedAssetTypeIds = require(parent.flags.getFStringUGCLCAllowedAssetTypeIds)
local getFFlagUGCValidationEyebrowEyelashCategory = require(parent.flags.getFFlagUGCValidationEyebrowEyelashCategory)
local v = string.split(getFStringUGCLCAllowedAssetTypeIds(), ",")

local function getUploadCategory(p, p2, p3)
	if p3 == nil then
		assert(p2)
		local v2 = nil

		if p2 == Enum.AssetType.EmoteAnimation then
			v2 = ValidationEnums.UploadCategory.EMOTE_ANIMATION
		elseif Constants.ASSET_TYPE_INFO[p2] and Constants.ASSET_TYPE_INFO[p2].isBodyPart then
			v2 = p2 == Enum.AssetType.DynamicHead and ValidationEnums.UploadCategory.DYNAMIC_HEAD
				or ValidationEnums.UploadCategory.TORSO_AND_LIMBS
		elseif table.find(v, (tostring(p2.Value))) then
			local v3 = p2 == Enum.AssetType.EyebrowAccessory or p2 == Enum.AssetType.EyelashAccessory

			if getFFlagUGCValidationEyebrowEyelashCategory() and v3 then
				v2 = ValidationEnums.UploadCategory.EYEBROW_EYELASH
			else
				v2 = ValidationEnums.UploadCategory.LAYERED_CLOTHING
			end
		elseif Constants.ASSET_TYPE_INFO[p2] and Constants.ASSET_TYPE_INFO[p2].rigidAllowed then
			v2 = ValidationEnums.UploadCategory.RIGID_ACCESSORY
		elseif ConstantsInterface.isMakeupAsset(p2) then
			v2 = ValidationEnums.UploadCategory.MAKEUP
		elseif Constants.ANIMATION_ASSET_INFO and Constants.ANIMATION_ASSET_INFO[p2] then
			v2 = ValidationEnums.UploadCategory.ANIMATION
		end

		if v2 == nil then
			error(`No assigned validation category for {p.Name}, {p2}, {nil} `)
		end

		return v2
	end

	if p3 == Enum.BundleType.BodyParts then
		return ValidationEnums.UploadCategory.FULL_BODY
	end

	if p3 == Enum.BundleType.Animations then
		return ValidationEnums.UploadCategory.ANIMATION_PACK
	end

	return ValidationEnums.UploadCategory.BOTH_SHOES
end

return getUploadCategory
