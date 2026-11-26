local RobloxSubscriptionStore = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Store/RobloxSubscriptionStore")
local PromptState = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/PromptState")
local RobloxSubscriptionFlowCompleteReason = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/RobloxSubscriptionFlowCompleteReason")
local cleanupSubscriptionFlow = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Actions/cleanupSubscriptionFlow")
local logRobloxSubscriptionUpsellCounter = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Utils/logRobloxSubscriptionUpsellCounter")
local logSubscriptionPurchaseFlowEvent = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Utils/logSubscriptionPurchaseFlowEvent")
local RobloxSubscriptionUpsellTelemetry = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Events/RobloxSubscriptionUpsellTelemetry")

local FFlagEnableSubscriptionPurchaseFlowEventIngest = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Flags/FFlagEnableSubscriptionPurchaseFlowEventIngest")
local FFlagBustAvatarCacheAfterSubscriptionPurchase = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Flags/FFlagBustAvatarCacheAfterSubscriptionPurchase")

local function emitCompletionTelemetry(p2)
	if p2 == RobloxSubscriptionFlowCompleteReason.UpsellDismissed then
		if FFlagEnableSubscriptionPurchaseFlowEventIngest then
			logSubscriptionPurchaseFlowEvent("SubscriptionUpsellPurchaseDismissed")
		end

		logRobloxSubscriptionUpsellCounter(RobloxSubscriptionUpsellTelemetry.RobloxSubscriptionUpsellDismissedCounter)
	elseif p2 == RobloxSubscriptionFlowCompleteReason.UpsellPurchaseSucceeded then
		if FFlagEnableSubscriptionPurchaseFlowEventIngest then
			logSubscriptionPurchaseFlowEvent("SubscriptionUpsellPurchaseSucceeded")
		end

		logRobloxSubscriptionUpsellCounter(RobloxSubscriptionUpsellTelemetry.RobloxSubscriptionUpsellPurchaseSucceededCounter)
	elseif p2 == RobloxSubscriptionFlowCompleteReason.UpsellPurchaseFailed then
		if FFlagEnableSubscriptionPurchaseFlowEventIngest then
			logSubscriptionPurchaseFlowEvent("SubscriptionUpsellPurchaseFailed")
		end

		logRobloxSubscriptionUpsellCounter(RobloxSubscriptionUpsellTelemetry.RobloxSubscriptionUpsellNativePurchasePollingTimeoutCounter)
	elseif p2 == RobloxSubscriptionFlowCompleteReason.UpsellPurchaseAttempted then
		logRobloxSubscriptionUpsellCounter(RobloxSubscriptionUpsellTelemetry.RobloxSubscriptionPurchaseAttemptedCounter)
	end

	logRobloxSubscriptionUpsellCounter(RobloxSubscriptionUpsellTelemetry.RobloxSubscriptionUpsellFlowCompletedCounter)
end

local function finalizeRobloxSubscriptionUpsellFlow(p2)
	local v5 = RobloxSubscriptionStore.get()
	local didTryPurchasing = v5.getDidTryPurchasing()
	local isNativePurchase = v5.getIsNativePurchase()
	local skipWaitingForPurchaseResult = v5.getPurchaseFlowOptions().skipWaitingForPurchaseResult or false
	local v6

	if didTryPurchasing then
		if p2 then
			v6 = RobloxSubscriptionFlowCompleteReason.UpsellPurchaseSucceeded
		elseif isNativePurchase and not skipWaitingForPurchaseResult then
			v6 = RobloxSubscriptionFlowCompleteReason.UpsellPurchaseFailed
		else
			v6 = RobloxSubscriptionFlowCompleteReason.UpsellPurchaseAttempted
		end
	else
		v6 = RobloxSubscriptionFlowCompleteReason.UpsellDismissed
	end

	v5.setPromptState(PromptState.SubscriptionPurchaseCompleted)

	emitCompletionTelemetry(v6)

	if FFlagBustAvatarCacheAfterSubscriptionPurchase and v6 == RobloxSubscriptionFlowCompleteReason.UpsellPurchaseSucceeded then
		local AvatarEditorService = game:GetService("AvatarEditorService")
		AvatarEditorService:BustAvatarFetchCache()
	end

	v5.triggerOnFlowComplete(v6)
	cleanupSubscriptionFlow()
end

return finalizeRobloxSubscriptionUpsellFlow
