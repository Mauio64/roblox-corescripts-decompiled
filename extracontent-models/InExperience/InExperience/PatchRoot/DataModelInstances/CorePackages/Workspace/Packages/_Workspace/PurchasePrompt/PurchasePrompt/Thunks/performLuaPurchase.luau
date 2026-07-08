local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local HttpService = game:GetService("HttpService")
local PurchasePromptParent = PurchasePrompt.Parent
local IAPExperience = require(PurchasePromptParent.IAPExperience)
local isEconomicRestrictionResponse = IAPExperience.Utility.isEconomicRestrictionResponse
local ErrorOccurred = require(PurchasePrompt.Actions.ErrorOccurred)
local SetEconomicRestrictionError = require(PurchasePrompt.Actions.SetEconomicRestrictionError)
local PurchaseError = require(PurchasePrompt.Enums.PurchaseError)
local Network = require(PurchasePrompt.Services.Network)
local Analytics = require(PurchasePrompt.Services.Analytics)
local Thunk = require(PurchasePrompt.Thunk)
local Promise = require(PurchasePrompt.Promise)
local Constants = require(PurchasePrompt.Misc.Constants)

require(PurchasePrompt.types)

local ProductTypeEnum = require(PurchasePrompt.types).ProductTypeEnum
local completePurchase = require(script.Parent.completePurchase)
local handlePriceChangedError = require(PurchasePrompt.Utils.handlePriceChangedError)
local performDevProductEdpPurchase = require(PurchasePrompt.Network.performDevProductEdpPurchase)
local performExperiencePurchase = require(PurchasePrompt.Network.performExperiencePurchase)
local performLookPurchase = require(PurchasePrompt.Network.performLookPurchase)
local performDeveloperSubscriptionRobuxPurchase = require(PurchasePrompt.Network.performDeveloperSubscriptionRobuxPurchase)
local performDeveloperSubscriptionFiatPurchase = require(PurchasePrompt.Network.performDeveloperSubscriptionFiatPurchase)
local deriveSelectedOfferIdsFromCartPricing = require(PurchasePrompt.Utils.deriveSelectedOfferIdsFromCartPricing)
local selectProductPrice = require(PurchasePrompt.Selectors.selectProductPrice)
local FFlagEnableUnifiedPurchaseFlowForDevSubs = require(PurchasePromptParent.SharedFlags).FFlagEnableUnifiedPurchaseFlowForDevSubs
local FFlagPurchasePromptFetchCartPricingForLooks = require(PurchasePromptParent.SharedFlags).FFlagPurchasePromptFetchCartPricingForLooks
local FFlagEnablePriceChangedErrorHandling = require(PurchasePrompt.Flags.FFlagEnablePriceChangedErrorHandling)
local parseEconomicRestrictionsFailureReason = IAPExperience.Utility.parseEconomicRestrictionsFailureReason
local parseEconomicRestrictionsExpirationTimeInMinutes = IAPExperience.Utility.parseEconomicRestrictionsExpirationTimeInMinutes
local t1 = {
	Network,
	Analytics
}

local function handleGenericPurchaseError(p1, p2, s1: string?) -- line: 44
	-- upvalues: isEconomicRestrictionResponse (copy), parseEconomicRestrictionsFailureReason (copy), parseEconomicRestrictionsExpirationTimeInMinutes (copy), SetEconomicRestrictionError (copy), ErrorOccurred (copy), PurchaseError (copy), handlePriceChangedError (copy)
	if isEconomicRestrictionResponse(p2) then
		local v35 = parseEconomicRestrictionsFailureReason(p2)
		local v36 = parseEconomicRestrictionsExpirationTimeInMinutes(p2)

		p1:dispatch(SetEconomicRestrictionError(v35, v36))
		p1:dispatch(ErrorOccurred(PurchaseError.EconomicRestriction))

		return
	end

	if handlePriceChangedError(p1, p2, s1) then
		return
	end

	if PurchaseError.isMember(p2) then
		p1:dispatch(ErrorOccurred(p2))

		return
	end

	p1:dispatch(ErrorOccurred(PurchaseError.UnknownFailure))
