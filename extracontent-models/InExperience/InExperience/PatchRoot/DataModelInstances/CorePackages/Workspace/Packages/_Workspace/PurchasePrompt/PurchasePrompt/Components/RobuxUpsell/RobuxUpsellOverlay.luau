local Players = game:GetService("Players")
local ContextActionService = game:GetService("ContextActionService")

local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent
local PurchasePromptDeps = require(parent.PurchasePromptDeps)
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

local extended = Roact.PureComponent:extend(script.Name)

local GetFFlagDisablePurchasePromptFunctionForMaquettes = require(PurchasePrompt.Flags.GetFFlagDisablePurchasePromptFunctionForMaquettes)
local PaymentPlatform = require(PurchasePrompt.Enums.PaymentPlatform)
local getPaymentPlatform = require(PurchasePrompt.Utils.getPaymentPlatform)
local getUnifiedPurchaseModalType = require(PurchasePrompt.Utils.getUnifiedPurchaseModalType)
local emitPerformanceMetrics = require(PurchasePrompt.Utils.emitPerformanceMetrics)
local ExternalSettings = require(PurchasePrompt.Services.ExternalSettings)
local UnifiedPurchaseTelemetry = require(PurchasePrompt.Events.UnifiedPurchaseTelemetry)
local logUnifiedPurchaseTelemetryCounter = require(PurchasePrompt.Utils.logUnifiedPurchaseTelemetryCounter)
local sendUnifiedPurchaseEventLog = require(PurchasePrompt.Utils.sendUnifiedPurchaseEventLog)
local deriveUnifiedPurchaseEventRobuxPrice = require(PurchasePrompt.Utils.deriveUnifiedPurchaseEventRobuxPrice)
local UnifiedPurchaseEventNameEnum = require(PurchasePrompt.Enums.UnifiedPurchaseEventNameEnum)
local Constants = require(PurchasePrompt.Misc.Constants)
local HttpService = game:GetService("HttpService")
local FFlagFixCountersForUpsellModalShown = require(PurchasePrompt.Flags.FFlagFixCountersForUpsellModalShown)

local SharedFlags = require(parent.SharedFlags)
local FFlagUnifiedPurchaseFlowMarketplaceUIImprovements = SharedFlags.FFlagUnifiedPurchaseFlowMarketplaceUIImprovements

local SharedFlags2 = require(parent.SharedFlags)
local FFlagAddPerformanceMetricsToUnifiedPurchaseModal = SharedFlags2.FFlagAddPerformanceMetricsToUnifiedPurchaseModal
local FFlagSkipBuyDelayForExperienceShop = require(PurchasePrompt.Flags.FFlagSkipBuyDelayForExperienceShop)

local SharedFlags3 = require(parent.SharedFlags)
local FFlagLuaAppsEnablePromptVIPServerPurchase = SharedFlags3.FFlagLuaAppsEnablePromptVIPServerPurchase

require(parent.IAPExperience)

