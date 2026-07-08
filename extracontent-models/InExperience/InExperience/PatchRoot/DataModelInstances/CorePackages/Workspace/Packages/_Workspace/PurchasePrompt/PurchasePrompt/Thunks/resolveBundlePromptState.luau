local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local Players = game:GetService("Players")
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
local UpsellFlow = require(PurchasePrompt.Enums.UpsellFlow)
local PurchaseFlow = require(PurchasePrompt.Enums.PurchaseFlow)

require(PurchasePrompt.Models.RobuxUpsell)

local getUpsellFlow = require(PurchasePrompt.NativeUpsell.getUpsellFlow)
local getRobuxUpsellSuggestions = require(PurchasePrompt.Network.getRobuxUpsellSuggestions)
local Analytics = require(PurchasePrompt.Services.Analytics)
local Network = require(PurchasePrompt.Services.Network)
local getPaymentPlatform = require(PurchasePrompt.Utils.getPaymentPlatform)

require(PurchasePrompt.Utils.getPaymentFromPlatformLegacy)
require(PurchasePrompt.Utils.getHasAmazonUserAgent)

local GetFFlagRespectBalanceInfoForBundleUpsellInStudio = require(PurchasePrompt.Flags.GetFFlagRespectBalanceInfoForBundleUpsellInStudio)
local Thunk = require(PurchasePrompt.Thunk)
local getPurchaseSurface = require(PurchasePrompt.Utils.getPurchaseSurface)

require(PurchasePrompt.Flags.GetFFlagEnableLuobuInGameUpsell)

local GetFFlagEnableInsufficientRobuxForBundleUpsellFix = require(PurchasePrompt.Flags.GetFFlagEnableInsufficientRobuxForBundleUpsellFix)
local FFlagEnableUnifiedProductPurchaseFlow = require(PurchasePrompt.Parent.SharedFlags).FFlagEnableUnifiedProductPurchaseFlow
local SetIsUserEligibleForUnifiedPurchaseFlow = require(PurchasePrompt.Actions.SetIsUserEligibleForUnifiedPurchaseFlow)
local SetPurchaseAnalyticsMetadata = require(PurchasePrompt.Actions.SetPurchaseAnalyticsMetadata)
local GetFFlagUseCatalogItemDetailsToResolveBundlePurchase = require(PurchasePrompt.Flags.GetFFlagUseCatalogItemDetailsToResolveBundlePurchase)
local getProductTypeFromRequestType = require(PurchasePrompt.Utils.getProductTypeFromRequestType)
local SetPostPurchaseActions = require(PurchasePrompt.Actions.SetPostPurchaseActions)
local FFlagUnifiedPurchaseGamepassAddProductUniverseId = require(PurchasePrompt.Parent.SharedFlags).FFlagUnifiedPurchaseGamepassAddProductUniverseId
local FFlagUpdatePriceTelemetry = require(PurchasePrompt.Parent.SharedFlags).FFlagUpdatePriceTelemetry
local selectPrice = require(PurchasePrompt.Selectors.selectPrice)

require(PurchasePrompt.Parent.RobloxSubscriptionPurchaseApp)

local SetRobloxSubscriptionProducts = require(PurchasePrompt.Actions.SetRobloxSubscriptionProducts)
local FFlagEnableBlackbirdUpsellInUnifiedPurchaseModal = require(PurchasePrompt.Parent.SharedFlags).FFlagEnableBlackbirdUpsellInUnifiedPurchaseModal

local function getBundlePriceFromProductInfo(p1, p2) -- line: 60
	if p1 and p1.product ~= nil then
		if p2 and p1.product.premiumPricing ~= nil then
			return p1.product.premiumPricing.premiumPriceInRobux or 0
		end

		return p1.product.priceInRobux or 0
	end

	return 0
end
local function meetsBundlePrerequisitesV2(p3, p4, p5, p6) -- line: 73
	-- upvalues: PurchaseError (copy)
	local owned = p3.owned
	local collectibleItemDetail = p4.collectibleItemDetail
	local v49 = collectibleItemDetail and (collectibleItemDetail.collectibleItemId ~= nil and collectibleItemDetail.collectibleItemId ~= "")
	local v50 = collectibleItemDetail and collectibleItemDetail.collectibleItemType == "Limited"

	if v49 then
		if not v50 and owned then
			return false, PurchaseError.AlreadyOwn
		end
	elseif owned then
		return false, PurchaseError.AlreadyOwn
	end

	if not p3.isPurchasable then
		return false, PurchaseError.NotForSale
	end

	if p6 ~= nil and p5.robux ~= nil and p6 > p5.robux then
		return false, PurchaseError.NotEnoughRobux
	end

	return true, nil
