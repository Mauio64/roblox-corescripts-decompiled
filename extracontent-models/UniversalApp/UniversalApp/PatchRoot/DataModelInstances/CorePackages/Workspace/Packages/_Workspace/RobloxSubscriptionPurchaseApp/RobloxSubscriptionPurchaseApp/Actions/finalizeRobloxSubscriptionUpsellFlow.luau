local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local RobloxSubscriptionStore = require(RobloxSubscriptionPurchaseApp.Store.RobloxSubscriptionStore)
local PromptState = require(RobloxSubscriptionPurchaseApp.Enums.PromptState)
local RobloxSubscriptionFlowCompleteReason = require(RobloxSubscriptionPurchaseApp.Enums.RobloxSubscriptionFlowCompleteReason)
local cleanupSubscriptionFlow = require(RobloxSubscriptionPurchaseApp.Actions.cleanupSubscriptionFlow)
local logRobloxSubscriptionUpsellCounter = require(RobloxSubscriptionPurchaseApp.Utils.logRobloxSubscriptionUpsellCounter)
local logSubscriptionPurchaseFlowEvent = require(RobloxSubscriptionPurchaseApp.Utils.logSubscriptionPurchaseFlowEvent)
local RobloxSubscriptionUpsellTelemetry = require(RobloxSubscriptionPurchaseApp.Events.RobloxSubscriptionUpsellTelemetry)
local FFlagEnableSubscriptionPurchaseFlowEventIngest = require(RobloxSubscriptionPurchaseApp.Flags.FFlagEnableSubscriptionPurchaseFlowEventIngest)

local function emitCompletionTelemetry(p1) -- line: 61
	-- upvalues: RobloxSubscriptionFlowCompleteReason (copy), FFlagEnableSubscriptionPurchaseFlowEventIngest (copy), logSubscriptionPurchaseFlowEvent (copy), logRobloxSubscriptionUpsellCounter (copy), RobloxSubscriptionUpsellTelemetry (copy)
	if p1 == RobloxSubscriptionFlowCompleteReason.UpsellDismissed then
		if FFlagEnableSubscriptionPurchaseFlowEventIngest then
			logSubscriptionPurchaseFlowEvent("SubscriptionUpsellPurchaseDismissed")
		end

		logRobloxSubscriptionUpsellCounter(RobloxSubscriptionUpsellTelemetry.RobloxSubscriptionUpsellDismissedCounter)
	elseif p1 == RobloxSubscriptionFlowCompleteReason.UpsellPurchaseSucceeded then
		if FFlagEnableSubscriptionPurchaseFlowEventIngest then
			logSubscriptionPurchaseFlowEvent("SubscriptionUpsellPurchaseSucceeded")
		end

		logRobloxSubscriptionUpsellCounter(RobloxSubscriptionUpsellTelemetry.RobloxSubscriptionUpsellPurchaseSucceededCounter)
	elseif p1 == RobloxSubscriptionFlowCompleteReason.UpsellPurchaseFailed then
		if FFlagEnableSubscriptionPurchaseFlowEventIngest then
			logSubscriptionPurchaseFlowEvent("SubscriptionUpsellPurchaseFailed")
		end

		logRobloxSubscriptionUpsellCounter(RobloxSubscriptionUpsellTelemetry.RobloxSubscriptionUpsellNativePurchasePollingTimeoutCounter)
	elseif p1 == RobloxSubscriptionFlowCompleteReason.UpsellPurchaseAttempted then
		logRobloxSubscriptionUpsellCounter(RobloxSubscriptionUpsellTelemetry.RobloxSubscriptionPurchaseAttemptedCounter)
	end

	logRobloxSubscriptionUpsellCounter(RobloxSubscriptionUpsellTelemetry.RobloxSubscriptionUpsellFlowCompletedCounter)
end
local function finalizeRobloxSubscriptionUpsellFlow(b1: boolean) -- line: 93
	-- upvalues: RobloxSubscriptionStore (copy), RobloxSubscriptionFlowCompleteReason (copy), PromptState (copy), emitCompletionTelemetry (copy), cleanupSubscriptionFlow (copy)
	local v18 = RobloxSubscriptionStore.get()
	local v19 = v18.getDidTryPurchasing()
	local v20 = v18.getIsNativePurchase()
	local v21 = v18.getPurchaseFlowOptions().skipWaitingForPurchaseResult or false
	local v22 = if v19 then if not b1 then if not v20 or v21 then RobloxSubscriptionFlowCompleteReason.UpsellPurchaseAttempted else RobloxSubscriptionFlowCompleteReason.UpsellPurchaseFailed else RobloxSubscriptionFlowCompleteReason.UpsellPurchaseSucceeded else RobloxSubscriptionFlowCompleteReason.UpsellDismissed

	v18.setPromptState(PromptState.SubscriptionPurchaseCompleted)
	emitCompletionTelemetry(v22)
	v18.triggerOnFlowComplete(v22)
	cleanupSubscriptionFlow()
end

return finalizeRobloxSubscriptionUpsellFlow
