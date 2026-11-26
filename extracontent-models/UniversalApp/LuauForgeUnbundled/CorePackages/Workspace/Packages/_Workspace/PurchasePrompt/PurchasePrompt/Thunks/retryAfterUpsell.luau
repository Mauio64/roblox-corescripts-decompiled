local SetPromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetPromptState")
local BalanceInfoRecieved = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/BalanceInfoRecieved")
local PurchaseCompleteRecieved = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/PurchaseCompleteRecieved")
local ErrorOccurred = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/ErrorOccurred")
local PromptNativeUpsellSuggestions = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/PromptNativeUpsellSuggestions")

require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/types")
local PurchaseFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseFlow")
local UpsellFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/UpsellFlow")
local PurchaseError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseError")
local PromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PromptState")
local RequestType = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/RequestType")

local Counter = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/Counter")
local sendCounter = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/sendCounter")

require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Models/RobuxUpsell")
local getRobuxUpsellSuggestions = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Network/getRobuxUpsellSuggestions")
local getBalanceInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Network/getBalanceInfo")
local Network = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/Network")
local Analytics = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/Analytics")
local ExternalSettings = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/ExternalSettings")
local completeRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/completeRequest")
local getPlayerPrice = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/getPlayerPrice")
local hasPendingRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/hasPendingRequest")
local getPaymentPlatform = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/getPaymentPlatform")
local isEligibleForRobuxUpsellPlusButton = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/isEligibleForRobuxUpsellPlusButton")
local selectPrice = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Selectors/selectPrice")
local getUpsellFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/NativeUpsell/getUpsellFlow")
local Thunk = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunk")

local purchaseItem = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/purchaseItem")

local defineFastInt = game:DefineFastInt("UpsellAccountBalanceRetryAttemps", 3)
local defineFastInt2 = game:DefineFastInt("UpsellAccountBalanceRetryIntervalSec", 1)

local defineFastFlag = game:DefineFastFlag("RetryAfterUpsellV2", false)
local retryAfterUpsellV2 = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/retryAfterUpsellV2")

local defineFastFlag2 = game:DefineFastFlag("AddUnifiedPurchaseRobuxUpsellCompletedTelemetry2", false)
local logUnifiedPurchaseTelemetryCounter = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/logUnifiedPurchaseTelemetryCounter")
local UnifiedPurchaseTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Events/UnifiedPurchaseTelemetry")
local fFlagAXMISWithBlackbird = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagAXMISWithBlackbird

local v5 = { Analytics, Network, ExternalSettings }

if defineFastFlag then
	return retryAfterUpsellV2
end

local function retryAfterUpsell(p2)
	local v6 = p2 or defineFastInt

	return Thunk.new("retryAfterUpsell", v5, function(object, p3)
		local v7 = p3[Analytics]
		local v8 = p3[Network]
		local v9 = p3[ExternalSettings]
		local state = object:getState()
		local requestType = state.promptRequest.requestType
		local promptState = state.promptState
		local purchaseFlow = state.purchaseFlow

		local v10 = getUpsellFlow(v9.getPlatform())

		if
			requestType == RequestType.None
			or promptState ~= PromptState.UpsellInProgress and promptState ~= PromptState.PollingBalance
		then
			return
		end

		if
			requestType == RequestType.Subscription
			or fFlagAXMISWithBlackbird and requestType == RequestType.RobuxUpsell
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

			return getBalanceInfo(v8, v9, false):andThen(function(p4)
				local state2 = object:getState()
				local v11 = state2.accountInfo.membershipType == 4
				local v12 = getPlayerPrice(state2.productInfo, v11)

				if not hasPendingRequest(object:getState()) then
					return
				end

				local balance = state2.accountInfo.balance
				local robux = p4.robux
				object:dispatch(BalanceInfoRecieved(p4))
				local state3 = object:getState()

				if balance == robux then
					if v6 > 0 then
						delay(defineFastInt2, function()
							object:dispatch(retryAfterUpsell(v6 - 1))
						end)
						return
					end

					v7.signalFailedPurchasePostUpsell()

					if v10 == UpsellFlow.Web then
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
				elseif v12 == nil or not (robux < v12) then
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
						v12,
						robux,
						getPaymentPlatform((v9.getPlatform())),
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
					if v10 == UpsellFlow.Web then
						object:dispatch(ErrorOccurred(PurchaseError.InvalidFundsUnknown))
					else
						object:dispatch(ErrorOccurred(PurchaseError.InvalidFunds))
					end

					object:dispatch(sendCounter(Counter.UpsellFailedNotEnoughRobux))
				end
			end):catch(function(p4)
				object:dispatch(ErrorOccurred(p4))
			end)
		end
	end)
end

return retryAfterUpsell
