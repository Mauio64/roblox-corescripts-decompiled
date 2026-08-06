local Parent = script:FindFirstAncestor("InExperienceShop").Parent
local ProductPurchaseSurface = require(Parent.PurchasePromptLite).Enums.ProductPurchaseSurface
local Constants = require(script.Parent.Constants)

local function getShopPurchaseAnalyticsSurface(s1: string) -- line: 16
	-- upvalues: Constants (copy), ProductPurchaseSurface (copy)
	if s1 == Constants.ShopPageType.Home then
		return ProductPurchaseSurface.InExperienceShopHome
	end

	if s1 == Constants.ShopPageType.Search then
		return ProductPurchaseSurface.InExperienceShopSearch
	end

	return ProductPurchaseSurface.InExperienceShopDetails
end

return getShopPurchaseAnalyticsSurface
