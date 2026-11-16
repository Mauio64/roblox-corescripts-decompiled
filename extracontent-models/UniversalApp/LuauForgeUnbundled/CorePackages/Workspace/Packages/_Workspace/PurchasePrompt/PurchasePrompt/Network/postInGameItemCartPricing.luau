require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptLite")

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Promise")
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/types")
local UnifiedPurchaseTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Events/UnifiedPurchaseTelemetry")
local logUnifiedPurchaseTelemetryCounter = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/logUnifiedPurchaseTelemetryCounter")

local function buildRequestBody(p2, p3, list, list2)
	local requestBody = { userId = p2, featureKey = p3, items = list }

	if list2 == nil or not (#list2 > 0) then
		return requestBody
	end

	local v5 = {}

	for k, item in list2 do
		table.insert(v5, {
			offerId = item,
			selectionType = "OFFER_SELECTION_TYPE_EXCLUDED"
		})
	end

	requestBody.offerSelections = v5

	return requestBody
end

local function postInGameItemCartPricing(p2, p3, p4, list, p5, p6, p7)
	if list == nil or #list == 0 or p2.postInGameItemCartPricing == nil then
		return Promise.resolve(nil)
	end

	return p2.postInGameItemCartPricing(buildRequestBody(p3, p4, list, p5)):andThen(function(p8)
		logUnifiedPurchaseTelemetryCounter(UnifiedPurchaseTelemetry.UnifiedCartPricingFetchSucceededCounter, p6, p7)

		return p8
	end):catch(function(p8): nil
		logUnifiedPurchaseTelemetryCounter(UnifiedPurchaseTelemetry.UnifiedCartPricingFetchFailedCounter, p6, p7)

		warn(string.format("postInGameItemCartPricing failed: %s", (tostring(p8))))
		return nil
	end)
end

return postInGameItemCartPricing
