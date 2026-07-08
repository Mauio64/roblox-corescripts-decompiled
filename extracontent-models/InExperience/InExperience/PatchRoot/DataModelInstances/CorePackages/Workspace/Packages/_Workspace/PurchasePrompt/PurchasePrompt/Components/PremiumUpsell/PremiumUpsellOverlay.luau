local ContextActionService = game:GetService("ContextActionService")
local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local PurchasePromptDeps = require(PurchasePromptParent.PurchasePromptDeps)
local Roact = PurchasePromptDeps.Roact
local IAPExperience = PurchasePromptDeps.IAPExperience
local PremiumUpsellFlow = IAPExperience.PurchaseFlow.PremiumUpsellFlow
local PremiumUpsellFlowState = IAPExperience.PurchaseFlow.PremiumUpsellFlowState
local PurchaseErrorType = IAPExperience.PurchaseFlow.PurchaseErrorType
local PromptState = require(PurchasePrompt.Enums.PromptState)
local PurchaseError = require(PurchasePrompt.Enums.PurchaseError)
local VPCModalType = require(PurchasePrompt.Enums.VPCModalType)
local v13 = Roact.PureComponent:extend(script.Name)
local GetFFlagEnableVpcForInExperiencePremiumUpsell = require(PurchasePrompt.Flags.GetFFlagEnableVpcForInExperiencePremiumUpsell)

game:GetService("CoreGui"):WaitForChild("RobloxGui")

function v13.init(p1) -- line: 51
	-- upvalues: PromptState (copy), GetFFlagEnableVpcForInExperiencePremiumUpsell (copy)
	function p1.confirmButtonPressed() -- line: 52
		-- upvalues: p1 (copy), PromptState (copy), GetFFlagEnableVpcForInExperiencePremiumUpsell (copy)
		local props = p1.props
		local promptState = props.promptState

		if promptState == PromptState.PremiumUpsell then
			if GetFFlagEnableVpcForInExperiencePremiumUpsell() then
				props.dispatchPremiumPrecheck()

				return
			end

			props.promptPremiumPurchase()

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
	function p1.cancelButtonPressed() -- line: 72
		-- upvalues: p1 (copy)
		p1.props.endPurchase()
	end
end
function v13.didMount(p2) -- line: 79
	-- upvalues: ContextActionService (copy)
	ContextActionService:BindCoreAction("PremiumPurchaseConfirmButtonBind", function(_, p4, _) -- line: 80
		-- upvalues: p2 (copy)
		if p4 == Enum.UserInputState.Begin then
			p2.confirmButtonPressed()
		end
	end, false, Enum.KeyCode.ButtonA)
	ContextActionService:BindCoreAction("PremiumPurchaseCancelButtonBind", function(_, p7, _) -- line: 85
		-- upvalues: p2 (copy)
		if p7 == Enum.UserInputState.Begin then
			p2.cancelButtonPressed()
		end
	end, false, Enum.KeyCode.ButtonB)
end
function v13.willUnmount(_) -- line: 92
	-- upvalues: ContextActionService (copy)
	ContextActionService:UnbindCoreAction("PremiumPurchaseConfirmButtonBind")
	ContextActionService:UnbindCoreAction("PremiumPurchaseCancelButtonBind")
end
function v13.getFlowState(p10) -- line: 97
	-- upvalues: PromptState (copy), PremiumUpsellFlowState (copy)
	local promptState = p10.props.promptState

	if promptState == PromptState.PremiumUpsell then
		return PremiumUpsellFlowState.PurchaseModal
	end

	if promptState == PromptState.Error then
		return PremiumUpsellFlowState.Error
	end

	if promptState == PromptState.EnablePurchaseVPCModal then
		return PremiumUpsellFlowState.PurchaseVPCModal
	end

	return PremiumUpsellFlowState.None
end
function v13.getErrorType(p11) -- line: 113
	-- upvalues: PurchaseError (copy), PurchaseErrorType (copy)
	local props = p11.props

	if props.purchaseError == PurchaseError.AlreadyPremium then
		return PurchaseErrorType.AlreadyPremium
	end

	if props.purchaseError == PurchaseError.PremiumUnavailablePlatform then
		return PurchaseErrorType.PremiumPlatformUnavailable
	end

	if props.purchaseError == PurchaseError.EconomicRestriction then
		return PurchaseErrorType.EconomicRestriction
	end

	return PurchaseErrorType.Unknown
end
function v13.getVPCModalType(p12) -- line: 127
	-- upvalues: PromptState (copy), VPCModalType (copy)
	if p12.props.promptState == PromptState.EnablePurchaseVPCModal then
		return VPCModalType.toRawValue(VPCModalType.EnablePurchase)
	end

	return VPCModalType.toRawValue(VPCModalType.None)
end
function v13.render(p13) -- line: 137
	-- upvalues: Roact (copy), PremiumUpsellFlow (copy), GetFFlagEnableVpcForInExperiencePremiumUpsell (copy)
	local props = p13.props

	return Roact.createElement(PremiumUpsellFlow, {
		isCatalog = false,
		eventPrefix = "InGame",
		screenSize = props.screenSize,
		currencySymbol = props.currencySymbol,
		robuxPrice = props.robuxPrice,
		robuxAmount = props.robuxAmount,
		purchaseState = p13:getFlowState(),
		errorType = p13:getErrorType(),
		economicRestrictionError = props.economicRestrictionError,
		purchaseVPCType = p13:getVPCModalType(),
		acceptControllerIcon = if not props.isGamepadEnabled then nil else "rbxasset://textures/ui/Controls/DesignSystem/ButtonA.png",
		purchasePremium = if not GetFFlagEnableVpcForInExperiencePremiumUpsell() then props.promptPremiumPurchase else props.dispatchPremiumPrecheck,
		cancelPurchase = props.endPurchase,
		flowComplete = props.endPurchase,
		onAnalyticEvent = props.onAnalyticEvent
	})
end

return v13
