local HttpService = game:GetService("HttpService")
local ContextActionService = game:GetService("ContextActionService")

local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Roact")

local RobuxUpsellFlowState = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/PurchaseFlow/RobuxUpsell/RobuxUpsellFlowState")

require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Enums/VirtualItemBadgeType")

local Animator = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/Animator")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/Constants")
local LoadingOverlay = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/LoadingOverlay")
local LoadingOverlayState = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/LoadingOverlayState")
local PurchaseErrorPrompt = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/PurchaseErrorPrompt")
local PurchaseErrorType = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Enums/PurchaseErrorType")
local U13ConfirmPrompt = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/U13ConfirmPrompt")
local TwoStepReqPrompt = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/TwoStepReqPrompt")
local InsufficientRobuxPrompt = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/InsufficientRobuxPrompt")

local InsufficientRobuxProductPrompt = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchaseRobuxUpsell/InsufficientRobuxProductPrompt")
local LeaveRobloxPrompt = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/LeaveRobloxPrompt")
local RobuxUpsellSuccessPrompt = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchaseRobuxUpsell/RobuxUpsellSuccessPrompt")
local RobuxUpsellPrompt = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchaseRobuxUpsell/RobuxUpsellPrompt")
local RobuxUpsellModal = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchaseRobuxUpsell/v2/RobuxUpsellModal")

local RobuxUpsellModalMultiplePackage = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchaseRobuxUpsell/v2/RobuxUpsellModalMultiplePackage")

local RobuxUpsellModalTooExpensive = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchaseRobuxUpsell/v2/RobuxUpsellModalTooExpensive")

local RobuxUpsellModalTooExpensiveFallback = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchaseRobuxUpsell/v2/RobuxUpsellModalTooExpensiveFallback")
local UnifiedRobuxUpsellModal = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchaseRobuxUpsell/v3/UnifiedRobuxUpsellModal")

local UnifiedRobuxUpsellModalTooExpensive = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchaseRobuxUpsell/v3/UnifiedRobuxUpsellModalTooExpensive")
local PurchasePromptLite = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/PurchasePromptLite")
local getTTIEventName = PurchasePromptLite.getTTIEventName
local timeToInteractiveTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/TimeToInteractiveTracker").TimeToInteractiveTracker
local productPurchaseSurface = PurchasePromptLite.Enums.ProductPurchaseSurface
local getModalShownEventData = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/getModalShownEventData")
local getUserInputEventData = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/getUserInputEventData")

local shouldShowNewUpsellModalExperiment = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/Experiments/shouldShowNewUpsellModalExperiment")
local overlayInGameMenu = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/overlayInGameMenu")

local DesktopUpsellExperiment = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/Experiments/DesktopUpsellExperiment")

local getEnableCentralOverlayForUpsellPrompt = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Flags/getEnableCentralOverlayForUpsellPrompt")
local getAppContext = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/getAppContext")

local FFlagMobilePopularItemBadgingExperimentEnabled = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Flags/FFlagMobilePopularItemBadgingExperimentEnabled")
local UnifiedPurchaseCompletionModalV2 = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/UnifiedPurchaseCompletionModalV2")

local extended = Roact.Component:extend("RobuxUpsellFlow")

local default = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/LoggingProtocol").default
local InGameRobuxUpsellEvent = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/PurchaseFlow/RobuxUpsell/Events/InGameRobuxUpsellEvent")
local Players = game:GetService("Players")
local intervalPerformanceTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/IntervalPerformanceTracker").IntervalPerformanceTracker

local verifiedParentalConsentDialog = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/VerifiedParentalConsentDialog").VerifiedParentalConsentDialog
local UnifiedRobuxUpsellModalV2 = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchaseRobuxUpsell/v4/UnifiedRobuxUpsellModalV2")

local UnifiedRobuxUpsellModalTooExpensiveV2 = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchaseRobuxUpsell/v4/UnifiedRobuxUpsellModalTooExpensiveV2")
require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchase/v4/cartPricingResponseLineItem")

local UnifiedPurchaseModalTypeEnum = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Enums/UnifiedPurchaseModalTypeEnum")
local UnifiedPurchaseCompletionModal = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/UnifiedPurchaseCompletionModal")

local fFlagUnifiedPurchaseFlowMarketplaceUIImprovements = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/SharedFlags").FFlagUnifiedPurchaseFlowMarketplaceUIImprovements

local fFlagLuaAppsEnablePromptVIPServerPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/SharedFlags").FFlagLuaAppsEnablePromptVIPServerPurchase

local fFlagAddPerformanceMetricsToUnifiedPurchaseModal = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/SharedFlags").FFlagAddPerformanceMetricsToUnifiedPurchaseModal
local fIntLegacyPurchaseFPSTrackingTimeout = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/SharedFlags").FIntLegacyPurchaseFPSTrackingTimeout
local fIntTTIUnifiedPurchaseSamplingRate = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/SharedFlags").FIntTTIUnifiedPurchaseSamplingRate

