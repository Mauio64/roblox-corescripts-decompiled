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
local GetFFlagFixLimitedBundleResalePrerequisite = require(PurchasePrompt.Flags.GetFFlagFixLimitedBundleResalePrerequisite)
local getProductTypeFromRequestType = require(PurchasePrompt.Utils.getProductTypeFromRequestType)
local meetsBundlePrerequisites = require(PurchasePrompt.Utils.meetsBundlePrerequisites)
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
local function meetsBundlePrerequisites2(p3, p4, p5, p6) -- line: 73
	-- upvalues: PurchaseError (copy), Players (copy)
	local collectibleItemDetail = p3.collectibleItemDetail
	local v48 = collectibleItemDetail and (collectibleItemDetail.collectibleItemId ~= nil and collectibleItemDetail.collectibleItemId ~= "")
	local v49 = collectibleItemDetail and (collectibleItemDetail.collectibleItemType ~= nil and collectibleItemDetail.collectibleItemType == "Limited")

	if v48 then
		if not v49 and p6 then
			return false, PurchaseError.AlreadyOwn
		end
	elseif p6 then
		return false, PurchaseError.AlreadyOwn
	end

	if not if not v48 then p3.product and p3.product.isForSale else collectibleItemDetail.saleStatus == "OnSale" then
		return false, PurchaseError.NotForSale
	end

	if p5 ~= nil and p4.robux ~= nil and p5 > p4.robux then
		return false, PurchaseError.NotEnoughRobux
	end

	if p3.itemRestrictions ~= nil then
		for _, v51 in p3.itemRestrictions do
			if v51 == "ThirteenPlus" then
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

