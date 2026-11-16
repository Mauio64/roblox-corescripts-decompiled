local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent
local PurchasePromptDeps = require(parent.PurchasePromptDeps)
local ToastLite = require(parent.ToastLite)
local Rodux = PurchasePromptDeps.Rodux

local PromptRequestReducer = require(script.Parent.PromptRequestReducer)
local PurchaseFlowReducer = require(script.Parent.PurchaseFlowReducer)
local ProductInfoReducer = require(script.Parent.ProductInfoReducer)
local NativeUpsellSuggestionsReducer = require(script.Parent.NativeUpsellSuggestionsReducer)
local PromptStateReducer = require(script.Parent.PromptStateReducer)
local PurchaseFlowUUIDReducer = require(script.Parent.PurchaseFlowUUIDReducer)
local PurchaseErrorReducer = require(script.Parent.PurchaseErrorReducer)
local AccountInfoReducer = require(script.Parent.AccountInfoReducer)
local PurchasingStartTimeReducer = require(script.Parent.PurchasingStartTimeReducer)
local HasCompletedPurchaseReducer = require(script.Parent.HasCompletedPurchaseReducer)
local GamepadEnabledReducer = require(script.Parent.GamepadEnabledReducer)
local ABVariationReducer = require(script.Parent.ABVariationReducer)
local WindowStateReducer = require(script.Parent.WindowStateReducer)
local ButtonStateReducer = require(script.Parent.ButtonStateReducer)
local SubscriptionPurchaseInfoReducer = require(script.Parent.SubscriptionPurchaseInfoReducer)
local EconomicRestrictionErrorReducer = require(script.Parent.EconomicRestrictionErrorReducer)
local CurrentToastMessagesReducer = ToastLite.Reducers.CurrentToastMessagesReducer
local PurchaseCallbacksReducer = require(script.Parent.PurchaseCallbacksReducer)
local PostPurchaseActionsReducer = require(script.Parent.PostPurchaseActionsReducer)
local ProductPayloadReducer = require(script.Parent.ProductPayloadReducer)
local UnifiedPurchaseEligibilityReducer = require(script.Parent.UnifiedPurchaseEligibilityReducer)
local PurchaseAnalyticsMetadataReducer = require(script.Parent.PurchaseAnalyticsMetadataReducer)
local PurchaseOptionsReducer = require(script.Parent.PurchaseOptionsReducer)
local RobloxSubscriptionProductsReducer = require(script.Parent.RobloxSubscriptionProductsReducer)
local CartPricingReducer = require(script.Parent.CartPricingReducer)

local GetFFlagEnableToastLiteRender = require(PurchasePrompt.Flags.GetFFlagEnableToastLiteRender)

local SharedFlags = require(PurchasePrompt.Parent.SharedFlags)
local FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow = SharedFlags.FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow
local combineReducers = Rodux.combineReducers

if not GetFFlagEnableToastLiteRender() then
	CurrentToastMessagesReducer = nil
end

if not FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow then
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
	currentToastMessages = CurrentToastMessagesReducer,
	purchaseCallbacks = PurchaseCallbacksReducer,
	postPurchaseActions = PostPurchaseActionsReducer,
	productPayload = ProductPayloadReducer,
	isUserEligibleForUnifiedPurchaseFlow = UnifiedPurchaseEligibilityReducer,
	purchaseAnalyticsMetadata = PurchaseAnalyticsMetadataReducer,
	purchaseOptions = PurchaseOptionsReducer,
	robloxSubscriptionProducts = RobloxSubscriptionProductsReducer,
	cartPricing = CartPricingReducer
}))
