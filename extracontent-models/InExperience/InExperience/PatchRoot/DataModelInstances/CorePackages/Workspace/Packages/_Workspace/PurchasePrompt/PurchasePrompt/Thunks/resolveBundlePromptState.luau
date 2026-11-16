local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local SetPromptState = require(PurchasePrompt.Actions.SetPromptState)
local ErrorOccurred = require(PurchasePrompt.Actions.ErrorOccurred)
local BundleProductInfoReceived = require(PurchasePrompt.Actions.BundleProductInfoReceived)
local AccountInfoReceived = require(PurchasePrompt.Actions.AccountInfoReceived)
local BalanceInfoRecieved = require(PurchasePrompt.Actions.BalanceInfoRecieved)
local PromptNativeUpsellSuggestions = require(PurchasePrompt.Actions.PromptNativeUpsellSuggestions)
local SetPurchaseFlow = require(PurchasePrompt.Actions.SetPurchaseFlow)

local PromptState = require(PurchasePrompt.Enums.PromptState)
local PurchaseError = require(PurchasePrompt.Enums.PurchaseError)
local PurchaseFlow = require(PurchasePrompt.Enums.PurchaseFlow)

require(PurchasePrompt.Models.RobuxUpsell)

local getRobuxUpsellSuggestions = require(PurchasePrompt.Network.getRobuxUpsellSuggestions)

local Analytics = require(PurchasePrompt.Services.Analytics)
local Network = require(PurchasePrompt.Services.Network)

local getPaymentPlatform = require(PurchasePrompt.Utils.getPaymentPlatform)
require(PurchasePrompt.Utils.getPaymentFromPlatformLegacy)
require(PurchasePrompt.Utils.getHasAmazonUserAgent)
local isEligibleForRobuxUpsellPlusButton = require(PurchasePrompt.Utils.isEligibleForRobuxUpsellPlusButton)

local GetFFlagRespectBalanceInfoForBundleUpsellInStudio = require(PurchasePrompt.Flags.GetFFlagRespectBalanceInfoForBundleUpsellInStudio)
local Thunk = require(PurchasePrompt.Thunk)
local getPurchaseSurface = require(PurchasePrompt.Utils.getPurchaseSurface)

require(PurchasePrompt.Flags.GetFFlagEnableLuobuInGameUpsell)
local SetIsUserEligibleForUnifiedPurchaseFlow = require(PurchasePrompt.Actions.SetIsUserEligibleForUnifiedPurchaseFlow)
local SetPurchaseAnalyticsMetadata = require(PurchasePrompt.Actions.SetPurchaseAnalyticsMetadata)

local getProductTypeFromRequestType = require(PurchasePrompt.Utils.getProductTypeFromRequestType)
local meetsBundlePrerequisites = require(PurchasePrompt.Utils.meetsBundlePrerequisites)
local SetPostPurchaseActions = require(PurchasePrompt.Actions.SetPostPurchaseActions)
local SharedFlags = require(PurchasePrompt.Parent.SharedFlags)
local FFlagUpdatePriceTelemetry = SharedFlags.FFlagUpdatePriceTelemetry
local selectPrice = require(PurchasePrompt.Selectors.selectPrice)
local selectCartPricingOverride = require(PurchasePrompt.Selectors.selectCartPricingOverride)

require(PurchasePrompt.Parent.RobloxSubscriptionPurchaseApp)
local SetRobloxSubscriptionProducts = require(PurchasePrompt.Actions.SetRobloxSubscriptionProducts)

local function getBundlePriceFromProductInfo(p, p2)
	if not p or p.product == nil then
		return 0
	end

	if p2 and p.product.premiumPricing ~= nil then
		return p.product.premiumPricing.premiumPriceInRobux or 0
	end

	return p.product.priceInRobux or 0
end

local v = { Analytics, Network }

