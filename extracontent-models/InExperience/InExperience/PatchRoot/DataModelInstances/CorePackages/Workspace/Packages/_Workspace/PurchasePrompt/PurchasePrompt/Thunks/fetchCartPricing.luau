local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local HttpService = game:GetService("HttpService")
local Network = require(PurchasePrompt.Services.Network)
local Thunk = require(PurchasePrompt.Thunk)
local postCartPricing = require(PurchasePrompt.Network.postCartPricing)
local getCartPricingRequestedItemsForCartPricing = require(PurchasePrompt.Utils.getCartPricingRequestedItemsForCartPricing)
local logUnifiedPurchaseTelemetryCounter = require(PurchasePrompt.Utils.logUnifiedPurchaseTelemetryCounter)
local UnifiedPurchaseTelemetry = require(PurchasePrompt.Events.UnifiedPurchaseTelemetry)
local SetCartPricingFetching = require(PurchasePrompt.Actions.SetCartPricingFetching)
local SetCartPricingResponse = require(PurchasePrompt.Actions.SetCartPricingResponse)
local SetCartPricingFetchFailed = require(PurchasePrompt.Actions.SetCartPricingFetchFailed)
local t1 = { Network }

local function resolveCollectibleItemId(p1) -- line: 31
	local productInfo = p1.productInfo

	if productInfo ~= nil and (type(productInfo.collectibleItemId) == "string" and productInfo.collectibleItemId ~= "") then
		return productInfo.collectibleItemId
	end

	local promptRequest = p1.promptRequest
	local v18 = promptRequest and promptRequest.collectibleItemId

	if type(v18) == "string" and v18 ~= "" then
		return v18
	end

	return nil
end
local function fetchCartPricing(t2: {[any]: any}?) -- line: 48
	-- upvalues: Thunk (copy), t1 (copy), Network (copy), getCartPricingRequestedItemsForCartPricing (copy), HttpService (copy), SetCartPricingFetching (copy), postCartPricing (copy), SetCartPricingFetchFailed (copy), SetCartPricingResponse (copy), logUnifiedPurchaseTelemetryCounter (copy), UnifiedPurchaseTelemetry (copy)
	return Thunk.new(script.Name, t1, function(p2, p3) -- line: 49
		-- upvalues: Network (copy), getCartPricingRequestedItemsForCartPricing (copy), HttpService (copy), SetCartPricingFetching (copy), postCartPricing (copy), t2 (copy), SetCartPricingFetchFailed (copy), SetCartPricingResponse (copy), logUnifiedPurchaseTelemetryCounter (copy), UnifiedPurchaseTelemetry (copy)
		local v22 = p3[Network]
		local v23 = p2:getState()
		local purchaseOptions = v23.purchaseOptions

		if purchaseOptions == nil or not purchaseOptions.shouldFetchCartPricing then
			return nil
		end

		local v25 = getCartPricingRequestedItemsForCartPricing
		local productInfo = v23.productInfo
		local collectibleItemId

		if productInfo ~= nil and type(productInfo.collectibleItemId) == "string" and productInfo.collectibleItemId ~= "" then
			collectibleItemId = productInfo.collectibleItemId
		else
			local promptRequest = v23.promptRequest
			local v29 = promptRequest and promptRequest.collectibleItemId

			collectibleItemId = if type(v29) ~= "string" or v29 == "" then nil else v29
		end

		local v30 = v25(collectibleItemId, v23.productPayload, v23.productInfo)

		if v30 == nil or #v30 == 0 then
			return nil
		end

		local purchaseAnalyticsMetadata = v23.purchaseAnalyticsMetadata
		local v32 = purchaseAnalyticsMetadata and purchaseAnalyticsMetadata.surface
		local v33 = purchaseAnalyticsMetadata and purchaseAnalyticsMetadata.productType
		local guid = HttpService:GenerateGUID(false)

		p2:dispatch(SetCartPricingFetching(guid))

		local function isCurrentRequest() -- line: 76
			-- upvalues: p2 (copy), guid (copy)
			local cartPricing = p2:getState().cartPricing

			return cartPricing ~= nil and cartPricing.requestId == guid
		end

		return postCartPricing(v22, v30, t2, v32, v33):andThen(function(p4) -- line: 82
			-- upvalues: p2 (copy), guid (copy), SetCartPricingFetchFailed (copy), SetCartPricingResponse (copy)
			local cartPricing = p2:getState().cartPricing

			if cartPricing == nil or cartPricing.requestId ~= guid then
				return nil
			end

			if p4 == nil then
				p2:dispatch(SetCartPricingFetchFailed())

				return nil
			end

			p2:dispatch(SetCartPricingResponse(p4))

			return p4
		end):catch(function() -- line: 96
			-- upvalues: logUnifiedPurchaseTelemetryCounter (copy), UnifiedPurchaseTelemetry (copy), v32 (copy), v33 (copy), p2 (copy), guid (copy), SetCartPricingFetchFailed (copy)
			logUnifiedPurchaseTelemetryCounter(UnifiedPurchaseTelemetry.UnifiedCartPricingHandlerErrorCounter, v32, v33)

			local cartPricing = p2:getState().cartPricing

			if cartPricing ~= nil and cartPricing.requestId == guid then
				p2:dispatch(SetCartPricingFetchFailed())
			end
		end)
	end)
end

return fetchCartPricing
