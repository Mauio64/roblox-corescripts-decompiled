local Players = game:GetService("Players")
local ContextActionService = game:GetService("ContextActionService")
local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local PurchasePromptDeps = require(PurchasePromptParent.PurchasePromptDeps)
local Roact = PurchasePromptDeps.Roact
local IAPExperience = PurchasePromptDeps.IAPExperience
local RobuxUpsellFlow = IAPExperience.PurchaseFlow.RobuxUpsellFlow
local RobuxUpsellFlowState = IAPExperience.PurchaseFlow.RobuxUpsellFlowState
local U13ConfirmType = IAPExperience.PurchaseFlow.U13ConfirmType
local PurchaseErrorType = IAPExperience.PurchaseFlow.PurchaseErrorType

require(PurchasePrompt.Models.RobuxUpsell)

local PromptState = require(PurchasePrompt.Enums.PromptState)
local PurchaseError = require(PurchasePrompt.Enums.PurchaseError)
local VPCModalType = require(PurchasePrompt.Enums.VPCModalType)
local AppContext = require(PurchasePrompt.Utils.AppContext)
local v16 = Roact.PureComponent:extend(script.Name)
local GetFFlagDisablePurchasePromptFunctionForMaquettes = require(PurchasePrompt.Flags.GetFFlagDisablePurchasePromptFunctionForMaquettes)
local PaymentPlatform = require(PurchasePrompt.Enums.PaymentPlatform)
local getPaymentPlatform = require(PurchasePrompt.Utils.getPaymentPlatform)
local getUnifiedPurchaseModalType = require(PurchasePrompt.Utils.getUnifiedPurchaseModalType)
local emitPerformanceMetrics = require(PurchasePrompt.Utils.emitPerformanceMetrics)
local FFlagEnableUnifiedProductPurchaseFlow = require(PurchasePromptParent.SharedFlags).FFlagEnableUnifiedProductPurchaseFlow
local ExternalSettings = require(PurchasePrompt.Services.ExternalSettings)
local UnifiedPurchaseTelemetry = require(PurchasePrompt.Events.UnifiedPurchaseTelemetry)
local logUnifiedPurchaseTelemetryCounter = require(PurchasePrompt.Utils.logUnifiedPurchaseTelemetryCounter)
local sendUnifiedPurchaseEventLog = require(PurchasePrompt.Utils.sendUnifiedPurchaseEventLog)
local deriveUnifiedPurchaseEventRobuxPrice = require(PurchasePrompt.Utils.deriveUnifiedPurchaseEventRobuxPrice)
local UnifiedPurchaseEventNameEnum = require(PurchasePrompt.Enums.UnifiedPurchaseEventNameEnum)
local Constants = require(PurchasePrompt.Misc.Constants)
local HttpService = game:GetService("HttpService")
local FFlagFixCountersForUpsellModalShown = require(PurchasePrompt.Flags.FFlagFixCountersForUpsellModalShown)
local FFlagUnifiedPurchaseGamepassAddProductUniverseId = require(PurchasePromptParent.SharedFlags).FFlagUnifiedPurchaseGamepassAddProductUniverseId
local FFlagUnifiedPurchaseFlowMarketplaceUIImprovements = require(PurchasePromptParent.SharedFlags).FFlagUnifiedPurchaseFlowMarketplaceUIImprovements
local FFlagAddPerformanceMetricsToUnifiedPurchaseModal = require(PurchasePromptParent.SharedFlags).FFlagAddPerformanceMetricsToUnifiedPurchaseModal
local FFlagEnableDiscountInfoInUnifiedPurchaseModal = require(PurchasePromptParent.SharedFlags).FFlagEnableDiscountInfoInUnifiedPurchaseModal
local FFlagPurchasePromptCartPricingEnabled = require(PurchasePrompt.Flags.FFlagPurchasePromptCartPricingEnabled)

require(PurchasePromptParent.IAPExperience)

