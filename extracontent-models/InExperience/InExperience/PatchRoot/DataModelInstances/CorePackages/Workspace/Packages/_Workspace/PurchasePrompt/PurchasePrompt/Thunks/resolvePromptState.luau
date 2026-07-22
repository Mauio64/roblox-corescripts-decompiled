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
local completeRequest = require(PurchasePrompt.Thunks.completeRequest)
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
local FFlagAXFixRobuxUpsellSoftLock = require(PurchasePrompt.Flags.FFlagAXFixRobuxUpsellSoftLock)
local t1 = {
	ABTest,
	Analytics,
	ExternalSettings,
	Network
}
local FFlagEnableUpsellSuggestionsAnalyticsId = require(PurchasePromptParent.SharedFlags).FFlagEnableUpsellSuggestionsAnalyticsId

local function handleSuccessfulUpsellSuggestions(p1, p2) -- line: 71
	-- upvalues: hasPendingRequest (copy), PromptNativeUpsellSuggestions (copy), sendCounter (copy), Counter (copy)
	if not hasPendingRequest(p1:getState()) then
		return
	end

	p1:dispatch(PromptNativeUpsellSuggestions(p2.products, 1, p2.virtualItemBadgeType))
	p1:dispatch(sendCounter(Counter.UpsellModalShown))
