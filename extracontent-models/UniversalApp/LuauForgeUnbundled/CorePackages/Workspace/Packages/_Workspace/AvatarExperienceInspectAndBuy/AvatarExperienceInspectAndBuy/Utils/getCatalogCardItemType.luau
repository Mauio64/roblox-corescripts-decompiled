local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceCommon")
local itemRestrictions = AvatarExperienceCommon.Enums.ItemRestrictions
local catalogItemCardItemTypeEnum = AvatarExperienceCommon.Components.CatalogItemCard.CatalogItemCardItemTypeEnum

local function getCatalogCardItemType(p2)
	if not p2 then
		return nil
	end

	if p2[itemRestrictions.Limited] then
		return catalogItemCardItemTypeEnum.Limited
	end

	if p2[itemRestrictions.Collectible] or p2[itemRestrictions.LimitedUnique] then
		return catalogItemCardItemTypeEnum.Collectible
	end

	return nil
end

return getCatalogCardItemType
