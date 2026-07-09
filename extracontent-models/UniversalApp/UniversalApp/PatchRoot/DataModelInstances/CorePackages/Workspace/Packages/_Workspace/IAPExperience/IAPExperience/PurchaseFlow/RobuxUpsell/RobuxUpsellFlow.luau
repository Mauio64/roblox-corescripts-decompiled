local HttpService = game:GetService("HttpService")
local ContextActionService = game:GetService("ContextActionService")
local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Roact = require(ParentParentParent.Roact)
local RobuxUpsellFlowState = require(scriptParent.RobuxUpsellFlowState)

require(ParentParent.Enums.VirtualItemBadgeType)

local Animator = require(ParentParent.Generic.Animator)
local Constants = require(ParentParent.Generic.Constants)
local LoadingOverlay = require(ParentParent.Generic.LoadingOverlay)
local LoadingOverlayState = require(ParentParent.Generic.LoadingOverlayState)
local PurchaseErrorPrompt = require(ParentParent.Generic.PurchaseErrorPrompt)
local PurchaseErrorType = require(ParentParent.Enums.PurchaseErrorType)
local U13ConfirmPrompt = require(ParentParent.Generic.U13ConfirmPrompt)
local TwoStepReqPrompt = require(ParentParent.Generic.TwoStepReqPrompt)
local InsufficientRobuxPrompt = require(ParentParent.Generic.InsufficientRobuxPrompt)
local InsufficientRobuxProductPrompt = require(ParentParent.ProductPurchaseRobuxUpsell.InsufficientRobuxProductPrompt)
local LeaveRobloxPrompt = require(ParentParent.Generic.LeaveRobloxPrompt)
local RobuxUpsellSuccessPrompt = require(ParentParent.ProductPurchaseRobuxUpsell.RobuxUpsellSuccessPrompt)
local RobuxUpsellPrompt = require(ParentParent.ProductPurchaseRobuxUpsell.RobuxUpsellPrompt)
local RobuxUpsellModal = require(ParentParent.ProductPurchaseRobuxUpsell.v2.RobuxUpsellModal)
local RobuxUpsellModalMultiplePackage = require(ParentParent.ProductPurchaseRobuxUpsell.v2.RobuxUpsellModalMultiplePackage)
local RobuxUpsellModalTooExpensive = require(ParentParent.ProductPurchaseRobuxUpsell.v2.RobuxUpsellModalTooExpensive)
local RobuxUpsellModalTooExpensiveFallback = require(ParentParent.ProductPurchaseRobuxUpsell.v2.RobuxUpsellModalTooExpensiveFallback)
local UnifiedRobuxUpsellModal = require(ParentParent.ProductPurchaseRobuxUpsell.v3.UnifiedRobuxUpsellModal)
local UnifiedRobuxUpsellModalTooExpensive = require(ParentParent.ProductPurchaseRobuxUpsell.v3.UnifiedRobuxUpsellModalTooExpensive)
local PurchasePromptLite = require(ParentParentParent.PurchasePromptLite)
local getTTIEventName = PurchasePromptLite.getTTIEventName
local TimeToInteractiveTracker = require(ParentParentParent.TimeToInteractiveTracker).TimeToInteractiveTracker
local ProductPurchaseSurface = PurchasePromptLite.Enums.ProductPurchaseSurface
local getModalShownEventData = require(ParentParent.Utility.getModalShownEventData)
local getUserInputEventData = require(ParentParent.Utility.getUserInputEventData)
local shouldShowNewUpsellModalExperiment = require(ParentParent.Utility.Experiments.shouldShowNewUpsellModalExperiment)
local overlayInGameMenu = require(ParentParent.Utility.overlayInGameMenu)
local DesktopUpsellExperiment = require(ParentParent.Utility.Experiments.DesktopUpsellExperiment)
local getEnableCentralOverlayForUpsellPrompt = require(ParentParent.Flags.getEnableCentralOverlayForUpsellPrompt)
local FFlagEnableUnifiedProductPurchaseFlow = require(ParentParentParent.SharedFlags).FFlagEnableUnifiedProductPurchaseFlow
local getAppContext = require(ParentParent.Utility.getAppContext)
local FFlagMobilePopularItemBadgingExperimentEnabled = require(ParentParent.Flags.FFlagMobilePopularItemBadgingExperimentEnabled)
local UnifiedPurchaseCompletionModalV2 = require(ParentParent.Generic.UnifiedPurchaseCompletionModalV2)
local v41 = Roact.Component:extend(script.Name)
local default = require(ParentParentParent.LoggingProtocol).default
local InGameRobuxUpsellEvent = require(scriptParent.Events.InGameRobuxUpsellEvent)
local Players = game:GetService("Players")
local IntervalPerformanceTracker = require(ParentParentParent.IntervalPerformanceTracker).IntervalPerformanceTracker
local VerifiedParentalConsentDialog = require(ParentParentParent.VerifiedParentalConsentDialog).VerifiedParentalConsentDialog
local UnifiedRobuxUpsellModalV2 = require(ParentParent.ProductPurchaseRobuxUpsell.v4.UnifiedRobuxUpsellModalV2)
local UnifiedRobuxUpsellModalTooExpensiveV2 = require(ParentParent.ProductPurchaseRobuxUpsell.v4.UnifiedRobuxUpsellModalTooExpensiveV2)

require(ParentParent.ProductPurchase.v4.cartPricingResponseLineItem)