function extended:init()
	function self.shouldUseDelayedInput(): boolean
		return not (FFlagSkipBuyDelayForExperienceShop and self.props.isFromInExperienceShop)
	end

	self.state = {
		canAcceptInput = not self.shouldUseDelayedInput()
	}

	function self.dispatchFetchPurchaseWarning()
		local props = self.props

		if self.props.useUnifiedProductPurchaseModal then
			local purchaseAnalyticsMetadata = self.props.purchaseAnalyticsMetadata or {}
			logUnifiedPurchaseTelemetryCounter(
				UnifiedPurchaseTelemetry.UnifiedRobuxUpsellModalBuyButtonClickedCounter,
				purchaseAnalyticsMetadata.surface,
				purchaseAnalyticsMetadata.productType
			)

			self:emitUnifiedPurchaseTelemetry(UnifiedPurchaseEventNameEnum.RobuxUpsellModalBuyClicked)
		end

		return self.props.dispatchFetchPurchaseWarning(props.robuxProviderId)
	end

	function self.promptRobuxPurchase()
		local props = self.props
		self.props.promptRobuxPurchase(self.props.networking, props.robuxProviderId, props.robuxProductId)
	end

	function self.onDelayedInputComplete()
		self:setState({ canAcceptInput = true })
	end

	function self.canAcceptInput()
		local state = self.state

		return not (Players and Players.LocalPlayer and Players.LocalPlayer.GameplayPaused) and state.canAcceptInput
	end

	function self.confirmButtonPressed()
		local props = self.props
		local promptState = props.promptState
		local purchaseError = props.purchaseError

		if not self.canAcceptInput() then
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

		if
			promptState == PromptState.U13PaymentModal
			or promptState == PromptState.U13MonthlyThreshold1Modal
			or promptState == PromptState.U13MonthlyThreshold2Modal
			or promptState == PromptState.ParentalConsentWarningPaymentModal13To17
		then
			props.promptRobuxPurchase()
			return
		end

		if promptState == PromptState.PurchaseComplete then
			props.endPurchase()
			return
		end

		if promptState ~= PromptState.Error then
			return
		end

		if purchaseError == PurchaseError.TwoFactorNeeded or purchaseError == PurchaseError.TwoFactorNeededSettings then
			props.openSecuritySettings()
		else
			props.endPurchase()
		end
	end

	function self.cancelButtonPressed()
		self.props.endPurchase()
	end

	function self.onBuyItemButtonMounted(_)
		local purchaseAnalyticsMetadata = self.props.purchaseAnalyticsMetadata or {}

		if FFlagFixCountersForUpsellModalShown then
			logUnifiedPurchaseTelemetryCounter(
				UnifiedPurchaseTelemetry.UnifiedRobuxUpsellModalShownCounter,
				purchaseAnalyticsMetadata.surface,
				purchaseAnalyticsMetadata.productType
			)
		else
			logUnifiedPurchaseTelemetryCounter(
				UnifiedPurchaseTelemetry.UnifiedRobuxUpsellModalBuyButtonClickedCounter,
				purchaseAnalyticsMetadata.surface,
				purchaseAnalyticsMetadata.productType
			)
		end

		self:emitUnifiedPurchaseTelemetry(UnifiedPurchaseEventNameEnum.RobuxUpsellModalShown)

		if
			FFlagAddPerformanceMetricsToUnifiedPurchaseModal
			and purchaseAnalyticsMetadata
			and purchaseAnalyticsMetadata.surface
		then
			emitPerformanceMetrics(
				Constants.PerformanceMetrics.IntervalName.RobuxUpsellModalShown,
				purchaseAnalyticsMetadata.surface
			)
		end
	end
end

function extended.didMount(p)
	ContextActionService:BindCoreAction("ProductPurchaseConfirmButtonBind", function(_, p2, _)
		if p2 == Enum.UserInputState.Begin then
			p.confirmButtonPressed()
		end
	end, false, Enum.KeyCode.ButtonA)
	ContextActionService:BindCoreAction("ProductPurchaseCancelButtonBind", function(_, p2, _)
		if p2 == Enum.UserInputState.Begin then
			p.cancelButtonPressed()
		end
	end, false, Enum.KeyCode.ButtonB)
end

function extended.willUnmount(_)
	ContextActionService:UnbindCoreAction("ProductPurchaseConfirmButtonBind")
	ContextActionService:UnbindCoreAction("ProductPurchaseCancelButtonBind")
end

function extended:getFlowState()
	local props = self.props

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

	if not (promptState ~= PromptState.U13PaymentModal and promptState ~= PromptState.U13MonthlyThreshold1Modal and promptState ~= PromptState.U13MonthlyThreshold2Modal) then
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

	if promptState ~= PromptState.Error then
		return RobuxUpsellFlowState.None
	end

	if purchaseError == PurchaseError.TwoFactorNeeded or purchaseError == PurchaseError.TwoFactorNeededSettings then
		return RobuxUpsellFlowState.TwoStepRequired
	end

	return RobuxUpsellFlowState.Error
end

function extended:getU13ConfirmType()
	local promptState = self.props.promptState

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

function extended:getErrorType()
	local props = self.props

	if props.purchaseError == PurchaseError.AlreadyOwn then
		return PurchaseErrorType.AlreadyOwn
	end

	if
		props.purchaseError == PurchaseError.NotEnoughRobux
		or props.purchaseError == PurchaseError.NotEnoughRobuxXbox
		or props.purchaseError == PurchaseError.NotEnoughRobuxNoUpsell
	then
		if props.useUnifiedProductPurchaseModal and AppContext.get() == AppContext.Enum.IN_APP then
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

function extended:getVPCModalType()
	if self.props.promptState == PromptState.EnablePurchaseVPCModal then
		return VPCModalType.toRawValue(VPCModalType.EnablePurchase)
	end

	return VPCModalType.toRawValue(VPCModalType.None)
end