local fFlagAddCenterDialogForUnifiedPurchaseModal = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/SharedFlags").FFlagAddCenterDialogForUnifiedPurchaseModal

game:DefineFastFlag("DisableNonSchematizedInGameRobuxUpsellEvent", false)

local defineFastFlag = game:DefineFastFlag("FixUnifiedUpsellCompletionModal", false)
require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchase/PricingTypes")
require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchase/v3/UnifiedProductPurchaseModalTypes")

require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Api/PaymentsGateway/GetUpsellSuggestionsTypes")

function extended:init()
	local props = self.props

	local v6 = if props.analyticId then props.analyticId else HttpService:GenerateGUID(false)
	self.state = {
		analyticId = v6,
		isDelayedInput = props.isDelayedInput,
		enableInputDelayed = false
	}

	function self.closeModal()
		local props2 = self.props
		self:reportUserInput("Cancel")
		props2.cancelPurchase()

		self:closeCentralOverlay()
		self:UnbindActions()
	end
end

function extended.didMount(p2)
	if fFlagAddPerformanceMetricsToUnifiedPurchaseModal and (p2.props or {}).eventPrefix == "UACatalog" then
		intervalPerformanceTracker:startTracking(
			"PurchaseModal_RobuxUpsellModalShown_Catalog",
			fIntLegacyPurchaseFPSTrackingTimeout,
			nil,
			true,
			true
		)

		intervalPerformanceTracker:startTracking(
			"PurchaseModal_LegacyFlowRobuxUpsellModalShown_Catalog",
			fIntLegacyPurchaseFPSTrackingTimeout,
			nil,
			true,
			true
		)

		local ttiEventName = getTTIEventName(productPurchaseSurface.Catalog)
		timeToInteractiveTracker.trackEnd(ttiEventName, {
			samplingRateOverride = fIntTTIUnifiedPurchaseSamplingRate
		})
	end
end

function extended:didUpdate(p2, p3)
	local props = self.props

	if p2.purchaseState ~= props.purchaseState then
		self:reportModalShown()
		self:dispatchCentralOverlayAndRenderModal(props)
	end
end

function extended:UnbindActions()
	if getEnableCentralOverlayForUpsellPrompt() and self.props.dispatchCentralOverlay then
		ContextActionService:UnbindAction(Constants.CLOSE_MODAL_ACTION)
	end
end

function extended:BindCancelAction()
	if getEnableCentralOverlayForUpsellPrompt() and self.props.dispatchCentralOverlay then
		ContextActionService:BindAction(
			Constants.CLOSE_MODAL_ACTION,
			self.closeModal,
			false,
			Enum.KeyCode.ButtonB,
			Enum.KeyCode.Escape
		)
	end
end

function extended.closeCentralOverlay(p2)
	local props = p2.props

	if getEnableCentralOverlayForUpsellPrompt() and props.dispatchCentralOverlay then
		props.dispatchCentralOverlay()
	end
end

