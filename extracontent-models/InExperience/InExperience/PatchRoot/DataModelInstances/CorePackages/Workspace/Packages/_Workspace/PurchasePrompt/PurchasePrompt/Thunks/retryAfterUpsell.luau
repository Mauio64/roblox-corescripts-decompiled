local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")

local SetPromptState = require(PurchasePrompt.Actions.SetPromptState)
local BalanceInfoRecieved = require(PurchasePrompt.Actions.BalanceInfoRecieved)
local PurchaseCompleteRecieved = require(PurchasePrompt.Actions.PurchaseCompleteRecieved)
local ErrorOccurred = require(PurchasePrompt.Actions.ErrorOccurred)
local PromptNativeUpsellSuggestions = require(PurchasePrompt.Actions.PromptNativeUpsellSuggestions)

require(PurchasePrompt.types)
local PurchaseFlow = require(PurchasePrompt.Enums.PurchaseFlow)
local UpsellFlow = require(PurchasePrompt.Enums.UpsellFlow)
local PurchaseError = require(PurchasePrompt.Enums.PurchaseError)
local PromptState = require(PurchasePrompt.Enums.PromptState)
local RequestType = require(PurchasePrompt.Enums.RequestType)

local Counter = require(PurchasePrompt.Enums.Counter)
local sendCounter = require(PurchasePrompt.Thunks.sendCounter)

require(PurchasePrompt.Models.RobuxUpsell)
local getRobuxUpsellSuggestions = require(PurchasePrompt.Network.getRobuxUpsellSuggestions)
local getBalanceInfo = require(PurchasePrompt.Network.getBalanceInfo)
local Network = require(PurchasePrompt.Services.Network)
local Analytics = require(PurchasePrompt.Services.Analytics)
local ExternalSettings = require(PurchasePrompt.Services.ExternalSettings)
local completeRequest = require(PurchasePrompt.Thunks.completeRequest)
local getPlayerPrice = require(PurchasePrompt.Utils.getPlayerPrice)
local hasPendingRequest = require(PurchasePrompt.Utils.hasPendingRequest)
local getPaymentPlatform = require(PurchasePrompt.Utils.getPaymentPlatform)
local isEligibleForRobuxUpsellPlusButton = require(PurchasePrompt.Utils.isEligibleForRobuxUpsellPlusButton)
local selectPrice = require(PurchasePrompt.Selectors.selectPrice)
local getUpsellFlow = require(PurchasePrompt.NativeUpsell.getUpsellFlow)
local Thunk = require(PurchasePrompt.Thunk)

local purchaseItem = require(script.Parent.purchaseItem)

local defineFastInt = game:DefineFastInt("UpsellAccountBalanceRetryAttemps", 3)
local defineFastInt2 = game:DefineFastInt("UpsellAccountBalanceRetryIntervalSec", 1)

local defineFastFlag = game:DefineFastFlag("RetryAfterUpsellV2", false)
local retryAfterUpsellV2 = require(script.Parent.retryAfterUpsellV2)

local defineFastFlag2 = game:DefineFastFlag("AddUnifiedPurchaseRobuxUpsellCompletedTelemetry2", false)
local logUnifiedPurchaseTelemetryCounter = require(PurchasePrompt.Utils.logUnifiedPurchaseTelemetryCounter)
local UnifiedPurchaseTelemetry = require(PurchasePrompt.Events.UnifiedPurchaseTelemetry)
local SharedFlags = require(PurchasePrompt.Parent.SharedFlags)
local FFlagAXMISWithBlackbird = SharedFlags.FFlagAXMISWithBlackbird

local v = { Analytics, Network, ExternalSettings }

if defineFastFlag then
	return retryAfterUpsellV2
end

