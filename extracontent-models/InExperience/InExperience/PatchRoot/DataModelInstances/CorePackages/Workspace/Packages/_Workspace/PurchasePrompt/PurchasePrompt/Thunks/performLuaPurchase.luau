local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local parent = PurchasePrompt.Parent
local IAPExperience = require(parent.IAPExperience)
local isEconomicRestrictionResponse = IAPExperience.Utility.isEconomicRestrictionResponse

local ErrorOccurred = require(PurchasePrompt.Actions.ErrorOccurred)
local SetEconomicRestrictionError = require(PurchasePrompt.Actions.SetEconomicRestrictionError)
local VIPServerCreated = require(PurchasePrompt.Actions.VIPServerCreated)
local PurchaseError = require(PurchasePrompt.Enums.PurchaseError)
local Network = require(PurchasePrompt.Services.Network)
local Analytics = require(PurchasePrompt.Services.Analytics)
local Thunk = require(PurchasePrompt.Thunk)
local Promise = require(PurchasePrompt.Promise)
local Constants = require(PurchasePrompt.Misc.Constants)
require(PurchasePrompt.types)
local types = require(PurchasePrompt.types)
local productTypeEnum = types.ProductTypeEnum
local completePurchase = require(script.Parent.completePurchase)
local handlePriceChangedError = require(PurchasePrompt.Utils.handlePriceChangedError)

local performDevProductEdpPurchase = require(PurchasePrompt.Network.performDevProductEdpPurchase)
local performExperiencePurchase = require(PurchasePrompt.Network.performExperiencePurchase)
local performLookPurchase = require(PurchasePrompt.Network.performLookPurchase)
local performDeveloperSubscriptionRobuxPurchase = require(PurchasePrompt.Network.performDeveloperSubscriptionRobuxPurchase)
local performDeveloperSubscriptionFiatPurchase = require(PurchasePrompt.Network.performDeveloperSubscriptionFiatPurchase)
local performVIPServerPurchase = require(PurchasePrompt.Network.performVIPServerPurchase)

local deriveSelectedOfferIdsFromCartPricing = require(PurchasePrompt.Utils.deriveSelectedOfferIdsFromCartPricing)
local applyCartPricingOffersToLineItems = require(PurchasePrompt.Utils.applyCartPricingOffersToLineItems)
local selectProductPrice = require(PurchasePrompt.Selectors.selectProductPrice)

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableUnifiedPurchaseFlowForDevSubs = SharedFlags.FFlagEnableUnifiedPurchaseFlowForDevSubs

local SharedFlags2 = require(parent.SharedFlags)
local FFlagPurchasePromptFetchCartPricingForLooks = SharedFlags2.FFlagPurchasePromptFetchCartPricingForLooks
local FFlagEnablePriceChangedErrorHandling = require(PurchasePrompt.Flags.FFlagEnablePriceChangedErrorHandling)
local FFlagEnableRequestLocationTypeForSduiPurchase = require(PurchasePrompt.Flags.FFlagEnableRequestLocationTypeForSduiPurchase)
local SharedFlags3 = require(parent.SharedFlags)
local FFlagEnableSearchGameItemOwnershipUpdate = SharedFlags3.FFlagEnableSearchGameItemOwnershipUpdate
local SharedFlags4 = require(parent.SharedFlags)
local FFlagEnableEdpPreviewPurchaseSurface = SharedFlags4.FFlagEnableEdpPreviewPurchaseSurface

local SharedFlags5 = require(parent.SharedFlags)
local FFlagLuaAppsEnablePromptVIPServerPurchase = SharedFlags5.FFlagLuaAppsEnablePromptVIPServerPurchase
local RobloxTranslator = require(parent.RobloxTranslator)

local PurchasePromptLite = require(parent.PurchasePromptLite)
local ProductPurchaseSurface = PurchasePromptLite.Enums.ProductPurchaseSurface