function extended:constructRobuxUpsellPromptAnimatorObj()
	local props = self.props
	local state = self.state

	self:BindCancelAction()

	local v5 = {
		shouldAnimate = props.shouldAnimate,
		shouldShow = props.purchaseState == RobuxUpsellFlowState.PurchaseModal,
		skipAnimation = props.useUnifiedProductPurchaseModal,
		onShown = 0,
		onHidden = 0,
		renderChildren = 0
	}
	local v6

	if props.isDelayedInput then
		v6 = function()
			self:setState({ enableInputDelayed = true })

			delay(3, function()
				self:setState({ isDelayedInput = false, enableInputDelayed = false })

				if props.onDelayedInputComplete then
					props.onDelayedInputComplete()
				end
			end)
		end or nil
	end

	v5.onShown = v6
	local v7

	if props.isDelayedInput then
		v7 = function()
			self:setState({
				isDelayedInput = props.isDelayedInput,
				enableInputDelayed = false
			})
		end or nil
	end

	v5.onHidden = v7

	function v5.renderChildren()
		if props.useUnifiedProductPurchaseModal then
			if fFlagAddCenterDialogForUnifiedPurchaseModal and getAppContext() == "UA" then
				local createElement = Roact.createElement
				local v9 = {
					product = {
						model = props.model,
						itemIcon = props.itemIcon,
						itemName = props.itemName,
						itemRobuxCost = props.itemRobuxCost,
						badgeType = props.virtualItemBadgeType,
						itemPrice = props.virtualItemPrice
					},
					userBalance = props.beforeRobuxBalance,
					upsellSuggestions = props.upsellSuggestions,
					selectedUpsellIndex = props.selectedUpsellIndex,
					onUpsellSuggestionsSelected = props.onUpsellSuggestionsSelected,
					purchaseModalType = props.unifiedProductPurchaseModalType,
					onBuyItemButtonMounted = props.onBuyItemButtonMounted,
					hideUserRobuxBalance = 0,
					cartPricingResponse = 0,
					collectibleItemId = 0,
					isCartPricingLoading = 0,
					onCartOfferAppliedChanged = 0,
					postPurchaseActions = 0,
					setPostPurchaseActions = 0,
					onRobloxPlusButtonActivated = 0,
					robloxPlusDiscountPercentage = 0,
					buttons = 0,
					termsOfUseActivated = 0,
					screenSize = 0
				}

				local v10 = if fFlagUnifiedPurchaseFlowMarketplaceUIImprovements then props.hideUserRobuxBalance else nil
				v9.hideUserRobuxBalance = v10

				v9.cartPricingResponse = props.cartPricingResponse
				v9.collectibleItemId = props.collectibleItemId
				v9.isCartPricingLoading = props.isCartPricingLoading
				v9.onCartOfferAppliedChanged = props.onCartOfferAppliedChanged
				v9.postPurchaseActions = props.postPurchaseActions
				v9.setPostPurchaseActions = props.setPostPurchaseActions
				v9.onRobloxPlusButtonActivated = props.onRobloxPlusButtonActivated
				v9.robloxPlusDiscountPercentage = props.robloxPlusDiscountPercentage
				v9.buttons = {
					buyItemActivated = function()
						self:reportUserInput("Buy")
						props.purchaseRobux()
						self:closeCentralOverlay()
					end,
					buyItemControllerIcon = props.acceptControllerIcon,
					buyItemisDelayedInput = state.isDelayedInput,
					buyItemEnableInputDelayed = state.enableInputDelayed and getAppContext() == "IN_EXPERIENCE",
					cancelPurchaseActivated = function()
						self:reportUserInput("Cancel")
						props.cancelPurchase()
						self:closeCentralOverlay()
					end,
					cancelControllerIcon = props.cancelControllerIcon
				}

				v9.termsOfUseActivated = props.showTermsOfUse and function()
					self:reportUserInput("TermsOfService")
					props.showTermsOfUse()
					props.flowComplete()
				end or nil
				v9.screenSize = props.screenSize
				return createElement(UnifiedRobuxUpsellModalV2, v9)
			else
				local createElement = Roact.createElement
				local v9 = {
					product = {
						model = props.model,
						itemIcon = props.itemIcon,
						itemName = props.itemName,
						itemRobuxCost = props.itemRobuxCost,
						badgeType = props.virtualItemBadgeType,
						itemPrice = props.virtualItemPrice
					},
					userBalance = props.beforeRobuxBalance,
					upsellSuggestions = props.upsellSuggestions,
					selectedUpsellIndex = props.selectedUpsellIndex,
					onUpsellSuggestionsSelected = props.onUpsellSuggestionsSelected,
					purchaseModalType = props.unifiedProductPurchaseModalType,
					onBuyItemButtonMounted = props.onBuyItemButtonMounted,
					hideUserRobuxBalance = 0,
					cartPricingResponse = 0,
					isCartPricingLoading = 0,
					onCartOfferAppliedChanged = 0,
					onRobloxPlusButtonActivated = 0,
					robloxPlusDiscountPercentage = 0,
					isMonthlyPrice = 0,
					buttons = 0,
					termsOfUseActivated = 0,
					screenSize = 0
				}

				local v10 = if fFlagUnifiedPurchaseFlowMarketplaceUIImprovements then props.hideUserRobuxBalance else nil
				v9.hideUserRobuxBalance = v10

				v9.cartPricingResponse = props.cartPricingResponse
				v9.isCartPricingLoading = props.isCartPricingLoading
				v9.onCartOfferAppliedChanged = props.onCartOfferAppliedChanged
				v9.onRobloxPlusButtonActivated = props.onRobloxPlusButtonActivated
				v9.robloxPlusDiscountPercentage = props.robloxPlusDiscountPercentage
				local v11 = if fFlagLuaAppsEnablePromptVIPServerPurchase then props.isMonthlyPrice else nil
				v9.isMonthlyPrice = v11
				v9.buttons = {
					buyItemActivated = function()
						self:reportUserInput("Buy")
						props.purchaseRobux()
						self:closeCentralOverlay()
					end,
					buyItemControllerIcon = props.acceptControllerIcon,
					buyItemisDelayedInput = state.isDelayedInput,
					buyItemEnableInputDelayed = state.enableInputDelayed and getAppContext() == "IN_EXPERIENCE",
					cancelPurchaseActivated = function()
						self:reportUserInput("Cancel")
						props.cancelPurchase()
						self:closeCentralOverlay()
					end,
					cancelControllerIcon = props.cancelControllerIcon
				}

				v9.termsOfUseActivated = props.showTermsOfUse and function()
					self:reportUserInput("TermsOfService")
					props.showTermsOfUse()
					props.flowComplete()
				end or nil
				v9.screenSize = props.screenSize
				return createElement(UnifiedRobuxUpsellModal, v9)
			end
		else
			if props.useUpsellSuggestions then
				return overlayInGameMenu(Roact.createElement(RobuxUpsellModalMultiplePackage, {
					product = {
						model = props.model,
						itemIcon = props.itemIcon,
						itemName = props.itemName,
						itemRobuxCost = props.itemRobuxCost,
						badgeType = props.virtualItemBadgeType
					},
					userBalance = props.beforeRobuxBalance,
					upsellSuggestions = props.upsellSuggestions,
					selectedUpsellIndex = props.selectedUpsellIndex,
					onUpsellSuggestionsSelected = props.onUpsellSuggestionsSelected,
					buttons = {
						buyItemActivated = function()
							self:reportUserInput("Buy")
							props.purchaseRobux()
							self:closeCentralOverlay()
						end,
						buyItemControllerIcon = props.acceptControllerIcon,
						buyItemisDelayedInput = state.isDelayedInput,
						buyItemEnableInputDelayed = state.enableInputDelayed,
						cancelPurchaseActivated = function()
							self:reportUserInput("Cancel")
							props.cancelPurchase()
							self:closeCentralOverlay()
						end,
						cancelControllerIcon = props.cancelControllerIcon
					},
					isQuest = props.isQuest,
					isVng = props.isVng,
					screenSize = props.screenSize
				}))
			end

			if shouldShowNewUpsellModalExperiment() or DesktopUpsellExperiment.shouldShowNewModal() then
				return overlayInGameMenu(Roact.createElement(RobuxUpsellModal, {
					product = {
						model = props.model,
						itemIcon = props.itemIcon,
						itemName = props.itemName,
						itemRobuxCost = props.itemRobuxCost,
						badgeType = props.virtualItemBadgeType
					},
					upsell = {
						balanceAmount = props.beforeRobuxBalance,
						robuxPurchaseAmount = props.iapRobuxAmount,
						robuxPurchaseCost = props.iapCostStr,
						robuxPurchaseAmountBeforeBonus = props.iapRobuxAmountBeforeBonus
					},
					buttons = {
						buyItemActivated = function()
							self:reportUserInput("Buy")
							props.purchaseRobux()
							self:closeCentralOverlay()
						end,
						buyItemControllerIcon = props.acceptControllerIcon,
						buyItemisDelayedInput = state.isDelayedInput,
						buyItemEnableInputDelayed = state.enableInputDelayed,
						cancelPurchaseActivated = function()
							self:reportUserInput("Cancel")
							props.cancelPurchase()
							self:closeCentralOverlay()
						end,
						cancelControllerIcon = props.cancelControllerIcon,
						opensBuyRobuxPage = DesktopUpsellExperiment.getVariant() == DesktopUpsellExperiment.variants.OpenRobuxStore
					},
					isQuest = props.isQuest,
					isVng = props.isVng,
					termsOfUseActivated = props.showTermsOfUse and function()
						self:reportUserInput("TermsOfService")
						props.showTermsOfUse()
					end or nil,
					screenSize = props.screenSize
				}))
			end

			return Roact.createElement(RobuxUpsellPrompt, {
				screenSize = props.screenSize,
				isDelayedInput = state.isDelayedInput,
				enableInputDelayed = state.enableInputDelayed,
				model = props.model,
				itemIcon = props.itemIcon,
				itemName = props.itemName,
				itemRobuxCost = props.itemRobuxCost,
				robuxPurchaseAmount = props.iapRobuxAmount,
				robuxPurchaseAmountBeforeBonus = props.iapRobuxAmountBeforeBonus,
				balanceAmount = props.beforeRobuxBalance,
				buyItemControllerIcon = props.acceptControllerIcon,
				cancelControllerIcon = props.cancelControllerIcon,
				itemProductId = FFlagMobilePopularItemBadgingExperimentEnabled and tostring(props.itemProductId) or nil,
				buyItemActivated = function()
					self:reportUserInput("Buy")
					props.purchaseRobux()
					self:closeCentralOverlay()
				end,
				cancelPurchaseActivated = function()
					self:reportUserInput("Cancel")
					props.cancelPurchase()
					self:closeCentralOverlay()
				end,
				termsOfUseActivated = props.showTermsOfUse and function()
					self:reportUserInput("TermsOfService")
					props.showTermsOfUse()
				end or nil,
				isQuest = self.props.isQuest,
				isVng = self.props.isVng
			})
		end
	end

	return v5
