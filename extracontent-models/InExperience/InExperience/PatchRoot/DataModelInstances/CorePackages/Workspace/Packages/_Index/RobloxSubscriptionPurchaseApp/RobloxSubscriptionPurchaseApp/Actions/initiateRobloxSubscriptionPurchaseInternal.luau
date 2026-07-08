local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local RobloxSubscriptionPurchaseAppParent = RobloxSubscriptionPurchaseApp.Parent
local Promise = require(RobloxSubscriptionPurchaseAppParent.Promise)
local RobloxSubscriptionStore = require(RobloxSubscriptionPurchaseApp.Store.RobloxSubscriptionStore)
local PromptState = require(RobloxSubscriptionPurchaseApp.Enums.PromptState)

require(RobloxSubscriptionPurchaseApp.types)
require(RobloxSubscriptionPurchaseApp.Models.GetRobloxSubscriptionProductsModel)

local createPaymentSession = require(RobloxSubscriptionPurchaseApp.Network.createPaymentSession)
local getRobloxSubscriptionProducts = require(RobloxSubscriptionPurchaseApp.Network.getRobloxSubscriptionProducts)
local logRobloxSubscriptionUpsellCounter = require(RobloxSubscriptionPurchaseApp.Utils.logRobloxSubscriptionUpsellCounter)
local logSubscriptionPurchaseFlowEvent = require(RobloxSubscriptionPurchaseApp.Utils.logSubscriptionPurchaseFlowEvent)
local FFlagEnableSubscriptionPurchaseFlowEventIngest = require(RobloxSubscriptionPurchaseApp.Flags.FFlagEnableSubscriptionPurchaseFlowEventIngest)
local RobloxSubscriptionUpsellTelemetry = require(RobloxSubscriptionPurchaseApp.Events.RobloxSubscriptionUpsellTelemetry)
local transitionToError = require(RobloxSubscriptionPurchaseApp.Actions.transitionToError)
local FFlagRobloxPlusFAEFreeTrial = require(RobloxSubscriptionPurchaseApp.Flags.FFlagRobloxPlusFAEFreeTrial)
local ErrorReason = require(RobloxSubscriptionPurchaseApp.Enums.ErrorReason)
local getAppFeaturePolicies = require(RobloxSubscriptionPurchaseAppParent.UniversalAppPolicy).getAppFeaturePolicies

function initiateRobloxSubscriptionPurchaseInternal(p1) -- line: 31
	-- upvalues: logRobloxSubscriptionUpsellCounter (copy), RobloxSubscriptionUpsellTelemetry (copy), RobloxSubscriptionStore (copy), FFlagRobloxPlusFAEFreeTrial (copy), getAppFeaturePolicies (copy), transitionToError (copy), ErrorReason (copy), PromptState (copy), FFlagEnableSubscriptionPurchaseFlowEventIngest (copy), logSubscriptionPurchaseFlowEvent (copy), createPaymentSession (copy), getRobloxSubscriptionProducts (copy), Promise (copy)
	logRobloxSubscriptionUpsellCounter(RobloxSubscriptionUpsellTelemetry.RobloxSubscriptionUpsellModalInitiatedCounter)

	local v17 = RobloxSubscriptionStore.get()
	local v18 = nil

	if FFlagRobloxPlusFAEFreeTrial then
		v18 = v17.getPurchaseUIOptions()
	end

	local v19 = getAppFeaturePolicies().getDisableBlackbirdEntrypoints()

	if FFlagRobloxPlusFAEFreeTrial and v18 ~= nil and v18.skipGuacPolicy then
		v19 = false
	end

	if v19 then
		transitionToError(ErrorReason.UnsupportedPlatform, "initiateRobloxSubscriptionPurchaseInternal")

		return
	end

	v17.setPromptState(PromptState.SubscriptionPurchaseRequested)

	if FFlagEnableSubscriptionPurchaseFlowEventIngest then
		logSubscriptionPurchaseFlowEvent("SubscriptionUpsellModalOpen")
	end

	local v20 = createPaymentSession(p1)
	local v21 = getRobloxSubscriptionProducts()

	Promise.all({
		v20,
		v21
	}):andThen(function(p2) -- line: 61
		-- upvalues: v17 (copy), transitionToError (copy), ErrorReason (copy), PromptState (copy)
		local v23 = p2[1]
		local v24 = p2[2]

		v17.setPaymentSessionId(v23)

		if #v24 > 0 then
			local v25 = v24[1]

			v17.setRobloxSubscriptionProduct(v25)
			v17.setPromptState(PromptState.SubscriptionPurchaseUIReady)

			return
		end

		transitionToError(ErrorReason.AlreadySubscribed, "initiateRobloxSubscriptionPurchaseInternal")
	end, function(_) -- line: 79
		-- upvalues: transitionToError (copy), ErrorReason (copy)
		transitionToError(ErrorReason.GenericError, "initiateRobloxSubscriptionPurchaseInternal")
	end)
end

return initiateRobloxSubscriptionPurchaseInternal
