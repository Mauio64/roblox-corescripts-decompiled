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
local FFlagAXMISWithBlackbird = require(PurchasePrompt.Parent.SharedFlags).FFlagAXMISWithBlackbird
local v26 = game:DefineFastFlag("AddUnifiedPurchaseRobuxUpsellCompletedTelemetry", false)
local logUnifiedPurchaseTelemetryCounter = require(PurchasePrompt.Utils.logUnifiedPurchaseTelemetryCounter)
local UnifiedPurchaseTelemetry = require(PurchasePrompt.Events.UnifiedPurchaseTelemetry)
local purchaseItem = require(script.Parent.purchaseItem)
local v30 = game:DefineFastInt("UpsellAccountBalanceRetryAttemps", 3)
local v31 = game:DefineFastInt("UpsellAccountBalanceRetryIntervalSec", 1)
local t1 = {
	Analytics,
	Network,
	ExternalSettings
}

local function restartUpsell(p1, _, p3, p4, p5) -- line: 52
	-- upvalues: getRobuxUpsellSuggestions (copy), hasPendingRequest (copy), PromptNativeUpsellSuggestions (copy), sendCounter (copy), Counter (copy), SetPromptState (copy), PromptState (copy)
	return getRobuxUpsellSuggestions(p3, p4, p5):andThen(function(p6) -- line: 55
		-- upvalues: hasPendingRequest (copy), p1 (copy), PromptNativeUpsellSuggestions (copy), sendCounter (copy), Counter (copy)
		if not hasPendingRequest(p1:getState()) then
			return
		end

		p1:dispatch(PromptNativeUpsellSuggestions(p6.products, 1, p6.virtualItemBadgeType))
		p1:dispatch(sendCounter(Counter.UpsellModalShownAgain))
	end, function() -- line: 65
		-- upvalues: hasPendingRequest (copy), p1 (copy), SetPromptState (copy), PromptState (copy), sendCounter (copy), Counter (copy)
		if not hasPendingRequest(p1:getState()) then
			return
		end

		p1:dispatch(SetPromptState(PromptState.LargeRobuxUpsell))
		p1:dispatch(sendCounter(Counter.UpsellGenericModalShownAgain))
	end)
