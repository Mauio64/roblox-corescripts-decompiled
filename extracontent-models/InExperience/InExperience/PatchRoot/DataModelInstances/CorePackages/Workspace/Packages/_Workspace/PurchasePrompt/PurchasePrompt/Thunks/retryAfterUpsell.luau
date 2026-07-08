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
local getUpsellFlow = require(PurchasePrompt.NativeUpsell.getUpsellFlow)
local Thunk = require(PurchasePrompt.Thunk)
local purchaseItem = require(script.Parent.purchaseItem)
local v26 = game:DefineFastInt("UpsellAccountBalanceRetryAttemps", 3)
local v27 = game:DefineFastInt("UpsellAccountBalanceRetryIntervalSec", 1)
local v28 = game:DefineFastFlag("RetryAfterUpsellV2", false)
local retryAfterUpsellV2 = require(script.Parent.retryAfterUpsellV2)
local v30 = game:DefineFastFlag("AddUnifiedPurchaseRobuxUpsellCompletedTelemetry2", false)
local logUnifiedPurchaseTelemetryCounter = require(PurchasePrompt.Utils.logUnifiedPurchaseTelemetryCounter)
local UnifiedPurchaseTelemetry = require(PurchasePrompt.Events.UnifiedPurchaseTelemetry)
local FFlagAXMISWithBlackbird = require(PurchasePrompt.Parent.SharedFlags).FFlagAXMISWithBlackbird
local t1 = {
	Analytics,
	Network,
	ExternalSettings
}

if v28 then
	return retryAfterUpsellV2
end