local v = {
	[ProductPurchaseSurface.EDP] = "ExperienceDetailPage",
	[ProductPurchaseSurface.EDPPreview] = FFlagEnableEdpPreviewPurchaseSurface and "ExperienceDetailPagePreview" or nil,
	[ProductPurchaseSurface.HomePageGameItemShop] = "HomePageGameItemShop",
	[ProductPurchaseSurface.SearchPageGameItemShop] = FFlagEnableSearchGameItemOwnershipUpdate and "SearchPageGameItemShop" or nil
}

local function decodePurchasePayload(value: string?)
	if type(value) ~= "string" or value == "" then
		return nil
	end

	local success, result = pcall(HttpService.JSONDecode, HttpService, value)

	if success and type(result) == "table" and type(result.surface) == "table" then
		return result
	end

	return nil
end

local parseEconomicRestrictionsFailureReason = IAPExperience.Utility.parseEconomicRestrictionsFailureReason

local parseEconomicRestrictionsExpirationTimeInMinutes = IAPExperience.Utility.parseEconomicRestrictionsExpirationTimeInMinutes

local v2 = { Network, Analytics }

local function handleGenericPurchaseError(object, p, p2: string?)
	if isEconomicRestrictionResponse(p) then
		object:dispatch(SetEconomicRestrictionError(
			parseEconomicRestrictionsFailureReason(p),
			(parseEconomicRestrictionsExpirationTimeInMinutes(p))
		))
		object:dispatch(ErrorOccurred(PurchaseError.EconomicRestriction))
	else
		if handlePriceChangedError(object, p, p2) then
			return
		end

		if PurchaseError.isMember(p) then
			object:dispatch(ErrorOccurred(p))
		else
			object:dispatch(ErrorOccurred(PurchaseError.UnknownFailure))
		end
	end
end