local UnifiedPurchaseModalTypeEnum = require(ParentParent.Enums.UnifiedPurchaseModalTypeEnum)
local UnifiedPurchaseCompletionModal = require(ParentParent.Generic.UnifiedPurchaseCompletionModal)
local FFlagUnifiedPurchaseFlowMarketplaceUIImprovements = require(ParentParentParent.SharedFlags).FFlagUnifiedPurchaseFlowMarketplaceUIImprovements
local FFlagAddPerformanceMetricsToUnifiedPurchaseModal = require(ParentParentParent.SharedFlags).FFlagAddPerformanceMetricsToUnifiedPurchaseModal
local FIntLegacyPurchaseFPSTrackingTimeout = require(ParentParentParent.SharedFlags).FIntLegacyPurchaseFPSTrackingTimeout
local FIntTTIUnifiedPurchaseSamplingRate = require(ParentParentParent.SharedFlags).FIntTTIUnifiedPurchaseSamplingRate
local FFlagAddCenterDialogForUnifiedPurchaseModal = require(ParentParentParent.SharedFlags).FFlagAddCenterDialogForUnifiedPurchaseModal

game:DefineFastFlag("DisableNonSchematizedInGameRobuxUpsellEvent", false)
game:DefineFastFlag("EnableSchematizedInGameRobuxUpsellEvent2", false)

local v56 = game:DefineFastFlag("FixUnifiedUpsellCompletionModal", false)

require(ParentParent.ProductPurchase.PricingTypes)
require(ParentParent.ProductPurchase.v3.UnifiedProductPurchaseModalTypes)

local FFlagEnableDiscountInfoInUnifiedPurchaseModal = require(ParentParentParent.SharedFlags).FFlagEnableDiscountInfoInUnifiedPurchaseModal
local FFlagPurchasePromptFetchCartPricing = require(ParentParentParent.SharedFlags).FFlagPurchasePromptFetchCartPricing

require(ParentParent.Api.PaymentsGateway.GetUpsellSuggestionsTypes)

function v41.init(p1) -- line: 182
	-- upvalues: HttpService (copy)
	local props = p1.props

	p1.state = {
		enableInputDelayed = false,
		analyticId = if not props.analyticId then HttpService:GenerateGUID(false) else props.analyticId,
		isDelayedInput = props.isDelayedInput
	}

	function p1.closeModal() -- line: 192
		-- upvalues: p1 (copy)
		local props2 = p1.props

		p1:reportUserInput("Cancel")
		props2.cancelPurchase()
		p1:closeCentralOverlay()
		p1:UnbindActions()
	end
end
function v41.didMount(p2) -- line: 202
	-- upvalues: FFlagAddPerformanceMetricsToUnifiedPurchaseModal (copy), IntervalPerformanceTracker (copy), FIntLegacyPurchaseFPSTrackingTimeout (copy), getTTIEventName (copy), ProductPurchaseSurface (copy), TimeToInteractiveTracker (copy), FIntTTIUnifiedPurchaseSamplingRate (copy)
	if FFlagAddPerformanceMetricsToUnifiedPurchaseModal and (p2.props or {}).eventPrefix == "UACatalog" then
		IntervalPerformanceTracker:startTracking("PurchaseModal_RobuxUpsellModalShown_Catalog", FIntLegacyPurchaseFPSTrackingTimeout, nil, true, true)
		IntervalPerformanceTracker:startTracking("PurchaseModal_LegacyFlowRobuxUpsellModalShown_Catalog", FIntLegacyPurchaseFPSTrackingTimeout, nil, true, true)

		local v62 = getTTIEventName(ProductPurchaseSurface.Catalog)

		TimeToInteractiveTracker.trackEnd(v62, {
			samplingRateOverride = FIntTTIUnifiedPurchaseSamplingRate
		})
	end
end
function v41.didUpdate(t1: {[any]: any}, t2: {[any]: any}, _: {[any]: any}) -- line: 231
	local props = t1.props

	if t2.purchaseState ~= props.purchaseState then
		t1:reportModalShown()
		t1:dispatchCentralOverlayAndRenderModal(props)
	end
end
function v41.UnbindActions(p3) -- line: 240
	-- upvalues: getEnableCentralOverlayForUpsellPrompt (copy), ContextActionService (copy), Constants (copy)
	if getEnableCentralOverlayForUpsellPrompt() and p3.props.dispatchCentralOverlay then
		ContextActionService:UnbindAction(Constants.CLOSE_MODAL_ACTION)
	end
end
function v41.BindCancelAction(p4) -- line: 246
	-- upvalues: getEnableCentralOverlayForUpsellPrompt (copy), ContextActionService (copy), Constants (copy)
	if getEnableCentralOverlayForUpsellPrompt() and p4.props.dispatchCentralOverlay then
		ContextActionService:BindAction(Constants.CLOSE_MODAL_ACTION, p4.closeModal, false, Enum.KeyCode.ButtonB, Enum.KeyCode.Escape)
	end
end
function v41.closeCentralOverlay(p5) -- line: 262
	-- upvalues: getEnableCentralOverlayForUpsellPrompt (copy)
	local props = p5.props

	if getEnableCentralOverlayForUpsellPrompt() and props.dispatchCentralOverlay then
		props.dispatchCentralOverlay()
	end
