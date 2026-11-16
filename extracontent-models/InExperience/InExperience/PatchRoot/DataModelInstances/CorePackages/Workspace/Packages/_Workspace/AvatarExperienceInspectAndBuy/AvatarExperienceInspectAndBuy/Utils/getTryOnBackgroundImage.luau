local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local parent = AvatarExperienceInspectAndBuy.Parent
local AXCommon = require(parent.AXCommon)
local AvatarExperienceModel = require(parent.AvatarExperienceModel)
require(AvatarExperienceInspectAndBuy.Types)
local getItemThumbnailUrl = require(AvatarExperienceInspectAndBuy.Utils.getItemThumbnailUrl)

local ItemTypeEnum = AvatarExperienceModel.Enums.ItemTypeEnum
local AvatarBackground = AXCommon.Constants.ASSET_TYPE_NAME_TO_ID_STRING.AvatarBackground

local function getTryOnBackgroundImage(data)
	if data == nil or data.itemType ~= ItemTypeEnum.Asset or data.itemSubType ~= AvatarBackground then
		return nil
	end

	return getItemThumbnailUrl({ itemType = data.itemType, id = data.itemId })
end

return getTryOnBackgroundImage
