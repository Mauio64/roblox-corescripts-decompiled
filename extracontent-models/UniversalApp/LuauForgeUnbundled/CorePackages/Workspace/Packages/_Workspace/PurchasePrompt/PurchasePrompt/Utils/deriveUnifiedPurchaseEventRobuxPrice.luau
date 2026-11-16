local deriveCartPricingView = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/IAPExperience").deriveCartPricingView

local fFlagPurchasePromptUnifiedEventsUseOfferAdjustedPrice = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagPurchasePromptUnifiedEventsUseOfferAdjustedPrice

local function deriveUnifiedPurchaseEventRobuxPrice(p2, p3)
	if not fFlagPurchasePromptUnifiedEventsUseOfferAdjustedPrice then
		return p3
	end

	local v5 = deriveCartPricingView(p2)

	if v5 == nil then
		return p3
	end

	return v5.priceAfterDiscount
end

return deriveUnifiedPurchaseEventRobuxPrice