end
function v41.constructRobuxUpsellPromptAnimatorObj(p6) -- line: 270
	-- upvalues: RobuxUpsellFlowState (copy), FFlagEnableUnifiedProductPurchaseFlow (copy), FFlagAddCenterDialogForUnifiedPurchaseModal (copy), getAppContext (copy), Roact (copy), UnifiedRobuxUpsellModalV2 (copy), FFlagEnableDiscountInfoInUnifiedPurchaseModal (copy), FFlagUnifiedPurchaseFlowMarketplaceUIImprovements (copy), FFlagPurchasePromptFetchCartPricing (copy), UnifiedRobuxUpsellModal (copy), overlayInGameMenu (copy), RobuxUpsellModalMultiplePackage (copy), shouldShowNewUpsellModalExperiment (copy), DesktopUpsellExperiment (copy), RobuxUpsellModal (copy), RobuxUpsellPrompt (copy), FFlagMobilePopularItemBadgingExperimentEnabled (copy)
	local props = p6.props
	local state = p6.state

	p6:BindCancelAction()

	return {
		shouldAnimate = props.shouldAnimate,
		shouldShow = props.purchaseState == RobuxUpsellFlowState.PurchaseModal,
		skipAnimation = if not FFlagEnableUnifiedProductPurchaseFlow then nil else props.useUnifiedProductPurchaseModal,
		onShown = props.isDelayedInput and function() -- line: 282
			-- upvalues: p6 (copy), props (copy)
			p6:setState({
				enableInputDelayed = true
			})
			delay(3, function() -- line: 286
				-- upvalues: p6 (copy), props (copy)
				p6:setState({
					isDelayedInput = false,
					enableInputDelayed = false
				})

				if props.onDelayedInputComplete then
					props.onDelayedInputComplete()
				end
			end)
		end or nil,
		onHidden = props.isDelayedInput and function() -- line: 296
			-- upvalues: p6 (copy), props (copy)
			p6:setState({
				enableInputDelayed = false,
				isDelayedInput = props.isDelayedInput
			})
		end or nil,
		renderChildren = function() -- line: 302
			-- upvalues: FFlagEnableUnifiedProductPurchaseFlow (copy), props (copy), FFlagAddCenterDialogForUnifiedPurchaseModal (copy), getAppContext (copy), Roact (copy), UnifiedRobuxUpsellModalV2 (copy), FFlagEnableDiscountInfoInUnifiedPurchaseModal (copy), FFlagUnifiedPurchaseFlowMarketplaceUIImprovements (copy), FFlagPurchasePromptFetchCartPricing (copy), p6 (copy), state (copy), UnifiedRobuxUpsellModal (copy), overlayInGameMenu (copy), RobuxUpsellModalMultiplePackage (copy), shouldShowNewUpsellModalExperiment (copy), DesktopUpsellExperiment (copy), RobuxUpsellModal (copy), RobuxUpsellPrompt (copy), FFlagMobilePopularItemBadgingExperimentEnabled (copy)
			if FFlagEnableUnifiedProductPurchaseFlow and props.useUnifiedProductPurchaseModal then
				if FFlagAddCenterDialogForUnifiedPurchaseModal and getAppContext() == "UA" then
					return Roact.createElement(UnifiedRobuxUpsellModalV2, {
						product = {
							model = props.model,
							itemIcon = props.itemIcon,
							itemName = props.itemName,
							itemRobuxCost = props.itemRobuxCost,
							badgeType = props.virtualItemBadgeType,
							itemPrice = if not FFlagEnableDiscountInfoInUnifiedPurchaseModal then nil else props.virtualItemPrice
						},
						userBalance = props.beforeRobuxBalance,
						upsellSuggestions = props.upsellSuggestions,
						selectedUpsellIndex = props.selectedUpsellIndex,
						onUpsellSuggestionsSelected = props.onUpsellSuggestionsSelected,
						purchaseModalType = props.unifiedProductPurchaseModalType,
						onBuyItemButtonMounted = props.onBuyItemButtonMounted,
						hideUserRobuxBalance = if not FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then nil else props.hideUserRobuxBalance,
						cartPricingResponse = if not FFlagPurchasePromptFetchCartPricing then nil else props.cartPricingResponse,
						collectibleItemId = if not FFlagPurchasePromptFetchCartPricing then nil else props.collectibleItemId,
						isCartPricingLoading = if not FFlagPurchasePromptFetchCartPricing then nil else props.isCartPricingLoading,
						onCartOfferAppliedChanged = if not FFlagPurchasePromptFetchCartPricing then nil else props.onCartOfferAppliedChanged,
						postPurchaseActions = if not FFlagPurchasePromptFetchCartPricing then nil else props.postPurchaseActions,
						setPostPurchaseActions = if not FFlagPurchasePromptFetchCartPricing then nil else props.setPostPurchaseActions,
						buttons = {
							buyItemActivated = function() -- line: 344
								-- upvalues: p6 (copy), props (copy)
								p6:reportUserInput("Buy")
								props.purchaseRobux()
								p6:closeCentralOverlay()
							end,
							buyItemControllerIcon = props.acceptControllerIcon,
							buyItemisDelayedInput = state.isDelayedInput,
							buyItemEnableInputDelayed = state.enableInputDelayed and getAppContext() == "IN_EXPERIENCE",
							cancelPurchaseActivated = function() -- line: 352
								-- upvalues: p6 (copy), props (copy)
								p6:reportUserInput("Cancel")
								props.cancelPurchase()
								p6:closeCentralOverlay()
							end,
							cancelControllerIcon = props.cancelControllerIcon
						},
						termsOfUseActivated = props.showTermsOfUse and function() -- line: 359
							-- upvalues: p6 (copy), props (copy)
							p6:reportUserInput("TermsOfService")
							props.showTermsOfUse()
							props.flowComplete()
						end or nil,
						screenSize = props.screenSize
					})
				end

				return Roact.createElement(UnifiedRobuxUpsellModal, {
					product = {
						model = props.model,
						itemIcon = props.itemIcon,
						itemName = props.itemName,
						itemRobuxCost = props.itemRobuxCost,
						badgeType = props.virtualItemBadgeType,
						itemPrice = if not FFlagEnableDiscountInfoInUnifiedPurchaseModal then nil else props.virtualItemPrice
					},
					userBalance = props.beforeRobuxBalance,
					upsellSuggestions = props.upsellSuggestions,
					selectedUpsellIndex = props.selectedUpsellIndex,
					onUpsellSuggestionsSelected = props.onUpsellSuggestionsSelected,
					purchaseModalType = props.unifiedProductPurchaseModalType,
					onBuyItemButtonMounted = props.onBuyItemButtonMounted,
					hideUserRobuxBalance = if not FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then nil else props.hideUserRobuxBalance,
					buttons = {
						buyItemActivated = function() -- line: 388
							-- upvalues: p6 (copy), props (copy)
							p6:reportUserInput("Buy")
							props.purchaseRobux()
							p6:closeCentralOverlay()
						end,
						buyItemControllerIcon = props.acceptControllerIcon,
						buyItemisDelayedInput = state.isDelayedInput,
						buyItemEnableInputDelayed = state.enableInputDelayed and getAppContext() == "IN_EXPERIENCE",
						cancelPurchaseActivated = function() -- line: 398
							-- upvalues: p6 (copy), props (copy)
							p6:reportUserInput("Cancel")
							props.cancelPurchase()
							p6:closeCentralOverlay()
						end,
						cancelControllerIcon = props.cancelControllerIcon
					},
					termsOfUseActivated = props.showTermsOfUse and function() -- line: 405
						-- upvalues: p6 (copy), props (copy)
						p6:reportUserInput("TermsOfService")
						props.showTermsOfUse()
						props.flowComplete()
					end or nil,
					screenSize = props.screenSize
				})
			end

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
						buyItemActivated = function() -- line: 427
							-- upvalues: p6 (copy), props (copy)
							p6:reportUserInput("Buy")
							props.purchaseRobux()
							p6:closeCentralOverlay()
						end,
						buyItemControllerIcon = props.acceptControllerIcon,
						buyItemisDelayedInput = state.isDelayedInput,
						buyItemEnableInputDelayed = state.enableInputDelayed,
						cancelPurchaseActivated = function() -- line: 437
							-- upvalues: p6 (copy), props (copy)
							p6:reportUserInput("Cancel")
							props.cancelPurchase()
							p6:closeCentralOverlay()
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
						buyItemActivated = function() -- line: 465
							-- upvalues: p6 (copy), props (copy)
							p6:reportUserInput("Buy")
							props.purchaseRobux()
							p6:closeCentralOverlay()
						end,
						buyItemControllerIcon = props.acceptControllerIcon,
						buyItemisDelayedInput = state.isDelayedInput,
						buyItemEnableInputDelayed = state.enableInputDelayed,
						cancelPurchaseActivated = function() -- line: 475
							-- upvalues: p6 (copy), props (copy)
							p6:reportUserInput("Cancel")
							props.cancelPurchase()
							p6:closeCentralOverlay()
						end,
						cancelControllerIcon = props.cancelControllerIcon,
						opensBuyRobuxPage = DesktopUpsellExperiment.getVariant() == DesktopUpsellExperiment.variants.OpenRobuxStore
					},
					isQuest = props.isQuest,
					isVng = props.isVng,
					termsOfUseActivated = props.showTermsOfUse and function() -- line: 486
						-- upvalues: p6 (copy), props (copy)
						p6:reportUserInput("TermsOfService")
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
				buyItemActivated = function() -- line: 510
					-- upvalues: p6 (copy), props (copy)
					p6:reportUserInput("Buy")
					props.purchaseRobux()
					p6:closeCentralOverlay()
				end,
				cancelPurchaseActivated = function() -- line: 515
					-- upvalues: p6 (copy), props (copy)
					p6:reportUserInput("Cancel")
					props.cancelPurchase()
					p6:closeCentralOverlay()
				end,
				termsOfUseActivated = props.showTermsOfUse and function() -- line: 520
					-- upvalues: p6 (copy), props (copy)
					p6:reportUserInput("TermsOfService")
					props.showTermsOfUse()
				end or nil,
				isQuest = p6.props.isQuest,
				isVng = p6.props.isVng
			})
		end
	}
