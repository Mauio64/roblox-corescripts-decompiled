local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local parent = RobloxSubscriptionPurchaseApp.Parent

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
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableBuyRobuxSdui = SharedFlags.FFlagEnableBuyRobuxSdui
local getAppFeaturePolicies = UniversalAppPolicy.getAppFeaturePolicies
require(RobloxSubscriptionPurchaseApp.Enums.RobloxSubscriptionFlowCompleteReason)
local Constants = require(RobloxSubscriptionPurchaseApp.Constants)

local function createProductFromParams(data)
	return {
		EligibleOffers = data.isFreeTrial and {
			{ Duration = 0, OfferType = "FreeTrial", PeriodType = "" }
		} or {},
		LocalizedPrice = { CurrencyCode = "", Nanos = 0, Units = 0 },
		LocalizedPriceDisplayString = data.displayPrice,
		PeriodType = "",
		ProductKey = {
			Id = data.subscriptionProductId,
			Type = Constants.ROBLOX_SUBSCRIPTION_PRODUCT_TYPE
		},
		ProductTypeDetails = {
			RobloxSubscriptionProductDetails = {
				FeatureConfig = {
					IsRobuxTransferEnabled = false,
					IsTradingEnabled = false,
					IsUgcPublishingEnabled = false
				}
			}
		}
	}
end

local function startRobloxSubscriptionPurchaseFromUpsell(data)
	local v = RobloxSubscriptionStore.get()
	local entryContext = data.entryContext

	v.setRobloxSubscriptionProduct(data.productDetails or createProductFromParams(data))
	v.setOnFlowComplete(data.onFlowComplete)
	v.setPurchaseFlowOptions({
		skipWaitingForPurchaseResult = data.skipWaitingForPurchaseResult == true
	})

	if entryContext then
		v.setEntryContext(entryContext)
	end

	logRobloxSubscriptionUpsellCounter(RobloxSubscriptionUpsellTelemetry.RobloxSubscriptionUpsellModalInitiatedCounter)

	local disableBlackbirdEntrypoints = getAppFeaturePolicies().getDisableBlackbirdEntrypoints()

	local v2 = RobloxSubscriptionHeadlessOverlayController.render()

	if disableBlackbirdEntrypoints then
		transitionToError(ErrorReason.UnsupportedPlatform, "startRobloxSubscriptionPurchaseFromUpsell")
		return v2
	end

	v.setPromptState(PromptState.SubscriptionPurchaseRequested)

	if FFlagEnableSubscriptionPurchaseFlowEventIngest then
		logSubscriptionPurchaseFlowEvent("SubscriptionUpsellModalOpen")
	end

	if not FFlagEnableBuyRobuxSdui or data.paymentSessionId == nil then
		createPaymentSession(entryContext):andThen(function(p: string)
			v.setPaymentSessionId(p)
			performRobloxSubscriptionPurchase()
		end)

		return v2
	end

	v.setPaymentSessionId(data.paymentSessionId)
	performRobloxSubscriptionPurchase()
	return v2
end

return startRobloxSubscriptionPurchaseFromUpsell
