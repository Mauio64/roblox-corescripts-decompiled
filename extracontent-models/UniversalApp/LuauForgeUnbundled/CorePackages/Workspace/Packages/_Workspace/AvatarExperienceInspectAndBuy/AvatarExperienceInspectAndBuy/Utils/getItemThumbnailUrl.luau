local AvatarExperienceModel = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceModel")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Types")
local itemTypeEnum = AvatarExperienceModel.Enums.ItemTypeEnum

local function getItemThumbnailUrl(p2)
	if p2.itemType == itemTypeEnum.Bundle then
		return "rbxthumb://type=BundleThumbnail&id=" .. p2.id .. "&w=420&h=420"
	end

	if p2.itemType == itemTypeEnum.Asset then
		return "rbxthumb://type=Asset&id=" .. p2.id .. "&w=420&h=420"
	end

	return nil
end

return getItemThumbnailUrl
