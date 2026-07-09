local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local InExperienceShopParent = InExperienceShop.Parent

require(InExperienceShop.Types)

local function mapShopItemTypeToUnifiedItemType(p1) -- line: 7
	-- upvalues: InExperienceShopParent (copy)
	local MarketplaceUnifiedItemType = require(InExperienceShopParent.AvatarExperienceAnalytics).UnifiedEventLogEnums.MarketplaceUnifiedItemType

	if p1 == "GamePass" then
		return MarketplaceUnifiedItemType.GAME_PASS
	end

	if p1 == "Product" then
		return MarketplaceUnifiedItemType.DEVELOPER_PRODUCT
	end

	if p1 == "Robux" then
		return MarketplaceUnifiedItemType.ROBUX
	end

	return nil
end

return mapShopItemTypeToUnifiedItemType
