local Parent = script:FindFirstAncestor("PurchasePrompt").Parent
local deriveCartPricingView = require(Parent.IAPExperience).deriveCartPricingView
local FFlagPurchasePromptUnifiedEventsUseOfferAdjustedPrice = require(Parent.SharedFlags).FFlagPurchasePromptUnifiedEventsUseOfferAdjustedPrice

local function deriveUnifiedPurchaseEventRobuxPrice(p1, n1: number?) -- line: 21
	-- upvalues: FFlagPurchasePromptUnifiedEventsUseOfferAdjustedPrice (copy), deriveCartPricingView (copy)
	if not FFlagPurchasePromptUnifiedEventsUseOfferAdjustedPrice then
		return n1
	end

	local v7 = deriveCartPricingView(p1)

	if v7 == nil then
		return n1
	end

	return v7.priceAfterDiscount
end

return deriveUnifiedPurchaseEventRobuxPrice
