local Parent = script:FindFirstAncestor("AvatarExperienceInspectAndBuy").Parent
local AXCommon = require(Parent.AXCommon)
local ItemRestrictions = AXCommon.Enums.ItemRestrictions
local CatalogItemCardItemTypeEnum = AXCommon.Components.CatalogItemCard.CatalogItemCardItemTypeEnum

local function getCatalogCardItemType(t1: {[any]: any}?) -- line: 13
	-- upvalues: ItemRestrictions (copy), CatalogItemCardItemTypeEnum (copy)
	if not t1 then
		return nil
	end

	if t1[ItemRestrictions.Limited] then
		return CatalogItemCardItemTypeEnum.Limited
	end

	if t1[ItemRestrictions.Collectible] or t1[ItemRestrictions.LimitedUnique] then
		return CatalogItemCardItemTypeEnum.Collectible
	end

	return nil
end

return getCatalogCardItemType
