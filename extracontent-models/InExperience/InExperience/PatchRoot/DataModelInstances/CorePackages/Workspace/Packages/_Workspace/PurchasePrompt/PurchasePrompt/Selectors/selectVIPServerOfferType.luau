local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")

local selectProductPrice = require(script.Parent.selectProductPrice)
require(PurchasePrompt.types)

local function selectVIPServerOfferType(p): string
	if p.productInfo.isFreeWithRobloxPlus then
		return "plus_included"
	end

	return if selectProductPrice(p) == 0 then "free" else "paid"
end

return selectVIPServerOfferType
