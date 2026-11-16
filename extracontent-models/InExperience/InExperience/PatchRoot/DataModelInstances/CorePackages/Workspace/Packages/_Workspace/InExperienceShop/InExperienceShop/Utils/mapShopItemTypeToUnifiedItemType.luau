local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

require(InExperienceShop.Types)

local function mapShopItemTypeToUnifiedItemType(p)
	local AvatarExperienceAnalytics = require(parent.AvatarExperienceAnalytics)
	local marketplaceUnifiedItemType = AvatarExperienceAnalytics.UnifiedEventLogEnums.MarketplaceUnifiedItemType

	if p == "GamePass" then
		return marketplaceUnifiedItemType.GAME_PASS
	elseif p == "Product" then
		return marketplaceUnifiedItemType.DEVELOPER_PRODUCT
	elseif p == "Robux" then
		return marketplaceUnifiedItemType.ROBUX
	end

	return nil
end

return mapShopItemTypeToUnifiedItemType
