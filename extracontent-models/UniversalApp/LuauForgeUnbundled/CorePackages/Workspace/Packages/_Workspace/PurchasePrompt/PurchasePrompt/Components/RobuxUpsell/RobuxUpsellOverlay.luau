local Players = game:GetService("Players")
local ContextActionService = game:GetService("ContextActionService")

local PurchasePromptDeps = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptDeps")
local roact = PurchasePromptDeps.Roact

local iapExperience = PurchasePromptDeps.IAPExperience
local robuxUpsellFlow = iapExperience.PurchaseFlow.RobuxUpsellFlow
local robuxUpsellFlowState = iapExperience.PurchaseFlow.RobuxUpsellFlowState
local u13ConfirmType = iapExperience.PurchaseFlow.U13ConfirmType
local purchaseErrorType = iapExperience.PurchaseFlow.PurchaseErrorType
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Models/RobuxUpsell")

local PromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PromptState")
local PurchaseError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseError")
local VPCModalType = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/VPCModalType")
local AppContext = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/AppContext")

local extended = roact.PureComponent:extend("RobuxUpsellOverlay")

local GetFFlagDisablePurchasePromptFunctionForMaquettes = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/GetFFlagDisablePurchasePromptFunctionForMaquettes")
local PaymentPlatform = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PaymentPlatform")
local getPaymentPlatform = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/getPaymentPlatform")
local getUnifiedPurchaseModalType = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/getUnifiedPurchaseModalType")
local emitPerformanceMetrics = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/emitPerformanceMetrics")
local ExternalSettings = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/ExternalSettings")
local UnifiedPurchaseTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Events/UnifiedPurchaseTelemetry")
local logUnifiedPurchaseTelemetryCounter = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/logUnifiedPurchaseTelemetryCounter")
local sendUnifiedPurchaseEventLog = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/sendUnifiedPurchaseEventLog")
local deriveUnifiedPurchaseEventRobuxPrice = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/deriveUnifiedPurchaseEventRobuxPrice")
local UnifiedPurchaseEventNameEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/UnifiedPurchaseEventNameEnum")
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Misc/Constants")
local HttpService = game:GetService("HttpService")
local FFlagFixCountersForUpsellModalShown = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagFixCountersForUpsellModalShown")

local fFlagUnifiedPurchaseFlowMarketplaceUIImprovements = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagUnifiedPurchaseFlowMarketplaceUIImprovements

local fFlagAddPerformanceMetricsToUnifiedPurchaseModal = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagAddPerformanceMetricsToUnifiedPurchaseModal
local FFlagSkipBuyDelayForExperienceShop = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagSkipBuyDelayForExperienceShop")

local fFlagLuaAppsEnablePromptVIPServerPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagLuaAppsEnablePromptVIPServerPurchase

require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/IAPExperience")

function extended:init()
	function self.shouldUseDelayedInput(): boolean
		if FFlagSkipBuyDelayForExperienceShop and self.props.isFromInExperienceShop then
			return false
		end

		return true
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

		if Players and Players.LocalPlayer and Players.LocalPlayer.GameplayPaused then
			return false
		end

		return state.canAcceptInput
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

	function self.onBuyItemButtonMounted(p2)
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
			fFlagAddPerformanceMetricsToUnifiedPurchaseModal
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

function extended.didMount(p2)
	ContextActionService:BindCoreAction("ProductPurchaseConfirmButtonBind", function(p3, p4, p5)
		if p4 == Enum.UserInputState.Begin then
			p2.confirmButtonPressed()
		end
	end, false, Enum.KeyCode.ButtonA)
	ContextActionService:BindCoreAction("ProductPurchaseCancelButtonBind", function(p3, p4, p5)
		if p4 == Enum.UserInputState.Begin then
			p2.cancelButtonPressed()
		end
	end, false, Enum.KeyCode.ButtonB)
end

function extended.willUnmount(p2)
	ContextActionService:UnbindCoreAction("ProductPurchaseConfirmButtonBind")
	ContextActionService:UnbindCoreAction("ProductPurchaseCancelButtonBind")
end

