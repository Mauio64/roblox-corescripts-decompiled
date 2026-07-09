local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local UserInputService = game:GetService("UserInputService")
local SetPurchaseFlow = require(PurchasePrompt.Actions.SetPurchaseFlow)
local SetPromptState = require(PurchasePrompt.Actions.SetPromptState)
local ProductInfoReceived = require(PurchasePrompt.Actions.ProductInfoReceived)
local AccountInfoReceived = require(PurchasePrompt.Actions.AccountInfoReceived)
local BalanceInfoRecieved = require(PurchasePrompt.Actions.BalanceInfoRecieved)
local PromptNativeUpsellSuggestions = require(PurchasePrompt.Actions.PromptNativeUpsellSuggestions)
local ErrorOccurred = require(PurchasePrompt.Actions.ErrorOccurred)
local CompleteRequest = require(PurchasePrompt.Actions.CompleteRequest)
local PurchaseFlow = require(PurchasePrompt.Enums.PurchaseFlow)
local PromptState = require(PurchasePrompt.Enums.PromptState)
local PurchaseError = require(PurchasePrompt.Enums.PurchaseError)
local PaymentPlatform = require(PurchasePrompt.Enums.PaymentPlatform)
local RequestType = require(PurchasePrompt.Enums.RequestType)

require(PurchasePrompt.Models.RobuxUpsell)

local getRobuxUpsellSuggestions = require(PurchasePrompt.Network.getRobuxUpsellSuggestions)
local ABTest = require(PurchasePrompt.Services.ABTest)
local Analytics = require(PurchasePrompt.Services.Analytics)
local ExternalSettings = require(PurchasePrompt.Services.ExternalSettings)
local Network = require(PurchasePrompt.Services.Network)
local Counter = require(PurchasePrompt.Enums.Counter)
local sendCounter = require(PurchasePrompt.Thunks.sendCounter)
local meetsPrerequisites = require(PurchasePrompt.Utils.meetsPrerequisites)
local getPlayerProductInfoPrice = require(PurchasePrompt.Utils.getPlayerProductInfoPrice)
local getPaymentPlatform = require(PurchasePrompt.Utils.getPaymentPlatform)

require(PurchasePrompt.Utils.getPaymentFromPlatformLegacy)
require(PurchasePrompt.Utils.getHasAmazonUserAgent)

local hasPendingRequest = require(PurchasePrompt.Utils.hasPendingRequest)
local SetPurchaseAnalyticsMetadata = require(PurchasePrompt.Actions.SetPurchaseAnalyticsMetadata)
local getPurchaseSurface = require(PurchasePrompt.Utils.getPurchaseSurface)
local Thunk = require(PurchasePrompt.Thunk)
local getProductTypeFromRequestType = require(PurchasePrompt.Utils.getProductTypeFromRequestType)

require(PurchasePrompt.Flags.GetFFlagEnableLuobuInGameUpsell)

local GetFStringLargerRobuxUpsellIxpLayer = require(PurchasePromptParent.SharedFlags).GetFStringLargerRobuxUpsellIxpLayer
local LargerRobuxUpsellTest = require(PurchasePrompt.Flags.LargerRobuxUpsellTest)
local FFlagEnableUnifiedProductPurchaseFlow = require(PurchasePrompt.Parent.SharedFlags).FFlagEnableUnifiedProductPurchaseFlow
local SetIsUserEligibleForUnifiedPurchaseFlow = require(PurchasePrompt.Actions.SetIsUserEligibleForUnifiedPurchaseFlow)
local SetPostPurchaseActions = require(PurchasePrompt.Actions.SetPostPurchaseActions)
local FFlagUnifiedPurchaseGamepassAddProductUniverseId = require(PurchasePromptParent.SharedFlags).FFlagUnifiedPurchaseGamepassAddProductUniverseId
local FFlagUpdatePriceTelemetry = require(PurchasePromptParent.SharedFlags).FFlagUpdatePriceTelemetry
local selectPrice = require(PurchasePrompt.Selectors.selectPrice)

require(PurchasePromptParent.RobloxSubscriptionPurchaseApp)

local SetRobloxSubscriptionProducts = require(PurchasePrompt.Actions.SetRobloxSubscriptionProducts)
local FFlagEnableBlackbirdUpsellInUnifiedPurchaseModal = require(PurchasePrompt.Parent.SharedFlags).FFlagEnableBlackbirdUpsellInUnifiedPurchaseModal
local t1 = {
	ABTest,
	Analytics,
	ExternalSettings,
	Network
}
local FFlagEnableUpsellSuggestionsAnalyticsId = require(PurchasePromptParent.SharedFlags).FFlagEnableUpsellSuggestionsAnalyticsId