end
local function performLuaPurchase() -- line: 65
	-- upvalues: Thunk (copy), t1 (copy), Network (copy), Analytics (copy), Constants (copy), performDevProductEdpPurchase (copy), completePurchase (copy), Promise (copy), handleGenericPurchaseError (copy), FFlagEnablePriceChangedErrorHandling (copy), ProductTypeEnum (copy), performExperiencePurchase (copy), FFlagPurchasePromptFetchCartPricingForLooks (copy), selectProductPrice (copy), deriveSelectedOfferIdsFromCartPricing (copy), HttpService (copy), performLookPurchase (copy), FFlagEnableUnifiedPurchaseFlowForDevSubs (copy), performDeveloperSubscriptionRobuxPurchase (copy), performDeveloperSubscriptionFiatPurchase (copy)
	return Thunk.new(script.Name, t1, function(p3, p4) -- line: 66
		-- upvalues: Network (copy), Analytics (copy), Constants (copy), performDevProductEdpPurchase (copy), completePurchase (copy), Promise (copy), handleGenericPurchaseError (copy), FFlagEnablePriceChangedErrorHandling (copy), ProductTypeEnum (copy), performExperiencePurchase (copy), FFlagPurchasePromptFetchCartPricingForLooks (copy), selectProductPrice (copy), deriveSelectedOfferIdsFromCartPricing (copy), HttpService (copy), performLookPurchase (copy), FFlagEnableUnifiedPurchaseFlowForDevSubs (copy), performDeveloperSubscriptionRobuxPurchase (copy), performDeveloperSubscriptionFiatPurchase (copy)
		local v39 = p4[Network]
		local v40 = p4[Analytics]
		local v41 = p3:getState()
		local productInfo = v41.productInfo
		local price = productInfo.price
		local productId = productInfo.productId
		local _ = v41.promptRequest
		local id = v41.promptRequest.id
		local productPayload = v41.productPayload

		if productPayload.kind == "Product" then
			local t2 = {
				expectedCurrency = Constants.Currency.Robux,
				expectedPrice = price,
				saleLocationId = productPayload.universeId
			}

			return performDevProductEdpPurchase(v39, productId, t2):andThen(function(p5) -- line: 92
				-- upvalues: p3 (copy), completePurchase (copy), v40 (copy), id (copy), Promise (copy)
				p3:dispatch(completePurchase(p5))
				v40.signalPurchaseSuccess(id, Enum.InfoType.Product, nil, p5)

				return Promise.resolve(p5)
			end):catch(function(p6) -- line: 99
				-- upvalues: handleGenericPurchaseError (copy), p3 (copy), FFlagEnablePriceChangedErrorHandling (copy), productPayload (copy)
				handleGenericPurchaseError(p3, p6, if not FFlagEnablePriceChangedErrorHandling then nil else productPayload.kind)
			end)
		end

		if productPayload.kind == ProductTypeEnum.Experience then
			local t3 = {
				expectedCurrency = Constants.Currency.Robux,
				expectedPrice = price,
				sellerId = productInfo.sellerId
			}

			return performExperiencePurchase(v39, productId, t3):andThen(function(p7) -- line: 113
				-- upvalues: p3 (copy), completePurchase (copy), Promise (copy)
				p3:dispatch(completePurchase(p7))

				return Promise.resolve(p7)
			end):catch(function(p8) -- line: 118
				-- upvalues: handleGenericPurchaseError (copy), p3 (copy), FFlagEnablePriceChangedErrorHandling (copy), productPayload (copy)
				handleGenericPurchaseError(p3, p8, if not FFlagEnablePriceChangedErrorHandling then nil else productPayload.kind)
			end)
		end

		if productPayload.kind == ProductTypeEnum.Look then
			local expectedPrice = productPayload.expectedPrice
			local v51 = nil

			if FFlagPurchasePromptFetchCartPricingForLooks then
				local cartPricing = v41.cartPricing
				local v53 = cartPricing and cartPricing.response

				if v53 ~= nil then
					expectedPrice = selectProductPrice(v41) or expectedPrice
					v51 = deriveSelectedOfferIdsFromCartPricing(v53)
				else
					v51 = {}
				end
			end

			local t4 = {
				lookId = productPayload.id,
				idempotencyKey = HttpService:GenerateGUID(false),
				expectedPrice = expectedPrice,
				salesLocationId = productPayload.salesLocationId,
				excludedAssets = productPayload.excludedAssetIds,
				excludedBundles = productPayload.excludedBundleIds,
				timedOptions = productPayload.timedOptions,
				selectedOfferIds = v51
			}

			return performLookPurchase(v39, productPayload.id, t4):andThen(function(p9) -- line: 163
				-- upvalues: p3 (copy), completePurchase (copy), Promise (copy)
				p3:dispatch(completePurchase(p9))

				return Promise.resolve(p9)
			end):catch(function(p10) -- line: 168
				-- upvalues: handleGenericPurchaseError (copy), p3 (copy), FFlagEnablePriceChangedErrorHandling (copy), productPayload (copy)
				handleGenericPurchaseError(p3, p10, if not FFlagEnablePriceChangedErrorHandling then nil else productPayload.kind)
			end)
		end

		if FFlagEnableUnifiedPurchaseFlowForDevSubs and productPayload.kind == ProductTypeEnum.DeveloperSubscription then
			local subscriptionId = productPayload.subscriptionId
			local v57

			if productPayload.isSubscriptionInRobux then
				local expectedPrice = productPayload.expectedPrice

				v57 = performDeveloperSubscriptionRobuxPurchase(v39, subscriptionId, expectedPrice)
			else
				v57 = performDeveloperSubscriptionFiatPurchase(v39, subscriptionId)
			end

			return v57:andThen(function() -- line: 191
				-- upvalues: p3 (copy), completePurchase (copy), Promise (copy)
				p3:dispatch(completePurchase())

				return Promise.resolve()
			end):catch(function(p11) -- line: 195
				-- upvalues: handleGenericPurchaseError (copy), p3 (copy), FFlagEnablePriceChangedErrorHandling (copy), productPayload (copy)
				handleGenericPurchaseError(p3, p11, if not FFlagEnablePriceChangedErrorHandling then nil else productPayload.kind)
			end)
		end
	end)
end

return performLuaPurchase