local function retryAfterUpsell(p1) -- line: 58
	-- upvalues: v26 (copy), Thunk (copy), t1 (copy), Analytics (copy), Network (copy), ExternalSettings (copy), getUpsellFlow (copy), RequestType (copy), PromptState (copy), FFlagAXMISWithBlackbird (copy), PurchaseCompleteRecieved (copy), completeRequest (copy), PurchaseFlow (copy), SetPromptState (copy), getBalanceInfo (copy), getPlayerPrice (copy), hasPendingRequest (copy), BalanceInfoRecieved (copy), getPaymentPlatform (copy), getRobuxUpsellSuggestions (copy), PromptNativeUpsellSuggestions (copy), sendCounter (copy), Counter (copy), UpsellFlow (copy), ErrorOccurred (copy), PurchaseError (copy), v30 (copy), logUnifiedPurchaseTelemetryCounter (copy), UnifiedPurchaseTelemetry (copy), purchaseItem (copy), v27 (copy), retryAfterUpsell (copy)
	local u37 = p1 or v26

	return Thunk.new(script.Name, t1, function(p2, p3) -- line: 61
		-- upvalues: Analytics (copy), Network (copy), ExternalSettings (copy), getUpsellFlow (copy), RequestType (copy), PromptState (copy), FFlagAXMISWithBlackbird (copy), PurchaseCompleteRecieved (copy), completeRequest (copy), PurchaseFlow (copy), SetPromptState (copy), getBalanceInfo (copy), getPlayerPrice (copy), hasPendingRequest (copy), BalanceInfoRecieved (copy), getPaymentPlatform (copy), getRobuxUpsellSuggestions (copy), PromptNativeUpsellSuggestions (copy), sendCounter (copy), Counter (copy), UpsellFlow (copy), ErrorOccurred (copy), PurchaseError (copy), v30 (copy), logUnifiedPurchaseTelemetryCounter (copy), UnifiedPurchaseTelemetry (copy), purchaseItem (copy), u37 (ref), v27 (copy), retryAfterUpsell (copy)
		local v40 = p3[Analytics]
		local v41 = p3[Network]
		local v42 = p3[ExternalSettings]
		local v43 = p2:getState()
		local requestType = v43.promptRequest.requestType
		local promptState = v43.promptState
		local purchaseFlow = v43.purchaseFlow
		local v47 = getUpsellFlow(v42.getPlatform())

		if requestType == RequestType.None then
			return
		end

		if promptState ~= PromptState.UpsellInProgress and promptState ~= PromptState.PollingBalance then
			return
		end

		if requestType == RequestType.Premium or requestType == RequestType.Subscription or FFlagAXMISWithBlackbird and requestType == RequestType.RobuxUpsell then
			if promptState == PromptState.UpsellInProgress then
				p2:dispatch(PurchaseCompleteRecieved())
				p2:dispatch(completeRequest())

				return
			end

			return
		end

		if purchaseFlow == PurchaseFlow.RobuxUpsellV2 or purchaseFlow == PurchaseFlow.LargeRobuxUpsell then
			p2:dispatch(SetPromptState(PromptState.PollingBalance))
		end

		return getBalanceInfo(v41, v42, false):andThen(function(p4) -- line: 95
			-- upvalues: p2 (copy), getPlayerPrice (copy), hasPendingRequest (copy), BalanceInfoRecieved (copy), purchaseFlow (copy), PurchaseFlow (copy), v42 (copy), getPaymentPlatform (copy), getRobuxUpsellSuggestions (copy), PromptNativeUpsellSuggestions (copy), sendCounter (copy), Counter (copy), SetPromptState (copy), PromptState (copy), v47 (copy), UpsellFlow (copy), ErrorOccurred (copy), PurchaseError (copy), v30 (copy), logUnifiedPurchaseTelemetryCounter (copy), UnifiedPurchaseTelemetry (copy), purchaseItem (copy), u37 (ref), v27 (copy), retryAfterUpsell (copy), v40 (copy)
			local v49 = p2:getState()
			local v50 = v49.accountInfo.membershipType == 4
			local v51 = getPlayerPrice(v49.productInfo, v50)

			if not hasPendingRequest(p2:getState()) then
				return
			end

			local balance = v49.accountInfo.balance
			local robux = p4.robux

			p2:dispatch(BalanceInfoRecieved(p4))

			if balance ~= robux then
				if v51 ~= nil and robux < v51 then
					if purchaseFlow == PurchaseFlow.LargeRobuxUpsell then
						local v54 = v42.getPlatform()
						local v55 = getPaymentPlatform(v54)

						return getRobuxUpsellSuggestions(v51, robux, v55):andThen(function(p5) -- line: 117
							-- upvalues: hasPendingRequest (copy), p2 (copy), PromptNativeUpsellSuggestions (copy), sendCounter (copy), Counter (copy)
							if not hasPendingRequest(p2:getState()) then
								return
							end

							p2:dispatch(PromptNativeUpsellSuggestions(p5.products, 1, p5.virtualItemBadgeType))
							p2:dispatch(sendCounter(Counter.UpsellModalShownAgain))
						end, function() -- line: 131
							-- upvalues: hasPendingRequest (copy), p2 (copy), SetPromptState (copy), PromptState (copy), sendCounter (copy), Counter (copy)
							if not hasPendingRequest(p2:getState()) then
								return
							end

							p2:dispatch(SetPromptState(PromptState.LargeRobuxUpsell))
							p2:dispatch(sendCounter(Counter.UpsellGenericModalShownAgain))
						end)
					end

					if v47 == UpsellFlow.Web then
						p2:dispatch(ErrorOccurred(PurchaseError.InvalidFundsUnknown))
					else
						p2:dispatch(ErrorOccurred(PurchaseError.InvalidFunds))
					end

					p2:dispatch(sendCounter(Counter.UpsellFailedNotEnoughRobux))

					return
				end

				if v30 and v49.purchaseAnalyticsMetadata then
					local purchaseAnalyticsMetadata = v49.purchaseAnalyticsMetadata

					logUnifiedPurchaseTelemetryCounter(UnifiedPurchaseTelemetry.UnifiedRobuxUpsellRobuxPurchaseCompletedCounter, purchaseAnalyticsMetadata.surface, purchaseAnalyticsMetadata.productType)
				end

				p2:dispatch(purchaseItem())

				return
			end

			if u37 > 0 then
				delay(v27, function() -- line: 165
					-- upvalues: p2 (copy), retryAfterUpsell (copy), u37 (ref)
					p2:dispatch(retryAfterUpsell(u37 - 1))
				end)

				return
			end

			v40.signalFailedPurchasePostUpsell()

			if v47 == UpsellFlow.Web then
				p2:dispatch(ErrorOccurred(PurchaseError.InvalidFundsUnknown))
			else
				p2:dispatch(ErrorOccurred(PurchaseError.InvalidFunds))
			end

			if v30 and v49.purchaseAnalyticsMetadata then
				local purchaseAnalyticsMetadata = v49.purchaseAnalyticsMetadata

				logUnifiedPurchaseTelemetryCounter(UnifiedPurchaseTelemetry.UnifiedRobuxUpsellRobuxPurchaseFailedCounter, purchaseAnalyticsMetadata.surface, purchaseAnalyticsMetadata.productType)
			end
		end):catch(function(p6) -- line: 189
			-- upvalues: p2 (copy), ErrorOccurred (copy)
			p2:dispatch(ErrorOccurred(p6))
		end)
	end)
end

return retryAfterUpsell