function v16.init(p1) -- line: 121
	-- upvalues: FFlagEnableUnifiedProductPurchaseFlow (copy), logUnifiedPurchaseTelemetryCounter (copy), UnifiedPurchaseTelemetry (copy), UnifiedPurchaseEventNameEnum (copy), Players (copy), PromptState (copy), PurchaseError (copy), FFlagFixCountersForUpsellModalShown (copy), FFlagAddPerformanceMetricsToUnifiedPurchaseModal (copy), emitPerformanceMetrics (copy), Constants (copy)
	p1.state = {
		canAcceptInput = false
	}

	function p1.dispatchFetchPurchaseWarning() -- line: 126
		-- upvalues: p1 (copy), FFlagEnableUnifiedProductPurchaseFlow (copy), logUnifiedPurchaseTelemetryCounter (copy), UnifiedPurchaseTelemetry (copy), UnifiedPurchaseEventNameEnum (copy)
		local props = p1.props

		if FFlagEnableUnifiedProductPurchaseFlow and p1.props.useUnifiedProductPurchaseModal then
			local v59 = p1.props.purchaseAnalyticsMetadata or {}

			logUnifiedPurchaseTelemetryCounter(UnifiedPurchaseTelemetry.UnifiedRobuxUpsellModalBuyButtonClickedCounter, v59.surface, v59.productType)
			p1:emitUnifiedPurchaseTelemetry(UnifiedPurchaseEventNameEnum.RobuxUpsellModalBuyClicked)
		end

		return p1.props.dispatchFetchPurchaseWarning(props.robuxProviderId)
	end
	function p1.promptRobuxPurchase() -- line: 141
		-- upvalues: p1 (copy)
		local props = p1.props

		p1.props.promptRobuxPurchase(p1.props.networking, props.robuxProviderId, props.robuxProductId)
	end
	function p1.onDelayedInputComplete() -- line: 146
		-- upvalues: p1 (copy)
		p1:setState({
			canAcceptInput = true
		})
	end
	function p1.canAcceptInput() -- line: 152
		-- upvalues: p1 (copy), Players (copy)
		local state = p1.state

		if Players and (Players.LocalPlayer and Players.LocalPlayer.GameplayPaused) then
			return false
		end

		return state.canAcceptInput
	end
	function p1.confirmButtonPressed() -- line: 162
		-- upvalues: p1 (copy), PromptState (copy), PurchaseError (copy)
		local props = p1.props
		local promptState = props.promptState
		local purchaseError = props.purchaseError

		if not p1.canAcceptInput() then
			return
		end

		if promptState == PromptState.RobuxUpsell then
			props.dispatchFetchPurchaseWarning()

			return
		end

		if promptState == PromptState.LargeRobuxUpsell then
			props.openRobuxStore()

			return
		end

		if promptState == PromptState.U13PaymentModal or promptState == PromptState.U13MonthlyThreshold1Modal or promptState == PromptState.U13MonthlyThreshold2Modal or promptState == PromptState.ParentalConsentWarningPaymentModal13To17 then
			props.promptRobuxPurchase()

			return
		end

		if promptState == PromptState.PurchaseComplete then
			props.endPurchase()

			return
		end

		if promptState == PromptState.Error then
			if purchaseError == PurchaseError.TwoFactorNeeded or purchaseError == PurchaseError.TwoFactorNeededSettings then
				props.openSecuritySettings()

				return
			end

			props.endPurchase()

			return
		end
	end
	function p1.cancelButtonPressed() -- line: 202
		-- upvalues: p1 (copy)
		p1.props.endPurchase()
	end
	function p1.onBuyItemButtonMounted(_) -- line: 208
		-- upvalues: p1 (copy), FFlagFixCountersForUpsellModalShown (copy), logUnifiedPurchaseTelemetryCounter (copy), UnifiedPurchaseTelemetry (copy), UnifiedPurchaseEventNameEnum (copy), FFlagAddPerformanceMetricsToUnifiedPurchaseModal (copy), emitPerformanceMetrics (copy), Constants (copy)
		local v66 = p1.props.purchaseAnalyticsMetadata or {}

		if FFlagFixCountersForUpsellModalShown then
			logUnifiedPurchaseTelemetryCounter(UnifiedPurchaseTelemetry.UnifiedRobuxUpsellModalShownCounter, v66.surface, v66.productType)
		else
			logUnifiedPurchaseTelemetryCounter(UnifiedPurchaseTelemetry.UnifiedRobuxUpsellModalBuyButtonClickedCounter, v66.surface, v66.productType)
		end

		p1:emitUnifiedPurchaseTelemetry(UnifiedPurchaseEventNameEnum.RobuxUpsellModalShown)

		if FFlagAddPerformanceMetricsToUnifiedPurchaseModal and v66 and v66.surface then
			emitPerformanceMetrics(Constants.PerformanceMetrics.IntervalName.RobuxUpsellModalShown, v66.surface)
		end
	end
