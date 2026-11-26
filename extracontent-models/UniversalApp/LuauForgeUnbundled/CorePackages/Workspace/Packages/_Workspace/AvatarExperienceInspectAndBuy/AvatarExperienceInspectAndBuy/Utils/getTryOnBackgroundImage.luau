local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceCommon")
local AvatarExperienceModel = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceModel")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Types")
local getItemThumbnailUrl = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/getItemThumbnailUrl")

local itemTypeEnum = AvatarExperienceModel.Enums.ItemTypeEnum
local avatarBackground = AvatarExperienceCommon.Constants.ASSET_TYPE_NAME_TO_ID_STRING.AvatarBackground

local function getTryOnBackgroundImage(data)
	if data == nil or data.itemType ~= itemTypeEnum.Asset or data.itemSubType ~= avatarBackground then
		return nil
	end

	return getItemThumbnailUrl({ itemType = data.itemType, id = data.itemId })
end

return getTryOnBackgroundImage
