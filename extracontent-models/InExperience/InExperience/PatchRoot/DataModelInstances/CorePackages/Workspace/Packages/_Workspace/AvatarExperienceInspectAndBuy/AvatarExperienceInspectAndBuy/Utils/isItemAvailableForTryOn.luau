local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local parent = AvatarExperienceInspectAndBuy.Parent
require(AvatarExperienceInspectAndBuy.Types)

local AXCommon = require(parent.AXCommon)
local AvatarExperienceModel = require(parent.AvatarExperienceModel)
local Constants = AXCommon.Constants
local ASSET_TYPE_TO_ACCESSORY_TYPE = Constants.ASSET_TYPE_TO_ACCESSORY_TYPE
local ASSET_TYPE_ID_STRING_TO_HUMANOID_DESCRIPTION_PROP = Constants.ASSET_TYPE_ID_STRING_TO_HUMANOID_DESCRIPTION_PROP
local LAYERED_ASSET_TYPES = Constants.LAYERED_ASSET_TYPES
local AVATAR_ANIMATIONS_BUNDLE_TYPE_ID = Constants.AVATAR_ANIMATIONS_BUNDLE_TYPE_ID
local SHOES_BUNDLE_TYPE_ID = Constants.SHOES_BUNDLE_TYPE_ID
local AvatarBackground = Constants.ASSET_TYPE_NAME_TO_ID_STRING.AvatarBackground
local ItemTypeEnum = AvatarExperienceModel.Enums.ItemTypeEnum

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)

local function isItemAvailableForTryOn(instance, p)
	local itemSubType = p.itemSubType

	local v = instance and instance.Humanoid and instance.Humanoid.RigType == Enum.HumanoidRigType.R6

	if
		p.itemType == ItemTypeEnum.Bundle and itemSubType == AVATAR_ANIMATIONS_BUNDLE_TYPE_ID
		or p.itemType == ItemTypeEnum.Bundle and itemSubType == SHOES_BUNDLE_TYPE_ID and v
	then
		return false
	end

	if p.itemType ~= ItemTypeEnum.Asset then
		return true
	end

	if not itemSubType then
		return false
	end

	if itemSubType == AvatarBackground then
		return AvatarExperienceFlags.FFlagAXBackgroundsTryOn
	end

	local v2 = ASSET_TYPE_TO_ACCESSORY_TYPE[itemSubType] ~= nil
		or ASSET_TYPE_ID_STRING_TO_HUMANOID_DESCRIPTION_PROP[itemSubType] ~= nil

	local v3 = v and LAYERED_ASSET_TYPES[itemSubType] ~= nil

	return v2 and not v3
end

return isItemAvailableForTryOn
