local HttpService = game:GetService("HttpService")
local ContextActionService = game:GetService("ContextActionService")

local parent = script.Parent
local parent2 = parent.Parent.Parent
local parent3 = parent2.Parent

local Roact = require(parent3.Roact)

local RobuxUpsellFlowState = require(parent.RobuxUpsellFlowState)

require(parent2.Enums.VirtualItemBadgeType)

local Animator = require(parent2.Generic.Animator)
local Constants = require(parent2.Generic.Constants)
local LoadingOverlay = require(parent2.Generic.LoadingOverlay)
local LoadingOverlayState = require(parent2.Generic.LoadingOverlayState)
local PurchaseErrorPrompt = require(parent2.Generic.PurchaseErrorPrompt)
local PurchaseErrorType = require(parent2.Enums.PurchaseErrorType)
local U13ConfirmPrompt = require(parent2.Generic.U13ConfirmPrompt)
local TwoStepReqPrompt = require(parent2.Generic.TwoStepReqPrompt)
local InsufficientRobuxPrompt = require(parent2.Generic.InsufficientRobuxPrompt)

local InsufficientRobuxProductPrompt = require(parent2.ProductPurchaseRobuxUpsell.InsufficientRobuxProductPrompt)
local LeaveRobloxPrompt = require(parent2.Generic.LeaveRobloxPrompt)
local RobuxUpsellSuccessPrompt = require(parent2.ProductPurchaseRobuxUpsell.RobuxUpsellSuccessPrompt)
local RobuxUpsellPrompt = require(parent2.ProductPurchaseRobuxUpsell.RobuxUpsellPrompt)
local RobuxUpsellModal = require(parent2.ProductPurchaseRobuxUpsell.v2.RobuxUpsellModal)

local RobuxUpsellModalMultiplePackage = require(parent2.ProductPurchaseRobuxUpsell.v2.RobuxUpsellModalMultiplePackage)

local RobuxUpsellModalTooExpensive = require(parent2.ProductPurchaseRobuxUpsell.v2.RobuxUpsellModalTooExpensive)

local RobuxUpsellModalTooExpensiveFallback = require(parent2.ProductPurchaseRobuxUpsell.v2.RobuxUpsellModalTooExpensiveFallback)
local UnifiedRobuxUpsellModal = require(parent2.ProductPurchaseRobuxUpsell.v3.UnifiedRobuxUpsellModal)

local UnifiedRobuxUpsellModalTooExpensive = require(parent2.ProductPurchaseRobuxUpsell.v3.UnifiedRobuxUpsellModalTooExpensive)
local PurchasePromptLite = require(parent3.PurchasePromptLite)
local getTTIEventName = PurchasePromptLite.getTTIEventName
local TimeToInteractiveTracker = require(parent3.TimeToInteractiveTracker)
local timeToInteractiveTracker = TimeToInteractiveTracker.TimeToInteractiveTracker
local ProductPurchaseSurface = PurchasePromptLite.Enums.ProductPurchaseSurface
local getModalShownEventData = require(parent2.Utility.getModalShownEventData)
local getUserInputEventData = require(parent2.Utility.getUserInputEventData)

local shouldShowNewUpsellModalExperiment = require(parent2.Utility.Experiments.shouldShowNewUpsellModalExperiment)
local overlayInGameMenu = require(parent2.Utility.overlayInGameMenu)

local DesktopUpsellExperiment = require(parent2.Utility.Experiments.DesktopUpsellExperiment)

local getEnableCentralOverlayForUpsellPrompt = require(parent2.Flags.getEnableCentralOverlayForUpsellPrompt)
local getAppContext = require(parent2.Utility.getAppContext)

local FFlagMobilePopularItemBadgingExperimentEnabled = require(parent2.Flags.FFlagMobilePopularItemBadgingExperimentEnabled)
local UnifiedPurchaseCompletionModalV2 = require(parent2.Generic.UnifiedPurchaseCompletionModalV2)

local extended = Roact.Component:extend(script.Name)

local LoggingProtocol = require(parent3.LoggingProtocol)
local default = LoggingProtocol.default
local InGameRobuxUpsellEvent = require(parent.Events.InGameRobuxUpsellEvent)
local Players = game:GetService("Players")
local IntervalPerformanceTracker = require(parent3.IntervalPerformanceTracker)
local intervalPerformanceTracker = IntervalPerformanceTracker.IntervalPerformanceTracker

local VerifiedParentalConsentDialog = require(parent3.VerifiedParentalConsentDialog)
local verifiedParentalConsentDialog = VerifiedParentalConsentDialog.VerifiedParentalConsentDialog
local UnifiedRobuxUpsellModalV2 = require(parent2.ProductPurchaseRobuxUpsell.v4.UnifiedRobuxUpsellModalV2)