local function resolveBundlePromptState(_, p, p2, p3, p4, p5, p6, p7)
	return Thunk.new(script.Name, v, function(object, p8)
		object:getState()
		local _ = p8[Analytics]
		local _ = p8[Network]

		object:dispatch(BundleProductInfoReceived(p))
		object:dispatch(AccountInfoReceived(p2))
		object:dispatch(BalanceInfoRecieved(p3))

		if p6 then
			object:dispatch(SetIsUserEligibleForUnifiedPurchaseFlow(true))
			local state = object:getState()

			local v2 = {
				purchaseFlowUUID = state.purchaseFlowUUID,
				surface = getPurchaseSurface(state.purchaseAnalyticsMetadata),
				productType = getProductTypeFromRequestType(state.promptRequest.requestType),
				productId = state.productInfo.productId,
				productTargetId = state.productInfo.productTargetId,
				saleLocationUniverseId = game.GameId or 0,
				price = 0,
				productUniverseId = 0,
				userRobuxBalance = 0
			}
			local price

			if FFlagUpdatePriceTelemetry then
				price = selectPrice(state).priceInRobux
			elseif state.productInfo.price then
				price = state.productInfo.price
			else
				price = p4
			end

			v2.price = price

			v2.productUniverseId = state.purchaseAnalyticsMetadata.productUniverseId
			v2.userRobuxBalance = state.accountInfo.balance
			object:dispatch(SetPurchaseAnalyticsMetadata(v2))

			if p7 then
				object:dispatch(SetRobloxSubscriptionProducts(p7))
			end
		else
			object:dispatch(SetIsUserEligibleForUnifiedPurchaseFlow(false))
		end

		if p4 == nil then
			local isPremium = p2.isPremium
			local v2 = p
			local v3

			if v2 and v2.product ~= nil then
				if isPremium and v2.product.premiumPricing ~= nil then
					v3 = v2.product.premiumPricing.premiumPriceInRobux or 0
				else
					v3 = v2.product.priceInRobux or 0
				end
			else
				v3 = 0
			end

			p4 = v3
		end

		local v2 = selectCartPricingOverride(object:getState())
		local v3 = if v2 == nil then p4 else v2.priceInRobux

		local v4, v5 = meetsBundlePrerequisites(p, p3, v3, p5)
		local v6 = p4
		local platform = UserInputService:GetPlatform()
		local v7 = v5 == PurchaseError.NotEnoughRobux

		if RunService:IsStudio() and GetFFlagRespectBalanceInfoForBundleUpsellInStudio() and v7 then
			v7 = p3.robux < v6

			if not v4 then
				v4 = not v7
			end
		end

		if v4 then
			return object:dispatch(SetPromptState(PromptState.PromptPurchase))
		end

		if not v7 then
			return object:dispatch(ErrorOccurred(v5))
		end

		if p6 then
			object:dispatch(SetPurchaseFlow(PurchaseFlow.RobuxUpsellV2))
		end

		if p6 then
			object:dispatch(SetPostPurchaseActions({}))
		end

		local _ = v6 - p3.robux
		local _isPremium = p2.isPremium

		local paymentPlatform = getPaymentPlatform(platform)

		local robux = p3.robux
		local state = object:getState()

		return getRobuxUpsellSuggestions(
			v6,
			robux,
			paymentPlatform,
			isEligibleForRobuxUpsellPlusButton(
				state.isUserEligibleForUnifiedPurchaseFlow,
				state.robloxSubscriptionProducts,
				state.productPayload,
				selectPrice(state),
				state.promptRequest.requestType
			)
		):andThen(
			function(data)
				object:dispatch(PromptNativeUpsellSuggestions(
					data.products,
					1,
					data.virtualItemBadgeType,
					data.experimentVariant
				))
			end,
			function()
				object:dispatch(ErrorOccurred(PurchaseError.NotEnoughRobuxXbox))
			end
		)
	end)
end

return resolveBundlePromptState