function extended:getFlowState()
	local props = self.props

	local promptState = props.promptState
	local purchaseError = props.purchaseError

	if promptState == PromptState.RobuxUpsell then
		return robuxUpsellFlowState.PurchaseModal
	end

	if promptState == PromptState.LargeRobuxUpsell then
		return robuxUpsellFlowState.LargeRobuxPurchaseModal
	end

	if promptState == PromptState.PurchaseInProgress then
		return robuxUpsellFlowState.ItemPurchasePending
	end

	if promptState == PromptState.UpsellInProgress then
		return robuxUpsellFlowState.RobuxPurchasePending
	end

	if promptState == PromptState.PollingBalance then
		return robuxUpsellFlowState.RobuxGrantPending
	end

	if not (promptState ~= PromptState.U13PaymentModal and promptState ~= PromptState.U13MonthlyThreshold1Modal and promptState ~= PromptState.U13MonthlyThreshold2Modal) then
		return robuxUpsellFlowState.PurchaseWarning
	end

	if promptState == PromptState.PurchaseComplete then
		return robuxUpsellFlowState.Success
	end

	if promptState == PromptState.LeaveRobloxWarning then
		return robuxUpsellFlowState.LeaveRobloxWarning
	end

	if promptState == PromptState.EnablePurchaseVPCModal then
		return robuxUpsellFlowState.PurchaseVPCModal
	end

	if promptState ~= PromptState.Error then
		return robuxUpsellFlowState.None
	end

	if purchaseError == PurchaseError.TwoFactorNeeded or purchaseError == PurchaseError.TwoFactorNeededSettings then
		return robuxUpsellFlowState.TwoStepRequired
	end

	return robuxUpsellFlowState.Error
end

function extended:getU13ConfirmType()
	local promptState = self.props.promptState

	if promptState == PromptState.U13PaymentModal then
		return u13ConfirmType.U13PaymentModal
	end

	if promptState == PromptState.U13MonthlyThreshold1Modal then
		return u13ConfirmType.U13MonthlyThreshold1Modal
	end

	if promptState == PromptState.U13MonthlyThreshold2Modal then
		return u13ConfirmType.U13MonthlyThreshold2Modal
	end

	if promptState == PromptState.ParentalConsentWarningPaymentModal13To17 then
		return u13ConfirmType.ParentalConsentWarningPaymentModal13To17
	end

	return u13ConfirmType.None
end

function extended:getErrorType()
	local props = self.props

	if props.purchaseError == PurchaseError.AlreadyOwn then
		return purchaseErrorType.AlreadyOwn
	end

	if
		props.purchaseError == PurchaseError.NotEnoughRobux
		or props.purchaseError == PurchaseError.NotEnoughRobuxXbox
		or props.purchaseError == PurchaseError.NotEnoughRobuxNoUpsell
	then
		if props.useUnifiedProductPurchaseModal and AppContext.get() == AppContext.Enum.IN_APP then
			return purchaseErrorType.NotEnoughRobuxInApp
		end

		return purchaseErrorType.NotEnoughRobux
	end

	if props.purchaseError == PurchaseError.Limited then
		return purchaseErrorType.Limited
	end

	if props.purchaseError == PurchaseError.NotForSale then
		return purchaseErrorType.NotForSale
	end

	if props.purchaseError == PurchaseError.NotForSaleHere then
		return purchaseErrorType.NotForSaleExperience
	end

	if props.purchaseError == PurchaseError.PremiumOnly then
		return purchaseErrorType.PremiumOnly
	end

	if props.purchaseError == PurchaseError.ThirdPartyDisabled then
		return purchaseErrorType.ThirdPartyDisabled
	end

	if props.purchaseError == PurchaseError.Under13 then
		return purchaseErrorType.Under13
	end

	if props.purchaseError == PurchaseError.InvalidFunds then
		return purchaseErrorType.FailedGrant
	end

	if props.purchaseError == PurchaseError.InvalidFundsUnknown then
		return purchaseErrorType.FailedGrantUnknown
	end

	if props.purchaseError == PurchaseError.EconomicRestriction then
		return purchaseErrorType.EconomicRestriction
	end

	return purchaseErrorType.Unknown
end

function extended.getVPCModalType(p2)
	if p2.props.promptState == PromptState.EnablePurchaseVPCModal then
		return VPCModalType.toRawValue(VPCModalType.EnablePurchase)
	end

	return VPCModalType.toRawValue(VPCModalType.None)
end