local UnifiedRobuxUpsellModalTooExpensiveV2 = require(parent2.ProductPurchaseRobuxUpsell.v4.UnifiedRobuxUpsellModalTooExpensiveV2)
require(parent2.ProductPurchase.v4.cartPricingResponseLineItem)

local UnifiedPurchaseModalTypeEnum = require(parent2.Enums.UnifiedPurchaseModalTypeEnum)
local UnifiedPurchaseCompletionModal = require(parent2.Generic.UnifiedPurchaseCompletionModal)

local SharedFlags = require(parent3.SharedFlags)
local FFlagUnifiedPurchaseFlowMarketplaceUIImprovements = SharedFlags.FFlagUnifiedPurchaseFlowMarketplaceUIImprovements

local SharedFlags2 = require(parent3.SharedFlags)
local FFlagLuaAppsEnablePromptVIPServerPurchase = SharedFlags2.FFlagLuaAppsEnablePromptVIPServerPurchase

local SharedFlags3 = require(parent3.SharedFlags)
local FFlagAddPerformanceMetricsToUnifiedPurchaseModal = SharedFlags3.FFlagAddPerformanceMetricsToUnifiedPurchaseModal
local SharedFlags4 = require(parent3.SharedFlags)
local FIntLegacyPurchaseFPSTrackingTimeout = SharedFlags4.FIntLegacyPurchaseFPSTrackingTimeout
local SharedFlags5 = require(parent3.SharedFlags)
local FIntTTIUnifiedPurchaseSamplingRate = SharedFlags5.FIntTTIUnifiedPurchaseSamplingRate

local SharedFlags6 = require(parent3.SharedFlags)
local FFlagAddCenterDialogForUnifiedPurchaseModal = SharedFlags6.FFlagAddCenterDialogForUnifiedPurchaseModal

game:DefineFastFlag("DisableNonSchematizedInGameRobuxUpsellEvent", false)

local defineFastFlag = game:DefineFastFlag("FixUnifiedUpsellCompletionModal", false)
require(parent2.ProductPurchase.PricingTypes)
require(parent2.ProductPurchase.v3.UnifiedProductPurchaseModalTypes)

require(parent2.Api.PaymentsGateway.GetUpsellSuggestionsTypes)

