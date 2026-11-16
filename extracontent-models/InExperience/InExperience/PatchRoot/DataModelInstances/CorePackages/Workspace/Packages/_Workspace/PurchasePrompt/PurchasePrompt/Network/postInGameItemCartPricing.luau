local parent = script.Parent.Parent
local parent2 = parent.Parent

require(parent2.PurchasePromptLite)

local Promise = require(parent.Promise)
require(parent.types)
local UnifiedPurchaseTelemetry = require(parent.Events.UnifiedPurchaseTelemetry)
local logUnifiedPurchaseTelemetryCounter = require(parent.Utils.logUnifiedPurchaseTelemetryCounter)

local function buildRequestBody(userId: number, featureKey: string, items, list)
	local requestBody = { userId = userId, featureKey = featureKey, items = items }

	if list == nil or not (#list > 0) then
		return requestBody
	end

	local offerSelections = {}

	for _, item in list do
		table.insert(offerSelections, {
			offerId = item,
			selectionType = "OFFER_SELECTION_TYPE_EXCLUDED"
		})
	end

	requestBody.offerSelections = offerSelections

	return requestBody
end

local function postInGameItemCartPricing(p, userId: number, featureKey: string, items, p2, p3, p4)
	if items == nil or #items == 0 or p.postInGameItemCartPricing == nil then
		return Promise.resolve(nil)
	end

	return p.postInGameItemCartPricing(buildRequestBody(userId, featureKey, items, p2)):andThen(function(p5)
		logUnifiedPurchaseTelemetryCounter(UnifiedPurchaseTelemetry.UnifiedCartPricingFetchSucceededCounter, p3, p4)

		return p5
	end):catch(function(p5): nil
		logUnifiedPurchaseTelemetryCounter(UnifiedPurchaseTelemetry.UnifiedCartPricingFetchFailedCounter, p3, p4)

		warn(string.format("postInGameItemCartPricing failed: %s", (tostring(p5))))
		return nil
	end)
end

return postInGameItemCartPricing
