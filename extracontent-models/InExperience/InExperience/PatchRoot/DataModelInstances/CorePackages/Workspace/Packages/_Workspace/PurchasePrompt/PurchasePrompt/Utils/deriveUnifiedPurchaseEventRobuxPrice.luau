local parent = script:FindFirstAncestor("PurchasePrompt").Parent

local IAPExperience = require(parent.IAPExperience)

local deriveCartPricingView = IAPExperience.deriveCartPricingView

local SharedFlags = require(parent.SharedFlags)
local FFlagPurchasePromptUnifiedEventsUseOfferAdjustedPrice = SharedFlags.FFlagPurchasePromptUnifiedEventsUseOfferAdjustedPrice

local function deriveUnifiedPurchaseEventRobuxPrice(p, p2: number?)
	if not FFlagPurchasePromptUnifiedEventsUseOfferAdjustedPrice then
		return p2
	end

	local v = deriveCartPricingView(p)
	return if v == nil then p2 else v.priceAfterDiscount
end

return deriveUnifiedPurchaseEventRobuxPrice
