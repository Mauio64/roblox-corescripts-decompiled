local CommercePurchaseApp = script:FindFirstAncestor("CommercePurchaseApp")

require(CommercePurchaseApp.Store.Types)

local function selectCommerceProductId(p1) -- line: 7
	return p1.commercePurchaseState.commerceProductId
end

return selectCommerceProductId
