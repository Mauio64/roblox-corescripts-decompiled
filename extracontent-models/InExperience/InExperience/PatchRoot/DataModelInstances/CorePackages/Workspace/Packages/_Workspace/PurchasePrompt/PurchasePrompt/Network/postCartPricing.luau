local parent = script.Parent.Parent
local parent2 = parent.Parent

require(parent2.PurchasePromptLite)

local Promise = require(parent.Promise)
require(parent.types)
local UnifiedPurchaseTelemetry = require(parent.Events.UnifiedPurchaseTelemetry)
local logUnifiedPurchaseTelemetryCounter = require(parent.Utils.logUnifiedPurchaseTelemetryCounter)

local function buildCartPricingRequestBody(items, unselectedOffers) -- 1 equivalent call inferred from this helper
	local cartPricingRequestBody = { featureKey = "MARKETPLACE_CART", items = items }

	if unselectedOffers ~= nil then
		cartPricingRequestBody.unselectedOffers = unselectedOffers
	end

	return cartPricingRequestBody
end

local function postCartPricing(p, items, unselectedOffers, p2, p3)
	if items == nil or #items == 0 or p.postCartPricing == nil then
		return Promise.resolve(nil)
	end

	return p.postCartPricing(buildCartPricingRequestBody(items, unselectedOffers)):andThen(function(p4) -- inferred equivalent call
		logUnifiedPurchaseTelemetryCounter(UnifiedPurchaseTelemetry.UnifiedCartPricingFetchSucceededCounter, p2, p3)

		return p4
	end):catch(function(p4): nil
		logUnifiedPurchaseTelemetryCounter(UnifiedPurchaseTelemetry.UnifiedCartPricingFetchFailedCounter, p2, p3)

		warn(string.format("postCartPricing failed: %s", (tostring(p4))))
		return nil
	end)
end

return postCartPricing