end

function extended:constructU13ConfirmPromptAnimatorObj()
	local props = self.props

	self:BindCancelAction()

	return {
		shouldAnimate = props.shouldAnimate,
		shouldShow = props.purchaseState == RobuxUpsellFlowState.PurchaseWarning,
		renderChildren = function()
			return Roact.createElement(U13ConfirmPrompt, {
				screenSize = props.screenSize,
				modalType = props.u13ConfirmType,
				doneControllerIcon = props.acceptControllerIcon,
				cancelControllerIcon = props.cancelControllerIcon,
				doneActivated = function()
					self:reportUserInput("Confirm")
					props.acceptPurchaseWarning()
					self:closeCentralOverlay()
				end,
				cancelActivated = function()
					self:reportUserInput("Cancel")
					props.cancelPurchase()
					self:closeCentralOverlay()
				end
			})
		end
	}
end

function extended:constructPurchaseErrorPromptAnimatorObj()
	local props = self.props

	self:BindCancelAction()

	return {
		shouldAnimate = props.shouldAnimate,
		shouldShow = props.purchaseState == RobuxUpsellFlowState.Error,
		renderChildren = function()
			if props.errorType == PurchaseErrorType.NotEnoughRobuxInApp then
				if fFlagAddCenterDialogForUnifiedPurchaseModal then
					return Roact.createElement(UnifiedRobuxUpsellModalTooExpensiveV2, {
						product = {
							model = props.model,
							itemIcon = props.itemIcon,
							itemName = props.itemName,
							itemRobuxCost = props.itemRobuxCost
						},
						balanceAmount = props.beforeRobuxBalance,
						buttons = {
							buyItemActivated = function()
								self:reportUserInput("Buy Robux")
								props.openBuyRobux()
								props.flowComplete()
								self:closeCentralOverlay()
							end,
							cancelPurchaseActivated = function()
								self:reportUserInput("Cancel")
								props.flowComplete()
								self:closeCentralOverlay()
							end
						},
						purchaseModalType = props.unifiedProductPurchaseModalType,
						screenSize = props.screenSize
					})
				end

				local createElement = Roact.createElement

				local v6 = {
					product = {
						model = props.model,
						itemIcon = props.itemIcon,
						itemName = props.itemName,
						itemRobuxCost = props.itemRobuxCost
					},
					balanceAmount = props.beforeRobuxBalance,
					hideUserRobuxBalance = 0,
					buttons = 0,
					isQuest = 0,
					screenSize = 0,
					purchaseModalType = 0
				}

				local v7 = if fFlagUnifiedPurchaseFlowMarketplaceUIImprovements then props.hideUserRobuxBalance else nil
				v6.hideUserRobuxBalance = v7

				v6.buttons = {
					buyItemActivated = function()
						self:reportUserInput("Buy Robux")
						props.openBuyRobux()
						props.flowComplete()
						self:closeCentralOverlay()
					end,
					cancelPurchaseActivated = function()
						self:reportUserInput("Cancel")
						props.flowComplete()
						self:closeCentralOverlay()
					end
				}

				v6.isQuest = props.isQuest
				v6.screenSize = props.screenSize
				v6.purchaseModalType = props.unifiedProductPurchaseModalType
				return createElement(UnifiedRobuxUpsellModalTooExpensive, v6)
			elseif
				props.errorType == PurchaseErrorType.NotEnoughRobux
				and (shouldShowNewUpsellModalExperiment() or DesktopUpsellExperiment.shouldShowNewModal())
			then
				return Roact.createElement(RobuxUpsellModalTooExpensiveFallback, {
					product = {
						model = props.model,
						itemIcon = props.itemIcon,
						itemName = props.itemName,
						itemRobuxCost = props.itemRobuxCost
					},
					balanceAmount = props.beforeRobuxBalance,
					doneActivated = function()
						self:reportUserInput("Done")
						props.flowComplete()
						self:closeCentralOverlay()
					end,
					doneControllerIcon = props.acceptControllerIcon,
					isQuest = props.isQuest,
					screenSize = props.screenSize
				})
			else
				return Roact.createElement(PurchaseErrorPrompt, {
					screenSize = props.screenSize,
					errorType = props.errorType,
					economicRestrictionError = props.economicRestrictionError,
					doneControllerIcon = props.acceptControllerIcon,
					doneActivated = function()
						self:reportUserInput("Done")
						props.flowComplete()
						self:closeCentralOverlay()
					end
				})
			end
		end
	}