local function handleSuccessfulUpsellSuggestions(p1, p2) -- line: 69
	-- upvalues: hasPendingRequest (copy), PromptNativeUpsellSuggestions (copy), sendCounter (copy), Counter (copy)
	if not hasPendingRequest(p1:getState()) then
		return
	end

	p1:dispatch(PromptNativeUpsellSuggestions(p2.products, 1, p2.virtualItemBadgeType))
	p1:dispatch(sendCounter(Counter.UpsellModalShown))
end
local function handleFailedUpsellProduct(p3, _) -- line: 79
	-- upvalues: hasPendingRequest (copy), PurchaseFlow (copy), SetPromptState (copy), PromptState (copy), sendCounter (copy), Counter (copy), ErrorOccurred (copy), PurchaseError (copy)
	if not hasPendingRequest(p3:getState()) then
		return
	end

	if p3:getState().purchaseFlow == PurchaseFlow.LargeRobuxUpsell then
		p3:dispatch(SetPromptState(PromptState.LargeRobuxUpsell))
		p3:dispatch(sendCounter(Counter.UpsellModalShown))

		return
	end

	p3:dispatch(ErrorOccurred(PurchaseError.NotEnoughRobuxXbox))
	p3:dispatch(sendCounter(Counter.UpsellGenericModalShown))
