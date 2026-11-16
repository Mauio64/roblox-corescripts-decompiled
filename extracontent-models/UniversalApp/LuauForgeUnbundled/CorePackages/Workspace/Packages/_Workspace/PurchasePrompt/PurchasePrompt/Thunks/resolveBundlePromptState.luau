local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local SetPromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetPromptState")
local ErrorOccurred = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/ErrorOccurred")
local BundleProductInfoReceived = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/BundleProductInfoReceived")
local AccountInfoReceived = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/AccountInfoReceived")
local BalanceInfoRecieved = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/BalanceInfoRecieved")
local PromptNativeUpsellSuggestions = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/PromptNativeUpsellSuggestions")
local SetPurchaseFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetPurchaseFlow")

local PromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PromptState")
local PurchaseError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseError")
local PurchaseFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseFlow")

require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Models/RobuxUpsell")

local getRobuxUpsellSuggestions = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Network/getRobuxUpsellSuggestions")

local Analytics = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/Analytics")
local Network = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/Network")

local getPaymentPlatform = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/getPaymentPlatform")
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/getPaymentFromPlatformLegacy")
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/getHasAmazonUserAgent")
local isEligibleForRobuxUpsellPlusButton = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/isEligibleForRobuxUpsellPlusButton")

local GetFFlagRespectBalanceInfoForBundleUpsellInStudio = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/GetFFlagRespectBalanceInfoForBundleUpsellInStudio")
local Thunk = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunk")
local getPurchaseSurface = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/getPurchaseSurface")

require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/GetFFlagEnableLuobuInGameUpsell")
local SetIsUserEligibleForUnifiedPurchaseFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetIsUserEligibleForUnifiedPurchaseFlow")
local SetPurchaseAnalyticsMetadata = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetPurchaseAnalyticsMetadata")

local getProductTypeFromRequestType = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/getProductTypeFromRequestType")
local meetsBundlePrerequisites = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/meetsBundlePrerequisites")
local SetPostPurchaseActions = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetPostPurchaseActions")
local fFlagUpdatePriceTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagUpdatePriceTelemetry
local selectPrice = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Selectors/selectPrice")
local selectCartPricingOverride = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Selectors/selectCartPricingOverride")

require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/RobloxSubscriptionPurchaseApp")
local SetRobloxSubscriptionProducts = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetRobloxSubscriptionProducts")

local function getBundlePriceFromProductInfo(p2, p3)
	if not p2 or p2.product == nil then
		return 0
	end

	if p3 and p2.product.premiumPricing ~= nil then
		return p2.product.premiumPricing.premiumPriceInRobux or 0
	end

	return p2.product.priceInRobux or 0
end

local v5 = { Analytics, Network }

local function resolveBundlePromptState(p2, p3, p4, p5, p6, p7, p8, p9)
	return Thunk.new("resolveBundlePromptState", v5, function(object, p10)
		object:getState()
		local v6 = p10[Analytics]
		local v7 = p10[Network]

		object:dispatch(BundleProductInfoReceived(p3))
		object:dispatch(AccountInfoReceived(p4))
		object:dispatch(BalanceInfoRecieved(p5))

		if p8 then
			object:dispatch(SetIsUserEligibleForUnifiedPurchaseFlow(true))
			local state = object:getState()

			local v9 = {
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
			local v10

			if fFlagUpdatePriceTelemetry then
				v10 = selectPrice(state).priceInRobux
			else
				v10 = if state.productInfo.price then state.productInfo.price else p6
			end

			v9.price = v10

			v9.productUniverseId = state.purchaseAnalyticsMetadata.productUniverseId
			v9.userRobuxBalance = state.accountInfo.balance
			object:dispatch(SetPurchaseAnalyticsMetadata(v9))

			if p9 then
				object:dispatch(SetRobloxSubscriptionProducts(p9))
			end
		else
			object:dispatch(SetIsUserEligibleForUnifiedPurchaseFlow(false))
		end

		if p6 == nil then
			local isPremium = p4.isPremium
			local v8 = p3
			local v9

			if v8 and v8.product ~= nil then
				if isPremium and v8.product.premiumPricing ~= nil then
					v9 = v8.product.premiumPricing.premiumPriceInRobux or 0
				else
					v9 = v8.product.priceInRobux or 0
				end
			else
				v9 = 0
			end

			p6 = v9
		end

		local v8 = selectCartPricingOverride(object:getState())
		local v9 = if v8 == nil then p6 else v8.priceInRobux

		local v10, v11 = meetsBundlePrerequisites(p3, p5, v9, p7)
		local v12 = p6
		local platform = UserInputService:GetPlatform()
		local v13 = v11 == PurchaseError.NotEnoughRobux

		if RunService:IsStudio() and GetFFlagRespectBalanceInfoForBundleUpsellInStudio() and v13 then
			v13 = p5.robux < v12

			if not v10 then
				v10 = not v13
			end
		end

		if v10 then
			return object:dispatch(SetPromptState(PromptState.PromptPurchase))
		end

		if not v13 then
			return object:dispatch(ErrorOccurred(v11))
		end

		if p8 then
			object:dispatch(SetPurchaseFlow(PurchaseFlow.RobuxUpsellV2))
		end

		if p8 then
			object:dispatch(SetPostPurchaseActions({}))
		end

		local v14 = v12 - p5.robux
		local isPremium = p4.isPremium

		local v15 = getPaymentPlatform(platform)

		local robux = p5.robux
		local state = object:getState()

		return getRobuxUpsellSuggestions(
			v12,
			robux,
			v15,
			isEligibleForRobuxUpsellPlusButton(
				state.isUserEligibleForUnifiedPurchaseFlow,
				state.robloxSubscriptionProducts,
				state.productPayload,
				selectPrice(state),
				state.promptRequest.requestType
			)
		):andThen(
			function(data)
				object:dispatch(PromptNativeUpsellSuggestions(data.products, 1, data.virtualItemBadgeType, data.experimentVariant))
			end,
			function()
				object:dispatch(ErrorOccurred(PurchaseError.NotEnoughRobuxXbox))
			end
		)
	end)
end

return resolveBundlePromptState
