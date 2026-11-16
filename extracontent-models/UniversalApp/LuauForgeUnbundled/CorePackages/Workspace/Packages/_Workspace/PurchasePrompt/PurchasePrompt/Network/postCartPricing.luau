require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptLite")

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Promise")
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/types")
local UnifiedPurchaseTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Events/UnifiedPurchaseTelemetry")
local logUnifiedPurchaseTelemetryCounter = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/logUnifiedPurchaseTelemetryCounter")

local function buildCartPricingRequestBody(p2, unselectedOffers)
	local cartPricingRequestBody = { featureKey = "MARKETPLACE_CART", items = p2 }

	if unselectedOffers ~= nil then
		cartPricingRequestBody.unselectedOffers = unselectedOffers
	end

	return cartPricingRequestBody
end

local function postCartPricing(p2, list, unselectedOffers, p3, p4)
	if list == nil or #list == 0 or p2.postCartPricing == nil then
		return Promise.resolve(nil)
	end

	local postCartPricing2 = p2.postCartPricing
	local v5 = { featureKey = "MARKETPLACE_CART", items = list }

	if unselectedOffers ~= nil then
		v5.unselectedOffers = unselectedOffers
	end

	return postCartPricing2(v5):andThen(function(p5)
		logUnifiedPurchaseTelemetryCounter(UnifiedPurchaseTelemetry.UnifiedCartPricingFetchSucceededCounter, p3, p4)

		return p5
	end):catch(function(p5): nil
		logUnifiedPurchaseTelemetryCounter(UnifiedPurchaseTelemetry.UnifiedCartPricingFetchFailedCounter, p3, p4)

		warn(string.format("postCartPricing failed: %s", (tostring(p5))))
		return nil
	end)
end

return postCartPricing
