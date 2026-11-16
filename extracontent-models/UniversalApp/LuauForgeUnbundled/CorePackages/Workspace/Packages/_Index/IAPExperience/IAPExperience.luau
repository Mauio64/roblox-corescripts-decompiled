local module = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Api/PaymentsGateway/GetUpsellSuggestionsTypes")
require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Enums/CheckUserPurchaseSettingsFailureReason")
require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Enums/EconomicRestrictionsViolationType")
require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchase/v3/UnifiedProductPurchaseModalTypes")
local module2 = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Enums/UnifiedPurchaseModalTypeEnum")
local PricingTypes = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchase/PricingTypes")
require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchase/v4/cartPricingResponseLineItem")
local module4 = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchase/v4/deriveCartPricingView")

return {
	DiscountType = PricingTypes.DiscountType,
	Animator = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/Animator"),
	DiscountSummary = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/DiscountSummary"),
	UnifiedProductPurchaseModal = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchase/v3/UnifiedProductPurchaseModal"),
	UnifiedPurchaseCompletionModal = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/UnifiedPurchaseCompletionModal"),
	UnifiedPurchaseCompletionModalV2 = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/UnifiedPurchaseCompletionModalV2"),
	UnifiedProductPurchaseModalV2 = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchase/v4/UnifiedProductPurchaseModalV2"),
	aggregateCartPricingForMultiItem = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchase/v4/aggregateCartPricingForMultiItem"),
	deriveCartPricingView = module4,
	UnifiedRobuxUpsellModalV2 = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchaseRobuxUpsell/v4/UnifiedRobuxUpsellModalV2"),
	ProductPurchaseModal = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchase/v2/ProductPurchaseModal"),
	RobuxUpsellModal = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchaseRobuxUpsell/v2/RobuxUpsellModal"),
	RobuxUpsellModalMultiplePackage = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchaseRobuxUpsell/v2/RobuxUpsellModalMultiplePackage"),
	RobuxUpsellModalTooExpensiveFallback = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchaseRobuxUpsell/v2/RobuxUpsellModalTooExpensiveFallback"),
	ProductPurchase = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchase/ProductPurchasePrompt"),
	ProductPurchaseRobuxUpsell = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchaseRobuxUpsell/ProductPurchaseRobuxUpsell"),
	LeaveRobloxAlert = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/LeaveRobloxPrompt"),
	PreparePaymentCheck = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/PreparePaymentCheck"),
	Api = {
		PaymentsGateway = {
			GetUpsellSuggestions = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Api/PaymentsGateway/GetUpsellSuggestions"),
			GetUpsellSuggestionsTypes = module
		}
	},
	Flags = {
		FFlagMobilePopularItemBadgingExperimentEnabled = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Flags/FFlagMobilePopularItemBadgingExperimentEnabled"),
		FFlagEnableRobuxUpsellPlusButtonExperiment = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Flags/FFlagEnableRobuxUpsellPlusButtonExperiment"),
		GetFStringMobilePopularItemBadgingLayer = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Flags/GetFStringMobilePopularItemBadgingLayer"),
		FFlagPopularFillIconEnabled = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Flags/FFlagPopularFillIconEnabled"),
		GetFStringPopularFillIconLocation = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Flags/GetFStringPopularFillIconLocation")
	},
	GetEnableConsolePreparePaymentCheck = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Flags/getEnableConsolePreparePaymentCheck"),
	PurchaseFlow = {
		BuyRobuxFlow = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/PurchaseFlow/BuyRobux/BuyRobuxFlow"),
		BuyRobuxFlowState = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/PurchaseFlow/BuyRobux/BuyRobuxFlowState"),
		RobuxUpsellFlow = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/PurchaseFlow/RobuxUpsell/RobuxUpsellFlow"),
		RobuxUpsellFlowState = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/PurchaseFlow/RobuxUpsell/RobuxUpsellFlowState"),
		PremiumUpsellFlow = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/PurchaseFlow/PremiumUpsell/PremiumUpsellFlow"),
		PremiumUpsellFlowState = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/PurchaseFlow/PremiumUpsell/PremiumUpsellFlowState"),
		PurchaseErrorType = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Enums/PurchaseErrorType"),
		U13ConfirmType = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/U13ConfirmType"),
		SubscriptionPurchaseFlow = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/PurchaseFlow/Subscription/SubscriptionPurchaseFlow"),
		SubscriptionPurchaseFlowState = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/PurchaseFlow/Subscription/SubscriptionPurchaseFlowState")
	},
	Enums = {
		EconomicRestrictionsViolationType = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Enums/EconomicRestrictionsViolationType"),
		CheckUserPurchaseSettingsFailureReason = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Enums/CheckUserPurchaseSettingsFailureReason"),
		UnifiedPurchaseModalTypeEnum = module2
	},
	Counters = {
		EconomicRestrictionsCounter = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/Events/EconomicRestrictionsCounter"),
		ProductPurchasePromptCounter = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/Events/ProductPurchasePromptCounter")
	},
	Utility = {
		decodeLuauUnicodeEscapes = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/decodeLuauUnicodeEscapes"),
		DesktopUpsellExperiment = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/Experiments/DesktopUpsellExperiment"),
		mapCheckUserPurchaseSettingsFailureReasonToViolationType = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/EconomicRestriction/mapCheckUserPurchaseSettingsFailureReasonToViolationType"),
		isErrorReasonPrefixWithEconomicRestrictions = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/EconomicRestriction/isErrorReasonPrefixWithEconomicRestrictions"),
		parseErrorReasonToEconomicRestriction = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/EconomicRestriction/parseErrorReasonToEconomicRestriction"),
		isEconomicRestrictionResponse = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/EconomicRestriction/isEconomicRestrictionResponse"),
		addEconomicRestrictionKeysToLocalization = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/EconomicRestriction/addEconomicRestrictionKeysToLocalization"),
		formatEconomicRestrictionText = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/EconomicRestriction/formatEconomicRestrictionText"),
		parseEconomicRestrictionsFailureReason = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/EconomicRestriction/parseEconomicRestrictionsFailureReason"),
		parseEconomicRestrictionsExpirationTimeInMinutes = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/EconomicRestriction/parseEconomicRestrictionsExpirationTimeInMinutes"),
		isErrorReasonContainsEconomicRestrictions = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/EconomicRestriction/isErrorReasonContainsEconomicRestrictions")
	},
	Locale = { LocaleProvider = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Locale/LocaleProvider") }
}