end
local function resolvePromptState(p5, p6, p7, p8, p9, p10, p11, p12) -- line: 95
	-- upvalues: Thunk (copy), t1 (copy), ABTest (copy), Analytics (copy), ExternalSettings (copy), Network (copy), ProductInfoReceived (copy), AccountInfoReceived (copy), BalanceInfoRecieved (copy), FFlagEnableUnifiedProductPurchaseFlow (copy), SetIsUserEligibleForUnifiedPurchaseFlow (copy), SetPurchaseAnalyticsMetadata (copy), getPurchaseSurface (copy), getProductTypeFromRequestType (copy), FFlagUpdatePriceTelemetry (copy), selectPrice (copy), FFlagUnifiedPurchaseGamepassAddProductUniverseId (copy), FFlagEnableBlackbirdUpsellInUnifiedPurchaseModal (copy), SetRobloxSubscriptionProducts (copy), meetsPrerequisites (copy), PurchaseError (copy), CompleteRequest (copy), ErrorOccurred (copy), getPlayerProductInfoPrice (copy), UserInputService (copy), getPaymentPlatform (copy), PaymentPlatform (copy), SetPurchaseFlow (copy), PurchaseFlow (copy), SetPostPurchaseActions (copy), LargerRobuxUpsellTest (copy), GetFStringLargerRobuxUpsellIxpLayer (copy), FFlagEnableUpsellSuggestionsAnalyticsId (copy), getRobuxUpsellSuggestions (copy), handleSuccessfulUpsellSuggestions (copy), handleFailedUpsellProduct (copy), RequestType (copy), SetPromptState (copy), PromptState (copy)
	return Thunk.new(script.Name, t1, function(p13, p14) -- line: 105
		-- upvalues: ABTest (copy), Analytics (copy), ExternalSettings (copy), Network (copy), ProductInfoReceived (copy), p5 (copy), AccountInfoReceived (copy), p6 (copy), BalanceInfoRecieved (copy), p7 (copy), FFlagEnableUnifiedProductPurchaseFlow (copy), p11 (copy), SetIsUserEligibleForUnifiedPurchaseFlow (copy), SetPurchaseAnalyticsMetadata (copy), getPurchaseSurface (copy), getProductTypeFromRequestType (copy), FFlagUpdatePriceTelemetry (copy), selectPrice (copy), p10 (copy), FFlagUnifiedPurchaseGamepassAddProductUniverseId (copy), FFlagEnableBlackbirdUpsellInUnifiedPurchaseModal (copy), p12 (copy), SetRobloxSubscriptionProducts (copy), p9 (copy), meetsPrerequisites (copy), p8 (copy), PurchaseError (copy), CompleteRequest (copy), ErrorOccurred (copy), getPlayerProductInfoPrice (copy), UserInputService (copy), getPaymentPlatform (copy), PaymentPlatform (copy), SetPurchaseFlow (copy), PurchaseFlow (copy), SetPostPurchaseActions (copy), LargerRobuxUpsellTest (copy), GetFStringLargerRobuxUpsellIxpLayer (copy), FFlagEnableUpsellSuggestionsAnalyticsId (copy), getRobuxUpsellSuggestions (copy), handleSuccessfulUpsellSuggestions (copy), handleFailedUpsellProduct (copy), RequestType (copy), SetPromptState (copy), PromptState (copy)
		local v61 = p13:getState()
		local v62 = p14[ABTest]
		local v63 = p14[Analytics]
		local v64 = p14[ExternalSettings]
		local _ = p14[Network]

		p13:dispatch(ProductInfoReceived(p5))
		p13:dispatch(AccountInfoReceived(p6))
		p13:dispatch(BalanceInfoRecieved(p7))

		if FFlagEnableUnifiedProductPurchaseFlow then
			if p11 then
				p13:dispatch(SetIsUserEligibleForUnifiedPurchaseFlow(true))

				local v66 = p13:getState()

				p13:dispatch(SetPurchaseAnalyticsMetadata({
					purchaseFlowUUID = v66.purchaseFlowUUID,
					surface = getPurchaseSurface(v66.purchaseAnalyticsMetadata),
					productType = getProductTypeFromRequestType(v66.promptRequest.requestType),
					productId = v66.productInfo.productId,
					productTargetId = v66.productInfo.productTargetId,
					saleLocationUniverseId = game.GameId or 0,
					price = if not FFlagUpdatePriceTelemetry then if not v66.productInfo.price then p10 else v66.productInfo.price else selectPrice(v66).priceInRobux,
					productUniverseId = if not FFlagUnifiedPurchaseGamepassAddProductUniverseId then nil else v66.purchaseAnalyticsMetadata.productUniverseId,
					userRobuxBalance = v66.accountInfo.balance
				}))

				if FFlagEnableBlackbirdUpsellInUnifiedPurchaseModal and p12 then
					p13:dispatch(SetRobloxSubscriptionProducts(p12))
				end
			else
				p13:dispatch(SetIsUserEligibleForUnifiedPurchaseFlow(false))
			end
		end

		local v67 = (not v64.getFlagBypassThirdPartySettingForRobloxPurchase() or not p9) and (v64.getLuaUseThirdPartyPermissions() or v64.getFlagRestrictSales2())
		local v68, v69 = meetsPrerequisites(p5, p8, v67, v64, p10)

		if not v68 then
			if not v64.isStudio() and v69 == PurchaseError.ThirdPartyDisabled then
				return p13:dispatch(CompleteRequest())
			end

			return p13:dispatch(ErrorOccurred(v69))
		end

		local robux = p7.robux
		local hasFailed = p7.hasFailed
		local isPremium = p6.isPremium
		local v73 = getPlayerProductInfoPrice(p5, isPremium)

		if p10 ~= nil then
			v73 = p10
		end

		local Platform = UserInputService:GetPlatform()

		if not hasFailed and robux < v73 then
			if v64.getFFlagDisableRobuxUpsell() then
				return p13:dispatch(ErrorOccurred(PurchaseError.NotEnoughRobuxNoUpsell))
			end

			local v75 = getPaymentPlatform(Platform)

			if FFlagEnableUnifiedProductPurchaseFlow and p11 or v75 ~= PaymentPlatform.Web then
				p13:dispatch(SetPurchaseFlow(PurchaseFlow.RobuxUpsellV2))
			end

			if FFlagEnableUnifiedProductPurchaseFlow and p11 then
				p13:dispatch(SetPostPurchaseActions({}))
			end

			if LargerRobuxUpsellTest.isEnabled() then
				local v76 = GetFStringLargerRobuxUpsellIxpLayer()
				local v77 = v62.getLayerData(v76)

				if v77 then
					v62.logUserLayerExposure(v76)

					if LargerRobuxUpsellTest.isUserEnrolled(v77) then
						p13:dispatch(SetPurchaseFlow(PurchaseFlow.LargeRobuxUpsell))
					end
				end
			end

			local GameId = game.GameId
			local ProductId = p5.ProductId
			local DisplayName = p5.DisplayName
			local v81 = FFlagEnableUpsellSuggestionsAnalyticsId and v61.purchaseFlowUUID or nil

			return getRobuxUpsellSuggestions(v73, robux, v75, ProductId, DisplayName, GameId, v81):andThen(function(p15) -- line: 224
				-- upvalues: handleSuccessfulUpsellSuggestions (copy), p13 (copy)
				return handleSuccessfulUpsellSuggestions(p13, p15)
			end, function() -- line: 228
				-- upvalues: handleFailedUpsellProduct (copy), p13 (copy), v61 (copy)
				return handleFailedUpsellProduct(p13, v61)
			end)
		end

		if v61.requestType ~= RequestType.AvatarCreationFee then
			v63.signalProductPurchaseShown(p5.productId, v61.requestType)
		end

		return p13:dispatch(SetPromptState(PromptState.PromptPurchase))
	end)
end

return resolvePromptState