end

function extended:constructTwoStepRequiredAnimatorObj()
	local props = self.props

	self:BindCancelAction()

	return {
		shouldAnimate = props.shouldAnimate,
		shouldShow = props.purchaseState == RobuxUpsellFlowState.TwoStepRequired,
		renderChildren = function()
			return Roact.createElement(TwoStepReqPrompt, {
				screenSize = props.screenSize,
				doneControllerIcon = props.acceptControllerIcon,
				openSecuritySettings = function()
					self:reportUserInput("GoToSecuritySettings")
					props.openSecuritySettings()
					props.flowComplete()
					self:closeCentralOverlay()
				end,
				closePrompt = function()
					self:reportUserInput("Cancel")
					props.flowComplete()
					self:closeCentralOverlay()
				end
			})
		end
	}
end

function extended:constructRobuxUpsellSuccessPromptAnimatorObj()
	local props = self.props

	self:BindCancelAction()

	return {
		shouldAnimate = props.shouldAnimate,
		shouldShow = props.purchaseState == RobuxUpsellFlowState.Success,
		renderChildren = function()
			local v5 = props.beforeRobuxBalance - props.itemRobuxCost

			if v5 < 0 then
				v5 += props.iapRobuxAmount
			end

			if not props.useUnifiedProductPurchaseModal then
				return Roact.createElement(RobuxUpsellSuccessPrompt, {
					screenSize = props.screenSize,
					model = props.model,
					itemIcon = props.itemIcon,
					itemName = props.itemName,
					balance = v5,
					confirmControllerIcon = props.acceptControllerIcon,
					cancelControllerIcon = props.cancelControllerIcon,
					doneActivated = function()
						self:reportUserInput("Done")
						props.flowComplete()
						self:closeCentralOverlay()
					end,
					equipActivated = props.equipItem and function()
						self:reportUserInput("Equip")
						props.equipItem()
						self:closeCentralOverlay()
					end or nil
				})
			end

			if defineFastFlag and getAppContext() == "UA" then
				return Roact.createElement(UnifiedPurchaseCompletionModalV2, {
					buttons = {
						onActivated = function()
							self:reportUserInput("Done")
							props.flowComplete()
							self:closeCentralOverlay()
						end
					},
					isMultiItem = props.unifiedProductPurchaseModalType == UnifiedPurchaseModalTypeEnum.MultiItem,
					itemName = props.itemName
				})
			end

			return Roact.createElement(UnifiedPurchaseCompletionModal, {
				buttons = {
					onActivated = function()
						self:reportUserInput("Done")
						props.flowComplete()
						self:closeCentralOverlay()
					end
				},
				isMultiItem = props.unifiedProductPurchaseModalType == UnifiedPurchaseModalTypeEnum.MultiItem,
				itemName = props.itemName
			})
		end
	}