local function resolveBundlePromptState(_, p8, p9, p10, p11, p12, p13, p14) -- line: 134
	-- upvalues: Thunk (copy), t1 (copy), Analytics (copy), Network (copy), BundleProductInfoReceived (copy), AccountInfoReceived (copy), BalanceInfoRecieved (copy), FFlagEnableUnifiedProductPurchaseFlow (copy), SetIsUserEligibleForUnifiedPurchaseFlow (copy), SetPurchaseAnalyticsMetadata (copy), getPurchaseSurface (copy), getProductTypeFromRequestType (copy), FFlagUpdatePriceTelemetry (copy), selectPrice (copy), FFlagUnifiedPurchaseGamepassAddProductUniverseId (copy), FFlagEnableBlackbirdUpsellInUnifiedPurchaseModal (copy), SetRobloxSubscriptionProducts (copy), GetFFlagFixLimitedBundleResalePrerequisite (copy), meetsBundlePrerequisites (copy), meetsBundlePrerequisites2 (copy), UserInputService (copy), getUpsellFlow (copy), PurchaseError (copy), RunService (copy), GetFFlagRespectBalanceInfoForBundleUpsellInStudio (copy), GetFFlagEnableInsufficientRobuxForBundleUpsellFix (copy), UpsellFlow (copy), SetPromptState (copy), PromptState (copy), SetPurchaseFlow (copy), PurchaseFlow (copy), SetPostPurchaseActions (copy), getPaymentPlatform (copy), getRobuxUpsellSuggestions (copy), PromptNativeUpsellSuggestions (copy), ErrorOccurred (copy)
	return Thunk.new(script.Name, t1, function(p15, p16) -- line: 144
		-- upvalues: Analytics (copy), Network (copy), BundleProductInfoReceived (copy), p8 (copy), AccountInfoReceived (copy), p9 (copy), BalanceInfoRecieved (copy), p10 (copy), FFlagEnableUnifiedProductPurchaseFlow (copy), p13 (copy), SetIsUserEligibleForUnifiedPurchaseFlow (copy), SetPurchaseAnalyticsMetadata (copy), getPurchaseSurface (copy), getProductTypeFromRequestType (copy), FFlagUpdatePriceTelemetry (copy), selectPrice (copy), p11 (ref), FFlagUnifiedPurchaseGamepassAddProductUniverseId (copy), FFlagEnableBlackbirdUpsellInUnifiedPurchaseModal (copy), p14 (copy), SetRobloxSubscriptionProducts (copy), GetFFlagFixLimitedBundleResalePrerequisite (copy), meetsBundlePrerequisites (copy), p12 (copy), meetsBundlePrerequisites2 (copy), UserInputService (copy), getUpsellFlow (copy), PurchaseError (copy), RunService (copy), GetFFlagRespectBalanceInfoForBundleUpsellInStudio (copy), GetFFlagEnableInsufficientRobuxForBundleUpsellFix (copy), UpsellFlow (copy), SetPromptState (copy), PromptState (copy), SetPurchaseFlow (copy), PurchaseFlow (copy), SetPostPurchaseActions (copy), getPaymentPlatform (copy), getRobuxUpsellSuggestions (copy), PromptNativeUpsellSuggestions (copy), ErrorOccurred (copy)
		p15:getState()

		local _ = p16[Analytics]
		local _ = p16[Network]

		p15:dispatch(BundleProductInfoReceived(p8))
		p15:dispatch(AccountInfoReceived(p9))
		p15:dispatch(BalanceInfoRecieved(p10))

		if FFlagEnableUnifiedProductPurchaseFlow then
			if p13 then
				p15:dispatch(SetIsUserEligibleForUnifiedPurchaseFlow(true))

				local v65 = p15:getState()

				p15:dispatch(SetPurchaseAnalyticsMetadata({
					purchaseFlowUUID = v65.purchaseFlowUUID,
					surface = getPurchaseSurface(v65.purchaseAnalyticsMetadata),
					productType = getProductTypeFromRequestType(v65.promptRequest.requestType),
					productId = v65.productInfo.productId,
					productTargetId = v65.productInfo.productTargetId,
					saleLocationUniverseId = game.GameId or 0,
					price = if not FFlagUpdatePriceTelemetry then if not v65.productInfo.price then p11 else v65.productInfo.price else selectPrice(v65).priceInRobux,
					productUniverseId = if not FFlagUnifiedPurchaseGamepassAddProductUniverseId then nil else v65.purchaseAnalyticsMetadata.productUniverseId,
					userRobuxBalance = v65.accountInfo.balance
				}))

				if FFlagEnableBlackbirdUpsellInUnifiedPurchaseModal and p14 then
					p15:dispatch(SetRobloxSubscriptionProducts(p14))
				end
			else
				p15:dispatch(SetIsUserEligibleForUnifiedPurchaseFlow(false))
			end
		end

		if p11 == nil then
			local isPremium = p9.isPremium
			local v67 = p8

			p11 = (not v67 or v67.product == nil) and 0 or if not isPremium or v67.product.premiumPricing == nil then v67.product.priceInRobux or 0 else v67.product.premiumPricing.premiumPriceInRobux or 0
		end

		local v68, v69

		if GetFFlagFixLimitedBundleResalePrerequisite() then
			v68, v69 = meetsBundlePrerequisites(p8, p10, p11, p12)
		else
			v68, v69 = meetsBundlePrerequisites2(p8, p10, p11, p12)
		end

		local v70 = p11
		local Platform = UserInputService:GetPlatform()
		local v72 = getUpsellFlow(Platform)
		local v73 = v69 == PurchaseError.NotEnoughRobux

		if RunService:IsStudio() and GetFFlagRespectBalanceInfoForBundleUpsellInStudio() and v73 then
			v73 = v70 > p10.robux

			if not v68 then
				v68 = not v73
			end
		end

		if not v68 then
			if v73 then
				if not GetFFlagEnableInsufficientRobuxForBundleUpsellFix() and v72 == UpsellFlow.Web then
					return p15:dispatch(SetPromptState(PromptState.RobuxUpsell))
				end

				if FFlagEnableUnifiedProductPurchaseFlow and p13 then
					p15:dispatch(SetPurchaseFlow(PurchaseFlow.RobuxUpsellV2))
				end

				if FFlagEnableUnifiedProductPurchaseFlow and p13 then
					p15:dispatch(SetPostPurchaseActions({}))
				end

				local _ = v70 - p10.robux
				local _ = p9.isPremium
				local v76 = getPaymentPlatform(Platform)
				local robux = p10.robux

				return getRobuxUpsellSuggestions(v70, robux, v76):andThen(function(p17) -- line: 241
					-- upvalues: p15 (copy), PromptNativeUpsellSuggestions (copy)
					p15:dispatch(PromptNativeUpsellSuggestions(p17.products, 1, p17.virtualItemBadgeType))
				end, function() -- line: 251
					-- upvalues: p15 (copy), ErrorOccurred (copy), PurchaseError (copy)
					p15:dispatch(ErrorOccurred(PurchaseError.NotEnoughRobuxXbox))
				end)
			end

			return p15:dispatch(ErrorOccurred(v69))
		end

		return p15:dispatch(SetPromptState(PromptState.PromptPurchase))
	end)
end

return resolveBundlePromptState