end
function v41.constructU13ConfirmPromptAnimatorObj(p7) -- line: 531
	-- upvalues: RobuxUpsellFlowState (copy), Roact (copy), U13ConfirmPrompt (copy)
	local props = p7.props

	p7:BindCancelAction()

	return {
		shouldAnimate = props.shouldAnimate,
		shouldShow = props.purchaseState == RobuxUpsellFlowState.PurchaseWarning,
		renderChildren = function() -- line: 539
			-- upvalues: Roact (copy), U13ConfirmPrompt (copy), props (copy), p7 (copy)
			return Roact.createElement(U13ConfirmPrompt, {
				screenSize = props.screenSize,
				modalType = props.u13ConfirmType,
				doneControllerIcon = props.acceptControllerIcon,
				cancelControllerIcon = props.cancelControllerIcon,
				doneActivated = function() -- line: 548
					-- upvalues: p7 (copy), props (copy)
					p7:reportUserInput("Confirm")
					props.acceptPurchaseWarning()
					p7:closeCentralOverlay()
				end,
				cancelActivated = function() -- line: 553
					-- upvalues: p7 (copy), props (copy)
					p7:reportUserInput("Cancel")
					props.cancelPurchase()
					p7:closeCentralOverlay()
				end
			})
		end
	}
end
function v41.constructPurchaseErrorPromptAnimatorObj(p8) -- line: 563
	-- upvalues: RobuxUpsellFlowState (copy), FFlagEnableUnifiedProductPurchaseFlow (copy), PurchaseErrorType (copy), FFlagAddCenterDialogForUnifiedPurchaseModal (copy), Roact (copy), UnifiedRobuxUpsellModalTooExpensiveV2 (copy), UnifiedRobuxUpsellModalTooExpensive (copy), FFlagUnifiedPurchaseFlowMarketplaceUIImprovements (copy), shouldShowNewUpsellModalExperiment (copy), DesktopUpsellExperiment (copy), RobuxUpsellModalTooExpensiveFallback (copy), PurchaseErrorPrompt (copy)
	local props = p8.props

	p8:BindCancelAction()

	return {
		shouldAnimate = props.shouldAnimate,
		shouldShow = props.purchaseState == RobuxUpsellFlowState.Error,
		renderChildren = function() -- line: 571
			-- upvalues: FFlagEnableUnifiedProductPurchaseFlow (copy), props (copy), PurchaseErrorType (copy), FFlagAddCenterDialogForUnifiedPurchaseModal (copy), Roact (copy), UnifiedRobuxUpsellModalTooExpensiveV2 (copy), p8 (copy), UnifiedRobuxUpsellModalTooExpensive (copy), FFlagUnifiedPurchaseFlowMarketplaceUIImprovements (copy), shouldShowNewUpsellModalExperiment (copy), DesktopUpsellExperiment (copy), RobuxUpsellModalTooExpensiveFallback (copy), PurchaseErrorPrompt (copy)
			if FFlagEnableUnifiedProductPurchaseFlow and props.errorType == PurchaseErrorType.NotEnoughRobuxInApp then
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
							buyItemActivated = function() -- line: 588
								-- upvalues: p8 (copy), props (copy)
								p8:reportUserInput("Buy Robux")
								props.openBuyRobux()
								props.flowComplete()
								p8:closeCentralOverlay()
							end,
							cancelPurchaseActivated = function() -- line: 594
								-- upvalues: p8 (copy), props (copy)
								p8:reportUserInput("Cancel")
								props.flowComplete()
								p8:closeCentralOverlay()
							end
						},
						purchaseModalType = props.unifiedProductPurchaseModalType,
						screenSize = props.screenSize
					}))
				end

				return (Roact.createElement(UnifiedRobuxUpsellModalTooExpensive, {
					product = {
						model = props.model,
						itemIcon = props.itemIcon,
						itemName = props.itemName,
						itemRobuxCost = props.itemRobuxCost
					},
					balanceAmount = props.beforeRobuxBalance,
					hideUserRobuxBalance = if not FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then nil else props.hideUserRobuxBalance,
					buttons = {
						buyItemActivated = function() -- line: 619
							-- upvalues: p8 (copy), props (copy)
							p8:reportUserInput("Buy Robux")
							props.openBuyRobux()
							props.flowComplete()
							p8:closeCentralOverlay()
						end,
						cancelPurchaseActivated = function() -- line: 626
							-- upvalues: p8 (copy), props (copy)
							p8:reportUserInput("Cancel")
							props.flowComplete()
							p8:closeCentralOverlay()
						end
					},
					isQuest = props.isQuest,
					screenSize = props.screenSize,
					purchaseModalType = props.unifiedProductPurchaseModalType
				}))
			end

			if props.errorType == PurchaseErrorType.NotEnoughRobux and (shouldShowNewUpsellModalExperiment() or DesktopUpsellExperiment.shouldShowNewModal()) then
				return Roact.createElement(RobuxUpsellModalTooExpensiveFallback, {
					product = {
						model = props.model,
						itemIcon = props.itemIcon,
						itemName = props.itemName,
						itemRobuxCost = props.itemRobuxCost
					},
					balanceAmount = props.beforeRobuxBalance,
					doneActivated = function() -- line: 652
						-- upvalues: p8 (copy), props (copy)
						p8:reportUserInput("Done")
						props.flowComplete()
						p8:closeCentralOverlay()
					end,
					doneControllerIcon = props.acceptControllerIcon,
					isQuest = props.isQuest,
					screenSize = props.screenSize
				})
			end

			return Roact.createElement(PurchaseErrorPrompt, {
				screenSize = props.screenSize,
				errorType = props.errorType,
				economicRestrictionError = props.economicRestrictionError,
				doneControllerIcon = props.acceptControllerIcon,
				doneActivated = function() -- line: 670
					-- upvalues: p8 (copy), props (copy)
					p8:reportUserInput("Done")
					props.flowComplete()
					p8:closeCentralOverlay()
				end
			})
		end
	}