end
local function meetsBundlePrerequisites(p7, p8, p9, p10) -- line: 110
	-- upvalues: PurchaseError (copy), Players (copy)
	local collectibleItemDetail = p7.collectibleItemDetail
	local v56 = collectibleItemDetail and (collectibleItemDetail.collectibleItemId ~= nil and collectibleItemDetail.collectibleItemId ~= "")
	local v57 = collectibleItemDetail and (collectibleItemDetail.collectibleItemType ~= nil and collectibleItemDetail.collectibleItemType == "Limited")

	if v56 then
		if not v57 and p10 then
			return false, PurchaseError.AlreadyOwn
		end
	elseif p10 then
		return false, PurchaseError.AlreadyOwn
	end

	if not if not v56 then p7.product and p7.product.isForSale else collectibleItemDetail.saleStatus == "OnSale" then
		return false, PurchaseError.NotForSale
	end

	if p9 ~= nil and p8.robux ~= nil and p9 > p8.robux then
		return false, PurchaseError.NotEnoughRobux
	end

	if p7.itemRestrictions ~= nil then
		for _, v59 in p7.itemRestrictions do
			if v59 == "ThirteenPlus" then
				if not Players.LocalPlayer:GetUnder13() then
					return true, nil
				end

				return false, PurchaseError.Under13
			end
		end
	end

	return true, nil
end

local t1 = {
	Analytics,
	Network
}

