local UserInputService = game:GetService("UserInputService")

local SetPurchaseFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetPurchaseFlow")
local SetPromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetPromptState")
local ProductInfoReceived = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/ProductInfoReceived")
local AccountInfoReceived = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/AccountInfoReceived")
local BalanceInfoRecieved = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/BalanceInfoRecieved")
local PromptNativeUpsellSuggestions = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/PromptNativeUpsellSuggestions")
local ErrorOccurred = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/ErrorOccurred")
local CompleteRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/CompleteRequest")

local PurchaseFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseFlow")
local PromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PromptState")
local PurchaseError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseError")
local PaymentPlatform = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PaymentPlatform")
local RequestType = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/RequestType")

require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Models/RobuxUpsell")

local getRobuxUpsellSuggestions = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Network/getRobuxUpsellSuggestions")

local ABTest = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/ABTest")
local Analytics = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/Analytics")
local ExternalSettings = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/ExternalSettings")
local Network = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/Network")

local Counter = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/Counter")
local sendCounter = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/sendCounter")
local completeRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/completeRequest")

local meetsPrerequisites = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/meetsPrerequisites")
local isEligibleForRobuxUpsellPlusButton = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/isEligibleForRobuxUpsellPlusButton")
local getPlayerProductInfoPrice = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/getPlayerProductInfoPrice")
local getPaymentPlatform = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/getPaymentPlatform")
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/getPaymentFromPlatformLegacy")
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/getHasAmazonUserAgent")
local hasPendingRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/hasPendingRequest")
local SetPurchaseAnalyticsMetadata = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetPurchaseAnalyticsMetadata")
local getPurchaseSurface = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/getPurchaseSurface")
local Thunk = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunk")
local getProductTypeFromRequestType = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/getProductTypeFromRequestType")
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/GetFFlagEnableLuobuInGameUpsell")
local getFStringLargerRobuxUpsellIxpLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").GetFStringLargerRobuxUpsellIxpLayer
local LargerRobuxUpsellTest = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/LargerRobuxUpsellTest")
local SetIsUserEligibleForUnifiedPurchaseFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetIsUserEligibleForUnifiedPurchaseFlow")
local SetPostPurchaseActions = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetPostPurchaseActions")
local fFlagUpdatePriceTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagUpdatePriceTelemetry
local selectPrice = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Selectors/selectPrice")

require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/RobloxSubscriptionPurchaseApp")
local SetRobloxSubscriptionProducts = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetRobloxSubscriptionProducts")
local selectCartPricingOverride = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Selectors/selectCartPricingOverride")

local v5 = { ABTest, Analytics, ExternalSettings, Network }

local fFlagEnableUpsellSuggestionsAnalyticsId = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagEnableUpsellSuggestionsAnalyticsId

local function handleSuccessfulUpsellSuggestions(object, data)
	if not hasPendingRequest(object:getState()) then
		return
	end

	object:dispatch(PromptNativeUpsellSuggestions(data.products, 1, data.virtualItemBadgeType, data.experimentVariant))

	object:dispatch(sendCounter(Counter.UpsellModalShown))
end

local function handleFailedUpsellProduct(object, state)
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

local function resolvePromptState(data, p2, p3, p4, p5, p6, p7, p8)
	return Thunk.new("resolvePromptState", v5, function(object, p9)
		local state = object:getState()
		local v6 = p9[ABTest]
		local v7 = p9[Analytics]
		local v8 = p9[ExternalSettings]
		local v9 = p9[Network]

		object:dispatch(ProductInfoReceived(data))
		object:dispatch(AccountInfoReceived(p2))
		object:dispatch(BalanceInfoRecieved(p3))

		if p7 then
			object:dispatch(SetIsUserEligibleForUnifiedPurchaseFlow(true))
			local state2 = object:getState()

			local v11 = {
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
			local v12

			if fFlagUpdatePriceTelemetry then
				v12 = selectPrice(state2).priceInRobux
			else
				v12 = if state2.productInfo.price then state2.productInfo.price else p6
			end

			v11.price = v12

			v11.productUniverseId = state2.purchaseAnalyticsMetadata.productUniverseId
			v11.userRobuxBalance = state2.accountInfo.balance
			object:dispatch(SetPurchaseAnalyticsMetadata(v11))

			if p8 then
				object:dispatch(SetRobloxSubscriptionProducts(p8))
			end
		else
			object:dispatch(SetIsUserEligibleForUnifiedPurchaseFlow(false))
		end

		local v11, v12 = meetsPrerequisites(
			data,
			p4,
			not (v8.getFlagBypassThirdPartySettingForRobloxPurchase() and p5) and (v8.getLuaUseThirdPartyPermissions() or v8.getFlagRestrictSales2()),
			v8,
			p6
		)

		if v11 then
			local robux = p3.robux
			local hasFailed = p3.hasFailed
			local v13 = getPlayerProductInfoPrice(data, p2.isPremium)

			if p6 ~= nil then
				v13 = p6
			end

			local platform = UserInputService:GetPlatform()

			local v14 = selectCartPricingOverride(object:getState())
			local v15 = if v14 == nil then v13 else v14.priceInRobux

			if hasFailed or not (robux < v15) then
				if v13 <= robux and state.promptRequest.requestType == RequestType.RobuxUpsell then
					return object:dispatch(completeRequest())
				end

				if state.requestType ~= RequestType.AvatarCreationFee then
					v7.signalProductPurchaseShown(data.productId, state.requestType)
				end

				return object:dispatch(SetPromptState(PromptState.PromptPurchase))
			else
				if v8.getFFlagDisableRobuxUpsell() then
					return object:dispatch(ErrorOccurred(PurchaseError.NotEnoughRobuxNoUpsell))
				end

				local v16 = getPaymentPlatform(platform)

				if p7 or v16 ~= PaymentPlatform.Web then
					object:dispatch(SetPurchaseFlow(PurchaseFlow.RobuxUpsellV2))
				end

				if p7 then
					object:dispatch(SetPostPurchaseActions({}))
				end

				if LargerRobuxUpsellTest.isEnabled() then
					local fStringLargerRobuxUpsellIxpLayer = getFStringLargerRobuxUpsellIxpLayer()
					local layerData = v6.getLayerData(fStringLargerRobuxUpsellIxpLayer)

					if layerData then
						v6.logUserLayerExposure(fStringLargerRobuxUpsellIxpLayer)

						if LargerRobuxUpsellTest.isUserEnrolled(layerData) then
							object:dispatch(SetPurchaseFlow(PurchaseFlow.LargeRobuxUpsell))
						end
					end
				end

				local gameId = game.GameId
				local productId = data.ProductId
				local displayName = data.DisplayName

				local purchaseFlowUUID = if fFlagEnableUpsellSuggestionsAnalyticsId then state.purchaseFlowUUID or nil else nil

				local state2 = object:getState()
				return getRobuxUpsellSuggestions(
					v13,
					robux,
					v16,
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
					function(p10)
						return handleSuccessfulUpsellSuggestions(object, p10)
					end,
					function()
						return handleFailedUpsellProduct(object, state)
					end
				)
			end
		elseif v8.isStudio() or v12 ~= PurchaseError.ThirdPartyDisabled then
			return object:dispatch(ErrorOccurred(v12))
		else
			return object:dispatch(CompleteRequest())
		end
	end)
end

return resolvePromptState