end
function v41.constructTwoStepRequiredAnimatorObj(p9) -- line: 680
	-- upvalues: RobuxUpsellFlowState (copy), Roact (copy), TwoStepReqPrompt (copy)
	local props = p9.props

	p9:BindCancelAction()

	return {
		shouldAnimate = props.shouldAnimate,
		shouldShow = props.purchaseState == RobuxUpsellFlowState.TwoStepRequired,
		renderChildren = function() -- line: 688
			-- upvalues: Roact (copy), TwoStepReqPrompt (copy), props (copy), p9 (copy)
			return Roact.createElement(TwoStepReqPrompt, {
				screenSize = props.screenSize,
				doneControllerIcon = props.acceptControllerIcon,
				openSecuritySettings = function() -- line: 694
					-- upvalues: p9 (copy), props (copy)
					p9:reportUserInput("GoToSecuritySettings")
					props.openSecuritySettings()
					props.flowComplete()
					p9:closeCentralOverlay()
				end,
				closePrompt = function() -- line: 700
					-- upvalues: p9 (copy), props (copy)
					p9:reportUserInput("Cancel")
					props.flowComplete()
					p9:closeCentralOverlay()
				end
			})
		end
	}
end
function v41.constructRobuxUpsellSuccessPromptAnimatorObj(p10) -- line: 710
	-- upvalues: RobuxUpsellFlowState (copy), FFlagEnableUnifiedProductPurchaseFlow (copy), v56 (copy), getAppContext (copy), Roact (copy), UnifiedPurchaseCompletionModalV2 (copy), UnifiedPurchaseModalTypeEnum (copy), UnifiedPurchaseCompletionModal (copy), RobuxUpsellSuccessPrompt (copy)
	local props = p10.props

	p10:BindCancelAction()

	return {
		shouldAnimate = props.shouldAnimate,
		shouldShow = props.purchaseState == RobuxUpsellFlowState.Success,
		renderChildren = function() -- line: 718
			-- upvalues: props (copy), FFlagEnableUnifiedProductPurchaseFlow (copy), v56 (copy), getAppContext (copy), Roact (copy), UnifiedPurchaseCompletionModalV2 (copy), p10 (copy), UnifiedPurchaseModalTypeEnum (copy), UnifiedPurchaseCompletionModal (copy), RobuxUpsellSuccessPrompt (copy)
			local v110 = props.beforeRobuxBalance - props.itemRobuxCost
			local v111 = if not (v110 < 0) then v110 else v110 + props.iapRobuxAmount

			if FFlagEnableUnifiedProductPurchaseFlow and props.useUnifiedProductPurchaseModal then
				if v56 and getAppContext() == "UA" then
					return Roact.createElement(UnifiedPurchaseCompletionModalV2, {
						buttons = {
							onActivated = function() -- line: 729
								-- upvalues: p10 (copy), props (copy)
								p10:reportUserInput("Done")
								props.flowComplete()
								p10:closeCentralOverlay()
							end
						},
						isMultiItem = props.unifiedProductPurchaseModalType == UnifiedPurchaseModalTypeEnum.MultiItem,
						itemName = props.itemName
					})
				end

				return Roact.createElement(UnifiedPurchaseCompletionModal, {
					buttons = {
						onActivated = function() -- line: 741
							-- upvalues: p10 (copy), props (copy)
							p10:reportUserInput("Done")
							props.flowComplete()
							p10:closeCentralOverlay()
						end
					},
					isMultiItem = props.unifiedProductPurchaseModalType == UnifiedPurchaseModalTypeEnum.MultiItem,
					itemName = props.itemName
				})
			end

			return Roact.createElement(RobuxUpsellSuccessPrompt, {
				screenSize = props.screenSize,
				model = props.model,
				itemIcon = props.itemIcon,
				itemName = props.itemName,
				balance = v111,
				confirmControllerIcon = props.acceptControllerIcon,
				cancelControllerIcon = props.cancelControllerIcon,
				doneActivated = function() -- line: 760
					-- upvalues: p10 (copy), props (copy)
					p10:reportUserInput("Done")
					props.flowComplete()
					p10:closeCentralOverlay()
				end,
				equipActivated = props.equipItem and function() -- line: 765
					-- upvalues: p10 (copy), props (copy)
					p10:reportUserInput("Equip")
					props.equipItem()
					p10:closeCentralOverlay()
				end or nil
			})
		end
	}
