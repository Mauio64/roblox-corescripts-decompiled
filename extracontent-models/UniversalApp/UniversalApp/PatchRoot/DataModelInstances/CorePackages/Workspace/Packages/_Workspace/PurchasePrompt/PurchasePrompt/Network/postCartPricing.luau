local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent

require(ParentParentParent.PurchasePromptLite)

local Promise = require(ParentParent.Promise)

require(ParentParent.types)

local UnifiedPurchaseTelemetry = require(ParentParent.Events.UnifiedPurchaseTelemetry)
local logUnifiedPurchaseTelemetryCounter = require(ParentParent.Utils.logUnifiedPurchaseTelemetryCounter)

local function buildCartPricingRequestBody(t1: {[any]: any}, t2: {[any]: any}?) -- line: 18
	local t3 = {
		featureKey = "MARKETPLACE_CART",
		items = t1
	}

	if t2 ~= nil then
		t3.unselectedOffers = t2
	end

	return t3
end
local function postCartPricing(p1, t4: {[any]: any}?, t5: {[any]: any}?, p2, p3) -- line: 32
	-- upvalues: Promise (copy), logUnifiedPurchaseTelemetryCounter (copy), UnifiedPurchaseTelemetry (copy)
	if t4 == nil or (#t4 == 0 or p1.postCartPricing == nil) then
		return Promise.resolve(nil)
	end

	local postCartPricing2 = p1.postCartPricing
	local t6 = {
		featureKey = "MARKETPLACE_CART",
		items = t4
	}

	if t5 ~= nil then
		t6.unselectedOffers = t5
	end

	return postCartPricing2(t6):andThen(function(p4) -- line: 48
		-- upvalues: logUnifiedPurchaseTelemetryCounter (copy), UnifiedPurchaseTelemetry (copy), p2 (copy), p3 (copy)
		logUnifiedPurchaseTelemetryCounter(UnifiedPurchaseTelemetry.UnifiedCartPricingFetchSucceededCounter, p2, p3)

		return p4
	end):catch(function(p5) -- line: 56
		-- upvalues: logUnifiedPurchaseTelemetryCounter (copy), UnifiedPurchaseTelemetry (copy), p2 (copy), p3 (copy)
		logUnifiedPurchaseTelemetryCounter(UnifiedPurchaseTelemetry.UnifiedCartPricingFetchFailedCounter, p2, p3)
		warn(string.format("postCartPricing failed: %s", (tostring(p5))))

		return nil
	end)
end

return postCartPricing