end
local function retryAfterUpsell(n1: number?) -- line: 76
	-- upvalues: v30 (copy), Thunk (copy), t1 (copy), Analytics (copy), Network (copy), ExternalSettings (copy), getUpsellFlow (copy), RequestType (copy), PromptState (copy), FFlagAXMISWithBlackbird (copy), PurchaseCompleteRecieved (copy), completeRequest (copy), PurchaseFlow (copy), SetPromptState (copy), getBalanceInfo (copy), getPlayerPrice (copy), hasPendingRequest (copy), getPaymentPlatform (copy), BalanceInfoRecieved (copy), UpsellFlow (copy), restartUpsell (copy), ErrorOccurred (copy), PurchaseError (copy), sendCounter (copy), Counter (copy), v26 (copy), logUnifiedPurchaseTelemetryCounter (copy), UnifiedPurchaseTelemetry (copy), purchaseItem (copy), v31 (copy), retryAfterUpsell (copy)
	local v41 = n1 or v30

	return Thunk.new(script.Name, t1, function(p7, p8) -- line: 79
		-- upvalues: Analytics (copy), Network (copy), ExternalSettings (copy), getUpsellFlow (copy), RequestType (copy), PromptState (copy), FFlagAXMISWithBlackbird (copy), PurchaseCompleteRecieved (copy), completeRequest (copy), PurchaseFlow (copy), SetPromptState (copy), getBalanceInfo (copy), getPlayerPrice (copy), hasPendingRequest (copy), getPaymentPlatform (copy), BalanceInfoRecieved (copy), UpsellFlow (copy), restartUpsell (copy), ErrorOccurred (copy), PurchaseError (copy), sendCounter (copy), Counter (copy), v26 (copy), logUnifiedPurchaseTelemetryCounter (copy), UnifiedPurchaseTelemetry (copy), purchaseItem (copy), v41 (copy), v31 (copy), retryAfterUpsell (copy)
		local v45 = p8[Analytics]
		local v46 = p8[Network]
		local v47 = p8[ExternalSettings]
		local v48 = p7:getState()
		local requestType = v48.promptRequest.requestType
		local promptState = v48.promptState
		local purchaseFlow = v48.purchaseFlow
		local v52 = getUpsellFlow(v47.getPlatform())

		if requestType == RequestType.None then
			return
		end

		if promptState ~= PromptState.UpsellInProgress and promptState ~= PromptState.PollingBalance then
			return
		end

		if requestType == RequestType.Premium or requestType == RequestType.Subscription or FFlagAXMISWithBlackbird and requestType == RequestType.RobuxUpsell then
			if promptState == PromptState.UpsellInProgress then
				p7:dispatch(PurchaseCompleteRecieved())
				p7:dispatch(completeRequest())

				return
			end

			return
		end

		if purchaseFlow == PurchaseFlow.RobuxUpsellV2 or purchaseFlow == PurchaseFlow.LargeRobuxUpsell then
			p7:dispatch(SetPromptState(PromptState.PollingBalance))
		end

		return getBalanceInfo(v46, v47, false):andThen(function(p9) -- line: 113
			-- upvalues: p7 (copy), getPlayerPrice (copy), hasPendingRequest (copy), getPaymentPlatform (copy), v47 (copy), BalanceInfoRecieved (copy), purchaseFlow (copy), PurchaseFlow (copy), v52 (copy), UpsellFlow (copy), restartUpsell (copy), v46 (copy), ErrorOccurred (copy), PurchaseError (copy), sendCounter (copy), Counter (copy), v26 (copy), logUnifiedPurchaseTelemetryCounter (copy), UnifiedPurchaseTelemetry (copy), purchaseItem (copy), v41 (copy), v31 (copy), retryAfterUpsell (copy), v45 (copy)
			local v54 = p7:getState()
			local v55 = v54.accountInfo.membershipType == 4
			local v56 = getPlayerPrice(v54.productInfo, v55)

			if not hasPendingRequest(p7:getState()) then
				return
			end

			local v57 = getPaymentPlatform(v47.getPlatform())
			local balance = v54.accountInfo.balance
			local robux = p9.robux

			p7:dispatch(BalanceInfoRecieved(p9))

			if balance ~= robux then
				if v56 ~= nil and robux < v56 then
					if purchaseFlow == PurchaseFlow.LargeRobuxUpsell or v52 == UpsellFlow.Web then
						return restartUpsell(p7, v46, v56, robux, v57)
					end

					p7:dispatch(ErrorOccurred(PurchaseError.InvalidFunds))
					p7:dispatch(sendCounter(Counter.UpsellFailedNotEnoughRobux))

					return
				end

				if v26 and v54.purchaseAnalyticsMetadata then
					local purchaseAnalyticsMetadata = v54.purchaseAnalyticsMetadata

					logUnifiedPurchaseTelemetryCounter(UnifiedPurchaseTelemetry.UnifiedRobuxUpsellRobuxPurchaseCompletedCounter, purchaseAnalyticsMetadata.surface, purchaseAnalyticsMetadata.productType)
				end

				p7:dispatch(purchaseItem())

				return
			end

			if v41 > 0 then
				delay(v31, function() -- line: 154
					-- upvalues: p7 (copy), retryAfterUpsell (copy), v41 (copy)
					p7:dispatch(retryAfterUpsell(v41 - 1))
				end)

				return
			end

			v45.signalFailedPurchasePostUpsell()

			if v52 == UpsellFlow.Web then
				restartUpsell(p7, v46, v56, robux, v57)
			else
				p7:dispatch(ErrorOccurred(PurchaseError.InvalidFunds))
			end

			if v26 and v54.purchaseAnalyticsMetadata then
				local purchaseAnalyticsMetadata = v54.purchaseAnalyticsMetadata

				logUnifiedPurchaseTelemetryCounter(UnifiedPurchaseTelemetry.UnifiedRobuxUpsellRobuxPurchaseFailedCounter, purchaseAnalyticsMetadata.surface, purchaseAnalyticsMetadata.productType)
			end
		end):catch(function(p10) -- line: 180
			-- upvalues: p7 (copy), ErrorOccurred (copy)
			p7:dispatch(ErrorOccurred(p10))
		end)
	end)
end

return retryAfterUpsell