local function performLuaPurchase()
	return Thunk.new(script.Name, v2, function(object, p)
		local v3 = p[Network]
		local v4 = p[Analytics]

		local state = object:getState()
		local productInfo = state.productInfo
		local price = productInfo.price
		local productId = productInfo.productId
		local promptRequest = state.promptRequest
		local id = state.promptRequest.id
		local productPayload = state.productPayload

		if productPayload.kind == "Product" then
			local v5 = {
				expectedCurrency = Constants.Currency.Robux,
				expectedPrice = price,
				saleLocationId = productPayload.universeId
			}

			if FFlagEnableRequestLocationTypeForSduiPurchase then
				local surface = state.purchaseAnalyticsMetadata and state.purchaseAnalyticsMetadata.surface
				v5.requestLocationType = surface == nil and "" or v[surface] or ""
			end

			local purchasePayload = productPayload.purchasePayload
			local result

			if type(purchasePayload) == "string" and purchasePayload ~= "" then
				local success
				success, result = pcall(HttpService.JSONDecode, HttpService, purchasePayload)

				if not success or type(result) ~= "table" or type(result.surface) ~= "table" then
					result = nil
				end
			end

			v5.purchasePayload = result

			return performDevProductEdpPurchase(v3, productId, v5):andThen(function(p2)
				object:dispatch(completePurchase(p2))

				v4.signalPurchaseSuccess(id, Enum.InfoType.Product, nil, p2)

				return Promise.resolve(p2)
			end):catch(function(p2)
				local v6

				if FFlagEnablePriceChangedErrorHandling then
					v6 = productPayload.kind
				end

				handleGenericPurchaseError(object, p2, v6)
			end)
		end

		if productPayload.kind == productTypeEnum.Experience then
			return performExperiencePurchase(v3, productId, {
				expectedCurrency = Constants.Currency.Robux,
				expectedPrice = price,
				sellerId = productInfo.sellerId
			}):andThen(function(p2)
				object:dispatch(completePurchase(p2))

				return Promise.resolve(p2)
			end):catch(function(p2)
				local v5

				if FFlagEnablePriceChangedErrorHandling then
					v5 = productPayload.kind
				end

				handleGenericPurchaseError(object, p2, v5)
			end)
		end

		if productPayload.kind == productTypeEnum.Look then
			local expectedPrice = productPayload.expectedPrice
			local bulkPurchaseLineItems, selectedOfferIds

			if FFlagPurchasePromptFetchCartPricingForLooks then
				bulkPurchaseLineItems = productPayload.bulkPurchaseLineItems

				local cartPricing = state.cartPricing
				local response = cartPricing and cartPricing.response

				if response == nil then
					selectedOfferIds = {}
				else
					expectedPrice = selectProductPrice(state) or expectedPrice
					selectedOfferIds = deriveSelectedOfferIdsFromCartPricing(response)

					if bulkPurchaseLineItems ~= nil then
						bulkPurchaseLineItems = applyCartPricingOffersToLineItems(
							bulkPurchaseLineItems,
							response,
							selectedOfferIds
						)
					end
				end
			end

			local v5 = {
				lookId = productPayload.id,
				idempotencyKey = HttpService:GenerateGUID(false),
				expectedPrice = expectedPrice,
				salesLocationId = productPayload.salesLocationId,
				excludedAssets = productPayload.excludedAssetIds,
				excludedBundles = productPayload.excludedBundleIds,
				timedOptions = productPayload.timedOptions,
				selectedOfferIds = selectedOfferIds,
				bulkPurchaseLineItems = 0
			}

			if not FFlagPurchasePromptFetchCartPricingForLooks then
				bulkPurchaseLineItems = nil
			end

			v5.bulkPurchaseLineItems = bulkPurchaseLineItems

			return performLookPurchase(v3, productPayload.id, v5):andThen(function(p2)
				object:dispatch(completePurchase(p2))

				return Promise.resolve(p2)
			end):catch(function(p2)
				local v6

				if FFlagEnablePriceChangedErrorHandling then
					v6 = productPayload.kind
				end

				handleGenericPurchaseError(object, p2, v6)
			end)
		elseif
			FFlagEnableUnifiedPurchaseFlowForDevSubs
			and productPayload.kind == productTypeEnum.DeveloperSubscription
		then
			local subscriptionId = productPayload.subscriptionId
			local v5

			if productPayload.isSubscriptionInRobux then
				v5 = performDeveloperSubscriptionRobuxPurchase(v3, subscriptionId, productPayload.expectedPrice)
			else
				v5 = performDeveloperSubscriptionFiatPurchase(v3, subscriptionId)
			end

			return v5:andThen(function()
				object:dispatch(completePurchase())
				return Promise.resolve()
			end):catch(function(p2)
				local v6

				if FFlagEnablePriceChangedErrorHandling then
					v6 = productPayload.kind
				end

				handleGenericPurchaseError(object, p2, v6)
			end)
		else
			if not FFlagLuaAppsEnablePromptVIPServerPurchase or productPayload.kind ~= productTypeEnum.VIPServer then
				return
			end

			local v5 = {
				name = RobloxTranslator:FormatByKey("Feature.PrivateServers.Label.OwnersServer", {
					displayName = Players.LocalPlayer.DisplayName
				}),
				expectedPrice = price,
				idempotencyKey = promptRequest.idempotencyKey
			}

			return performVIPServerPurchase(v3, productPayload.universeId, v5):andThen(function(data)
				local name

				if type(data.name) == "string" then
					name = data.name
				else
					name = v5.name
				end

				local v6

				if type(data.accessCode) == "string" then
					v6 = data.accessCode
				end

				object:dispatch(VIPServerCreated(data.vipServerId, name, v6))
				object:dispatch(completePurchase(data))

				return Promise.resolve(data)
			end):catch(function(p2)
				local v6

				if FFlagEnablePriceChangedErrorHandling then
					v6 = productPayload.kind
				end

				handleGenericPurchaseError(object, p2, v6)
			end)
		end
	end)
end

return performLuaPurchase
