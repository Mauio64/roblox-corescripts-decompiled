local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent
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
local isEligibleForRobuxUpsellPlusButton = require(PurchasePrompt.Utils.isEligibleForRobuxUpsellPlusButton)
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
local SharedFlags = require(parent.SharedFlags)
local GetFStringLargerRobuxUpsellIxpLayer = SharedFlags.GetFStringLargerRobuxUpsellIxpLayer
local LargerRobuxUpsellTest = require(PurchasePrompt.Flags.LargerRobuxUpsellTest)
local SetIsUserEligibleForUnifiedPurchaseFlow = require(PurchasePrompt.Actions.SetIsUserEligibleForUnifiedPurchaseFlow)
local SetPostPurchaseActions = require(PurchasePrompt.Actions.SetPostPurchaseActions)
local SharedFlags2 = require(parent.SharedFlags)
local FFlagUpdatePriceTelemetry = SharedFlags2.FFlagUpdatePriceTelemetry
local selectPrice = require(PurchasePrompt.Selectors.selectPrice)

require(parent.RobloxSubscriptionPurchaseApp)
local SetRobloxSubscriptionProducts = require(PurchasePrompt.Actions.SetRobloxSubscriptionProducts)
local selectCartPricingOverride = require(PurchasePrompt.Selectors.selectCartPricingOverride)

local v = { ABTest, Analytics, ExternalSettings, Network }

local SharedFlags3 = require(parent.SharedFlags)
local FFlagEnableUpsellSuggestionsAnalyticsId = SharedFlags3.FFlagEnableUpsellSuggestionsAnalyticsId

local function handleSuccessfulUpsellSuggestions(object, data)
	if not hasPendingRequest(object:getState()) then
		return
	end

	object:dispatch(PromptNativeUpsellSuggestions(data.products, 1, data.virtualItemBadgeType, data.experimentVariant))

	object:dispatch(sendCounter(Counter.UpsellModalShown))
end

local function handleFailedUpsellProduct(object, _)
	if not hasPendingRequest(object:getState()) then
		return
	end

	if object:getState().purchaseFlow == PurchaseFlow.LargeRobuxUpsell then
		object:dispatch(SetPromptState(PromptState.LargeRobuxUpsell))
		object:dispatch(sendCounter(Counter.UpsellModalShown))
	else
		object:dispatch(ErrorOccurred(PurchaseError.NotEnoughRobuxXbox))
		object:dispatch(sendCounter(Counter.UpsellGenericModalShown))
	end
end

local function resolvePromptState(data, p, p2, p3, p4, p5, p6, p7)
	return Thunk.new(script.Name, v, function(object, p8)
		local state = object:getState()
		local v2 = p8[ABTest]
		local v3 = p8[Analytics]
		local v4 = p8[ExternalSettings]
		local _ = p8[Network]

		object:dispatch(ProductInfoReceived(data))
		object:dispatch(AccountInfoReceived(p))
		object:dispatch(BalanceInfoRecieved(p2))

		if p6 then
			object:dispatch(SetIsUserEligibleForUnifiedPurchaseFlow(true))
			local state2 = object:getState()

			local v5 = {
				purchaseFlowUUID = state2.purchaseFlowUUID,
				surface = getPurchaseSurface(state2.purchaseAnalyticsMetadata),
				productType = getProductTypeFromRequestType(state2.promptRequest.requestType),
				productId = state2.productInfo.productId,
				productTargetId = state2.productInfo.productTargetId,
				saleLocationUniverseId = game.GameId or 0,
				price = 0,
				productUniverseId = 0,
				userRobuxBalance = 0
			}
			local price

			if FFlagUpdatePriceTelemetry then
				price = selectPrice(state2).priceInRobux
			elseif state2.productInfo.price then
				price = state2.productInfo.price
			else
				price = p5
			end

			v5.price = price

			v5.productUniverseId = state2.purchaseAnalyticsMetadata.productUniverseId
			v5.userRobuxBalance = state2.accountInfo.balance
			object:dispatch(SetPurchaseAnalyticsMetadata(v5))

			if p7 then
				object:dispatch(SetRobloxSubscriptionProducts(p7))
			end
		else
			object:dispatch(SetIsUserEligibleForUnifiedPurchaseFlow(false))
		end

		local v5, v6 = meetsPrerequisites(
			data,
			p3,
			not (v4.getFlagBypassThirdPartySettingForRobloxPurchase() and p4) and (v4.getLuaUseThirdPartyPermissions() or v4.getFlagRestrictSales2()),
			v4,
			p5
		)

		if v5 then
			local robux = p2.robux
			local hasFailed = p2.hasFailed
			local v7 = getPlayerProductInfoPrice(data, p.isPremium)

			if p5 ~= nil then
				v7 = p5
			end

			local platform = UserInputService:GetPlatform()

			local v8 = selectCartPricingOverride((object:getState()))
			local v9 = if v8 == nil then v7 else v8.priceInRobux

			if hasFailed or not (robux < v9) then
				if v7 <= robux and state.promptRequest.requestType == RequestType.RobuxUpsell then
					return object:dispatch(completeRequest())
				end

				if state.requestType ~= RequestType.AvatarCreationFee then
					v3.signalProductPurchaseShown(data.productId, state.requestType)
				end

				return object:dispatch(SetPromptState(PromptState.PromptPurchase))
			else
				if v4.getFFlagDisableRobuxUpsell() then
					return object:dispatch(ErrorOccurred(PurchaseError.NotEnoughRobuxNoUpsell))
				end

				local paymentPlatform = getPaymentPlatform(platform)

				if p6 or paymentPlatform ~= PaymentPlatform.Web then
					object:dispatch(SetPurchaseFlow(PurchaseFlow.RobuxUpsellV2))
				end

				if p6 then
					object:dispatch(SetPostPurchaseActions({}))
				end

				if LargerRobuxUpsellTest.isEnabled() then
					local fStringLargerRobuxUpsellIxpLayer = GetFStringLargerRobuxUpsellIxpLayer()
					local layerData = v2.getLayerData(fStringLargerRobuxUpsellIxpLayer)

					if layerData then
						v2.logUserLayerExposure(fStringLargerRobuxUpsellIxpLayer)

						if LargerRobuxUpsellTest.isUserEnrolled(layerData) then
							object:dispatch(SetPurchaseFlow(PurchaseFlow.LargeRobuxUpsell))
						end
					end
				end

				local gameId = game.GameId
				local productId = data.ProductId
				local displayName = data.DisplayName
				local purchaseFlowUUID

				if FFlagEnableUpsellSuggestionsAnalyticsId then
					purchaseFlowUUID = state.purchaseFlowUUID or nil
				end

				local state2 = object:getState()
				return getRobuxUpsellSuggestions(
					v7,
					robux,
					paymentPlatform,
					isEligibleForRobuxUpsellPlusButton(
						state2.isUserEligibleForUnifiedPurchaseFlow,
						state2.robloxSubscriptionProducts,
						state2.productPayload,
						selectPrice(state2),
						state2.promptRequest.requestType
					),
					productId,
					displayName,
					gameId,
					purchaseFlowUUID
				):andThen(
					function(p9)
						return handleSuccessfulUpsellSuggestions(object, p9)
					end,
					function()
						return handleFailedUpsellProduct(object, state)
					end
				)
			end
		elseif v4.isStudio() or v6 ~= PurchaseError.ThirdPartyDisabled then
			return object:dispatch(ErrorOccurred(v6))
		else
			return object:dispatch(CompleteRequest())
		end
	end)
end

return resolvePromptState