local function retryAfterUpsell(p)
	local v2 = p or defineFastInt

	return Thunk.new(script.Name, v, function(object, p2)
		local v3 = p2[Analytics]
		local v4 = p2[Network]
		local v5 = p2[ExternalSettings]
		local state = object:getState()
		local requestType = state.promptRequest.requestType
		local promptState = state.promptState
		local purchaseFlow = state.purchaseFlow

		local upsellFlow = getUpsellFlow(v5.getPlatform())

		if
			requestType == RequestType.None
			or promptState ~= PromptState.UpsellInProgress and promptState ~= PromptState.PollingBalance
		then
			return
		end

		if
			requestType == RequestType.Subscription
			or FFlagAXMISWithBlackbird and requestType == RequestType.RobuxUpsell
		then
			if promptState ~= PromptState.UpsellInProgress then
				return
			end

			object:dispatch(PurchaseCompleteRecieved())
			object:dispatch(completeRequest())
		else
			if purchaseFlow == PurchaseFlow.RobuxUpsellV2 or purchaseFlow == PurchaseFlow.LargeRobuxUpsell then
				object:dispatch(SetPromptState(PromptState.PollingBalance))
			end

			return getBalanceInfo(v4, v5, false):andThen(function(p3)
				local state2 = object:getState()
				local v6 = state2.accountInfo.membershipType == 4
				local playerPrice = getPlayerPrice(state2.productInfo, v6)

				if not hasPendingRequest(object:getState()) then
					return
				end

				local balance = state2.accountInfo.balance
				local robux = p3.robux
				object:dispatch(BalanceInfoRecieved(p3))
				local state3 = object:getState()

				if balance == robux then
					if v2 > 0 then
						delay(defineFastInt2, function()
							object:dispatch(retryAfterUpsell(v2 - 1))
						end)
						return
					end

					v3.signalFailedPurchasePostUpsell()

					if upsellFlow == UpsellFlow.Web then
						object:dispatch(ErrorOccurred(PurchaseError.InvalidFundsUnknown))
					else
						object:dispatch(ErrorOccurred(PurchaseError.InvalidFunds))
					end

					if defineFastFlag2 and state2.purchaseAnalyticsMetadata then
						local purchaseAnalyticsMetadata = state2.purchaseAnalyticsMetadata
						logUnifiedPurchaseTelemetryCounter(
							UnifiedPurchaseTelemetry.UnifiedRobuxUpsellRobuxPurchaseFailedCounter,
							purchaseAnalyticsMetadata.surface,
							purchaseAnalyticsMetadata.productType
						)
					end
				elseif playerPrice == nil or not (robux < playerPrice) then
					if defineFastFlag2 and state2.purchaseAnalyticsMetadata then
						local purchaseAnalyticsMetadata = state2.purchaseAnalyticsMetadata
						logUnifiedPurchaseTelemetryCounter(
							UnifiedPurchaseTelemetry.UnifiedRobuxUpsellRobuxPurchaseCompletedCounter,
							purchaseAnalyticsMetadata.surface,
							purchaseAnalyticsMetadata.productType
						)
					end

					object:dispatch(purchaseItem())
				elseif purchaseFlow == PurchaseFlow.LargeRobuxUpsell then
					return getRobuxUpsellSuggestions(
						playerPrice,
						robux,
						getPaymentPlatform((v5.getPlatform())),
						isEligibleForRobuxUpsellPlusButton(
							state3.isUserEligibleForUnifiedPurchaseFlow,
							state3.robloxSubscriptionProducts,
							state3.productPayload,
							selectPrice(state3),
							state3.promptRequest.requestType
						)
					):andThen(
						function(data)
							if not hasPendingRequest(object:getState()) then
								return
							end

							object:dispatch(PromptNativeUpsellSuggestions(
								data.products,
								1,
								data.virtualItemBadgeType,
								data.experimentVariant
							))

							object:dispatch(sendCounter(Counter.UpsellModalShownAgain))
						end,
						function()
							if not hasPendingRequest(object:getState()) then
								return
							end

							object:dispatch(SetPromptState(PromptState.LargeRobuxUpsell))
							object:dispatch(sendCounter(Counter.UpsellGenericModalShownAgain))
						end
					)
				else
					if upsellFlow == UpsellFlow.Web then
						object:dispatch(ErrorOccurred(PurchaseError.InvalidFundsUnknown))
					else
						object:dispatch(ErrorOccurred(PurchaseError.InvalidFunds))
					end

					object:dispatch(sendCounter(Counter.UpsellFailedNotEnoughRobux))
				end
			end):catch(function(p3)
				object:dispatch(ErrorOccurred(p3))
			end)
		end
	end)
end

return retryAfterUpsell
