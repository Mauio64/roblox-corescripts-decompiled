local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local AvatarExperienceInspectAndBuyParent = AvatarExperienceInspectAndBuy.Parent

require(AvatarExperienceInspectAndBuy.Types)

local AXCommon = require(AvatarExperienceInspectAndBuyParent.AXCommon)
local Constants = AXCommon.Constants
local ASSET_TYPE_TO_ACCESSORY_TYPE = Constants.ASSET_TYPE_TO_ACCESSORY_TYPE
local ASSET_TYPE_ID_STRING_TO_HUMANOID_DESCRIPTION_PROP = Constants.ASSET_TYPE_ID_STRING_TO_HUMANOID_DESCRIPTION_PROP
local LAYERED_ASSET_TYPES = Constants.LAYERED_ASSET_TYPES
local AVATAR_ANIMATIONS_BUNDLE_TYPE_ID = Constants.AVATAR_ANIMATIONS_BUNDLE_TYPE_ID
local SHOES_BUNDLE_TYPE_ID = Constants.SHOES_BUNDLE_TYPE_ID
local AvatarBackground = Constants.ASSET_TYPE_NAME_TO_ID_STRING.AvatarBackground
local ItemTypeEnum = AXCommon.Enums.ItemTypeEnum
local AvatarExperienceFlags = require(AvatarExperienceInspectAndBuyParent.AvatarExperienceFlags)

local function isItemAvailableForTryOn(p1, p2) -- line: 24
	-- upvalues: ItemTypeEnum (copy), AVATAR_ANIMATIONS_BUNDLE_TYPE_ID (copy), SHOES_BUNDLE_TYPE_ID (copy), AvatarBackground (copy), AvatarExperienceFlags (copy), ASSET_TYPE_TO_ACCESSORY_TYPE (copy), ASSET_TYPE_ID_STRING_TO_HUMANOID_DESCRIPTION_PROP (copy), LAYERED_ASSET_TYPES (copy)
	local itemSubType = p2.itemSubType
	local v17 = p1 and (p1.Humanoid and p1.Humanoid.RigType == Enum.HumanoidRigType.R6)

	if p2.itemType == ItemTypeEnum.Bundle and itemSubType == AVATAR_ANIMATIONS_BUNDLE_TYPE_ID then
		return false
	end

	if p2.itemType == ItemTypeEnum.Bundle and itemSubType == SHOES_BUNDLE_TYPE_ID and v17 then
		return false
	end

	if p2.itemType == ItemTypeEnum.Asset then
		if not itemSubType then
			return false
		end

		if itemSubType == AvatarBackground then
			return AvatarExperienceFlags.FFlagAXBackgroundsTryOn
		end

		local v18 = ASSET_TYPE_TO_ACCESSORY_TYPE[itemSubType] ~= nil or ASSET_TYPE_ID_STRING_TO_HUMANOID_DESCRIPTION_PROP[itemSubType] ~= nil
		local v19 = v17 and LAYERED_ASSET_TYPES[itemSubType] ~= nil

		return v18 and not v19
	end

	return true
end

return isItemAvailableForTryOn