end
function v41.constructInsufficientRobuxAnimatorObj(p11) -- line: 775
	-- upvalues: RobuxUpsellFlowState (copy), shouldShowNewUpsellModalExperiment (copy), DesktopUpsellExperiment (copy), Roact (copy), RobuxUpsellModalTooExpensive (copy), InsufficientRobuxPrompt (copy)
	local props = p11.props

	p11:BindCancelAction()

	return {
		shouldAnimate = props.shouldAnimate,
		shouldShow = props.purchaseState == RobuxUpsellFlowState.GenericPurchaseModal,
		renderChildren = function() -- line: 783
			-- upvalues: shouldShowNewUpsellModalExperiment (copy), DesktopUpsellExperiment (copy), Roact (copy), RobuxUpsellModalTooExpensive (copy), props (copy), p11 (copy), InsufficientRobuxPrompt (copy)
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
						buyItemActivated = function() -- line: 795
							-- upvalues: p11 (copy), props (copy)
							p11:reportUserInput("Buy Robux")
							props.openBuyRobux()
							props.flowComplete()
							p11:closeCentralOverlay()
						end,
						buyItemControllerIcon = props.acceptControllerIcon,
						cancelPurchaseActivated = function() -- line: 803
							-- upvalues: p11 (copy), props (copy)
							p11:reportUserInput("Cancel")
							props.flowComplete()
							p11:closeCentralOverlay()
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
				buyRobux = function() -- line: 819
					-- upvalues: p11 (copy), props (copy)
					p11:reportUserInput("Buy Robux")
					props.openBuyRobux()
					props.flowComplete()
					p11:closeCentralOverlay()
				end,
				closePrompt = function() -- line: 825
					-- upvalues: p11 (copy), props (copy)
					p11:reportUserInput("Cancel")
					props.flowComplete()
					p11:closeCentralOverlay()
				end
			})
		end
	}
