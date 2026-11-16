local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local InExperienceOffers = require(parent.InExperienceOffers)
local Promise = require(PurchasePrompt.Promise)
local Network = require(PurchasePrompt.Services.Network)
local ExternalSettings = require(PurchasePrompt.Services.ExternalSettings)
local Thunk = require(PurchasePrompt.Thunk)
require(PurchasePrompt.types)

local postInGameItemCartPricing = require(PurchasePrompt.Network.postInGameItemCartPricing)
local MockPostInGameItemCartPricing = require(PurchasePrompt.Mocks.MockPostInGameItemCartPricing)
local FFlagMockCartPricingResponseInStudio = require(PurchasePrompt.Flags.FFlagMockCartPricingResponseInStudio)
local getInGameItemCartPricingRequestedItems = require(PurchasePrompt.Utils.getInGameItemCartPricingRequestedItems)
local getInGameItemProductIdentifier = require(PurchasePrompt.Utils.getInGameItemProductIdentifier)
local getFeatureKeyForSurface = require(PurchasePrompt.Utils.getFeatureKeyForSurface)
local getProductTypeFromRequestType = require(PurchasePrompt.Utils.getProductTypeFromRequestType)
local logUnifiedPurchaseTelemetryCounter = require(PurchasePrompt.Utils.logUnifiedPurchaseTelemetryCounter)
local UnifiedPurchaseTelemetry = require(PurchasePrompt.Events.UnifiedPurchaseTelemetry)

local SetCartPricingFetching = require(PurchasePrompt.Actions.SetCartPricingFetching)
local SetCartPricingResponse = require(PurchasePrompt.Actions.SetCartPricingResponse)
local SetCartPricingFetchFailed = require(PurchasePrompt.Actions.SetCartPricingFetchFailed)

local v = FFlagMockCartPricingResponseInStudio and { Network, ExternalSettings } or { Network }

local function resolveProductIdentifier(state)
	local promptRequest = state.promptRequest

	if promptRequest == nil then
		return nil
	end

	return getInGameItemProductIdentifier(promptRequest.infoType, promptRequest.id)
end

local function fetchInGameItemCartPricing(p)
	return Thunk.new(script.Name, v, function(object, p2)
		local v2 = p2[Network]
		local state = object:getState()

		local v3 = FFlagMockCartPricingResponseInStudio and p2[ExternalSettings].isStudio()
		local v4

		if v3 then
			v4 = MockPostInGameItemCartPricing
		else
			v4 = postInGameItemCartPricing
		end

		local v5 = getInGameItemCartPricingRequestedItems(resolveProductIdentifier(state))

		if v5 == nil or #v5 == 0 then
			return Promise.resolve(nil)
		end

		local userId = Players.LocalPlayer.UserId
		local purchaseAnalyticsMetadata = state.purchaseAnalyticsMetadata
		local surface = purchaseAnalyticsMetadata and purchaseAnalyticsMetadata.surface
		local featureKeyForSurface = getFeatureKeyForSurface(surface)

		if not v3 then
			local offers = InExperienceOffers.getOffersStore(false).getOffers(false)

			if InExperienceOffers.Utils.getOffersForKey(
				offers,
				featureKeyForSurface,
				InExperienceOffers.OfferStatuses.Available
			) == nil then
				return Promise.resolve(nil)
			end
		end

		local productTypeFromRequestType = getProductTypeFromRequestType(state.promptRequest.requestType)

		local guid = HttpService:GenerateGUID(false)
		object:dispatch(SetCartPricingFetching(guid))

		local function isCurrentRequest(): boolean -- 2 equivalent calls inferred from this helper
			local cartPricing = object:getState().cartPricing
			return cartPricing ~= nil and cartPricing.requestId == guid
		end

		return v4(v2, userId, featureKeyForSurface, v5, p, surface, productTypeFromRequestType):andThen(function(p3)
			if not isCurrentRequest() then -- inferred equivalent call
				return nil
			end

			if p3 == nil then
				object:dispatch(SetCartPricingFetchFailed())
				return nil
			end

			object:dispatch(SetCartPricingResponse(p3))
			return p3
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
	end)
end

return fetchInGameItemCartPricing
