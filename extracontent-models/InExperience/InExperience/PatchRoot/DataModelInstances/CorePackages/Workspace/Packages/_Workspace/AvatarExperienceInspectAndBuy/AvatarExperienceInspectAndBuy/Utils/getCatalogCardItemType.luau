local parent = script:FindFirstAncestor("AvatarExperienceInspectAndBuy").Parent
local AXCommon = require(parent.AXCommon)
local ItemRestrictions = AXCommon.Enums.ItemRestrictions
local CatalogItemCardItemTypeEnum = AXCommon.Components.CatalogItemCard.CatalogItemCardItemTypeEnum

local function getCatalogCardItemType(p)
	if not p then
		return nil
	end

	if p[ItemRestrictions.Limited] then
		return CatalogItemCardItemTypeEnum.Limited
	end

	if p[ItemRestrictions.Collectible] or p[ItemRestrictions.LimitedUnique] then
		return CatalogItemCardItemTypeEnum.Collectible
	end

	return nil
end

return getCatalogCardItemType