end

function extended:constructInsufficientRobuxAnimatorObj()
	local props = self.props

	self:BindCancelAction()

	return {
		shouldAnimate = props.shouldAnimate,
		shouldShow = props.purchaseState == RobuxUpsellFlowState.GenericPurchaseModal,
		renderChildren = function()
			if shouldShowNewUpsellModalExperiment() or DesktopUpsellExperiment.shouldShowNewModal() then
				return Roact.createElement(RobuxUpsellModalTooExpensive, {
					product = {
						model = props.model,
						itemIcon = props.itemIcon,
						itemName = props.itemName,
						itemRobuxCost = props.itemRobuxCost
					},
					balanceAmount = props.beforeRobuxBalance,
					buttons = {
						buyItemActivated = function()
							self:reportUserInput("Buy Robux")
							props.openBuyRobux()
							props.flowComplete()
							self:closeCentralOverlay()
						end,
						buyItemControllerIcon = props.acceptControllerIcon,
						cancelPurchaseActivated = function()
							self:reportUserInput("Cancel")
							props.flowComplete()
							self:closeCentralOverlay()
						end,
						cancelControllerIcon = props.cancelControllerIcon
					},
					isQuest = props.isQuest,
					screenSize = props.screenSize
				})
			end

			return Roact.createElement(InsufficientRobuxPrompt, {
				screenSize = props.screenSize,
				robuxBalance = props.beforeRobuxBalance,
				buyRobux = function()
					self:reportUserInput("Buy Robux")
					props.openBuyRobux()
					props.flowComplete()
					self:closeCentralOverlay()
				end,
				closePrompt = function()
					self:reportUserInput("Cancel")
					props.flowComplete()
					self:closeCentralOverlay()
				end
			})
		end
	}
end