local function resolveBundlePromptState(p11, p12, p13, p14, p15, p16, p17, p18) -- line: 171
	-- upvalues: Thunk (copy), t1 (copy), Analytics (copy), Network (copy), BundleProductInfoReceived (copy), AccountInfoReceived (copy), BalanceInfoRecieved (copy), FFlagEnableUnifiedProductPurchaseFlow (copy), SetIsUserEligibleForUnifiedPurchaseFlow (copy), SetPurchaseAnalyticsMetadata (copy), getPurchaseSurface (copy), getProductTypeFromRequestType (copy), FFlagUpdatePriceTelemetry (copy), selectPrice (copy), FFlagUnifiedPurchaseGamepassAddProductUniverseId (copy), FFlagEnableBlackbirdUpsellInUnifiedPurchaseModal (copy), SetRobloxSubscriptionProducts (copy), GetFFlagUseCatalogItemDetailsToResolveBundlePurchase (copy), meetsBundlePrerequisitesV2 (copy), meetsBundlePrerequisites (copy), UserInputService (copy), getUpsellFlow (copy), PurchaseError (copy), RunService (copy), GetFFlagRespectBalanceInfoForBundleUpsellInStudio (copy), GetFFlagEnableInsufficientRobuxForBundleUpsellFix (copy), UpsellFlow (copy), SetPromptState (copy), PromptState (copy), SetPurchaseFlow (copy), PurchaseFlow (copy), SetPostPurchaseActions (copy), getPaymentPlatform (copy), getRobuxUpsellSuggestions (copy), PromptNativeUpsellSuggestions (copy), ErrorOccurred (copy)
	return Thunk.new(script.Name, t1, function(p19, p20) -- line: 181
		-- upvalues: Analytics (copy), Network (copy), BundleProductInfoReceived (copy), p12 (copy), AccountInfoReceived (copy), p13 (copy), BalanceInfoRecieved (copy), p14 (copy), FFlagEnableUnifiedProductPurchaseFlow (copy), p17 (copy), SetIsUserEligibleForUnifiedPurchaseFlow (copy), SetPurchaseAnalyticsMetadata (copy), getPurchaseSurface (copy), getProductTypeFromRequestType (copy), FFlagUpdatePriceTelemetry (copy), selectPrice (copy), p15 (ref), FFlagUnifiedPurchaseGamepassAddProductUniverseId (copy), FFlagEnableBlackbirdUpsellInUnifiedPurchaseModal (copy), p18 (copy), SetRobloxSubscriptionProducts (copy), GetFFlagUseCatalogItemDetailsToResolveBundlePurchase (copy), meetsBundlePrerequisitesV2 (copy), p11 (copy), meetsBundlePrerequisites (copy), p16 (copy), UserInputService (copy), getUpsellFlow (copy), PurchaseError (copy), RunService (copy), GetFFlagRespectBalanceInfoForBundleUpsellInStudio (copy), GetFFlagEnableInsufficientRobuxForBundleUpsellFix (copy), UpsellFlow (copy), SetPromptState (copy), PromptState (copy), SetPurchaseFlow (copy), PurchaseFlow (copy), SetPostPurchaseActions (copy), getPaymentPlatform (copy), getRobuxUpsellSuggestions (copy), PromptNativeUpsellSuggestions (copy), ErrorOccurred (copy)
		p19:getState()

		local _ = p20[Analytics]
		local _ = p20[Network]

		p19:dispatch(BundleProductInfoReceived(p12))
		p19:dispatch(AccountInfoReceived(p13))
		p19:dispatch(BalanceInfoRecieved(p14))

		if FFlagEnableUnifiedProductPurchaseFlow then
			if p17 then
				p19:dispatch(SetIsUserEligibleForUnifiedPurchaseFlow(true))

				local v73 = p19:getState()

				p19:dispatch(SetPurchaseAnalyticsMetadata({
					purchaseFlowUUID = v73.purchaseFlowUUID,
					surface = getPurchaseSurface(v73.purchaseAnalyticsMetadata),
					productType = getProductTypeFromRequestType(v73.promptRequest.requestType),
					productId = v73.productInfo.productId,
					productTargetId = v73.productInfo.productTargetId,
					saleLocationUniverseId = game.GameId or 0,
					price = if not FFlagUpdatePriceTelemetry then if not v73.productInfo.price then p15 else v73.productInfo.price else selectPrice(v73).priceInRobux,
					productUniverseId = if not FFlagUnifiedPurchaseGamepassAddProductUniverseId then nil else v73.purchaseAnalyticsMetadata.productUniverseId,
					userRobuxBalance = v73.accountInfo.balance
				}))

				if FFlagEnableBlackbirdUpsellInUnifiedPurchaseModal and p18 then
					p19:dispatch(SetRobloxSubscriptionProducts(p18))
				end
			else
				p19:dispatch(SetIsUserEligibleForUnifiedPurchaseFlow(false))
			end
		end

		if p15 == nil then
			local isPremium = p13.isPremium
			local v75 = p12

			p15 = (not v75 or v75.product == nil) and 0 or if not isPremium or v75.product.premiumPricing == nil then v75.product.priceInRobux or 0 else v75.product.premiumPricing.premiumPriceInRobux or 0
		end

		local v76, v77

		if GetFFlagUseCatalogItemDetailsToResolveBundlePurchase() then
			v76, v77 = meetsBundlePrerequisitesV2(p11, p12, p14, p15)
		else
			v76, v77 = meetsBundlePrerequisites(p12, p14, p15, p16)
		end

		local v78 = p15
		local Platform = UserInputService:GetPlatform()
		local v80 = getUpsellFlow(Platform)
		local v81 = v77 == PurchaseError.NotEnoughRobux

		if RunService:IsStudio() and GetFFlagRespectBalanceInfoForBundleUpsellInStudio() and v81 then
			v81 = v78 > p14.robux

			if not v76 then
				v76 = not v81
			end
		end

		if not v76 then
			if v81 then
				if not GetFFlagEnableInsufficientRobuxForBundleUpsellFix() and v80 == UpsellFlow.Web then
					return p19:dispatch(SetPromptState(PromptState.RobuxUpsell))
				end

				if FFlagEnableUnifiedProductPurchaseFlow and p17 then
					p19:dispatch(SetPurchaseFlow(PurchaseFlow.RobuxUpsellV2))
				end

				if FFlagEnableUnifiedProductPurchaseFlow and p17 then
					p19:dispatch(SetPostPurchaseActions({}))
				end

				local _ = v78 - p14.robux
				local _ = p13.isPremium
				local v84 = getPaymentPlatform(Platform)
				local robux = p14.robux

				return getRobuxUpsellSuggestions(v78, robux, v84):andThen(function(p21) -- line: 278
					-- upvalues: p19 (copy), PromptNativeUpsellSuggestions (copy)
					p19:dispatch(PromptNativeUpsellSuggestions(p21.products, 1, p21.virtualItemBadgeType))
				end, function() -- line: 288
					-- upvalues: p19 (copy), ErrorOccurred (copy), PurchaseError (copy)
					p19:dispatch(ErrorOccurred(PurchaseError.NotEnoughRobuxXbox))
				end)
			end

			return p19:dispatch(ErrorOccurred(v77))
		end

		return p19:dispatch(SetPromptState(PromptState.PromptPurchase))
	end)
end

return resolveBundlePromptState