function extended:emitUnifiedPurchaseTelemetry(event_name)
	local props = self.props

	local purchaseAnalyticsMetadata = props.purchaseAnalyticsMetadata or {}

	local robux_price = deriveUnifiedPurchaseEventRobuxPrice(props.cartPricingResponse, purchaseAnalyticsMetadata.price)

	sendUnifiedPurchaseEventLog({
		event_name = event_name,
		purchase_flow_uuid = purchaseAnalyticsMetadata.purchaseFlowUUID,
		product_id = purchaseAnalyticsMetadata.productId,
		product_type = purchaseAnalyticsMetadata.productType,
		product_target_id = purchaseAnalyticsMetadata.productTargetId,
		robux_price = robux_price,
		surface = purchaseAnalyticsMetadata.surface,
		user_roblox_balance = purchaseAnalyticsMetadata.userRobuxBalance,
		salelocation_universeid = purchaseAnalyticsMetadata.saleLocationUniverseId,
		product_universeid = purchaseAnalyticsMetadata.productUniverseId,
		event_metadata = HttpService:JSONEncode({
			upsell_robux_package_id = props.robuxProductId,
			upsell_robux_package_amount = props.iapRobuxAmount
		})
	})
end

function extended:render()
	local props = self.props
	local v = ExternalSettings.new()

	local createElement = Roact.createElement
	local v2 = {}
	v2.screenSize = props.screenSize
	v2.shouldAnimate = true
	v2.isDelayedInput = self.shouldUseDelayedInput()
	v2.onDelayedInputComplete = self.onDelayedInputComplete

	v2.model = props.humanoidModel
	v2.itemIcon = props.itemIcon
	v2.itemProductId = props.itemProductId
	v2.itemName = props.itemName
	v2.itemRobuxCost = props.itemRobuxCost
	v2.virtualItemPrice = props.virtualItemPrice

	v2.iapCostStr = props.iapCostStr
	v2.iapRobuxAmount = props.iapRobuxAmount
	v2.beforeRobuxBalance = props.beforeRobuxBalance

	v2.useUpsellSuggestions = props.useUpsellSuggestions
	v2.upsellSuggestions = props.upsellSuggestions
	v2.selectedUpsellIndex = props.selectedUpsellIndex
	v2.onUpsellSuggestionsSelected = props.onUpsellSuggestionsSelected
	v2.virtualItemBadgeType = props.virtualItemBadgeType

	v2.useUnifiedProductPurchaseModal = props.useUnifiedProductPurchaseModal
	v2.unifiedProductPurchaseModalType = getUnifiedPurchaseModalType(props.requestType)
	v2.onBuyItemButtonMounted = self.onBuyItemButtonMounted
	local hideUserRobuxBalance

	if FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then
		hideUserRobuxBalance = props.purchaseAnalyticsMetadata and props.purchaseAnalyticsMetadata.surface == "Catalog"
	end

	v2.hideUserRobuxBalance = hideUserRobuxBalance

	v2.cartPricingResponse = props.cartPricingResponse
	v2.collectibleItemId = props.collectibleItemId
	v2.isCartPricingLoading = props.isCartPricingLoading
	v2.onCartOfferAppliedChanged = props.onCartOfferAppliedChanged
	v2.postPurchaseActions = props.postPurchaseActions
	v2.setPostPurchaseActions = props.setPostPurchaseActions
	v2.onRobloxPlusButtonActivated = props.onRobloxPlusButtonActivated
	v2.robloxPlusDiscountPercentage = props.robloxPlusDiscountPercentage
	local isMonthlyPrice

	if FFlagLuaAppsEnablePromptVIPServerPurchase then
		isMonthlyPrice = props.isMonthlyPrice
	end

	v2.isMonthlyPrice = isMonthlyPrice

	v2.purchaseState = self:getFlowState()
	v2.errorType = self:getErrorType()
	v2.economicRestrictionError = props.economicRestrictionError
	v2.u13ConfirmType = self:getU13ConfirmType()
	v2.purchaseVPCType = self:getVPCModalType()

	v2.acceptControllerIcon = props.isGamepadEnabled and "rbxasset://textures/ui/Controls/DesignSystem/ButtonA.png"
		or nil
	v2.cancelControllerIcon = props.isGamepadEnabled and "rbxasset://textures/ui/Controls/DesignSystem/ButtonB.png"
		or nil

	v2.purchaseRobux = self.dispatchFetchPurchaseWarning
	v2.acceptPurchaseWarning = self.promptRobuxPurchase
	v2.openBuyRobux = props.openRobuxStore
	v2.showTermsOfUse = props.openTermsOfUse
	v2.openSecuritySettings = props.openSecuritySettings
	v2.cancelPurchase = props.endPurchase
	v2.flowComplete = props.endPurchase

	v2.onAnalyticEvent = props.onAnalyticEvent
	v2.eventPrefix = "InGame"
	v2.isQuest = GetFFlagDisablePurchasePromptFunctionForMaquettes()
		and getPaymentPlatform(v.getPlatform()) == PaymentPlatform.Maquettes
	return createElement(RobuxUpsellFlow, v2)
end

return extended