function extended:constructInsufficientRobuxProductAnimatorObj()
	local props = self.props

	self:BindCancelAction()

	return {
		shouldAnimate = props.shouldAnimate,
		shouldShow = props.purchaseState == RobuxUpsellFlowState.LargeRobuxPurchaseModal,
		renderChildren = function()
			return Roact.createElement(InsufficientRobuxProductPrompt, {
				screenSize = props.screenSize,
				model = props.model,
				itemIcon = props.itemIcon,
				itemName = props.itemName,
				itemRobuxCost = props.itemRobuxCost,
				balanceAmount = props.beforeRobuxBalance,
				acceptControllerIcon = props.acceptControllerIcon,
				cancelControllerIcon = props.cancelControllerIcon,
				robuxStoreActivated = function()
					self:reportUserInput("Go to Robux store")
					props.openBuyRobux()
					self:closeCentralOverlay()
				end,
				cancelPurchaseActivated = function()
					self:reportUserInput("Cancel")
					props.flowComplete()
					self:closeCentralOverlay()
				end
			})
		end
	}
end

function extended:constructLeaveRobloxPromptAnimatorObj()
	local props = self.props

	self:BindCancelAction()

	return {
		shouldAnimate = props.shouldAnimate,
		shouldShow = props.purchaseState == RobuxUpsellFlowState.LeaveRobloxWarning,
		renderChildren = function()
			return Roact.createElement(LeaveRobloxPrompt, {
				screenSize = props.screenSize,
				cancelActivated = function()
					self:closeCentralOverlay()
				end,
				continueActivated = function()
					props.openVngShop()
				end
			})
		end
	}
end

function extended:constructPurchaseVPCPromptAnimatorObj()
	local props = self.props

	self:BindCancelAction()

	return {
		shouldAnimate = props.shouldAnimate,
		shouldShow = props.purchaseState == RobuxUpsellFlowState.PurchaseVPCModal,
		renderChildren = function()
			return Roact.createElement(verifiedParentalConsentDialog, {
				screenSize = props.screenSize,
				isActionable = props.openSettingsPage ~= nil,
				modalType = props.purchaseVPCType,
				onAction = props.openSettingsPage and function()
					self:reportUserInput("Confirm")
					props.openSettingsPage()
					props.flowComplete()
				end,
				onDismiss = function()
					self:reportUserInput("Cancel")
					props.cancelPurchase()
					self:closeCentralOverlay()
				end
			})
		end
	}
end

function extended:dispatchCentralOverlayAndRenderModal(p2)
	if not (getEnableCentralOverlayForUpsellPrompt() and p2.dispatchCentralOverlay) then
		return
	end

	local purchaseState = p2.purchaseState

	if purchaseState == RobuxUpsellFlowState.PurchaseModal then
		p2.dispatchCentralOverlay(
			Constants.CENTRAL_OVERLAY_TYPE_ANIMATOR,
			self:constructRobuxUpsellPromptAnimatorObj()
		)

		return
	end

	if purchaseState == RobuxUpsellFlowState.PurchaseWarning then
		p2.dispatchCentralOverlay(
			Constants.CENTRAL_OVERLAY_TYPE_ANIMATOR,
			self:constructU13ConfirmPromptAnimatorObj()
		)
	end

	if purchaseState == RobuxUpsellFlowState.Error then
		p2.dispatchCentralOverlay(
			Constants.CENTRAL_OVERLAY_TYPE_ANIMATOR,
			self:constructPurchaseErrorPromptAnimatorObj()
		)
	end

	if purchaseState == RobuxUpsellFlowState.TwoStepRequired then
		p2.dispatchCentralOverlay(
			Constants.CENTRAL_OVERLAY_TYPE_ANIMATOR,
			self:constructTwoStepRequiredAnimatorObj()
		)
	end

	if purchaseState == RobuxUpsellFlowState.Success then
		p2.dispatchCentralOverlay(
			Constants.CENTRAL_OVERLAY_TYPE_ANIMATOR,
			self:constructRobuxUpsellSuccessPromptAnimatorObj()
		)
	end

	if purchaseState == RobuxUpsellFlowState.GenericPurchaseModal then
		p2.dispatchCentralOverlay(
			Constants.CENTRAL_OVERLAY_TYPE_ANIMATOR,
			self:constructInsufficientRobuxAnimatorObj()
		)
	end

	if purchaseState == RobuxUpsellFlowState.LargeRobuxPurchaseModal then
		p2.dispatchCentralOverlay(
			Constants.CENTRAL_OVERLAY_TYPE_ANIMATOR,
			self:constructInsufficientRobuxProductAnimatorObj()
		)
	end

	if purchaseState == RobuxUpsellFlowState.LeaveRobloxWarning then
		p2.dispatchCentralOverlay(
			Constants.CENTRAL_OVERLAY_TYPE_ANIMATOR,
			self:constructLeaveRobloxPromptAnimatorObj()
		)
	end

	if purchaseState == RobuxUpsellFlowState.PurchaseVPCModal then
		p2.dispatchCentralOverlay(
			Constants.CENTRAL_OVERLAY_TYPE_ANIMATOR,
			self:constructPurchaseVPCPromptAnimatorObj()
		)
	end