function extended:emitUnifiedPurchaseTelemetry(p3)
	local props = self.props

	local purchaseAnalyticsMetadata = props.purchaseAnalyticsMetadata or {}

	local v5 = deriveUnifiedPurchaseEventRobuxPrice(props.cartPricingResponse, purchaseAnalyticsMetadata.price)

	sendUnifiedPurchaseEventLog({
		event_name = p3,
		purchase_flow_uuid = purchaseAnalyticsMetadata.purchaseFlowUUID,
		product_id = purchaseAnalyticsMetadata.productId,
		product_type = purchaseAnalyticsMetadata.productType,
		product_target_id = purchaseAnalyticsMetadata.productTargetId,
		robux_price = v5,
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
	local props2 = self.props
	local v5 = ExternalSettings.new()

	local createElement = roact.createElement
	local v7 = {}
	v7.screenSize = props2.screenSize
	v7.shouldAnimate = true
	v7.isDelayedInput = self.shouldUseDelayedInput()
	v7.onDelayedInputComplete = self.onDelayedInputComplete

	v7.model = props2.humanoidModel
	v7.itemIcon = props2.itemIcon
	v7.itemProductId = props2.itemProductId
	v7.itemName = props2.itemName
	v7.itemRobuxCost = props2.itemRobuxCost
	v7.virtualItemPrice = props2.virtualItemPrice

	v7.iapCostStr = props2.iapCostStr
	v7.iapRobuxAmount = props2.iapRobuxAmount
	v7.beforeRobuxBalance = props2.beforeRobuxBalance

	v7.useUpsellSuggestions = props2.useUpsellSuggestions
	v7.upsellSuggestions = props2.upsellSuggestions
	v7.selectedUpsellIndex = props2.selectedUpsellIndex
	v7.onUpsellSuggestionsSelected = props2.onUpsellSuggestionsSelected
	v7.virtualItemBadgeType = props2.virtualItemBadgeType

	v7.useUnifiedProductPurchaseModal = props2.useUnifiedProductPurchaseModal
	v7.unifiedProductPurchaseModalType = getUnifiedPurchaseModalType(props2.requestType)
	v7.onBuyItemButtonMounted = self.onBuyItemButtonMounted

	local v8 = if fFlagUnifiedPurchaseFlowMarketplaceUIImprovements then props2.purchaseAnalyticsMetadata and props2.purchaseAnalyticsMetadata.surface == "Catalog" else nil
	v7.hideUserRobuxBalance = v8

	v7.cartPricingResponse = props2.cartPricingResponse
	v7.collectibleItemId = props2.collectibleItemId
	v7.isCartPricingLoading = props2.isCartPricingLoading
	v7.onCartOfferAppliedChanged = props2.onCartOfferAppliedChanged
	v7.postPurchaseActions = props2.postPurchaseActions
	v7.setPostPurchaseActions = props2.setPostPurchaseActions
	v7.onRobloxPlusButtonActivated = props2.onRobloxPlusButtonActivated
	v7.robloxPlusDiscountPercentage = props2.robloxPlusDiscountPercentage
	local v9 = if fFlagLuaAppsEnablePromptVIPServerPurchase then props2.isMonthlyPrice else nil
	v7.isMonthlyPrice = v9

	v7.purchaseState = self:getFlowState()
	v7.errorType = self:getErrorType()
	v7.economicRestrictionError = props2.economicRestrictionError
	v7.u13ConfirmType = self:getU13ConfirmType()
	v7.purchaseVPCType = self:getVPCModalType()

	v7.acceptControllerIcon = props2.isGamepadEnabled
		and "rbxasset://textures/ui/Controls/DesignSystem/ButtonA.png"
		or nil
	v7.cancelControllerIcon = props2.isGamepadEnabled
		and "rbxasset://textures/ui/Controls/DesignSystem/ButtonB.png"
		or nil

	v7.purchaseRobux = self.dispatchFetchPurchaseWarning
	v7.acceptPurchaseWarning = self.promptRobuxPurchase
	v7.openBuyRobux = props2.openRobuxStore
	v7.showTermsOfUse = props2.openTermsOfUse
	v7.openSecuritySettings = props2.openSecuritySettings
	v7.cancelPurchase = props2.endPurchase
	v7.flowComplete = props2.endPurchase

	v7.onAnalyticEvent = props2.onAnalyticEvent
	v7.eventPrefix = "InGame"
	v7.isQuest = GetFFlagDisablePurchasePromptFunctionForMaquettes() and getPaymentPlatform(v5.getPlatform()) == PaymentPlatform.Maquettes
	return createElement(robuxUpsellFlow, v7)
end

return extended
