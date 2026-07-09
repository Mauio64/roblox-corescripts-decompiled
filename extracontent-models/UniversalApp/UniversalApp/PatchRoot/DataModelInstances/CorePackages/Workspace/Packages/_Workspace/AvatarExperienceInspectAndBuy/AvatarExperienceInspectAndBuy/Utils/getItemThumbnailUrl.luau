local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local AvatarExperienceInspectAndBuyParent = AvatarExperienceInspectAndBuy.Parent
local AXCommon = require(AvatarExperienceInspectAndBuyParent.AXCommon)

require(AvatarExperienceInspectAndBuy.Types)

local ItemTypeEnum = AXCommon.Enums.ItemTypeEnum

local function getItemThumbnailUrl(p1) -- line: 12
	-- upvalues: ItemTypeEnum (copy)
	if p1.itemType == ItemTypeEnum.Bundle then
		return "rbxthumb://type=BundleThumbnail&id=" .. p1.id .. "&w=420&h=420"
	end

	if p1.itemType == ItemTypeEnum.Asset then
		return "rbxthumb://type=Asset&id=" .. p1.id .. "&w=420&h=420"
	end

	return nil
end

return getItemThumbnailUrl
