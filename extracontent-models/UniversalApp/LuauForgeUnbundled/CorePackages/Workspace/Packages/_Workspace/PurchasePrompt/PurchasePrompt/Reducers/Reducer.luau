local PurchasePromptDeps = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptDeps")
local ToastLite = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/ToastLite")
local rodux = PurchasePromptDeps.Rodux

local PromptRequestReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Reducers/PromptRequestReducer")
local PurchaseFlowReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Reducers/PurchaseFlowReducer")
local ProductInfoReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Reducers/ProductInfoReducer")
local NativeUpsellSuggestionsReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Reducers/NativeUpsellSuggestionsReducer")
local PromptStateReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Reducers/PromptStateReducer")
local PurchaseFlowUUIDReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Reducers/PurchaseFlowUUIDReducer")
local PurchaseErrorReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Reducers/PurchaseErrorReducer")
local AccountInfoReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Reducers/AccountInfoReducer")
local PurchasingStartTimeReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Reducers/PurchasingStartTimeReducer")
local HasCompletedPurchaseReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Reducers/HasCompletedPurchaseReducer")
local GamepadEnabledReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Reducers/GamepadEnabledReducer")
local ABVariationReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Reducers/ABVariationReducer")
local WindowStateReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Reducers/WindowStateReducer")
local ButtonStateReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Reducers/ButtonStateReducer")
local SubscriptionPurchaseInfoReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Reducers/SubscriptionPurchaseInfoReducer")
local EconomicRestrictionErrorReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Reducers/EconomicRestrictionErrorReducer")
local currentToastMessagesReducer = ToastLite.Reducers.CurrentToastMessagesReducer
local PurchaseCallbacksReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Reducers/PurchaseCallbacksReducer")
local PostPurchaseActionsReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Reducers/PostPurchaseActionsReducer")
local ProductPayloadReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Reducers/ProductPayloadReducer")
local UnifiedPurchaseEligibilityReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Reducers/UnifiedPurchaseEligibilityReducer")
local PurchaseAnalyticsMetadataReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Reducers/PurchaseAnalyticsMetadataReducer")
local PurchaseOptionsReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Reducers/PurchaseOptionsReducer")
local RobloxSubscriptionProductsReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Reducers/RobloxSubscriptionProductsReducer")
local CartPricingReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Reducers/CartPricingReducer")

local GetFFlagEnableToastLiteRender = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/GetFFlagEnableToastLiteRender")

local fFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow
local combineReducers = rodux.combineReducers

if not GetFFlagEnableToastLiteRender() then
	currentToastMessagesReducer = nil
end

if not fFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow then
	PurchaseOptionsReducer = nil
end

return (combineReducers({
	promptRequest = PromptRequestReducer,
	purchaseFlow = PurchaseFlowReducer,
	productInfo = ProductInfoReducer,
	robuxUpsellSuggestions = NativeUpsellSuggestionsReducer,
	promptState = PromptStateReducer,
	purchaseFlowUUID = PurchaseFlowUUIDReducer,
	purchaseError = PurchaseErrorReducer,
	economicRestrictionError = EconomicRestrictionErrorReducer,
	accountInfo = AccountInfoReducer,
	purchasingStartTime = PurchasingStartTimeReducer,
	hasCompletedPurchase = HasCompletedPurchaseReducer,
	gamepadEnabled = GamepadEnabledReducer,
	abVariations = ABVariationReducer,
	windowState = WindowStateReducer,
	buttonState = ButtonStateReducer,
	subscriptionPurchaseInfo = SubscriptionPurchaseInfoReducer,
	currentToastMessages = currentToastMessagesReducer,
	purchaseCallbacks = PurchaseCallbacksReducer,
	postPurchaseActions = PostPurchaseActionsReducer,
	productPayload = ProductPayloadReducer,
	isUserEligibleForUnifiedPurchaseFlow = UnifiedPurchaseEligibilityReducer,
	purchaseAnalyticsMetadata = PurchaseAnalyticsMetadataReducer,
	purchaseOptions = PurchaseOptionsReducer,
	robloxSubscriptionProducts = RobloxSubscriptionProductsReducer,
	cartPricing = CartPricingReducer
}))