end
function v41.constructInsufficientRobuxProductAnimatorObj(p12) -- line: 835
	-- upvalues: RobuxUpsellFlowState (copy), Roact (copy), InsufficientRobuxProductPrompt (copy)
	local props = p12.props

	p12:BindCancelAction()

	return {
		shouldAnimate = props.shouldAnimate,
		shouldShow = props.purchaseState == RobuxUpsellFlowState.LargeRobuxPurchaseModal,
		renderChildren = function() -- line: 843
			-- upvalues: Roact (copy), InsufficientRobuxProductPrompt (copy), props (copy), p12 (copy)
			return Roact.createElement(InsufficientRobuxProductPrompt, {
				screenSize = props.screenSize,
				model = props.model,
				itemIcon = props.itemIcon,
				itemName = props.itemName,
				itemRobuxCost = props.itemRobuxCost,
				balanceAmount = props.beforeRobuxBalance,
				acceptControllerIcon = props.acceptControllerIcon,
				cancelControllerIcon = props.cancelControllerIcon,
				robuxStoreActivated = function() -- line: 856
					-- upvalues: p12 (copy), props (copy)
					p12:reportUserInput("Go to Robux store")
					props.openBuyRobux()
					p12:closeCentralOverlay()
				end,
				cancelPurchaseActivated = function() -- line: 861
					-- upvalues: p12 (copy), props (copy)
					p12:reportUserInput("Cancel")
					props.flowComplete()
					p12:closeCentralOverlay()
				end
			})
		end
	}
end
function v41.constructLeaveRobloxPromptAnimatorObj(p13) -- line: 871
	-- upvalues: RobuxUpsellFlowState (copy), Roact (copy), LeaveRobloxPrompt (copy)
	local props = p13.props

	p13:BindCancelAction()

	return {
		shouldAnimate = props.shouldAnimate,
		shouldShow = props.purchaseState == RobuxUpsellFlowState.LeaveRobloxWarning,
		renderChildren = function() -- line: 879
			-- upvalues: Roact (copy), LeaveRobloxPrompt (copy), props (copy), p13 (copy)
			return Roact.createElement(LeaveRobloxPrompt, {
				screenSize = props.screenSize,
				cancelActivated = function() -- line: 883
					-- upvalues: p13 (copy)
					p13:closeCentralOverlay()
				end,
				continueActivated = function() -- line: 886
					-- upvalues: props (copy)
					props.openVngShop()
				end
			})
		end
	}
end
function v41.constructPurchaseVPCPromptAnimatorObj(p14) -- line: 894
	-- upvalues: RobuxUpsellFlowState (copy), Roact (copy), VerifiedParentalConsentDialog (copy)
	local props = p14.props

	p14:BindCancelAction()

	return {
		shouldAnimate = props.shouldAnimate,
		shouldShow = props.purchaseState == RobuxUpsellFlowState.PurchaseVPCModal,
		renderChildren = function() -- line: 902
			-- upvalues: Roact (copy), VerifiedParentalConsentDialog (copy), props (copy), p14 (copy)
			return Roact.createElement(VerifiedParentalConsentDialog, {
				screenSize = props.screenSize,
				isActionable = props.openSettingsPage ~= nil,
				modalType = props.purchaseVPCType,
				onAction = props.openSettingsPage and function() -- line: 907
					-- upvalues: p14 (copy), props (copy)
					p14:reportUserInput("Confirm")
					props.openSettingsPage()
					props.flowComplete()
				end,
				onDismiss = function() -- line: 912
					-- upvalues: p14 (copy), props (copy)
					p14:reportUserInput("Cancel")
					props.cancelPurchase()
					p14:closeCentralOverlay()
				end
			})
		end
	}
end
function v41.dispatchCentralOverlayAndRenderModal(t4: {[any]: any}, t5: {[any]: any}) -- line: 924
	-- upvalues: getEnableCentralOverlayForUpsellPrompt (copy), RobuxUpsellFlowState (copy), Constants (copy)
	if not getEnableCentralOverlayForUpsellPrompt() or not t5.dispatchCentralOverlay then
		return
	end

	local purchaseState = t5.purchaseState

	if purchaseState == RobuxUpsellFlowState.PurchaseModal then
		t5.dispatchCentralOverlay(Constants.CENTRAL_OVERLAY_TYPE_ANIMATOR, t4:constructRobuxUpsellPromptAnimatorObj())

		return
	end

	if purchaseState == RobuxUpsellFlowState.PurchaseWarning then
		t5.dispatchCentralOverlay(Constants.CENTRAL_OVERLAY_TYPE_ANIMATOR, t4:constructU13ConfirmPromptAnimatorObj())
	end

	if purchaseState == RobuxUpsellFlowState.Error then
		t5.dispatchCentralOverlay(Constants.CENTRAL_OVERLAY_TYPE_ANIMATOR, t4:constructPurchaseErrorPromptAnimatorObj())
	end

	if purchaseState == RobuxUpsellFlowState.TwoStepRequired then
		t5.dispatchCentralOverlay(Constants.CENTRAL_OVERLAY_TYPE_ANIMATOR, t4:constructTwoStepRequiredAnimatorObj())
	end

	if purchaseState == RobuxUpsellFlowState.Success then
		t5.dispatchCentralOverlay(Constants.CENTRAL_OVERLAY_TYPE_ANIMATOR, t4:constructRobuxUpsellSuccessPromptAnimatorObj())
	end

	if purchaseState == RobuxUpsellFlowState.GenericPurchaseModal then
		t5.dispatchCentralOverlay(Constants.CENTRAL_OVERLAY_TYPE_ANIMATOR, t4:constructInsufficientRobuxAnimatorObj())
	end

	if purchaseState == RobuxUpsellFlowState.LargeRobuxPurchaseModal then
		t5.dispatchCentralOverlay(Constants.CENTRAL_OVERLAY_TYPE_ANIMATOR, t4:constructInsufficientRobuxProductAnimatorObj())
	end

	if purchaseState == RobuxUpsellFlowState.LeaveRobloxWarning then
		t5.dispatchCentralOverlay(Constants.CENTRAL_OVERLAY_TYPE_ANIMATOR, t4:constructLeaveRobloxPromptAnimatorObj())
	end

	if purchaseState == RobuxUpsellFlowState.PurchaseVPCModal then
		t5.dispatchCentralOverlay(Constants.CENTRAL_OVERLAY_TYPE_ANIMATOR, t4:constructPurchaseVPCPromptAnimatorObj())
	end
