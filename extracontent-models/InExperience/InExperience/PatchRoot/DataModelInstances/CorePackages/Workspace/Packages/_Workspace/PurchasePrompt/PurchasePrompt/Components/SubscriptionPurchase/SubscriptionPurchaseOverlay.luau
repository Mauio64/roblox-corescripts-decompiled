game:GetService("ContextActionService")

local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent
local PurchasePromptDeps = require(parent.PurchasePromptDeps)
local ToastRodux = require(parent.ToastRodux)

local PromptState = require(PurchasePrompt.Enums.PromptState)
local PurchaseError = require(PurchasePrompt.Enums.PurchaseError)

local CoreGui = game:GetService("CoreGui")
CoreGui:WaitForChild("RobloxGui")
local RobloxTranslator = require(parent.RobloxTranslator)

local Roact = PurchasePromptDeps.Roact
local ToastType = ToastRodux.Enums.ToastType
local IAPExperience = PurchasePromptDeps.IAPExperience
local SubscriptionPurchaseFlow = IAPExperience.PurchaseFlow.SubscriptionPurchaseFlow
local SubscriptionPurchaseFlowState = IAPExperience.PurchaseFlow.SubscriptionPurchaseFlowState
local PurchaseErrorType = IAPExperience.PurchaseFlow.PurchaseErrorType
local VPCModalType = require(PurchasePrompt.Enums.VPCModalType)

local GetFFlagEnableSubscriptionPurchaseToast = require(PurchasePrompt.Flags.GetFFlagEnableSubscriptionPurchaseToast)

local GetFFlagEnableVpcForInExperienceSubscriptionPurchase = require(PurchasePrompt.Flags.GetFFlagEnableVpcForInExperienceSubscriptionPurchase)

local extended = Roact.PureComponent:extend(script.Name)

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
		return SubscriptionPurchaseFlowState.PurchaseModal
	end

	if promptState ~= PromptState.Error then
		return SubscriptionPurchaseFlowState.None
	end

	if GetFFlagEnableVpcForInExperienceSubscriptionPurchase() and props.purchaseError == PurchaseError.VpcRequired then
		return SubscriptionPurchaseFlowState.PurchaseVPCModal
	end

	return SubscriptionPurchaseFlowState.Error
end

function extended:getErrorType()
	local props = self.props

	if props.purchaseError == PurchaseError.AlreadySubscribed then
		return PurchaseErrorType.AlreadySubscribed
	end

	if props.purchaseError == PurchaseError.SubscriptionExceededUserSpendLimit then
		return PurchaseErrorType.SubscriptionExceededUserSpendLimit
	end

	if props.purchaseError == PurchaseError.SubscriptionUnsupportedLocale then
		return PurchaseErrorType.SubscriptionUnsupportedLocale
	end

	if props.purchaseError == PurchaseError.RestrictedUser then
		return PurchaseErrorType.RestrictedUser
	end

	if props.purchaseError == PurchaseError.SubscriptionPurchasePlatformNotSupported then
		return PurchaseErrorType.SubscriptionPurchasePlatformNotSupported
	end

	if props.purchaseError == PurchaseError.SubscriptionInvalidSaleLocation then
		return PurchaseErrorType.SubscriptionInvalidSaleLocation
	end

	if props.purchaseError == PurchaseError.SubscriptionNotForSale then
		return PurchaseErrorType.SubscriptionNotForSale
	end

	if props.purchaseError == PurchaseError.VpcRequired then
		return PurchaseErrorType.VpcRequired
	end

	if props.purchaseError == PurchaseError.ExceedParentalSpendLimit then
		return PurchaseErrorType.ExceedParentalSpendLimit
	end

	if props.purchaseError == PurchaseError.EconomicRestriction then
		return PurchaseErrorType.EconomicRestriction
	end

	return PurchaseErrorType.Unknown
end

function extended:getVPCModalType(p)
	if p == SubscriptionPurchaseFlowState.PurchaseVPCModal then
		return VPCModalType.toRawValue(VPCModalType.EnablePurchase)
	end

	return VPCModalType.toRawValue(VPCModalType.None)
end

function extended:render()
	local props = self.props

	local flowState = self:getFlowState()
	local errorType = self:getErrorType()

	return Roact.createElement(SubscriptionPurchaseFlow, {
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

		if flowState == SubscriptionPurchaseFlowState.Error and errorType == PurchaseErrorType.Unknown then
			self.props.setCurrentToastMessage({
				toastTitle = RobloxTranslator:FormatByKey("Feature.Subscription.Error.GenericSubscribeError"),
				toastType = ToastType.NetworkingError
			})

			self.props.endPurchase()
		end
	end
end

return extended
