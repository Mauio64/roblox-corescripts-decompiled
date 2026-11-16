local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local HttpService = game:GetService("HttpService")

local Promise = require(PurchasePrompt.Promise)
local Network = require(PurchasePrompt.Services.Network)
local Thunk = require(PurchasePrompt.Thunk)

local postCartPricing = require(PurchasePrompt.Network.postCartPricing)
local getCartPricingRequestedItemsForCartPricing = require(PurchasePrompt.Utils.getCartPricingRequestedItemsForCartPricing)
local getProductTypeFromRequestType = require(PurchasePrompt.Utils.getProductTypeFromRequestType)
local logUnifiedPurchaseTelemetryCounter = require(PurchasePrompt.Utils.logUnifiedPurchaseTelemetryCounter)
local UnifiedPurchaseTelemetry = require(PurchasePrompt.Events.UnifiedPurchaseTelemetry)

local SharedFlags = require(PurchasePrompt.Parent.SharedFlags)
local FFlagEnableFetchCartPricingDuringInExperience = SharedFlags.FFlagEnableFetchCartPricingDuringInExperience
local defineFastFlag = game:DefineFastFlag("DisableInExpMarketplaceOffersTemp", false)

local SetCartPricingFetching = require(PurchasePrompt.Actions.SetCartPricingFetching)
local SetCartPricingResponse = require(PurchasePrompt.Actions.SetCartPricingResponse)
local SetCartPricingFetchFailed = require(PurchasePrompt.Actions.SetCartPricingFetchFailed)

local v = { Network }

local function resolveCollectibleItemId(p)
	local productInfo = p.productInfo

	if
		productInfo ~= nil
		and type(productInfo.collectibleItemId) == "string"
		and productInfo.collectibleItemId ~= ""
	then
		return productInfo.collectibleItemId
	end

	local promptRequest = p.promptRequest
	local collectibleItemId = promptRequest and promptRequest.collectibleItemId

	if type(collectibleItemId) == "string" and collectibleItemId ~= "" then
		return collectibleItemId
	end

	return nil
end

local function fetchCartPricing(p, p2: string?)
	return Thunk.new(script.Name, v, function(object, p3)
		local v2 = p3[Network]

		local state = object:getState()

		if not FFlagEnableFetchCartPricingDuringInExperience then
			local purchaseOptions = state.purchaseOptions

			if purchaseOptions == nil or not purchaseOptions.shouldFetchCartPricing then
				return nil
			end
		end

		local v3

		if FFlagEnableFetchCartPricingDuringInExperience then
			v3 = p2

			if not v3 then
				local productInfo = state.productInfo

				if
					productInfo == nil
					or type(productInfo.collectibleItemId) ~= "string"
					or productInfo.collectibleItemId == ""
				then
					local promptRequest = state.promptRequest
					v3 = promptRequest and promptRequest.collectibleItemId

					if type(v3) ~= "string" or v3 == "" then
						v3 = nil
					end
				else
					v3 = productInfo.collectibleItemId
				end
			end
		else
			local productInfo = state.productInfo

			if
				productInfo == nil
				or type(productInfo.collectibleItemId) ~= "string"
				or productInfo.collectibleItemId == ""
			then
				local promptRequest = state.promptRequest
				v3 = promptRequest and promptRequest.collectibleItemId

				if type(v3) ~= "string" or v3 == "" then
					v3 = nil
				end
			else
				v3 = productInfo.collectibleItemId
			end
		end

		local cartPricingRequestedItemsForCartPricing = getCartPricingRequestedItemsForCartPricing(
			v3,
			state.productPayload,
			state.productInfo
		)

		if cartPricingRequestedItemsForCartPricing == nil or #cartPricingRequestedItemsForCartPricing == 0 then
			if FFlagEnableFetchCartPricingDuringInExperience then
				return Promise.resolve(nil)
			end

			return nil
		else
			local purchaseAnalyticsMetadata = state.purchaseAnalyticsMetadata
			local surface = purchaseAnalyticsMetadata and purchaseAnalyticsMetadata.surface

			local productTypeFromRequestType = getProductTypeFromRequestType(state.promptRequest.requestType)

			local guid = HttpService:GenerateGUID(false)
			object:dispatch(SetCartPricingFetching(guid))

			local function isCurrentRequest(): boolean -- 2 equivalent calls inferred from this helper
				local cartPricing = object:getState().cartPricing
				return cartPricing ~= nil and cartPricing.requestId == guid
			end

			return postCartPricing(v2, cartPricingRequestedItemsForCartPricing, p, surface, productTypeFromRequestType):andThen(function(p4)
				if defineFastFlag and p2 then
					object:dispatch(SetCartPricingFetchFailed())
					return nil
				end

				if not isCurrentRequest() then -- inferred equivalent call
					return nil
				end

				if p4 == nil then
					object:dispatch(SetCartPricingFetchFailed())
					return nil
				end

				object:dispatch(SetCartPricingResponse(p4))
				return p4
			end):catch(function()
				logUnifiedPurchaseTelemetryCounter(
					UnifiedPurchaseTelemetry.UnifiedCartPricingHandlerErrorCounter,
					surface,
					productTypeFromRequestType
				)

				if isCurrentRequest() then -- inferred equivalent call
					object:dispatch(SetCartPricingFetchFailed())
				end
			end)
		end
	end)
end

return fetchCartPricing
