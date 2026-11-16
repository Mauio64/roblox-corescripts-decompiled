local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local InExperienceOffers = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/InExperienceOffers")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Promise")
local Network = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/Network")
local ExternalSettings = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/ExternalSettings")
local Thunk = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunk")
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/types")

local postInGameItemCartPricing = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Network/postInGameItemCartPricing")
local MockPostInGameItemCartPricing = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Mocks/MockPostInGameItemCartPricing")
local FFlagMockCartPricingResponseInStudio = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagMockCartPricingResponseInStudio")
local getInGameItemCartPricingRequestedItems = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/getInGameItemCartPricingRequestedItems")
local getInGameItemProductIdentifier = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/getInGameItemProductIdentifier")
local getFeatureKeyForSurface = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/getFeatureKeyForSurface")
local getProductTypeFromRequestType = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/getProductTypeFromRequestType")
local logUnifiedPurchaseTelemetryCounter = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/logUnifiedPurchaseTelemetryCounter")
local UnifiedPurchaseTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Events/UnifiedPurchaseTelemetry")

local SetCartPricingFetching = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetCartPricingFetching")
local SetCartPricingResponse = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetCartPricingResponse")
local SetCartPricingFetchFailed = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetCartPricingFetchFailed")

local v5 = FFlagMockCartPricingResponseInStudio and { Network, ExternalSettings } or { Network }

local function resolveProductIdentifier(state)
	local promptRequest = state.promptRequest

	if promptRequest == nil then
		return nil
	end

	return getInGameItemProductIdentifier(promptRequest.infoType, promptRequest.id)
end

local function fetchInGameItemCartPricing(p2)
	return Thunk.new("fetchInGameItemCartPricing", v5, function(object, p3)
		local v6 = p3[Network]
		local state = object:getState()

		local v7 = FFlagMockCartPricingResponseInStudio and p3[ExternalSettings].isStudio()
		local v8 = if v7 then MockPostInGameItemCartPricing else postInGameItemCartPricing
		local v9 = getInGameItemCartPricingRequestedItems(resolveProductIdentifier(state))

		if v9 == nil or #v9 == 0 then
			return Promise.resolve(nil)
		end

		local userId = Players.LocalPlayer.UserId
		local purchaseAnalyticsMetadata = state.purchaseAnalyticsMetadata
		local surface = purchaseAnalyticsMetadata and purchaseAnalyticsMetadata.surface
		local v10 = getFeatureKeyForSurface(surface)

		if not v7 then
			local offers = InExperienceOffers.getOffersStore(false).getOffers(false)

			if InExperienceOffers.Utils.getOffersForKey(offers, v10, InExperienceOffers.OfferStatuses.Available) == nil then
				return Promise.resolve(nil)
			end
		end

		local v11 = getProductTypeFromRequestType(state.promptRequest.requestType)

		local guid = HttpService:GenerateGUID(false)
		object:dispatch(SetCartPricingFetching(guid))

		local function isCurrentRequest(): boolean
			local cartPricing = object:getState().cartPricing
			return cartPricing ~= nil and cartPricing.requestId == guid
		end

		return v8(v6, userId, v10, v9, p2, surface, v11):andThen(function(p4)
			local cartPricing = object:getState().cartPricing
			local v12 = not (cartPricing == nil) and cartPricing.requestId == guid

			if not v12 then
				return nil
			end

			if p4 == nil then
				object:dispatch(SetCartPricingFetchFailed())
				return nil
			end

			object:dispatch(SetCartPricingResponse(p4))
			return p4
		end):catch(function()
			logUnifiedPurchaseTelemetryCounter(UnifiedPurchaseTelemetry.UnifiedCartPricingHandlerErrorCounter, surface, v11)
			local cartPricing = object:getState().cartPricing
			local v12 = not (cartPricing == nil) and cartPricing.requestId == guid

			if v12 then
				object:dispatch(SetCartPricingFetchFailed())
			end
		end)
	end)
end

return fetchInGameItemCartPricing
