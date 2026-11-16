local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local IAPExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/IAPExperience")
local isEconomicRestrictionResponse = IAPExperience.Utility.isEconomicRestrictionResponse

local ErrorOccurred = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/ErrorOccurred")
local SetEconomicRestrictionError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetEconomicRestrictionError")
local VIPServerCreated = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/VIPServerCreated")
local PurchaseError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseError")
local Network = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/Network")
local Analytics = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/Analytics")
local Thunk = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunk")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Promise")
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Misc/Constants")
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/types")
local productTypeEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/types").ProductTypeEnum
local completePurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/completePurchase")
local handlePriceChangedError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/handlePriceChangedError")

local performDevProductEdpPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Network/performDevProductEdpPurchase")
local performExperiencePurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Network/performExperiencePurchase")
local performLookPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Network/performLookPurchase")
local performDeveloperSubscriptionRobuxPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Network/performDeveloperSubscriptionRobuxPurchase")
local performDeveloperSubscriptionFiatPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Network/performDeveloperSubscriptionFiatPurchase")
local performVIPServerPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Network/performVIPServerPurchase")

local deriveSelectedOfferIdsFromCartPricing = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/deriveSelectedOfferIdsFromCartPricing")
local applyCartPricingOffersToLineItems = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/applyCartPricingOffersToLineItems")
local selectProductPrice = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Selectors/selectProductPrice")

local fFlagEnableUnifiedPurchaseFlowForDevSubs = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagEnableUnifiedPurchaseFlowForDevSubs

local fFlagPurchasePromptFetchCartPricingForLooks = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagPurchasePromptFetchCartPricingForLooks
local FFlagEnablePriceChangedErrorHandling = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagEnablePriceChangedErrorHandling")
local FFlagEnableRequestLocationTypeForSduiPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagEnableRequestLocationTypeForSduiPurchase")
local fFlagEnableSearchGameItemOwnershipUpdate = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagEnableSearchGameItemOwnershipUpdate
local fFlagEnableEdpPreviewPurchaseSurface = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagEnableEdpPreviewPurchaseSurface

local fFlagLuaAppsEnablePromptVIPServerPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagLuaAppsEnablePromptVIPServerPurchase
local RobloxTranslator = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/RobloxTranslator")

local productPurchaseSurface = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptLite").Enums.ProductPurchaseSurface

local v5 = {
	[productPurchaseSurface.EDP] = "ExperienceDetailPage",
	[productPurchaseSurface.EDPPreview] = fFlagEnableEdpPreviewPurchaseSurface and "ExperienceDetailPagePreview" or nil,
	[productPurchaseSurface.HomePageGameItemShop] = "HomePageGameItemShop",
	[productPurchaseSurface.SearchPageGameItemShop] = fFlagEnableSearchGameItemOwnershipUpdate and "SearchPageGameItemShop" or nil
}

local function decodePurchasePayload(value)
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

local v6 = { Network, Analytics }

local function handleGenericPurchaseError(object, p2, p3)
	if isEconomicRestrictionResponse(p2) then
		object:dispatch(SetEconomicRestrictionError(
			parseEconomicRestrictionsFailureReason(p2),
			(parseEconomicRestrictionsExpirationTimeInMinutes(p2))
		))
		object:dispatch(ErrorOccurred(PurchaseError.EconomicRestriction))
	else
		if handlePriceChangedError(object, p2, p3) then
			return
		end

		if PurchaseError.isMember(p2) then
			object:dispatch(ErrorOccurred(p2))
		else
			object:dispatch(ErrorOccurred(PurchaseError.UnknownFailure))
		end
	end
end

