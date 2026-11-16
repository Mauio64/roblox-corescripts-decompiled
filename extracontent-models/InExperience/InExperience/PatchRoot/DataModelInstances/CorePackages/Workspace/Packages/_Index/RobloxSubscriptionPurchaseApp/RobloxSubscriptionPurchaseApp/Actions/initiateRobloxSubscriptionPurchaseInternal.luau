local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local parent = RobloxSubscriptionPurchaseApp.Parent
local Promise = require(parent.Promise)

local RobloxSubscriptionStore = require(RobloxSubscriptionPurchaseApp.Store.RobloxSubscriptionStore)
local PromptState = require(RobloxSubscriptionPurchaseApp.Enums.PromptState)
require(RobloxSubscriptionPurchaseApp.types)
require(RobloxSubscriptionPurchaseApp.Models.GetRobloxSubscriptionProductsModel)
local createPaymentSession = require(RobloxSubscriptionPurchaseApp.Network.createPaymentSession)
local getRobloxSubscriptionProducts = require(RobloxSubscriptionPurchaseApp.Network.getRobloxSubscriptionProducts)
local getRobloxSubscriptionProductsDirect = require(RobloxSubscriptionPurchaseApp.Network.getRobloxSubscriptionProductsDirect)
local FFlagRobloxSubscriptionProductsDirectFetch = require(RobloxSubscriptionPurchaseApp.Flags.FFlagRobloxSubscriptionProductsDirectFetch)
local getAmpFeatureAccess = require(RobloxSubscriptionPurchaseApp.Network.getAmpFeatureAccess)
local logRobloxSubscriptionUpsellCounter = require(RobloxSubscriptionPurchaseApp.Utils.logRobloxSubscriptionUpsellCounter)
local logSubscriptionPurchaseFlowEvent = require(RobloxSubscriptionPurchaseApp.Utils.logSubscriptionPurchaseFlowEvent)

local FFlagEnableSubscriptionPurchaseFlowEventIngest = require(RobloxSubscriptionPurchaseApp.Flags.FFlagEnableSubscriptionPurchaseFlowEventIngest)
local RobloxSubscriptionUpsellTelemetry = require(RobloxSubscriptionPurchaseApp.Events.RobloxSubscriptionUpsellTelemetry)
local transitionToError = require(RobloxSubscriptionPurchaseApp.Actions.transitionToError)
local FFlagRobloxPlusAmpSubscriptionCheck = require(RobloxSubscriptionPurchaseApp.Flags.FFlagRobloxPlusAmpSubscriptionCheck)
local SharedFlags = require(parent.SharedFlags)
local FFlagEnablePlusReferralLandingSheet = SharedFlags.FFlagEnablePlusReferralLandingSheet
local fetchReferralEligibility = require(RobloxSubscriptionPurchaseApp.Network.fetchReferralEligibility)
local ErrorReason = require(RobloxSubscriptionPurchaseApp.Enums.ErrorReason)
local ReferralIneligibilityReason = require(RobloxSubscriptionPurchaseApp.Enums.ReferralIneligibilityReason)
local AmpAccessResponse = require(RobloxSubscriptionPurchaseApp.Enums.AmpAccessResponse)
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local getAppFeaturePolicies = UniversalAppPolicy.getAppFeaturePolicies

local referralSelfReferralsByRecipientSelfReferral = {
	[ReferralIneligibilityReason.RecipientSelfReferral] = ErrorReason.ReferralSelfReferral
}

function initiateRobloxSubscriptionPurchaseInternal(p)
	logRobloxSubscriptionUpsellCounter(RobloxSubscriptionUpsellTelemetry.RobloxSubscriptionUpsellModalInitiatedCounter)

	local v = RobloxSubscriptionStore.get()

	local purchaseUIOptions = v.getPurchaseUIOptions()

	local v2 = getAppFeaturePolicies().getDisableBlackbirdEntrypoints()

	if purchaseUIOptions ~= nil and purchaseUIOptions.skipGuacPolicy then
		v2 = false
	end

	if v2 then
		transitionToError(ErrorReason.UnsupportedPlatform, "initiateRobloxSubscriptionPurchaseInternal")
		return
	end

	v.setPromptState(PromptState.SubscriptionPurchaseRequested)

	if FFlagEnableSubscriptionPurchaseFlowEventIngest then
		logSubscriptionPurchaseFlowEvent("SubscriptionUpsellModalOpen")
	end

	local paymentSession = createPaymentSession(p)
	local v3

	if FFlagEnablePlusReferralLandingSheet then
		v3 = v.getReferrerId()
	else
		v3 = nil
	end

	if not (v3 and v3 > 0) then
		v3 = nil
	end

	local v4

	if FFlagRobloxSubscriptionProductsDirectFetch then
		v4 = getRobloxSubscriptionProductsDirect(v3)
	else
		v4 = getRobloxSubscriptionProducts()
	end

	local v5 = { paymentSession, v4 }

	if FFlagRobloxPlusAmpSubscriptionCheck then
		table.insert(v5, getAmpFeatureAccess())
	end

	if FFlagEnablePlusReferralLandingSheet and v3 then
		table.insert(v5, fetchReferralEligibility(v3))
	end

	Promise.all(v5):andThen(function(list)
		local item = list[1]
		local item2 = list[2]

		if FFlagRobloxPlusAmpSubscriptionCheck and list[3] == AmpAccessResponse.Granted then
			transitionToError(ErrorReason.AlreadySubscribed, "initiateRobloxSubscriptionPurchaseInternal")
			return
		end

		if FFlagEnablePlusReferralLandingSheet and v3 then
			local item3 = list[FFlagRobloxPlusAmpSubscriptionCheck and 4 or 3]

			if not item3.eligible then
				transitionToError(
					referralSelfReferralsByRecipientSelfReferral[item3.reason] or ErrorReason.ReferralIneligible,
					"initiateRobloxSubscriptionPurchaseInternal"
				)
				return
			end
		end

		v.setPaymentSessionId(item)

		if not (#item2 > 0) then
			transitionToError(ErrorReason.AlreadySubscribed, "initiateRobloxSubscriptionPurchaseInternal")
			return
		end

		local v6 = item2[1]
		v.setRobloxSubscriptionProduct(v6)

		v.setPromptState(PromptState.SubscriptionPurchaseUIReady)
	end, function(_)
		transitionToError(ErrorReason.GenericError, "initiateRobloxSubscriptionPurchaseInternal")
	end)
end

return initiateRobloxSubscriptionPurchaseInternal