end
function v16.didMount(p3) -- line: 237
	-- upvalues: ContextActionService (copy)
	ContextActionService:BindCoreAction("ProductPurchaseConfirmButtonBind", function(_, p5, _) -- line: 238
		-- upvalues: p3 (copy)
		if p5 == Enum.UserInputState.Begin then
			p3.confirmButtonPressed()
		end
	end, false, Enum.KeyCode.ButtonA)
	ContextActionService:BindCoreAction("ProductPurchaseCancelButtonBind", function(_, p8, _) -- line: 243
		-- upvalues: p3 (copy)
		if p8 == Enum.UserInputState.Begin then
			p3.cancelButtonPressed()
		end
	end, false, Enum.KeyCode.ButtonB)
end
function v16.willUnmount(_) -- line: 250
	-- upvalues: ContextActionService (copy)
	ContextActionService:UnbindCoreAction("ProductPurchaseConfirmButtonBind")
	ContextActionService:UnbindCoreAction("ProductPurchaseCancelButtonBind")
end
function v16.getFlowState(p11) -- line: 255
	-- upvalues: PromptState (copy), RobuxUpsellFlowState (copy), PurchaseError (copy)
	local props = p11.props
	local promptState = props.promptState
	local purchaseError = props.purchaseError

	if promptState == PromptState.RobuxUpsell then
		return RobuxUpsellFlowState.PurchaseModal
	end

	if promptState == PromptState.LargeRobuxUpsell then
		return RobuxUpsellFlowState.LargeRobuxPurchaseModal
	end

	if promptState == PromptState.PurchaseInProgress then
		return RobuxUpsellFlowState.ItemPurchasePending
	end

	if promptState == PromptState.UpsellInProgress then
		return RobuxUpsellFlowState.RobuxPurchasePending
	end

	if promptState == PromptState.PollingBalance then
		return RobuxUpsellFlowState.RobuxGrantPending
	end

	if promptState == PromptState.U13PaymentModal then
		return RobuxUpsellFlowState.PurchaseWarning
	end

	if promptState == PromptState.U13MonthlyThreshold1Modal then
		return RobuxUpsellFlowState.PurchaseWarning
	end

	if promptState == PromptState.U13MonthlyThreshold2Modal then
		return RobuxUpsellFlowState.PurchaseWarning
	end

	if promptState == PromptState.PurchaseComplete then
		return RobuxUpsellFlowState.Success
	end

	if promptState == PromptState.LeaveRobloxWarning then
		return RobuxUpsellFlowState.LeaveRobloxWarning
	end

	if promptState == PromptState.EnablePurchaseVPCModal then
		return RobuxUpsellFlowState.PurchaseVPCModal
	end

	if promptState == PromptState.Error then
		if purchaseError == PurchaseError.TwoFactorNeeded or purchaseError == PurchaseError.TwoFactorNeededSettings then
			return RobuxUpsellFlowState.TwoStepRequired
		end

		return RobuxUpsellFlowState.Error
	end

	return RobuxUpsellFlowState.None
end
function v16.getU13ConfirmType(p12) -- line: 293
	-- upvalues: PromptState (copy), U13ConfirmType (copy)
	local promptState = p12.props.promptState

	if promptState == PromptState.U13PaymentModal then
		return U13ConfirmType.U13PaymentModal
	end

	if promptState == PromptState.U13MonthlyThreshold1Modal then
		return U13ConfirmType.U13MonthlyThreshold1Modal
	end

	if promptState == PromptState.U13MonthlyThreshold2Modal then
		return U13ConfirmType.U13MonthlyThreshold2Modal
	end

	if promptState == PromptState.ParentalConsentWarningPaymentModal13To17 then
		return U13ConfirmType.ParentalConsentWarningPaymentModal13To17
	end

	return U13ConfirmType.None
