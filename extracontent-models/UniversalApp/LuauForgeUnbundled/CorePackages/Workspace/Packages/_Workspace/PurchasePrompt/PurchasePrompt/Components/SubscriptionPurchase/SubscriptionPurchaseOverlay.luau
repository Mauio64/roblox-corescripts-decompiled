local PurchasePromptDeps = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptDeps")
local ToastRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/ToastRodux")

local PromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PromptState")
local PurchaseError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseError")

local RobloxTranslator = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/RobloxTranslator")

local roact = PurchasePromptDeps.Roact
local toastType = ToastRodux.Enums.ToastType
local iapExperience = PurchasePromptDeps.IAPExperience
local subscriptionPurchaseFlow = iapExperience.PurchaseFlow.SubscriptionPurchaseFlow
local subscriptionPurchaseFlowState = iapExperience.PurchaseFlow.SubscriptionPurchaseFlowState
local purchaseErrorType = iapExperience.PurchaseFlow.PurchaseErrorType
local VPCModalType = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/VPCModalType")

local GetFFlagEnableSubscriptionPurchaseToast = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/GetFFlagEnableSubscriptionPurchaseToast")

local GetFFlagEnableVpcForInExperienceSubscriptionPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/GetFFlagEnableVpcForInExperienceSubscriptionPurchase")

local extended = roact.PureComponent:extend("SubscriptionPurchaseOverlay")

function extended:init()
	function self.confirmButtonPressed()
		local props = self.props
		local promptState = props.promptState

		if promptState == PromptState.PromptSubscriptionPurchase then
			props.promptSubscriptionPurchase()
			return
		end

		if promptState == PromptState.PurchaseComplete then
			props.endPurchase()
			return
		end

		if promptState ~= PromptState.Error then
			return
		end

		props.endPurchase()
	end

	function self.cancelButtonPressed()
		self.props.endPurchase()
	end
end

function extended:getFlowState()
	local props = self.props

	local promptState = props.promptState

	if promptState == PromptState.PromptSubscriptionPurchase then
		return subscriptionPurchaseFlowState.PurchaseModal
	end

	if promptState ~= PromptState.Error then
		return subscriptionPurchaseFlowState.None
	end

	if GetFFlagEnableVpcForInExperienceSubscriptionPurchase() and props.purchaseError == PurchaseError.VpcRequired then
		return subscriptionPurchaseFlowState.PurchaseVPCModal
	end

	return subscriptionPurchaseFlowState.Error
end

function extended:getErrorType()
	local props = self.props

	if props.purchaseError == PurchaseError.AlreadySubscribed then
		return purchaseErrorType.AlreadySubscribed
	end

	if props.purchaseError == PurchaseError.SubscriptionExceededUserSpendLimit then
		return purchaseErrorType.SubscriptionExceededUserSpendLimit
	end

	if props.purchaseError == PurchaseError.SubscriptionUnsupportedLocale then
		return purchaseErrorType.SubscriptionUnsupportedLocale
	end

	if props.purchaseError == PurchaseError.RestrictedUser then
		return purchaseErrorType.RestrictedUser
	end

	if props.purchaseError == PurchaseError.SubscriptionPurchasePlatformNotSupported then
		return purchaseErrorType.SubscriptionPurchasePlatformNotSupported
	end

	if props.purchaseError == PurchaseError.SubscriptionInvalidSaleLocation then
		return purchaseErrorType.SubscriptionInvalidSaleLocation
	end

	if props.purchaseError == PurchaseError.SubscriptionNotForSale then
		return purchaseErrorType.SubscriptionNotForSale
	end

	if props.purchaseError == PurchaseError.VpcRequired then
		return purchaseErrorType.VpcRequired
	end

	if props.purchaseError == PurchaseError.ExceedParentalSpendLimit then
		return purchaseErrorType.ExceedParentalSpendLimit
	end

	if props.purchaseError == PurchaseError.EconomicRestriction then
		return purchaseErrorType.EconomicRestriction
	end

	return purchaseErrorType.Unknown
end

function extended.getVPCModalType(p2, p3)
	if p3 == subscriptionPurchaseFlowState.PurchaseVPCModal then
		return VPCModalType.toRawValue(VPCModalType.EnablePurchase)
	end

	return VPCModalType.toRawValue(VPCModalType.None)
end

function extended:render()
	local props = self.props

	local flowState = self:getFlowState()
	local errorType = self:getErrorType()

	return roact.createElement(subscriptionPurchaseFlow, {
		screenSize = props.screenSize,
		purchaseState = flowState,
		errorType = errorType,
		economicRestrictionError = props.economicRestrictionError,
		purchaseVPCType = self:getVPCModalType(flowState),
		subscriptionId = props.subscriptionId,
		name = props.name,
		subscriptionProviderId = props.subscriptionProviderId,
		subscriptionProviderName = props.subscriptionProviderName,
		priceTier = props.priceTier,
		displayPrice = props.displayPrice,
		period = props.period,
		disclaimerText = props.disclaimerText,
		description = props.description,
		itemIcon = props.itemIcon,
		primaryPaymentMethod = props.primaryPaymentMethod,
		secondaryPaymentMethod = props.secondaryPaymentMethod,
		acceptControllerIcon = props.isGamepadEnabled and "rbxasset://textures/ui/Controls/DesignSystem/ButtonA.png" or nil,
		isTestingMode = props.isTestingMode,
		purchaseSubscription = props.promptSubscriptionPurchase,
		cancelPurchase = props.endPurchase,
		flowComplete = props.endPurchase,
		onAnalyticEvent = props.onAnalyticEvent,
		eventPrefix = "InGame"
	})
end

function extended:didUpdate()
	if GetFFlagEnableSubscriptionPurchaseToast() then
		local flowState = self:getFlowState()
		local errorType = self:getErrorType()

		if flowState == subscriptionPurchaseFlowState.Error and errorType == purchaseErrorType.Unknown then
			self.props.setCurrentToastMessage({
				toastTitle = RobloxTranslator:FormatByKey("Feature.Subscription.Error.GenericSubscribeError"),
				toastType = toastType.NetworkingError
			})

			self.props.endPurchase()
		end
	end
end

return extended
