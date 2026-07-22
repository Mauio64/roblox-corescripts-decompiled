local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local RobloxSubscriptionPurchaseAppParent = RobloxSubscriptionPurchaseApp.Parent
local Promise = require(RobloxSubscriptionPurchaseAppParent.Promise)
local RobloxSubscriptionStore = require(RobloxSubscriptionPurchaseApp.Store.RobloxSubscriptionStore)
local PromptState = require(RobloxSubscriptionPurchaseApp.Enums.PromptState)

require(RobloxSubscriptionPurchaseApp.types)
require(RobloxSubscriptionPurchaseApp.Models.GetRobloxSubscriptionProductsModel)

local createPaymentSession = require(RobloxSubscriptionPurchaseApp.Network.createPaymentSession)
local getRobloxSubscriptionProducts = require(RobloxSubscriptionPurchaseApp.Network.getRobloxSubscriptionProducts)
local getAmpFeatureAccess = require(RobloxSubscriptionPurchaseApp.Network.getAmpFeatureAccess)
local logRobloxSubscriptionUpsellCounter = require(RobloxSubscriptionPurchaseApp.Utils.logRobloxSubscriptionUpsellCounter)
local logSubscriptionPurchaseFlowEvent = require(RobloxSubscriptionPurchaseApp.Utils.logSubscriptionPurchaseFlowEvent)
local FFlagEnableSubscriptionPurchaseFlowEventIngest = require(RobloxSubscriptionPurchaseApp.Flags.FFlagEnableSubscriptionPurchaseFlowEventIngest)
local RobloxSubscriptionUpsellTelemetry = require(RobloxSubscriptionPurchaseApp.Events.RobloxSubscriptionUpsellTelemetry)
local transitionToError = require(RobloxSubscriptionPurchaseApp.Actions.transitionToError)
local FFlagRobloxPlusFAEFreeTrial = require(RobloxSubscriptionPurchaseApp.Flags.FFlagRobloxPlusFAEFreeTrial)
local FFlagRobloxPlusAmpSubscriptionCheck = require(RobloxSubscriptionPurchaseApp.Flags.FFlagRobloxPlusAmpSubscriptionCheck)
local ErrorReason = require(RobloxSubscriptionPurchaseApp.Enums.ErrorReason)
local AmpAccessResponse = require(RobloxSubscriptionPurchaseApp.Enums.AmpAccessResponse)
local getAppFeaturePolicies = require(RobloxSubscriptionPurchaseAppParent.UniversalAppPolicy).getAppFeaturePolicies

function initiateRobloxSubscriptionPurchaseInternal(p1) -- line: 34
	-- upvalues: logRobloxSubscriptionUpsellCounter (copy), RobloxSubscriptionUpsellTelemetry (copy), RobloxSubscriptionStore (copy), FFlagRobloxPlusFAEFreeTrial (copy), getAppFeaturePolicies (copy), transitionToError (copy), ErrorReason (copy), PromptState (copy), FFlagEnableSubscriptionPurchaseFlowEventIngest (copy), logSubscriptionPurchaseFlowEvent (copy), createPaymentSession (copy), getRobloxSubscriptionProducts (copy), FFlagRobloxPlusAmpSubscriptionCheck (copy), getAmpFeatureAccess (copy), Promise (copy), AmpAccessResponse (copy)
	logRobloxSubscriptionUpsellCounter(RobloxSubscriptionUpsellTelemetry.RobloxSubscriptionUpsellModalInitiatedCounter)

	local v20 = RobloxSubscriptionStore.get()
	local v21 = nil

	if FFlagRobloxPlusFAEFreeTrial then
		v21 = v20.getPurchaseUIOptions()
	end

	local v22 = getAppFeaturePolicies().getDisableBlackbirdEntrypoints()

	if FFlagRobloxPlusFAEFreeTrial and v21 ~= nil and v21.skipGuacPolicy then
		v22 = false
	end

	if v22 then
		transitionToError(ErrorReason.UnsupportedPlatform, "initiateRobloxSubscriptionPurchaseInternal")

		return
	end

	v20.setPromptState(PromptState.SubscriptionPurchaseRequested)

	if FFlagEnableSubscriptionPurchaseFlowEventIngest then
		logSubscriptionPurchaseFlowEvent("SubscriptionUpsellModalOpen")
	end

	local t1 = {
		createPaymentSession(p1),
		(getRobloxSubscriptionProducts())
	}

	if FFlagRobloxPlusAmpSubscriptionCheck then
		table.insert(t1, getAmpFeatureAccess())
	end

	Promise.all(t1):andThen(function(p2) -- line: 69
		-- upvalues: FFlagRobloxPlusAmpSubscriptionCheck (copy), AmpAccessResponse (copy), transitionToError (copy), ErrorReason (copy), v20 (copy), PromptState (copy)
		local v25 = p2[1]
		local v26 = p2[2]

		if FFlagRobloxPlusAmpSubscriptionCheck and p2[3] == AmpAccessResponse.Granted then
			transitionToError(ErrorReason.AlreadySubscribed, "initiateRobloxSubscriptionPurchaseInternal")

			return
		end

		v20.setPaymentSessionId(v25)

		if #v26 > 0 then
			local v27 = v26[1]

			v20.setRobloxSubscriptionProduct(v27)
			v20.setPromptState(PromptState.SubscriptionPurchaseUIReady)

			return
		end

		transitionToError(ErrorReason.AlreadySubscribed, "initiateRobloxSubscriptionPurchaseInternal")
	end, function(_) -- line: 95
		-- upvalues: transitionToError (copy), ErrorReason (copy)
		transitionToError(ErrorReason.GenericError, "initiateRobloxSubscriptionPurchaseInternal")
	end)
end

return initiateRobloxSubscriptionPurchaseInternal
