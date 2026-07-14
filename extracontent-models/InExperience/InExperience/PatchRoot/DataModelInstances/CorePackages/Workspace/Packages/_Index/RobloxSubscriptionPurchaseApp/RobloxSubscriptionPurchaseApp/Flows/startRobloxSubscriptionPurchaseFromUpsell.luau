local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local RobloxSubscriptionPurchaseAppParent = RobloxSubscriptionPurchaseApp.Parent
local RobloxSubscriptionStore = require(RobloxSubscriptionPurchaseApp.Store.RobloxSubscriptionStore)

require(RobloxSubscriptionPurchaseApp.Models.GetRobloxSubscriptionProductsModel)

local PromptState = require(RobloxSubscriptionPurchaseApp.Enums.PromptState)

require(RobloxSubscriptionPurchaseApp.types)

local createPaymentSession = require(RobloxSubscriptionPurchaseApp.Network.createPaymentSession)
local performRobloxSubscriptionPurchase = require(RobloxSubscriptionPurchaseApp.Actions.performRobloxSubscriptionPurchase)
local RobloxSubscriptionHeadlessOverlayController = require(RobloxSubscriptionPurchaseApp.Flows.RobloxSubscriptionHeadlessOverlayController)
local transitionToError = require(RobloxSubscriptionPurchaseApp.Actions.transitionToError)
local ErrorReason = require(RobloxSubscriptionPurchaseApp.Enums.ErrorReason)
local logRobloxSubscriptionUpsellCounter = require(RobloxSubscriptionPurchaseApp.Utils.logRobloxSubscriptionUpsellCounter)
local RobloxSubscriptionUpsellTelemetry = require(RobloxSubscriptionPurchaseApp.Events.RobloxSubscriptionUpsellTelemetry)
local logSubscriptionPurchaseFlowEvent = require(RobloxSubscriptionPurchaseApp.Utils.logSubscriptionPurchaseFlowEvent)
local FFlagEnableSubscriptionPurchaseFlowEventIngest = require(RobloxSubscriptionPurchaseApp.Flags.FFlagEnableSubscriptionPurchaseFlowEventIngest)
local getAppFeaturePolicies = require(RobloxSubscriptionPurchaseAppParent.UniversalAppPolicy).getAppFeaturePolicies

require(RobloxSubscriptionPurchaseApp.Enums.RobloxSubscriptionFlowCompleteReason)

local function startRobloxSubscriptionPurchaseFromUpsell(t1: {[any]: any}) -- line: 40
	-- upvalues: RobloxSubscriptionStore (copy), logRobloxSubscriptionUpsellCounter (copy), RobloxSubscriptionUpsellTelemetry (copy), getAppFeaturePolicies (copy), RobloxSubscriptionHeadlessOverlayController (copy), transitionToError (copy), ErrorReason (copy), PromptState (copy), FFlagEnableSubscriptionPurchaseFlowEventIngest (copy), logSubscriptionPurchaseFlowEvent (copy), createPaymentSession (copy), performRobloxSubscriptionPurchase (copy)
	local v17 = RobloxSubscriptionStore.get()
	local entryContext = t1.entryContext

	v17.setRobloxSubscriptionProduct(t1.productDetails)
	v17.setOnFlowComplete(t1.onFlowComplete)
	v17.setPurchaseFlowOptions({
		skipWaitingForPurchaseResult = t1.skipWaitingForPurchaseResult == true
	})

	if entryContext then
		v17.setEntryContext(entryContext)
	end

	logRobloxSubscriptionUpsellCounter(RobloxSubscriptionUpsellTelemetry.RobloxSubscriptionUpsellModalInitiatedCounter)

	local v19 = getAppFeaturePolicies().getDisableBlackbirdEntrypoints()
	local v20 = RobloxSubscriptionHeadlessOverlayController.render()

	if v19 then
		transitionToError(ErrorReason.UnsupportedPlatform, "startRobloxSubscriptionPurchaseFromUpsell")

		return v20
	end

	v17.setPromptState(PromptState.SubscriptionPurchaseRequested)

	if FFlagEnableSubscriptionPurchaseFlowEventIngest then
		logSubscriptionPurchaseFlowEvent("SubscriptionUpsellModalOpen")
	end

	createPaymentSession(entryContext):andThen(function(s1: string) -- line: 76
		-- upvalues: v17 (copy), performRobloxSubscriptionPurchase (copy)
		v17.setPaymentSessionId(s1)
		performRobloxSubscriptionPurchase()
	end)

	return v20
end

return startRobloxSubscriptionPurchaseFromUpsell
