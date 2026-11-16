local parent = script:FindFirstAncestor("InExperienceShop").Parent

local PurchasePromptLite = require(parent.PurchasePromptLite)
local ProductPurchaseSurface = PurchasePromptLite.Enums.ProductPurchaseSurface

local Constants = require(script.Parent.Constants)

local function getShopPurchaseAnalyticsSurface(p: string)
	if p == Constants.ShopPageType.Home then
		return ProductPurchaseSurface.InExperienceShopHome
	end

	if p == Constants.ShopPageType.Search then
		return ProductPurchaseSurface.InExperienceShopSearch
	end

	return ProductPurchaseSurface.InExperienceShopDetails
end

return getShopPurchaseAnalyticsSurface
