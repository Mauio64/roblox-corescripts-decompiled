local RobloxSubscriptionStore = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Store/RobloxSubscriptionStore")
require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Models/GetRobloxSubscriptionProductsModel")
local PromptState = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/PromptState")
require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/types")
local createPaymentSession = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Network/createPaymentSession")
local performRobloxSubscriptionPurchase = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Actions/performRobloxSubscriptionPurchase")
local RobloxSubscriptionHeadlessOverlayController = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Flows/RobloxSubscriptionHeadlessOverlayController")
local transitionToError = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Actions/transitionToError")
local ErrorReason = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/ErrorReason")
local logRobloxSubscriptionUpsellCounter = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Utils/logRobloxSubscriptionUpsellCounter")
local RobloxSubscriptionUpsellTelemetry = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Events/RobloxSubscriptionUpsellTelemetry")
local logSubscriptionPurchaseFlowEvent = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Utils/logSubscriptionPurchaseFlowEvent")

local FFlagEnableSubscriptionPurchaseFlowEventIngest = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Flags/FFlagEnableSubscriptionPurchaseFlowEventIngest")
local UniversalAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/UniversalAppPolicy")
local fFlagEnableBuyRobuxSdui = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/SharedFlags").FFlagEnableBuyRobuxSdui
local getAppFeaturePolicies = UniversalAppPolicy.getAppFeaturePolicies
require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/RobloxSubscriptionFlowCompleteReason")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Constants")

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
	local v5 = RobloxSubscriptionStore.get()
	local entryContext = data.entryContext

	v5.setRobloxSubscriptionProduct(data.productDetails or createProductFromParams(data))
	v5.setOnFlowComplete(data.onFlowComplete)
	v5.setPurchaseFlowOptions({
		skipWaitingForPurchaseResult = data.skipWaitingForPurchaseResult == true
	})

	if entryContext then
		v5.setEntryContext(entryContext)
	end

	logRobloxSubscriptionUpsellCounter(RobloxSubscriptionUpsellTelemetry.RobloxSubscriptionUpsellModalInitiatedCounter)

	local disableBlackbirdEntrypoints = getAppFeaturePolicies().getDisableBlackbirdEntrypoints()

	local v6 = RobloxSubscriptionHeadlessOverlayController.render()

	if disableBlackbirdEntrypoints then
		transitionToError(ErrorReason.UnsupportedPlatform, "startRobloxSubscriptionPurchaseFromUpsell")
		return v6
	end

	v5.setPromptState(PromptState.SubscriptionPurchaseRequested)

	if FFlagEnableSubscriptionPurchaseFlowEventIngest then
		logSubscriptionPurchaseFlowEvent("SubscriptionUpsellModalOpen")
	end

	if not fFlagEnableBuyRobuxSdui or data.paymentSessionId == nil then
		createPaymentSession(entryContext):andThen(function(p2)
			v5.setPaymentSessionId(p2)
			performRobloxSubscriptionPurchase()
		end)

		return v6
	end

	v5.setPaymentSessionId(data.paymentSessionId)
	performRobloxSubscriptionPurchase()
	return v6
end

return startRobloxSubscriptionPurchaseFromUpsell
