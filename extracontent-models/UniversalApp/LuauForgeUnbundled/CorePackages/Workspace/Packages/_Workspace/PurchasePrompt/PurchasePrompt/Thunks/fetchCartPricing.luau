local HttpService = game:GetService("HttpService")

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Promise")
local Network = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/Network")
local Thunk = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunk")

local postCartPricing = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Network/postCartPricing")
local getCartPricingRequestedItemsForCartPricing = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/getCartPricingRequestedItemsForCartPricing")
local getProductTypeFromRequestType = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/getProductTypeFromRequestType")
local logUnifiedPurchaseTelemetryCounter = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/logUnifiedPurchaseTelemetryCounter")
local UnifiedPurchaseTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Events/UnifiedPurchaseTelemetry")

local fFlagEnableFetchCartPricingDuringInExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagEnableFetchCartPricingDuringInExperience
local defineFastFlag = game:DefineFastFlag("DisableInExpMarketplaceOffersTemp", false)

local SetCartPricingFetching = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetCartPricingFetching")
local SetCartPricingResponse = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetCartPricingResponse")
local SetCartPricingFetchFailed = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetCartPricingFetchFailed")

local v5 = { Network }

local function resolveCollectibleItemId(p2)
	local productInfo = p2.productInfo

	if
		productInfo ~= nil
		and type(productInfo.collectibleItemId) == "string"
		and productInfo.collectibleItemId ~= ""
	then
		return productInfo.collectibleItemId
	end

	local promptRequest = p2.promptRequest
	local collectibleItemId = promptRequest and promptRequest.collectibleItemId

	if type(collectibleItemId) == "string" and collectibleItemId ~= "" then
		return collectibleItemId
	end

	return nil
end

local function fetchCartPricing(p2, p3)
	return Thunk.new("fetchCartPricing", v5, function(object, p4)
		local v6 = p4[Network]

		local state = object:getState()

		if not fFlagEnableFetchCartPricingDuringInExperience then
			local purchaseOptions = state.purchaseOptions

			if purchaseOptions == nil or not purchaseOptions.shouldFetchCartPricing then
				return nil
			end
		end

		local v8

		if fFlagEnableFetchCartPricingDuringInExperience then
			v8 = p3

			if not v8 then
				local productInfo = state.productInfo

				if
					productInfo == nil
					or type(productInfo.collectibleItemId) ~= "string"
					or productInfo.collectibleItemId == ""
				then
					local promptRequest = state.promptRequest
					v8 = promptRequest and promptRequest.collectibleItemId

					if type(v8) ~= "string" or v8 == "" then
						v8 = nil
					end
				else
					v8 = productInfo.collectibleItemId
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
				v8 = promptRequest and promptRequest.collectibleItemId

				if type(v8) ~= "string" or v8 == "" then
					v8 = nil
				end
			else
				v8 = productInfo.collectibleItemId
			end
		end

		local v9 = getCartPricingRequestedItemsForCartPricing(v8, state.productPayload, state.productInfo)

		if v9 == nil or #v9 == 0 then
			if fFlagEnableFetchCartPricingDuringInExperience then
				return Promise.resolve(nil)
			end

			return nil
		else
			local purchaseAnalyticsMetadata = state.purchaseAnalyticsMetadata
			local surface = purchaseAnalyticsMetadata and purchaseAnalyticsMetadata.surface

			local v10 = getProductTypeFromRequestType(state.promptRequest.requestType)

			local guid = HttpService:GenerateGUID(false)
			object:dispatch(SetCartPricingFetching(guid))

			local function isCurrentRequest(): boolean
				local cartPricing = object:getState().cartPricing
				return cartPricing ~= nil and cartPricing.requestId == guid
			end

			return postCartPricing(v6, v9, p2, surface, v10):andThen(function(p5)
				if defineFastFlag and p3 then
					object:dispatch(SetCartPricingFetchFailed())
					return nil
				end

				local cartPricing = object:getState().cartPricing
				local v11 = not (cartPricing == nil) and cartPricing.requestId == guid

				if not v11 then
					return nil
				end

				if p5 == nil then
					object:dispatch(SetCartPricingFetchFailed())
					return nil
				end

				object:dispatch(SetCartPricingResponse(p5))
				return p5
			end):catch(function()
				logUnifiedPurchaseTelemetryCounter(UnifiedPurchaseTelemetry.UnifiedCartPricingHandlerErrorCounter, surface, v10)
				local cartPricing = object:getState().cartPricing
				local v11 = not (cartPricing == nil) and cartPricing.requestId == guid

				if v11 then
					object:dispatch(SetCartPricingFetchFailed())
				end
			end)
		end
	end)
end

return fetchCartPricing