end
function v16.getErrorType(p13) -- line: 311
	-- upvalues: PurchaseError (copy), PurchaseErrorType (copy), FFlagEnableUnifiedProductPurchaseFlow (copy), AppContext (copy)
	local props = p13.props

	if props.purchaseError == PurchaseError.AlreadyOwn then
		return PurchaseErrorType.AlreadyOwn
	end

	if props.purchaseError == PurchaseError.NotEnoughRobux or props.purchaseError == PurchaseError.NotEnoughRobuxXbox or props.purchaseError == PurchaseError.NotEnoughRobuxNoUpsell then
		if FFlagEnableUnifiedProductPurchaseFlow and props.useUnifiedProductPurchaseModal and AppContext.get() == AppContext.Enum.IN_APP then
			return PurchaseErrorType.NotEnoughRobuxInApp
		end

		return PurchaseErrorType.NotEnoughRobux
	end

	if props.purchaseError == PurchaseError.Limited then
		return PurchaseErrorType.Limited
	end

	if props.purchaseError == PurchaseError.NotForSale then
		return PurchaseErrorType.NotForSale
	end

	if props.purchaseError == PurchaseError.NotForSaleHere then
		return PurchaseErrorType.NotForSaleExperience
	end

	if props.purchaseError == PurchaseError.PremiumOnly then
		return PurchaseErrorType.PremiumOnly
	end

	if props.purchaseError == PurchaseError.ThirdPartyDisabled then
		return PurchaseErrorType.ThirdPartyDisabled
	end

	if props.purchaseError == PurchaseError.Under13 then
		return PurchaseErrorType.Under13
	end

	if props.purchaseError == PurchaseError.InvalidFunds then
		return PurchaseErrorType.FailedGrant
	end

	if props.purchaseError == PurchaseError.InvalidFundsUnknown then
		return PurchaseErrorType.FailedGrantUnknown
	end

	if props.purchaseError == PurchaseError.EconomicRestriction then
		return PurchaseErrorType.EconomicRestriction
	end

	return PurchaseErrorType.Unknown
end
function v16.getVPCModalType(p14) -- line: 351
	-- upvalues: PromptState (copy), VPCModalType (copy)
	if p14.props.promptState == PromptState.EnablePurchaseVPCModal then
		return VPCModalType.toRawValue(VPCModalType.EnablePurchase)
	end

	return VPCModalType.toRawValue(VPCModalType.None)
end
function v16.emitUnifiedPurchaseTelemetry(p15, p16) -- line: 363
	-- upvalues: FFlagPurchasePromptCartPricingEnabled (copy), deriveUnifiedPurchaseEventRobuxPrice (copy), FFlagUnifiedPurchaseGamepassAddProductUniverseId (copy), HttpService (copy), sendUnifiedPurchaseEventLog (copy)
	local props = p15.props
	local v52 = props.purchaseAnalyticsMetadata or {}
	local v53 = if not FFlagPurchasePromptCartPricingEnabled then v52.price else deriveUnifiedPurchaseEventRobuxPrice(props.cartPricingResponse, v52.price)
	local t1 = {
		event_name = p16,
		purchase_flow_uuid = v52.purchaseFlowUUID,
		product_id = v52.productId,
		product_type = v52.productType,
		product_target_id = v52.productTargetId,
		robux_price = v53,
		surface = v52.surface,
		user_roblox_balance = v52.userRobuxBalance,
		salelocation_universeid = v52.saleLocationUniverseId,
		product_universeid = if not FFlagUnifiedPurchaseGamepassAddProductUniverseId then nil else v52.productUniverseId,
		event_metadata = HttpService:JSONEncode({
			upsell_robux_package_id = props.robuxProductId,
			upsell_robux_package_amount = props.iapRobuxAmount
		})
	}

	sendUnifiedPurchaseEventLog(t1)