function extended:init()
	local props = self.props
	local analyticId

	if props.analyticId then
		analyticId = props.analyticId
	else
		analyticId = HttpService:GenerateGUID(false)
	end

	self.state = {
		analyticId = analyticId,
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

function extended.didMount(p)
	if FFlagAddPerformanceMetricsToUnifiedPurchaseModal and (p.props or {}).eventPrefix == "UACatalog" then
		intervalPerformanceTracker:startTracking(
			"PurchaseModal_RobuxUpsellModalShown_Catalog",
			FIntLegacyPurchaseFPSTrackingTimeout,
			nil,
			true,
			true
		)

		intervalPerformanceTracker:startTracking(
			"PurchaseModal_LegacyFlowRobuxUpsellModalShown_Catalog",
			FIntLegacyPurchaseFPSTrackingTimeout,
			nil,
			true,
			true
		)

		local ttiEventName = getTTIEventName(ProductPurchaseSurface.Catalog)
		timeToInteractiveTracker.trackEnd(ttiEventName, {
			samplingRateOverride = FIntTTIUnifiedPurchaseSamplingRate
		})
	end
end

function extended:didUpdate(p, _)
	local props = self.props

	if p.purchaseState ~= props.purchaseState then
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

function extended:closeCentralOverlay()
	local props = self.props

	if getEnableCentralOverlayForUpsellPrompt() and props.dispatchCentralOverlay then
		props.dispatchCentralOverlay()
	end
end

function extended:constructRobuxUpsellPromptAnimatorObj()
	local props = self.props
	local state = self.state

	self:BindCancelAction()

	local v = {
		shouldAnimate = props.shouldAnimate,
		shouldShow = props.purchaseState == RobuxUpsellFlowState.PurchaseModal,
		skipAnimation = props.useUnifiedProductPurchaseModal,
		onShown = 0,
		onHidden = 0,
		renderChildren = 0
	}
	local onShown

	if props.isDelayedInput then
		onShown = function()
			self:setState({ enableInputDelayed = true })

			delay(3, function()
				self:setState({ isDelayedInput = false, enableInputDelayed = false })

				if props.onDelayedInputComplete then
					props.onDelayedInputComplete()
				end
			end)
		end or nil
	end

	v.onShown = onShown
	local onHidden

	if props.isDelayedInput then
		onHidden = function()
			self:setState({ isDelayedInput = props.isDelayedInput, enableInputDelayed = false })
		end or nil
	end

	v.onHidden = onHidden

	function v.renderChildren()
		if props.useUnifiedProductPurchaseModal then
			if FFlagAddCenterDialogForUnifiedPurchaseModal and getAppContext() == "UA" then
				local createElement = Roact.createElement
				local v2 = {
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
				local hideUserRobuxBalance

				if FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then
					hideUserRobuxBalance = props.hideUserRobuxBalance
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
				v2.buttons = {
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

				v2.termsOfUseActivated = props.showTermsOfUse and function()
					self:reportUserInput("TermsOfService")
					props.showTermsOfUse()
					props.flowComplete()
				end or nil
				v2.screenSize = props.screenSize
				return createElement(UnifiedRobuxUpsellModalV2, v2)
			else
				local createElement = Roact.createElement
				local v2 = {
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
				local hideUserRobuxBalance

				if FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then
					hideUserRobuxBalance = props.hideUserRobuxBalance
				end

				v2.hideUserRobuxBalance = hideUserRobuxBalance

				v2.cartPricingResponse = props.cartPricingResponse
				v2.isCartPricingLoading = props.isCartPricingLoading
				v2.onCartOfferAppliedChanged = props.onCartOfferAppliedChanged
				v2.onRobloxPlusButtonActivated = props.onRobloxPlusButtonActivated
				v2.robloxPlusDiscountPercentage = props.robloxPlusDiscountPercentage
				local isMonthlyPrice

				if FFlagLuaAppsEnablePromptVIPServerPurchase then
					isMonthlyPrice = props.isMonthlyPrice
				end

				v2.isMonthlyPrice = isMonthlyPrice
				v2.buttons = {
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

				v2.termsOfUseActivated = props.showTermsOfUse and function()
					self:reportUserInput("TermsOfService")
					props.showTermsOfUse()
					props.flowComplete()
				end or nil
				v2.screenSize = props.screenSize
				return createElement(UnifiedRobuxUpsellModal, v2)
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

	return v
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
				if FFlagAddCenterDialogForUnifiedPurchaseModal then
					return (Roact.createElement(UnifiedRobuxUpsellModalTooExpensiveV2, {
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
					}))
				end

				local createElement = Roact.createElement

				local v = {
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
				local hideUserRobuxBalance

				if FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then
					hideUserRobuxBalance = props.hideUserRobuxBalance
				end

				v.hideUserRobuxBalance = hideUserRobuxBalance

				v.buttons = {
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

				v.isQuest = props.isQuest
				v.screenSize = props.screenSize
				v.purchaseModalType = props.unifiedProductPurchaseModalType
				return (createElement(UnifiedRobuxUpsellModalTooExpensive, v))
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
			local balance = props.beforeRobuxBalance - props.itemRobuxCost

			if balance < 0 then
				balance += props.iapRobuxAmount
			end

			if not props.useUnifiedProductPurchaseModal then
				return Roact.createElement(RobuxUpsellSuccessPrompt, {
					screenSize = props.screenSize,
					model = props.model,
					itemIcon = props.itemIcon,
					itemName = props.itemName,
					balance = balance,
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

function extended:dispatchCentralOverlayAndRenderModal(p)
	if not (getEnableCentralOverlayForUpsellPrompt() and p.dispatchCentralOverlay) then
		return
	end

	local purchaseState = p.purchaseState

	if purchaseState == RobuxUpsellFlowState.PurchaseModal then
		p.dispatchCentralOverlay(Constants.CENTRAL_OVERLAY_TYPE_ANIMATOR, self:constructRobuxUpsellPromptAnimatorObj())

		return
	end

	if purchaseState == RobuxUpsellFlowState.PurchaseWarning then
		p.dispatchCentralOverlay(Constants.CENTRAL_OVERLAY_TYPE_ANIMATOR, self:constructU13ConfirmPromptAnimatorObj())
	end

	if purchaseState == RobuxUpsellFlowState.Error then
		p.dispatchCentralOverlay(
			Constants.CENTRAL_OVERLAY_TYPE_ANIMATOR,
			self:constructPurchaseErrorPromptAnimatorObj()
		)
	end

	if purchaseState == RobuxUpsellFlowState.TwoStepRequired then
		p.dispatchCentralOverlay(Constants.CENTRAL_OVERLAY_TYPE_ANIMATOR, self:constructTwoStepRequiredAnimatorObj())
	end

	if purchaseState == RobuxUpsellFlowState.Success then
		p.dispatchCentralOverlay(
			Constants.CENTRAL_OVERLAY_TYPE_ANIMATOR,
			self:constructRobuxUpsellSuccessPromptAnimatorObj()
		)
	end

	if purchaseState == RobuxUpsellFlowState.GenericPurchaseModal then
		p.dispatchCentralOverlay(Constants.CENTRAL_OVERLAY_TYPE_ANIMATOR, self:constructInsufficientRobuxAnimatorObj())
	end

	if purchaseState == RobuxUpsellFlowState.LargeRobuxPurchaseModal then
		p.dispatchCentralOverlay(
			Constants.CENTRAL_OVERLAY_TYPE_ANIMATOR,
			self:constructInsufficientRobuxProductAnimatorObj()
		)
	end

	if purchaseState == RobuxUpsellFlowState.LeaveRobloxWarning then
		p.dispatchCentralOverlay(Constants.CENTRAL_OVERLAY_TYPE_ANIMATOR, self:constructLeaveRobloxPromptAnimatorObj())
	end

	if purchaseState == RobuxUpsellFlowState.PurchaseVPCModal then
		p.dispatchCentralOverlay(Constants.CENTRAL_OVERLAY_TYPE_ANIMATOR, self:constructPurchaseVPCPromptAnimatorObj())
	end
end

function extended:reportModalShown()
	local props = self.props
	local state = self.state

	if not self.props.onAnalyticEvent then
		return
	end

	local modalShownEventData = getModalShownEventData(
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

	props.onAnalyticEvent("UserPurchaseFlow", modalShownEventData)
end

function extended:reportUserInput(input_type: string)
	local props = self.props
	local userInputEventData = getUserInputEventData(
		self.state.analyticId,
		props.eventPrefix,
		"RobuxUpsell",
		RobuxUpsellFlowState.toRawValue(props.purchaseState),
		input_type,
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

	if not game:GetFastFlag("DisableNonSchematizedInGameRobuxUpsellEvent") and self.props.onAnalyticEvent then
		props.onAnalyticEvent("UserPurchaseFlow", userInputEventData)
	end

	local v

	if Players.LocalPlayer and Players.LocalPlayer.UserId > 0 then
		v = Players.LocalPlayer.UserId
	end

	default:logRobloxTelemetryEvent(
		InGameRobuxUpsellEvent,
		{ default.StandardizedFields.addOsInfo, default.StandardizedFields.addSessionId },
		{
			universe_id = game.GameId,
			price = props.itemRobuxCost,
			view_name = userInputEventData.view_name,
			purchase_event_type = userInputEventData.purchase_event_type,
			input_type = input_type,
			user_id = tostring(v)
		}
	)
end

function extended:purchaseStateToOverlayState(p)
	if p == RobuxUpsellFlowState.Loading then
		return LoadingOverlayState.Loading
	end

	if p == RobuxUpsellFlowState.RobuxPurchasePending then
		return LoadingOverlayState.PurchasingRobux
	end

	if p == RobuxUpsellFlowState.RobuxGrantPending then
		return LoadingOverlayState.WaitingForRobux
	end

	if p == RobuxUpsellFlowState.ItemPurchasePending then
		return LoadingOverlayState.PurchasingItem
	end

	if p == RobuxUpsellFlowState.None then
		return nil
	end

	return LoadingOverlayState.None
end

function extended:getChildrenElements()
	return {
		RobuxUpsellPromptAnimator = Roact.createElement(Animator, self:constructRobuxUpsellPromptAnimatorObj()),
		U13ConfirmPromptAnimator = Roact.createElement(Animator, self:constructU13ConfirmPromptAnimatorObj()),
		PurchaseErrorPromptAnimator = Roact.createElement(Animator, self:constructPurchaseErrorPromptAnimatorObj()),
		TwoStepRequiredAnimator = Roact.createElement(Animator, self:constructTwoStepRequiredAnimatorObj()),
		RobuxUpsellSuccessPromptAnimator = Roact.createElement(
			Animator,
			self:constructRobuxUpsellSuccessPromptAnimatorObj()
		),
		InsufficientRobuxAnimator = Roact.createElement(Animator, self:constructInsufficientRobuxAnimatorObj()),
		InsufficientRobuxProductAnimator = Roact.createElement(
			Animator,
			self:constructInsufficientRobuxProductAnimatorObj()
		),
		PurchaseVPCPromptAnimator = Roact.createElement(Animator, self:constructPurchaseVPCPromptAnimatorObj())
	}
end

function extended:render()
	local props = self.props

	local v = getEnableCentralOverlayForUpsellPrompt() and props.dispatchCentralOverlay and {}
		or self:getChildrenElements()

	return Roact.createElement(
		LoadingOverlay,
		{
			shouldAnimate = props.shouldAnimate,
			loadingState = self:purchaseStateToOverlayState(props.purchaseState)
		},
		v
	)
end

return extended
