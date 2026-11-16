local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local RobloxSubscriptionStore = require(RobloxSubscriptionPurchaseApp.Store.RobloxSubscriptionStore)
local PromptState = require(RobloxSubscriptionPurchaseApp.Enums.PromptState)
local RobloxSubscriptionFlowCompleteReason = require(RobloxSubscriptionPurchaseApp.Enums.RobloxSubscriptionFlowCompleteReason)
local cleanupSubscriptionFlow = require(RobloxSubscriptionPurchaseApp.Actions.cleanupSubscriptionFlow)
local logRobloxSubscriptionUpsellCounter = require(RobloxSubscriptionPurchaseApp.Utils.logRobloxSubscriptionUpsellCounter)
local logSubscriptionPurchaseFlowEvent = require(RobloxSubscriptionPurchaseApp.Utils.logSubscriptionPurchaseFlowEvent)
local RobloxSubscriptionUpsellTelemetry = require(RobloxSubscriptionPurchaseApp.Events.RobloxSubscriptionUpsellTelemetry)

local FFlagEnableSubscriptionPurchaseFlowEventIngest = require(RobloxSubscriptionPurchaseApp.Flags.FFlagEnableSubscriptionPurchaseFlowEventIngest)
local FFlagBustAvatarCacheAfterSubscriptionPurchase = require(RobloxSubscriptionPurchaseApp.Flags.FFlagBustAvatarCacheAfterSubscriptionPurchase)

local function emitCompletionTelemetry(p)
	if p == RobloxSubscriptionFlowCompleteReason.UpsellDismissed then
		if FFlagEnableSubscriptionPurchaseFlowEventIngest then
			logSubscriptionPurchaseFlowEvent("SubscriptionUpsellPurchaseDismissed")
		end

		logRobloxSubscriptionUpsellCounter(RobloxSubscriptionUpsellTelemetry.RobloxSubscriptionUpsellDismissedCounter)
	elseif p == RobloxSubscriptionFlowCompleteReason.UpsellPurchaseSucceeded then
		if FFlagEnableSubscriptionPurchaseFlowEventIngest then
			logSubscriptionPurchaseFlowEvent("SubscriptionUpsellPurchaseSucceeded")
		end

		logRobloxSubscriptionUpsellCounter(RobloxSubscriptionUpsellTelemetry.RobloxSubscriptionUpsellPurchaseSucceededCounter)
	elseif p == RobloxSubscriptionFlowCompleteReason.UpsellPurchaseFailed then
		if FFlagEnableSubscriptionPurchaseFlowEventIngest then
			logSubscriptionPurchaseFlowEvent("SubscriptionUpsellPurchaseFailed")
		end

		logRobloxSubscriptionUpsellCounter(RobloxSubscriptionUpsellTelemetry.RobloxSubscriptionUpsellNativePurchasePollingTimeoutCounter)
	elseif p == RobloxSubscriptionFlowCompleteReason.UpsellPurchaseAttempted then
		logRobloxSubscriptionUpsellCounter(RobloxSubscriptionUpsellTelemetry.RobloxSubscriptionPurchaseAttemptedCounter)
	end

	logRobloxSubscriptionUpsellCounter(RobloxSubscriptionUpsellTelemetry.RobloxSubscriptionUpsellFlowCompletedCounter)
end

local function fn(flag: boolean, flag2: boolean, flag3: boolean, skipWaitingForPurchaseResult: boolean) -- 1 equivalent call inferred from this helper
	if not flag then
		return RobloxSubscriptionFlowCompleteReason.UpsellDismissed
	end

	if flag2 then
		return RobloxSubscriptionFlowCompleteReason.UpsellPurchaseSucceeded
	end

	if flag3 and not skipWaitingForPurchaseResult then
		return RobloxSubscriptionFlowCompleteReason.UpsellPurchaseFailed
	end

	return RobloxSubscriptionFlowCompleteReason.UpsellPurchaseAttempted
end

local function finalizeRobloxSubscriptionUpsellFlow(flag: boolean)
	local v = RobloxSubscriptionStore.get()
	local v2 = fn( -- inferred equivalent call
		v.getDidTryPurchasing(),
		flag,
		v.getIsNativePurchase(),
		v.getPurchaseFlowOptions().skipWaitingForPurchaseResult or false
	)

	v.setPromptState(PromptState.SubscriptionPurchaseCompleted)

	emitCompletionTelemetry(v2)

	if
		FFlagBustAvatarCacheAfterSubscriptionPurchase
		and v2 == RobloxSubscriptionFlowCompleteReason.UpsellPurchaseSucceeded
	then
		local AvatarEditorService = game:GetService("AvatarEditorService")
		AvatarEditorService:BustAvatarFetchCache()
	end

	v.triggerOnFlowComplete(v2)
	cleanupSubscriptionFlow()
end

return finalizeRobloxSubscriptionUpsellFlow