end
local function handleFailedUpsellProduct(p3, _) -- line: 81
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
local function resolvePromptState(p5, p6, p7, p8, p9, p10, p11, p12) -- line: 97
	-- upvalues: Thunk (copy), t1 (copy), ABTest (copy), Analytics (copy), ExternalSettings (copy), Network (copy), ProductInfoReceived (copy), AccountInfoReceived (copy), BalanceInfoRecieved (copy), FFlagEnableUnifiedProductPurchaseFlow (copy), SetIsUserEligibleForUnifiedPurchaseFlow (copy), SetPurchaseAnalyticsMetadata (copy), getPurchaseSurface (copy), getProductTypeFromRequestType (copy), FFlagUpdatePriceTelemetry (copy), selectPrice (copy), FFlagUnifiedPurchaseGamepassAddProductUniverseId (copy), FFlagEnableBlackbirdUpsellInUnifiedPurchaseModal (copy), SetRobloxSubscriptionProducts (copy), meetsPrerequisites (copy), PurchaseError (copy), CompleteRequest (copy), ErrorOccurred (copy), getPlayerProductInfoPrice (copy), UserInputService (copy), getPaymentPlatform (copy), PaymentPlatform (copy), SetPurchaseFlow (copy), PurchaseFlow (copy), SetPostPurchaseActions (copy), LargerRobuxUpsellTest (copy), GetFStringLargerRobuxUpsellIxpLayer (copy), FFlagEnableUpsellSuggestionsAnalyticsId (copy), getRobuxUpsellSuggestions (copy), handleSuccessfulUpsellSuggestions (copy), handleFailedUpsellProduct (copy), FFlagAXFixRobuxUpsellSoftLock (copy), RequestType (copy), completeRequest (copy), SetPromptState (copy), PromptState (copy)
	return Thunk.new(script.Name, t1, function(p13, p14) -- line: 107
		-- upvalues: ABTest (copy), Analytics (copy), ExternalSettings (copy), Network (copy), ProductInfoReceived (copy), p5 (copy), AccountInfoReceived (copy), p6 (copy), BalanceInfoRecieved (copy), p7 (copy), FFlagEnableUnifiedProductPurchaseFlow (copy), p11 (copy), SetIsUserEligibleForUnifiedPurchaseFlow (copy), SetPurchaseAnalyticsMetadata (copy), getPurchaseSurface (copy), getProductTypeFromRequestType (copy), FFlagUpdatePriceTelemetry (copy), selectPrice (copy), p10 (copy), FFlagUnifiedPurchaseGamepassAddProductUniverseId (copy), FFlagEnableBlackbirdUpsellInUnifiedPurchaseModal (copy), p12 (copy), SetRobloxSubscriptionProducts (copy), p9 (copy), meetsPrerequisites (copy), p8 (copy), PurchaseError (copy), CompleteRequest (copy), ErrorOccurred (copy), getPlayerProductInfoPrice (copy), UserInputService (copy), getPaymentPlatform (copy), PaymentPlatform (copy), SetPurchaseFlow (copy), PurchaseFlow (copy), SetPostPurchaseActions (copy), LargerRobuxUpsellTest (copy), GetFStringLargerRobuxUpsellIxpLayer (copy), FFlagEnableUpsellSuggestionsAnalyticsId (copy), getRobuxUpsellSuggestions (copy), handleSuccessfulUpsellSuggestions (copy), handleFailedUpsellProduct (copy), FFlagAXFixRobuxUpsellSoftLock (copy), RequestType (copy), completeRequest (copy), SetPromptState (copy), PromptState (copy)
		local v63 = p13:getState()
		local v64 = p14[ABTest]
		local v65 = p14[Analytics]
		local v66 = p14[ExternalSettings]
		local _ = p14[Network]

		p13:dispatch(ProductInfoReceived(p5))
		p13:dispatch(AccountInfoReceived(p6))
		p13:dispatch(BalanceInfoRecieved(p7))

		if FFlagEnableUnifiedProductPurchaseFlow then
			if p11 then
				p13:dispatch(SetIsUserEligibleForUnifiedPurchaseFlow(true))

				local v68 = p13:getState()

				p13:dispatch(SetPurchaseAnalyticsMetadata({
					purchaseFlowUUID = v68.purchaseFlowUUID,
					surface = getPurchaseSurface(v68.purchaseAnalyticsMetadata),
					productType = getProductTypeFromRequestType(v68.promptRequest.requestType),
					productId = v68.productInfo.productId,
					productTargetId = v68.productInfo.productTargetId,
					saleLocationUniverseId = game.GameId or 0,
					price = if not FFlagUpdatePriceTelemetry then if not v68.productInfo.price then p10 else v68.productInfo.price else selectPrice(v68).priceInRobux,
					productUniverseId = if not FFlagUnifiedPurchaseGamepassAddProductUniverseId then nil else v68.purchaseAnalyticsMetadata.productUniverseId,
					userRobuxBalance = v68.accountInfo.balance
				}))

				if FFlagEnableBlackbirdUpsellInUnifiedPurchaseModal and p12 then
					p13:dispatch(SetRobloxSubscriptionProducts(p12))
				end
			else
				p13:dispatch(SetIsUserEligibleForUnifiedPurchaseFlow(false))
			end
		end

		local v69 = (not v66.getFlagBypassThirdPartySettingForRobloxPurchase() or not p9) and (v66.getLuaUseThirdPartyPermissions() or v66.getFlagRestrictSales2())
		local v70, v71 = meetsPrerequisites(p5, p8, v69, v66, p10)

		if not v70 then
			if not v66.isStudio() and v71 == PurchaseError.ThirdPartyDisabled then
				return p13:dispatch(CompleteRequest())
			end

			return p13:dispatch(ErrorOccurred(v71))
		end

		local robux = p7.robux
		local hasFailed = p7.hasFailed
		local isPremium = p6.isPremium
		local v75 = getPlayerProductInfoPrice(p5, isPremium)

		if p10 ~= nil then
			v75 = p10
		end

		local Platform = UserInputService:GetPlatform()

		if not hasFailed and robux < v75 then
			if v66.getFFlagDisableRobuxUpsell() then
				return p13:dispatch(ErrorOccurred(PurchaseError.NotEnoughRobuxNoUpsell))
			end

			local v77 = getPaymentPlatform(Platform)

			if FFlagEnableUnifiedProductPurchaseFlow and p11 or v77 ~= PaymentPlatform.Web then
				p13:dispatch(SetPurchaseFlow(PurchaseFlow.RobuxUpsellV2))
			end

			if FFlagEnableUnifiedProductPurchaseFlow and p11 then
				p13:dispatch(SetPostPurchaseActions({}))
			end

			if LargerRobuxUpsellTest.isEnabled() then
				local v78 = GetFStringLargerRobuxUpsellIxpLayer()
				local v79 = v64.getLayerData(v78)

				if v79 then
					v64.logUserLayerExposure(v78)

					if LargerRobuxUpsellTest.isUserEnrolled(v79) then
						p13:dispatch(SetPurchaseFlow(PurchaseFlow.LargeRobuxUpsell))
					end
				end
			end

			local GameId = game.GameId
			local ProductId = p5.ProductId
			local DisplayName = p5.DisplayName
			local v83 = FFlagEnableUpsellSuggestionsAnalyticsId and v63.purchaseFlowUUID or nil

			return getRobuxUpsellSuggestions(v75, robux, v77, ProductId, DisplayName, GameId, v83):andThen(function(p15) -- line: 226
				-- upvalues: handleSuccessfulUpsellSuggestions (copy), p13 (copy)
				return handleSuccessfulUpsellSuggestions(p13, p15)
			end, function() -- line: 230
				-- upvalues: handleFailedUpsellProduct (copy), p13 (copy), v63 (copy)
				return handleFailedUpsellProduct(p13, v63)
			end)
		end

		if FFlagAXFixRobuxUpsellSoftLock and v75 <= robux and v63.promptRequest.requestType == RequestType.RobuxUpsell then
			return p13:dispatch(completeRequest())
		end

		if v63.requestType ~= RequestType.AvatarCreationFee then
			v65.signalProductPurchaseShown(p5.productId, v63.requestType)
		end

		return p13:dispatch(SetPromptState(PromptState.PromptPurchase))
	end)
end

return resolvePromptState