end

function extended:reportModalShown()
	local props = self.props
	local state = self.state

	if not self.props.onAnalyticEvent then
		return
	end

	local v5 = getModalShownEventData(
		state.analyticId,
		props.eventPrefix,
		"RobuxUpsell",
		RobuxUpsellFlowState.toRawValue(props.purchaseState),
		HttpService:JSONEncode({
			universe_id = tostring(game.GameId),
			item_product_id = tostring(props.itemProductId),
			item_name = props.itemName,
			price = tostring(props.itemRobuxCost),
			user_balance = tostring(props.beforeRobuxBalance) or nil,
			package_robux_amount = tostring(props.iapRobuxAmount) or nil,
			package_cost = props.iapCostStr or nil
		})
	)

	props.onAnalyticEvent("UserPurchaseFlow", v5)
end

function extended:reportUserInput(p3)
	local props = self.props
	local v5 = getUserInputEventData(
		self.state.analyticId,
		props.eventPrefix,
		"RobuxUpsell",
		RobuxUpsellFlowState.toRawValue(props.purchaseState),
		p3,
		HttpService:JSONEncode({
			universe_id = tostring(game.GameId),
			item_product_id = tostring(props.itemProductId),
			item_name = props.itemName,
			price = tostring(props.itemRobuxCost),
			user_balance = tostring(props.beforeRobuxBalance) or nil,
			package_robux_amount = tostring(props.iapRobuxAmount) or nil,
			package_cost = props.iapCostStr or nil
		})
	)

	if
		not game:GetFastFlag("DisableNonSchematizedInGameRobuxUpsellEvent")
		and self.props.onAnalyticEvent
	then
		props.onAnalyticEvent("UserPurchaseFlow", v5)
	end

	local v6

	if Players.LocalPlayer and Players.LocalPlayer.UserId > 0 then
		v6 = Players.LocalPlayer.UserId
	end

	default:logRobloxTelemetryEvent(
		InGameRobuxUpsellEvent,
		{ default.StandardizedFields.addOsInfo, default.StandardizedFields.addSessionId },
		{
			universe_id = game.GameId,
			price = props.itemRobuxCost,
			view_name = v5.view_name,
			purchase_event_type = v5.purchase_event_type,
			input_type = p3,
			user_id = tostring(v6)
		}
	)
end

function extended:purchaseStateToOverlayState(p3)
	if p3 == RobuxUpsellFlowState.Loading then
		return LoadingOverlayState.Loading
	end

	if p3 == RobuxUpsellFlowState.RobuxPurchasePending then
		return LoadingOverlayState.PurchasingRobux
	end

	if p3 == RobuxUpsellFlowState.RobuxGrantPending then
		return LoadingOverlayState.WaitingForRobux
	end

	if p3 == RobuxUpsellFlowState.ItemPurchasePending then
		return LoadingOverlayState.PurchasingItem
	end

	if p3 == RobuxUpsellFlowState.None then
		return nil
	end

	return LoadingOverlayState.None
end

function extended:getChildrenElements()
	return {
		RobuxUpsellPromptAnimator = Roact.createElement(
			Animator,
			self:constructRobuxUpsellPromptAnimatorObj()
		),
		U13ConfirmPromptAnimator = Roact.createElement(
			Animator,
			self:constructU13ConfirmPromptAnimatorObj()
		),
		PurchaseErrorPromptAnimator = Roact.createElement(
			Animator,
			self:constructPurchaseErrorPromptAnimatorObj()
		),
		TwoStepRequiredAnimator = Roact.createElement(Animator, self:constructTwoStepRequiredAnimatorObj()),
		RobuxUpsellSuccessPromptAnimator = Roact.createElement(
			Animator,
			self:constructRobuxUpsellSuccessPromptAnimatorObj()
		),
		InsufficientRobuxAnimator = Roact.createElement(
			Animator,
			self:constructInsufficientRobuxAnimatorObj()
		),
		InsufficientRobuxProductAnimator = Roact.createElement(
			Animator,
			self:constructInsufficientRobuxProductAnimatorObj()
		),
		PurchaseVPCPromptAnimator = Roact.createElement(
			Animator,
			self:constructPurchaseVPCPromptAnimatorObj()
		)
	}
end

function extended:render()
	local props = self.props

	local v5 = getEnableCentralOverlayForUpsellPrompt() and props.dispatchCentralOverlay and {} or self:getChildrenElements()

	return Roact.createElement(
		LoadingOverlay,
		{
			shouldAnimate = props.shouldAnimate,
			loadingState = self:purchaseStateToOverlayState(props.purchaseState)
		},
		v5
	)
end

return extended
