game:GetService("ContextActionService")

local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local PurchasePromptDeps = require(PurchasePromptParent.PurchasePromptDeps)
local ToastRodux = require(PurchasePromptParent.ToastRodux)
local PromptState = require(PurchasePrompt.Enums.PromptState)
local PurchaseError = require(PurchasePrompt.Enums.PurchaseError)

game:GetService("CoreGui"):WaitForChild("RobloxGui")

local RobloxTranslator = require(PurchasePromptParent.RobloxTranslator)
local Roact = PurchasePromptDeps.Roact
local ToastType = ToastRodux.Enums.ToastType
local IAPExperience = PurchasePromptDeps.IAPExperience
local SubscriptionPurchaseFlow = IAPExperience.PurchaseFlow.SubscriptionPurchaseFlow
local SubscriptionPurchaseFlowState = IAPExperience.PurchaseFlow.SubscriptionPurchaseFlowState
local PurchaseErrorType = IAPExperience.PurchaseFlow.PurchaseErrorType
local VPCModalType = require(PurchasePrompt.Enums.VPCModalType)
local GetFFlagEnableSubscriptionPurchaseToast = require(PurchasePrompt.Flags.GetFFlagEnableSubscriptionPurchaseToast)
local GetFFlagEnableVpcForInExperienceSubscriptionPurchase = require(PurchasePrompt.Flags.GetFFlagEnableVpcForInExperienceSubscriptionPurchase)
local v17 = Roact.PureComponent:extend(script.Name)

function v17.init(p1) -- line: 63
	-- upvalues: PromptState (copy)
	function p1.confirmButtonPressed() -- line: 64
		-- upvalues: p1 (copy), PromptState (copy)
		local props = p1.props
		local promptState = props.promptState

		if promptState == PromptState.PromptSubscriptionPurchase then
			props.promptSubscriptionPurchase()

			return
		end

		if promptState == PromptState.PurchaseComplete then
			props.endPurchase()

			return
		end

		if promptState == PromptState.Error then
			props.endPurchase()

			return
		end
	end
	function p1.cancelButtonPressed() -- line: 80
		-- upvalues: p1 (copy)
		p1.props.endPurchase()
	end
end
function v17.getFlowState(p2) -- line: 87
	-- upvalues: PromptState (copy), SubscriptionPurchaseFlowState (copy), GetFFlagEnableVpcForInExperienceSubscriptionPurchase (copy), PurchaseError (copy)
	local props = p2.props
	local promptState = props.promptState

	if promptState == PromptState.PromptSubscriptionPurchase then
		return SubscriptionPurchaseFlowState.PurchaseModal
	end

	if promptState == PromptState.Error then
		if GetFFlagEnableVpcForInExperienceSubscriptionPurchase() and props.purchaseError == PurchaseError.VpcRequired then
			return SubscriptionPurchaseFlowState.PurchaseVPCModal
		end

		return SubscriptionPurchaseFlowState.Error
	end

	return SubscriptionPurchaseFlowState.None
end
function v17.getErrorType(p3) -- line: 106
	-- upvalues: PurchaseError (copy), PurchaseErrorType (copy)
	local props = p3.props

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
function v17.getVPCModalType(_, p5) -- line: 134
	-- upvalues: SubscriptionPurchaseFlowState (copy), VPCModalType (copy)
	if p5 == SubscriptionPurchaseFlowState.PurchaseVPCModal then
		return VPCModalType.toRawValue(VPCModalType.EnablePurchase)
	end

	return VPCModalType.toRawValue(VPCModalType.None)
end
function v17.render(p6) -- line: 141
	-- upvalues: Roact (copy), SubscriptionPurchaseFlow (copy)
	local props = p6.props
	local v28 = p6:getFlowState()
	local v29 = p6:getErrorType()

	return Roact.createElement(SubscriptionPurchaseFlow, {
		eventPrefix = "InGame",
		screenSize = props.screenSize,
		purchaseState = v28,
		errorType = v29,
		economicRestrictionError = props.economicRestrictionError,
		purchaseVPCType = p6:getVPCModalType(v28),
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
		acceptControllerIcon = if not props.isGamepadEnabled then nil else "rbxasset://textures/ui/Controls/DesignSystem/ButtonA.png",
		isTestingMode = props.isTestingMode,
		purchaseSubscription = props.promptSubscriptionPurchase,
		cancelPurchase = props.endPurchase,
		flowComplete = props.endPurchase,
		onAnalyticEvent = props.onAnalyticEvent
	})
end
function v17.didUpdate(p7) -- line: 183
	-- upvalues: GetFFlagEnableSubscriptionPurchaseToast (copy), SubscriptionPurchaseFlowState (copy), PurchaseErrorType (copy), RobloxTranslator (copy), ToastType (copy)
	if GetFFlagEnableSubscriptionPurchaseToast() then
		local v31 = p7:getFlowState()
		local v32 = p7:getErrorType()

		if v31 == SubscriptionPurchaseFlowState.Error and v32 == PurchaseErrorType.Unknown then
			p7.props.setCurrentToastMessage({
				toastTitle = RobloxTranslator:FormatByKey("Feature.Subscription.Error.GenericSubscribeError"),
				toastType = ToastType.NetworkingError
			})
			p7.props.endPurchase()
		end
	end
end

return v17