end
function v16.render(p17) -- line: 393
	-- upvalues: ExternalSettings (copy), Roact (copy), RobuxUpsellFlow (copy), FFlagEnableDiscountInfoInUnifiedPurchaseModal (copy), FFlagEnableUnifiedProductPurchaseFlow (copy), getUnifiedPurchaseModalType (copy), FFlagUnifiedPurchaseFlowMarketplaceUIImprovements (copy), FFlagPurchasePromptCartPricingEnabled (copy), GetFFlagDisablePurchasePromptFunctionForMaquettes (copy), getPaymentPlatform (copy), PaymentPlatform (copy)
	local props = p17.props
	local v57 = ExternalSettings.new()

	return Roact.createElement(RobuxUpsellFlow, {
		screenSize = props.screenSize,
		shouldAnimate = true,
		isDelayedInput = true,
		onDelayedInputComplete = p17.onDelayedInputComplete,
		model = props.humanoidModel,
		itemIcon = props.itemIcon,
		itemProductId = props.itemProductId,
		itemName = props.itemName,
		itemRobuxCost = props.itemRobuxCost,
		virtualItemPrice = if not FFlagEnableDiscountInfoInUnifiedPurchaseModal then nil else props.virtualItemPrice,
		iapCostStr = props.iapCostStr,
		iapRobuxAmount = props.iapRobuxAmount,
		beforeRobuxBalance = props.beforeRobuxBalance,
		useUpsellSuggestions = props.useUpsellSuggestions,
		upsellSuggestions = props.upsellSuggestions,
		selectedUpsellIndex = props.selectedUpsellIndex,
		onUpsellSuggestionsSelected = props.onUpsellSuggestionsSelected,
		virtualItemBadgeType = props.virtualItemBadgeType,
		useUnifiedProductPurchaseModal = if not FFlagEnableUnifiedProductPurchaseFlow then nil else props.useUnifiedProductPurchaseModal,
		unifiedProductPurchaseModalType = if not FFlagEnableUnifiedProductPurchaseFlow then nil else getUnifiedPurchaseModalType(props.requestType),
		onBuyItemButtonMounted = if not FFlagEnableUnifiedProductPurchaseFlow then nil else p17.onBuyItemButtonMounted,
		hideUserRobuxBalance = if not FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then nil else props.purchaseAnalyticsMetadata and props.purchaseAnalyticsMetadata.surface == "Catalog",
		cartPricingResponse = if not FFlagPurchasePromptCartPricingEnabled then nil else props.cartPricingResponse,
		collectibleItemId = if not FFlagPurchasePromptCartPricingEnabled then nil else props.collectibleItemId,
		isCartPricingLoading = if not FFlagPurchasePromptCartPricingEnabled then nil else props.isCartPricingLoading,
		onCartOfferAppliedChanged = if not FFlagPurchasePromptCartPricingEnabled then nil else props.onCartOfferAppliedChanged,
		postPurchaseActions = if not FFlagPurchasePromptCartPricingEnabled then nil else props.postPurchaseActions,
		setPostPurchaseActions = if not FFlagPurchasePromptCartPricingEnabled then nil else props.setPostPurchaseActions,
		purchaseState = p17:getFlowState(),
		errorType = p17:getErrorType(),
		economicRestrictionError = props.economicRestrictionError,
		u13ConfirmType = p17:getU13ConfirmType(),
		purchaseVPCType = p17:getVPCModalType(),
		acceptControllerIcon = if not props.isGamepadEnabled then nil else "rbxasset://textures/ui/Controls/DesignSystem/ButtonA.png",
		cancelControllerIcon = if not props.isGamepadEnabled then nil else "rbxasset://textures/ui/Controls/DesignSystem/ButtonB.png",
		purchaseRobux = p17.dispatchFetchPurchaseWarning,
		acceptPurchaseWarning = p17.promptRobuxPurchase,
		openBuyRobux = props.openRobuxStore,
		showTermsOfUse = props.openTermsOfUse,
		openSecuritySettings = props.openSecuritySettings,
		cancelPurchase = props.endPurchase,
		flowComplete = props.endPurchase,
		onAnalyticEvent = props.onAnalyticEvent,
		eventPrefix = "InGame",
		isQuest = GetFFlagDisablePurchasePromptFunctionForMaquettes() and getPaymentPlatform(v57.getPlatform()) == PaymentPlatform.Maquettes
	})
end

return v16
