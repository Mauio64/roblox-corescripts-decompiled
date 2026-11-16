local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local parent = AvatarExperienceInspectAndBuy.Parent
local AvatarExperienceModel = require(parent.AvatarExperienceModel)
require(AvatarExperienceInspectAndBuy.Types)
local ItemTypeEnum = AvatarExperienceModel.Enums.ItemTypeEnum

local function getItemThumbnailUrl(p)
	if p.itemType == ItemTypeEnum.Bundle then
		return "rbxthumb://type=BundleThumbnail&id=" .. p.id .. "&w=420&h=420"
	end

	if p.itemType == ItemTypeEnum.Asset then
		return "rbxthumb://type=Asset&id=" .. p.id .. "&w=420&h=420"
	end

	return nil
end

return getItemThumbnailUrl