local function performLuaPurchase()
	return Thunk.new("performLuaPurchase", v6, function(object, p2)
		local v7 = p2[Network]
		local v8 = p2[Analytics]

		local state = object:getState()
		local productInfo = state.productInfo
		local price = productInfo.price
		local productId = productInfo.productId
		local promptRequest = state.promptRequest
		local id = state.promptRequest.id
		local productPayload = state.productPayload

		if productPayload.kind == "Product" then
			local v9 = {
				expectedCurrency = Constants.Currency.Robux,
				expectedPrice = price,
				saleLocationId = productPayload.universeId
			}

			if FFlagEnableRequestLocationTypeForSduiPurchase then
				local surface = state.purchaseAnalyticsMetadata and state.purchaseAnalyticsMetadata.surface
				v9.requestLocationType = surface == nil and "" or v5[surface] or ""
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

			v9.purchasePayload = result

			return performDevProductEdpPurchase(v7, productId, v9):andThen(function(p3)
				object:dispatch(completePurchase(p3))

				v8.signalPurchaseSuccess(id, Enum.InfoType.Product, nil, p3)

				return Promise.resolve(p3)
			end):catch(function(p3)
				local v12 = if FFlagEnablePriceChangedErrorHandling then productPayload.kind else nil
				handleGenericPurchaseError(object, p3, v12)
			end)
		end

		if productPayload.kind == productTypeEnum.Experience then
			return performExperiencePurchase(v7, productId, {
				expectedCurrency = Constants.Currency.Robux,
				expectedPrice = price,
				sellerId = productInfo.sellerId
			}):andThen(function(p3)
				object:dispatch(completePurchase(p3))

				return Promise.resolve(p3)
			end):catch(function(p3)
				local v12 = if FFlagEnablePriceChangedErrorHandling then productPayload.kind else nil
				handleGenericPurchaseError(object, p3, v12)
			end)
		end

		if productPayload.kind == productTypeEnum.Look then
			local v9 = productPayload.expectedPrice
			local bulkPurchaseLineItems, v10

			if fFlagPurchasePromptFetchCartPricingForLooks then
				bulkPurchaseLineItems = productPayload.bulkPurchaseLineItems

				local cartPricing = state.cartPricing
				local response = cartPricing and cartPricing.response

				if response == nil then
					v10 = {}
				else
					v9 = selectProductPrice(state) or v9
					v10 = deriveSelectedOfferIdsFromCartPricing(response)

					if bulkPurchaseLineItems ~= nil then
						bulkPurchaseLineItems = applyCartPricingOffersToLineItems(bulkPurchaseLineItems, response, v10)
					end
				end
			end

			local v11 = {
				lookId = productPayload.id,
				idempotencyKey = HttpService:GenerateGUID(false),
				expectedPrice = v9,
				salesLocationId = productPayload.salesLocationId,
				excludedAssets = productPayload.excludedAssetIds,
				excludedBundles = productPayload.excludedBundleIds,
				timedOptions = productPayload.timedOptions,
				selectedOfferIds = v10,
				bulkPurchaseLineItems = 0
			}

			if not fFlagPurchasePromptFetchCartPricingForLooks then
				bulkPurchaseLineItems = nil
			end

			v11.bulkPurchaseLineItems = bulkPurchaseLineItems

			return performLookPurchase(v7, productPayload.id, v11):andThen(function(p3)
				object:dispatch(completePurchase(p3))

				return Promise.resolve(p3)
			end):catch(function(p3)
				local v14 = if FFlagEnablePriceChangedErrorHandling then productPayload.kind else nil
				handleGenericPurchaseError(object, p3, v14)
			end)
		elseif
			fFlagEnableUnifiedPurchaseFlowForDevSubs
			and productPayload.kind == productTypeEnum.DeveloperSubscription
		then
			local subscriptionId = productPayload.subscriptionId
			local v9

			if productPayload.isSubscriptionInRobux then
				v9 = performDeveloperSubscriptionRobuxPurchase(v7, subscriptionId, productPayload.expectedPrice)
			else
				v9 = performDeveloperSubscriptionFiatPurchase(v7, subscriptionId)
			end

			return v9:andThen(function()
				object:dispatch(completePurchase())
				return Promise.resolve()
			end):catch(function(p3)
				local v12 = if FFlagEnablePriceChangedErrorHandling then productPayload.kind else nil
				handleGenericPurchaseError(object, p3, v12)
			end)
		else
			if
				not fFlagLuaAppsEnablePromptVIPServerPurchase
				or productPayload.kind ~= productTypeEnum.VIPServer
			then
				return
			end

			local v9 = {
				name = RobloxTranslator:FormatByKey("Feature.PrivateServers.Label.OwnersServer", {
					displayName = Players.LocalPlayer.DisplayName
				}),
				expectedPrice = price,
				idempotencyKey = promptRequest.idempotencyKey
			}

			return performVIPServerPurchase(v7, productPayload.universeId, v9):andThen(function(data)
				local name = if type(data.name) == "string" then data.name else v9.name
				local v10 = if type(data.accessCode) == "string" then data.accessCode else nil
				object:dispatch(VIPServerCreated(data.vipServerId, name, v10))
				object:dispatch(completePurchase(data))

				return Promise.resolve(data)
			end):catch(function(p3)
				local v12 = if FFlagEnablePriceChangedErrorHandling then productPayload.kind else nil
				handleGenericPurchaseError(object, p3, v12)
			end)
		end
	end)
end

return performLuaPurchase
