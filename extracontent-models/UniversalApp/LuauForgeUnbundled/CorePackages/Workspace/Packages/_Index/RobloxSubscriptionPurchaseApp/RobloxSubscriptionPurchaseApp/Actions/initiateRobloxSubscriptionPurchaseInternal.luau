local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/Promise")

local RobloxSubscriptionStore = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Store/RobloxSubscriptionStore")
local PromptState = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/PromptState")
require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/types")
require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Models/GetRobloxSubscriptionProductsModel")
local createPaymentSession = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Network/createPaymentSession")
local getRobloxSubscriptionProducts = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Network/getRobloxSubscriptionProducts")
local getRobloxSubscriptionProductsDirect = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Network/getRobloxSubscriptionProductsDirect")
local FFlagRobloxSubscriptionProductsDirectFetch = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Flags/FFlagRobloxSubscriptionProductsDirectFetch")
local getAmpFeatureAccess = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Network/getAmpFeatureAccess")
local logRobloxSubscriptionUpsellCounter = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Utils/logRobloxSubscriptionUpsellCounter")
local logSubscriptionPurchaseFlowEvent = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Utils/logSubscriptionPurchaseFlowEvent")

local FFlagEnableSubscriptionPurchaseFlowEventIngest = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Flags/FFlagEnableSubscriptionPurchaseFlowEventIngest")
local RobloxSubscriptionUpsellTelemetry = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Events/RobloxSubscriptionUpsellTelemetry")
local transitionToError = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Actions/transitionToError")
local FFlagRobloxPlusAmpSubscriptionCheck = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Flags/FFlagRobloxPlusAmpSubscriptionCheck")
local fFlagEnablePlusReferralLandingSheet = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/SharedFlags").FFlagEnablePlusReferralLandingSheet

local fFlagPlusSubscribeDeepLinkIncludeUpgrades = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/SharedFlags").FFlagPlusSubscribeDeepLinkIncludeUpgrades
local FFlagTTOnboardingSheet = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Flags/FFlagTTOnboardingSheet")
local RobloxPlusSheetKind = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/RobloxPlusSheetKind")
local fFlagPlusMembershipConfigChangeCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/SharedFlags").FFlagPlusMembershipConfigChangeCheck
local getRobloxSubscriptionMembershipConfig = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Network/getRobloxSubscriptionMembershipConfig")
local resetPerFlowState = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Actions/resetPerFlowState")
local RobloxSubscriptionSignals = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Store/RobloxSubscriptionSignals")
local fetchReferralEligibility = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Network/fetchReferralEligibility")
local ErrorReason = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/ErrorReason")
local ReferralIneligibilityReason = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/ReferralIneligibilityReason")
local AmpAccessResponse = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/AmpAccessResponse")
local getAppFeaturePolicies = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/UniversalAppPolicy").getAppFeaturePolicies

local referralSelfReferralsByRecipientSelfReferral = {
	[ReferralIneligibilityReason.RecipientSelfReferral] = ErrorReason.ReferralSelfReferral
}

function LUAUFORGE_MODULE_GLOBALS_aQi_initiateRobloxSubscriptionPurchaseInternal(p2)
	logRobloxSubscriptionUpsellCounter(RobloxSubscriptionUpsellTelemetry.RobloxSubscriptionUpsellModalInitiatedCounter)

	local v5 = RobloxSubscriptionStore.get()

	if fFlagPlusMembershipConfigChangeCheck then
		resetPerFlowState()
	end

	local purchaseUIOptions = v5.getPurchaseUIOptions()

	local v6 = getAppFeaturePolicies().getDisableBlackbirdEntrypoints()

	if purchaseUIOptions ~= nil and purchaseUIOptions.skipGuacPolicy then
		v6 = false
	end

	if v6 then
		transitionToError(ErrorReason.UnsupportedPlatform, "initiateRobloxSubscriptionPurchaseInternal")
		return
	end

	if FFlagTTOnboardingSheet and purchaseUIOptions and purchaseUIOptions.sheetKind == RobloxPlusSheetKind.TT then
		v5.setPromptState(PromptState.SubscriptionPurchaseUIReady)
		return
	end

	v5.setPromptState(PromptState.SubscriptionPurchaseRequested)

	if FFlagEnableSubscriptionPurchaseFlowEventIngest then
		logSubscriptionPurchaseFlowEvent("SubscriptionUpsellModalOpen")
	end

	local v7 = createPaymentSession(p2)

	local v8 = if fFlagEnablePlusReferralLandingSheet then v5.getReferrerId() else nil

	if not (v8 and v8 > 0) then
		v8 = nil
	end

	local v9

	if fFlagPlusSubscribeDeepLinkIncludeUpgrades and FFlagRobloxSubscriptionProductsDirectFetch then
		v9 = v5.getPurchaseFlowOptions().includeUpgrades == true
	end

	local v10 = if FFlagRobloxSubscriptionProductsDirectFetch then getRobloxSubscriptionProductsDirect(v8, v9) else getRobloxSubscriptionProducts()
	local v11 = FFlagRobloxPlusAmpSubscriptionCheck and not v9
	local v12 = { v7, v10 }

	if v11 then
		table.insert(v12, getAmpFeatureAccess())
	end

	if fFlagEnablePlusReferralLandingSheet and v8 then
		table.insert(v12, fetchReferralEligibility(v8))
	end

	local v13

	if fFlagPlusMembershipConfigChangeCheck and v9 and RobloxSubscriptionSignals.get().getHasRobloxSubscription() then
		table.insert(v12, getRobloxSubscriptionMembershipConfig())
		v13 = #v12
	else
		v13 = nil
	end

	Promise.all(v12):andThen(function(list)
		local item = list[1]
		local item2 = list[2]

		if v11 and list[3] == AmpAccessResponse.Granted then
			transitionToError(ErrorReason.AlreadySubscribed, "initiateRobloxSubscriptionPurchaseInternal")
			return
		end

		if fFlagEnablePlusReferralLandingSheet and v8 then
			local item3 = list[v11 and 4 or 3]

			if not item3.eligible then
				transitionToError(
					referralSelfReferralsByRecipientSelfReferral[item3.reason] or ErrorReason.ReferralIneligible,
					"initiateRobloxSubscriptionPurchaseInternal"
				)
				return
			end
		end

		if v13 then
			local item3 = list[v13]

			if item3 == nil then
				transitionToError(ErrorReason.GenericError, "initiateRobloxSubscriptionPurchaseInternal")
				return
			end

			v5.setMembershipConfigSnapshot(item3)
		end

		v5.setPaymentSessionId(item)

		if not (#item2 > 0) then
			transitionToError(ErrorReason.AlreadySubscribed, "initiateRobloxSubscriptionPurchaseInternal")
			return
		end

		local v14 = item2[1]
		v5.setRobloxSubscriptionProduct(v14)

		v5.setPromptState(PromptState.SubscriptionPurchaseUIReady)
	end, function(p3)
		transitionToError(ErrorReason.GenericError, "initiateRobloxSubscriptionPurchaseInternal")
	end)
end

return LUAUFORGE_MODULE_GLOBALS_aQi_initiateRobloxSubscriptionPurchaseInternal