end
function v41.reportModalShown(p15) -- line: 1005
	-- upvalues: getModalShownEventData (copy), RobuxUpsellFlowState (copy), HttpService (copy)
	local props = p15.props
	local state = p15.state

	if not p15.props.onAnalyticEvent then
		return
	end

	local v96 = getModalShownEventData(state.analyticId, props.eventPrefix, "RobuxUpsell", RobuxUpsellFlowState.toRawValue(props.purchaseState), HttpService:JSONEncode({
		universe_id = tostring(game.GameId),
		item_product_id = tostring(props.itemProductId),
		item_name = props.itemName,
		price = tostring(props.itemRobuxCost),
		user_balance = tostring(props.beforeRobuxBalance) or nil,
		package_robux_amount = tostring(props.iapRobuxAmount) or nil,
		package_cost = props.iapCostStr or nil
	}))

	props.onAnalyticEvent("UserPurchaseFlow", v96)
end
function v41.reportUserInput(t6: {[any]: any}, s1: string) -- line: 1034
	-- upvalues: getUserInputEventData (copy), RobuxUpsellFlowState (copy), HttpService (copy), Players (copy), default (copy), InGameRobuxUpsellEvent (copy)
	local props = t6.props
	local state = t6.state
	local v101 = getUserInputEventData(state.analyticId, props.eventPrefix, "RobuxUpsell", RobuxUpsellFlowState.toRawValue(props.purchaseState), s1, HttpService:JSONEncode({
		universe_id = tostring(game.GameId),
		item_product_id = tostring(props.itemProductId),
		item_name = props.itemName,
		price = tostring(props.itemRobuxCost),
		user_balance = tostring(props.beforeRobuxBalance) or nil,
		package_robux_amount = tostring(props.iapRobuxAmount) or nil,
		package_cost = props.iapCostStr or nil
	}))

	if not game:GetFastFlag("DisableNonSchematizedInGameRobuxUpsellEvent") and t6.props.onAnalyticEvent then
		props.onAnalyticEvent("UserPurchaseFlow", v101)
	end

	if game:GetFastFlag("EnableSchematizedInGameRobuxUpsellEvent2") then
		local UserId = nil

		if Players.LocalPlayer and Players.LocalPlayer.UserId > 0 then
			UserId = Players.LocalPlayer.UserId
		end

		default:logRobloxTelemetryEvent(InGameRobuxUpsellEvent, {
			default.StandardizedFields.addOsInfo,
			default.StandardizedFields.addSessionId
		}, {
			universe_id = game.GameId,
			price = props.itemRobuxCost,
			view_name = v101.view_name,
			purchase_event_type = v101.purchase_event_type,
			input_type = s1,
			user_id = tostring(UserId)
		})
	end
end
function v41.purchaseStateToOverlayState(_, p17) -- line: 1080
	-- upvalues: RobuxUpsellFlowState (copy), LoadingOverlayState (copy)
	if p17 == RobuxUpsellFlowState.Loading then
		return LoadingOverlayState.Loading
	end

	if p17 == RobuxUpsellFlowState.RobuxPurchasePending then
		return LoadingOverlayState.PurchasingRobux
	end

	if p17 == RobuxUpsellFlowState.RobuxGrantPending then
		return LoadingOverlayState.WaitingForRobux
	end

	if p17 == RobuxUpsellFlowState.ItemPurchasePending then
		return LoadingOverlayState.PurchasingItem
	end

	if p17 == RobuxUpsellFlowState.None then
		return nil
	end

	return LoadingOverlayState.None
end
function v41.getChildrenElements(p18) -- line: 1097
	-- upvalues: Roact (copy), Animator (copy)
	return {
		RobuxUpsellPromptAnimator = Roact.createElement(Animator, p18:constructRobuxUpsellPromptAnimatorObj()),
		U13ConfirmPromptAnimator = Roact.createElement(Animator, p18:constructU13ConfirmPromptAnimatorObj()),
		PurchaseErrorPromptAnimator = Roact.createElement(Animator, p18:constructPurchaseErrorPromptAnimatorObj()),
		TwoStepRequiredAnimator = Roact.createElement(Animator, p18:constructTwoStepRequiredAnimatorObj()),
		RobuxUpsellSuccessPromptAnimator = Roact.createElement(Animator, p18:constructRobuxUpsellSuccessPromptAnimatorObj()),
		InsufficientRobuxAnimator = Roact.createElement(Animator, p18:constructInsufficientRobuxAnimatorObj()),
		InsufficientRobuxProductAnimator = Roact.createElement(Animator, p18:constructInsufficientRobuxProductAnimatorObj()),
		PurchaseVPCPromptAnimator = Roact.createElement(Animator, p18:constructPurchaseVPCPromptAnimatorObj())
	}
end
function v41.render(p19) -- line: 1116
	-- upvalues: getEnableCentralOverlayForUpsellPrompt (copy), Roact (copy), LoadingOverlay (copy)
	local props = p19.props
	local t7 = {}

	if not getEnableCentralOverlayForUpsellPrompt() or not props.dispatchCentralOverlay then
		t7 = p19:getChildrenElements()
	end

	return Roact.createElement(LoadingOverlay, {
		shouldAnimate = props.shouldAnimate,
		loadingState = p19:purchaseStateToOverlayState(props.purchaseState)
	}, t7)
end

return v41
