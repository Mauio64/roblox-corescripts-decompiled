local CommercePurchaseApp = script:FindFirstAncestor("CommercePurchaseApp")

require(CommercePurchaseApp.Store.Types)

local function selectCommerceProductId(p)
	return p.commercePurchaseState.commerceProductId
end

return selectCommerceProductId
