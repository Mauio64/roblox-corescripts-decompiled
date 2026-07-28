local GuiService = game:GetService("GuiService")
local ContextActionService = game:GetService("ContextActionService")
local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local PurchasePromptDeps = require(PurchasePromptParent.PurchasePromptDeps)
local Roact = PurchasePromptDeps.Roact
local React = require(PurchasePromptParent.React)
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local CachedPolicyService = require(PurchasePromptParent.CachedPolicyService)
local RobloxTranslator = require(PurchasePromptParent.RobloxTranslator)
local UIBlox = PurchasePromptDeps.UIBlox
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Images = UIBlox.App.ImageSet.Images
local IAPExperience = require(PurchasePromptParent.IAPExperience)
local ProductPurchase = IAPExperience.ProductPurchase
local ProductPurchaseRobuxUpsell = IAPExperience.ProductPurchaseRobuxUpsell
local LeaveRobloxAlert = IAPExperience.LeaveRobloxAlert
local Animator = IAPExperience.Animator
local UnifiedProductPurchaseModal = IAPExperience.UnifiedProductPurchaseModal
local UnifiedProductPurchaseModalV2 = IAPExperience.UnifiedProductPurchaseModalV2
local RobloxSubscriptionPurchaseApp = require(PurchasePromptParent.RobloxSubscriptionPurchaseApp)
local getBlackbirdUpsellBannerProductInfo = require(PurchasePrompt.Utils.getBlackbirdUpsellBannerProductInfo)
local RobloxSubscriptionFlowCompleteReason = RobloxSubscriptionPurchaseApp.RobloxSubscriptionFlowCompleteReason
local SurfaceName = RobloxSubscriptionPurchaseApp.SurfaceName
local SurfaceContext = RobloxSubscriptionPurchaseApp.SurfaceContext
local PurchaseClientSessionIdType = RobloxSubscriptionPurchaseApp.PurchaseClientSessionIdType
local SetWindowState = require(PurchasePrompt.Actions.SetWindowState)
local PurchaseFlow = require(PurchasePrompt.Enums.PurchaseFlow)
local RequestType = require(PurchasePrompt.Enums.RequestType)
local PromptState = require(PurchasePrompt.Enums.PromptState)
local WindowState = require(PurchasePrompt.Enums.WindowState)
local PurchaseError = require(PurchasePrompt.Enums.PurchaseError)
local _ = require(PurchasePrompt.types).ProductTypeEnum
local hideWindow = require(PurchasePrompt.Thunks.hideWindow)
local retryPurchaseAfterUpsell = require(PurchasePrompt.Thunks.retryPurchaseAfterUpsell)
local completeRequest = require(PurchasePrompt.Thunks.completeRequest)
local purchaseItem = require(PurchasePrompt.Thunks.purchaseItem)
local completePurchase = require(PurchasePrompt.Thunks.completePurchase)
local launchRobuxUpsell = require(PurchasePrompt.Thunks.launchRobuxUpsell)
local openSecuritySettings = require(PurchasePrompt.Thunks.openSecuritySettings)
local isMockingPurchases = require(PurchasePrompt.Utils.isMockingPurchases)
local connectToStore = require(PurchasePrompt.connectToStore)
local sendEvent = require(PurchasePrompt.Thunks.sendEvent)
local PublishAssetAnalytics = require(PurchasePrompt.Utils.PublishAssetAnalytics)
local ExternalEventConnection = require(PurchasePrompt.Components.Connection.ExternalEventConnection)
local LocalizationService = require(PurchasePrompt.Localization.LocalizationService)
local getPlayerPrice = require(PurchasePrompt.Utils.getPlayerPrice)
local isGenericChallengeResponse = require(PurchasePrompt.Utils.isGenericChallengeResponse)
local SelectedRobuxPackage = require(PurchasePrompt.Utils.SelectedRobuxPackage)
local ProductPurchaseSurface = require(PurchasePromptParent.PurchasePromptLite).Enums.ProductPurchaseSurface
local logUnifiedPurchaseTelemetryCounter = require(PurchasePrompt.Utils.logUnifiedPurchaseTelemetryCounter)
local emitPerformanceMetrics = require(PurchasePrompt.Utils.emitPerformanceMetrics)
local initiateUserPurchaseSettingsPrecheck = require(PurchasePrompt.Thunks.initiateUserPurchaseSettingsPrecheck)
local VerifiedParentalConsentDialog = require(PurchasePromptParent.VerifiedParentalConsentDialog).VerifiedParentalConsentDialog
local VPCModalType = require(PurchasePrompt.Enums.VPCModalType)
local Animator2 = require(script.Parent.Animator)
local SharedFlags = require(PurchasePromptParent.SharedFlags)
local FFlagAddCursorProviderToPurchasePromptApp = SharedFlags.FFlagAddCursorProviderToPurchasePromptApp
local FFlagPurchasePromptPriceShouldUseProductInfoPrice = require(PurchasePrompt.Flags.FFlagPurchasePromptPriceShouldUseProductInfoPrice)
local getUnifiedPurchaseModalType = require(PurchasePrompt.Utils.getUnifiedPurchaseModalType)
local selectProductPrice = require(PurchasePrompt.Selectors.selectProductPrice)
local FFlagEnableDiscountInfoInUnifiedPurchaseModal = SharedFlags.FFlagEnableDiscountInfoInUnifiedPurchaseModal
local v65 = if not FFlagEnableDiscountInfoInUnifiedPurchaseModal then nil else require(PurchasePrompt.Selectors.selectPrice)
local SetPromptState = require(PurchasePrompt.Actions.SetPromptState)
local HttpService = game:GetService("HttpService")
local SetPurchaseFlowUUID = require(PurchasePrompt.Actions.SetPurchaseFlowUUID)
local SetPostPurchaseActions = require(PurchasePrompt.Actions.SetPostPurchaseActions)
local sendUnifiedPurchaseEventLog = require(PurchasePrompt.Utils.sendUnifiedPurchaseEventLog)
local UnifiedPurchaseEventNameEnum = require(PurchasePrompt.Enums.UnifiedPurchaseEventNameEnum)
local Constants = require(PurchasePrompt.Misc.Constants)
local FFlagEnablePurchaseFlowUUIDMigration = require(PurchasePrompt.Flags.FFlagEnablePurchaseFlowUUIDMigration)
local LoggingProtocol = require(PurchasePromptParent.LoggingProtocol)
local PurchaseFlowUUIDTelemetry = require(PurchasePrompt.Events.PurchaseFlowUUIDTelemetry)
local UnifiedPurchaseTelemetry = require(PurchasePrompt.Events.UnifiedPurchaseTelemetry)
local AppContext = require(PurchasePrompt.Utils.AppContext)
local FFlagPurchasePromptCartPricingEnabled = require(PurchasePrompt.Flags.FFlagPurchasePromptCartPricingEnabled)
local fetchCartPricing = require(PurchasePrompt.Thunks.fetchCartPricing)
local selectCartPricingResponse = require(PurchasePrompt.Selectors.selectCartPricingResponse)
local selectIsCartPricingFetching = require(PurchasePrompt.Selectors.selectIsCartPricingFetching)
local FFlagPurchasePromptUnifiedEventsUseOfferAdjustedPrice = SharedFlags.FFlagPurchasePromptUnifiedEventsUseOfferAdjustedPrice
local deriveCartPricingView = IAPExperience.deriveCartPricingView
local DesktopUpsellExperiment = IAPExperience.Utility.DesktopUpsellExperiment
local ProductPurchaseModal = IAPExperience.ProductPurchaseModal
local RobuxUpsellModal = IAPExperience.RobuxUpsellModal
local RobuxUpsellModalTooExpensiveFallback = IAPExperience.RobuxUpsellModalTooExpensiveFallback
local shouldShowBlackbirdUpsell = require(PurchasePrompt.Utils.shouldShowBlackbirdUpsell)
local v89 = Roact.Component:extend(script.Name)
local ProductPurchasePrompt = require(script.Parent.ProductPurchasePrompt)
local SharedFlags2 = require(PurchasePromptParent.SharedFlags)
local GetFFlagOpenVngTosForVngRobuxUpsell = SharedFlags2.GetFFlagOpenVngTosForVngRobuxUpsell
local getAppFeaturePolicies = require(PurchasePromptParent.UniversalAppPolicy).getAppFeaturePolicies
local FFlagEnableUnifiedProductPurchaseFlow = SharedFlags2.FFlagEnableUnifiedProductPurchaseFlow
local UnifiedPurchaseModalTypeEnum = IAPExperience.Enums.UnifiedPurchaseModalTypeEnum
local FFlagUnifiedPurchaseGamepassAddProductUniverseId = require(PurchasePromptParent.SharedFlags).FFlagUnifiedPurchaseGamepassAddProductUniverseId
local FFlagUnifiedPurchaseFlowMarketplaceUIImprovements = require(PurchasePromptParent.SharedFlags).FFlagUnifiedPurchaseFlowMarketplaceUIImprovements
local FFlagAddPerformanceMetricsToUnifiedPurchaseModal = require(PurchasePromptParent.SharedFlags).FFlagAddPerformanceMetricsToUnifiedPurchaseModal
local FFlagEnableUnifiedPurchaseFlowForDevSubs = require(PurchasePromptParent.SharedFlags).FFlagEnableUnifiedPurchaseFlowForDevSubs
local FFlagAddCenterDialogForUnifiedPurchaseModal = require(PurchasePromptParent.SharedFlags).FFlagAddCenterDialogForUnifiedPurchaseModal
local FFlagUnifiedPurchaseAddSkeleton = require(PurchasePromptParent.SharedFlags).FFlagUnifiedPurchaseAddSkeleton
local FFlagEnableBlackbirdUpsellInUnifiedPurchaseModal = require(PurchasePromptParent.SharedFlags).FFlagEnableBlackbirdUpsellInUnifiedPurchaseModal
local FFlagEnableSubscriptionUpsellUnifiedPurchaseEventTelemetry = require(PurchasePromptParent.SharedFlags).FFlagEnableSubscriptionUpsellUnifiedPurchaseEventTelemetry
local v104 = game:DefineFastFlag("RemoveDelayedInputForUnifiedPurchaseModal", true)
local FFlagPurchasePromptSubtitleForTimedOptions = require(PurchasePromptParent.SharedFlags).FFlagPurchasePromptSubtitleForTimedOptions
local FFlagPurchaseModalTimedOptionExtension = require(PurchasePromptParent.SharedFlags).FFlagPurchaseModalTimedOptionExtension
local FFlagAddOnRobloxSubscriptionUpsellSuccessCallbackToUnifiedPurchaseModal = require(PurchasePromptParent.SharedFlags).FFlagAddOnRobloxSubscriptionUpsellSuccessCallbackToUnifiedPurchaseModal
local FFlagEnableBlackbirdUpsellImpressionGating = require(PurchasePromptParent.SharedFlags).FFlagEnableBlackbirdUpsellImpressionGating
local BlackbirdUpsellImpressionTracker = require(PurchasePrompt.Utils.BlackbirdUpsellImpressionTracker)
local FFlagBlackbirdUpsellGateResaleAndTimedOption = require(PurchasePrompt.Flags.FFlagBlackbirdUpsellGateResaleAndTimedOption)
local FFlagSetMenuOnPurchasePrompt = require(PurchasePrompt.Flags.FFlagSetMenuOnPurchasePrompt)
local FFlagSkipBuyDelayForExperienceShop = require(PurchasePrompt.Flags.FFlagSkipBuyDelayForExperienceShop)

local function isRelevantRequestType(p1, p2, p3) -- line: 173
	-- upvalues: FFlagUnifiedPurchaseAddSkeleton (copy), PromptState (copy), PurchaseFlow (copy), RequestType (copy), FFlagEnableUnifiedProductPurchaseFlow (copy), FFlagEnableUnifiedPurchaseFlowForDevSubs (copy)
	if FFlagUnifiedPurchaseAddSkeleton and (p3 == PromptState.InitializingPurchase and p2 == PurchaseFlow.RobuxUpsellV2) then
		return true
	end

	if p2 == PurchaseFlow.RobuxUpsellV2 or p2 == PurchaseFlow.LargeRobuxUpsell then
		return false
	end

	return p1 == RequestType.Asset or (p1 == RequestType.Bundle or (p1 == RequestType.GamePass or (p1 == RequestType.Product or (p1 == RequestType.AvatarCreationFee or (FFlagEnableUnifiedProductPurchaseFlow and p1 == RequestType.Experience or (FFlagEnableUnifiedProductPurchaseFlow and p1 == RequestType.Look or FFlagEnableUnifiedPurchaseFlowForDevSubs and p1 == RequestType.DeveloperSubscription))))))
end
local function getIsFiatProduct(p4, p5, n1: number) -- line: 196
	-- upvalues: FFlagEnableUnifiedPurchaseFlowForDevSubs (copy), RequestType (copy)
	if FFlagEnableUnifiedPurchaseFlowForDevSubs and p4 == RequestType.DeveloperSubscription then
		return p5.displayPrice ~= nil and n1 == 0
	end

	return false
end
local function promptStateToViewName(p6) -- line: 204
	-- upvalues: PromptState (copy)
	return ({
		[PromptState.RobuxUpsell] = "PurchaseModal",
		[PromptState.UpsellInProgress] = "RobuxPurchasePending"
	})[p6]
end

function v89.init(p7) -- line: 212
	-- upvalues: HttpService (copy), FFlagEnablePurchaseFlowUUIDMigration (copy), LoggingProtocol (copy), PurchaseFlowUUIDTelemetry (copy), CachedPolicyService (copy), PromptState (copy), FFlagPurchasePromptUnifiedEventsUseOfferAdjustedPrice (copy), FFlagUnifiedPurchaseGamepassAddProductUniverseId (copy), sendUnifiedPurchaseEventLog (copy), v104 (copy), FFlagSkipBuyDelayForExperienceShop (copy), AppContext (copy), Players (copy), isRelevantRequestType (copy), FFlagEnableUnifiedProductPurchaseFlow (copy), logUnifiedPurchaseTelemetryCounter (copy), UnifiedPurchaseTelemetry (copy), UnifiedPurchaseEventNameEnum (copy), PurchaseError (copy), isGenericChallengeResponse (copy), RequestType (copy), PublishAssetAnalytics (copy), WindowState (copy), ContextActionService (copy), VPCModalType (copy), FFlagAddPerformanceMetricsToUnifiedPurchaseModal (copy), emitPerformanceMetrics (copy), Constants (copy)
	p7.state = {
		isLuobu = false,
		screenSize = Vector2.new(0, 0),
		analyticId = HttpService:GenerateGUID(false)
	}

	if not FFlagEnablePurchaseFlowUUIDMigration then
		p7.props.setPurchaseFlowUUID(HttpService:GenerateGUID(false))
		LoggingProtocol.default:logRobloxTelemetryCounter(PurchaseFlowUUIDTelemetry.ProductPurchaseContainerMigrationCounter, 1, {
			method = "ProductPurchaseContainerInit"
		})
	end

	coroutine.wrap(function() -- line: 231
		-- upvalues: CachedPolicyService (copy), p7 (copy)
		if CachedPolicyService:IsSubjectToChinaPolicies() then
			p7:setState({
				isLuobu = true
			})
		end
	end)()

	function p7.emitPurchaseFlowEvent(p8, p9) -- line: 242
		-- upvalues: p7 (copy), PromptState (copy), HttpService (copy)
		local promptState = p7.props.promptState
		local v171 = ({
			[PromptState.RobuxUpsell] = "PurchaseModal",
			[PromptState.UpsellInProgress] = "RobuxPurchasePending"
		})[promptState]

		if not v171 then
			return
		end

		local t1 = {
			purchase_flow = "InGameRobuxUpsell",
			purchase_flow_uuid = p7.props.purchaseFlowUUID,
			view_name = v171,
			purchase_event_type = p8,
			input_type = p9,
			event_metadata = HttpService:JSONEncode({
				universe_id = tostring(game.GameId),
				item_product_id = tostring(p7.props.productInfo.productId),
				item_name = p7.props.productInfo.name,
				price = tostring(p7.props.productInfo.price),
				user_balance = tostring(p7.props.accountInfo.balance) or nil,
				package_robux_amount = tostring(p7.props.robuxPurchaseAmount) or nil
			})
		}

		p7.props.onAnalyticEvent("UserPurchaseFlow", t1)
	end
	function p7.emitUnifiedProductPurchaseFlowEvent(p10) -- line: 266
		-- upvalues: p7 (copy), FFlagPurchasePromptUnifiedEventsUseOfferAdjustedPrice (copy), FFlagUnifiedPurchaseGamepassAddProductUniverseId (copy), sendUnifiedPurchaseEventLog (copy)
		local v174 = p7.props.purchaseAnalyticsMetadata or {}
		local v175 = if not FFlagPurchasePromptUnifiedEventsUseOfferAdjustedPrice or p7.props.productPrice == nil then v174.price else p7.props.productPrice
		local t2 = {
			event_name = p10,
			purchase_flow_uuid = v174.purchaseFlowUUID,
			product_id = v174.productId,
			product_type = v174.productType,
			product_target_id = v174.productTargetId,
			robux_price = v175,
			surface = v174.surface,
			user_roblox_balance = v174.userRobuxBalance,
			salelocation_universeid = v174.saleLocationUniverseId,
			product_universeid = if not FFlagUnifiedPurchaseGamepassAddProductUniverseId then nil else v174.productUniverseId
		}

		sendUnifiedPurchaseEventLog(t2)
	end
	function p7.changeScreenSize(p11) -- line: 293
		-- upvalues: p7 (copy)
		if p7.state.screenSize ~= p11.AbsoluteSize then
			p7:setState({
				screenSize = p11.AbsoluteSize
			})
		end
	end
	function p7.isFromShopSkip() -- line: 301
		-- upvalues: p7 (copy)
		return p7.props.productPayload ~= nil and p7.props.productPayload.isFromInExperienceShop == true
	end
	function p7.hasDelayedInput() -- line: 305
		-- upvalues: v104 (copy), p7 (copy), PromptState (copy), FFlagSkipBuyDelayForExperienceShop (copy)
		if not v104 and p7.props.isTestPurchase then
			return false
		end

		local promptState = p7.props.promptState

		if promptState == PromptState.PromptPurchase and p7.buyButtonUsesFoundationInputDelay and (not FFlagSkipBuyDelayForExperienceShop or not p7.isFromShopSkip()) then
			return true
		end

		if v104 then
			if FFlagSkipBuyDelayForExperienceShop and p7.isFromShopSkip() and (promptState == PromptState.RobuxUpsell or promptState == PromptState.UpsellInProgress) then
				return false
			end

			return promptState == PromptState.PurchaseInProgress or (promptState == PromptState.RobuxUpsell or promptState == PromptState.UpsellInProgress)
		end

		if FFlagSkipBuyDelayForExperienceShop and p7.isFromShopSkip() and (promptState == PromptState.PromptPurchase or promptState == PromptState.RobuxUpsell or promptState == PromptState.UpsellInProgress) then
			return false
		end

		return promptState == PromptState.PromptPurchase or (promptState == PromptState.PurchaseInProgress or (promptState == PromptState.RobuxUpsell or promptState == PromptState.UpsellInProgress))
	end
	function p7.isWindowShowAndDoneAnimating() -- line: 359
		-- upvalues: p7 (copy)
		return p7.state.isAnimating == false
	end

	p7.buyButtonUsesFoundationInputDelay = AppContext.get() == AppContext.Enum.IN_EXPERIENCE

	function p7.canConfirmInput() -- line: 368
		-- upvalues: Players (copy), p7 (copy)
		if Players.LocalPlayer.GameplayPaused then
			return false
		end

		local v179 = p7.isWindowShowAndDoneAnimating()

		if p7.hasDelayedInput() then
			local v180 = false

			if p7.state.doneAnimatingTime then
				v180 = os.clock() - p7.state.doneAnimatingTime > 2.5
			end

			return v179 and v180
		end

		return v179
	end
	function p7.getConfirmButtonAction(p12, p13, p14) -- line: 393
		-- upvalues: PromptState (copy), isRelevantRequestType (copy), FFlagEnableUnifiedProductPurchaseFlow (copy), p7 (copy), logUnifiedPurchaseTelemetryCounter (copy), UnifiedPurchaseTelemetry (copy), UnifiedPurchaseEventNameEnum (copy), PurchaseError (copy), isGenericChallengeResponse (copy)
		if p12 == PromptState.None or not isRelevantRequestType(p13) then
			return nil
		end

		if p12 == PromptState.PromptPurchase or p12 == PromptState.PurchaseInProgress then
			if FFlagEnableUnifiedProductPurchaseFlow and p7.props.isUserEligibleForUnifiedPurchaseFlow then
				local v184 = p7.props.purchaseAnalyticsMetadata or {}

				logUnifiedPurchaseTelemetryCounter(UnifiedPurchaseTelemetry.UnifiedProductPurchaseModalBuyItemButtonClickedCounter, v184.surface, v184.productType)
				p7.emitUnifiedProductPurchaseFlowEvent(UnifiedPurchaseEventNameEnum.BuyItemModalBuyClicked)
			end

			return p7.props.onBuy
		end

		if p12 == PromptState.RobuxUpsell or p12 == PromptState.UpsellInProgress or p12 == PromptState.LeaveRobloxWarning then
			return p7.props.onRobuxUpsell
		end

		if p12 == PromptState.U13PaymentModal or p12 == PromptState.U13MonthlyThreshold1Modal or p12 == PromptState.U13MonthlyThreshold2Modal or p12 == PromptState.ParentalConsentWarningPaymentModal13To17 then
			return p7.props.onScaryModalConfirm
		end

		if p12 == PromptState.Error and p14 == PurchaseError.TwoFactorNeededSettings then
			return p7.props.onOpenSecuritySettings
		end

		if isGenericChallengeResponse(p14) then
			return function() -- line: 425
				-- upvalues: p7 (copy), p14 (copy)
				p7.props.onOpenSecuritySettings(p14)
			end
		end

		return p7.props.hideWindow
	end
	function p7.getCancelButtonAction(p15, p16) -- line: 433
		-- upvalues: PromptState (copy), isRelevantRequestType (copy), p7 (copy)
		if p15 == PromptState.None or not isRelevantRequestType(p16) then
			return nil
		end

		return p7.props.hideWindow
	end
	function p7.confirmButtonPressed() -- line: 441
		-- upvalues: p7 (copy), RequestType (copy), PromptState (copy), PublishAssetAnalytics (copy)
		if p7.props.requestType == RequestType.AvatarCreationFee and p7.props.promptState == PromptState.PromptPurchase then
			PublishAssetAnalytics.sendButtonClicked(PublishAssetAnalytics.Section.BuyItemModal, PublishAssetAnalytics.Element.Buy)
		end

		local v187 = p7.getConfirmButtonAction(p7.props.promptState, p7.props.requestType, p7.props.purchaseError)

		if v187 ~= nil and p7.canConfirmInput() then
			v187()
		end
	end
	function p7.cancelButtonPressed() -- line: 458
		-- upvalues: p7 (copy), RequestType (copy), PromptState (copy), PublishAssetAnalytics (copy), FFlagEnableUnifiedProductPurchaseFlow (copy), logUnifiedPurchaseTelemetryCounter (copy), UnifiedPurchaseTelemetry (copy)
		if p7.props.requestType == RequestType.AvatarCreationFee and p7.props.promptState == PromptState.PromptPurchase then
			PublishAssetAnalytics.sendButtonClicked(PublishAssetAnalytics.Section.BuyItemModal, PublishAssetAnalytics.Element.Cancel)
		end

		if FFlagEnableUnifiedProductPurchaseFlow and p7.props.isUserEligibleForUnifiedPurchaseFlow then
			logUnifiedPurchaseTelemetryCounter(UnifiedPurchaseTelemetry.UnifiedProductPurchaseModalCancelButtonClickedCounter, p7.props.purchaseAnalyticsMetadata.surface, p7.props.purchaseAnalyticsMetadata.productType)
		end

		local v188 = p7.getCancelButtonAction(p7.props.promptState, p7.props.requestType)

		if v188 ~= nil then
			v188()
		end
	end
	function p7.configContextActionService(p17) -- line: 483
		-- upvalues: WindowState (copy), ContextActionService (copy), p7 (copy)
		if p17 == WindowState.Shown then
			ContextActionService:BindCoreAction("ProductPurchaseConfirmButtonBind", function(_, p19, _) -- line: 485
				-- upvalues: p7 (copy)
				if p19 == Enum.UserInputState.Begin then
					p7.confirmButtonPressed()
				end
			end, false, Enum.KeyCode.ButtonA)
			ContextActionService:BindCoreAction("ProductPurchaseCancelButtonBind", function(_, p22, _) -- line: 490
				-- upvalues: p7 (copy)
				if p22 == Enum.UserInputState.Begin then
					p7.cancelButtonPressed()
				end
			end, false, Enum.KeyCode.ButtonB)

			return
		end

		ContextActionService:UnbindCoreAction("ProductPurchaseConfirmButtonBind")
		ContextActionService:UnbindCoreAction("ProductPurchaseCancelButtonBind")
	end
	function p7.getVPCModalType(p24) -- line: 501
		-- upvalues: PromptState (copy), VPCModalType (copy)
		if p24 == PromptState.EnablePurchaseVPCModal then
			return VPCModalType.toRawValue(VPCModalType.EnablePurchase)
		end

		return VPCModalType.toRawValue(VPCModalType.None)
	end
	function p7.onBuyItemButtonMounted(p25) -- line: 508
		-- upvalues: p7 (copy), logUnifiedPurchaseTelemetryCounter (copy), UnifiedPurchaseTelemetry (copy), UnifiedPurchaseEventNameEnum (copy), FFlagAddPerformanceMetricsToUnifiedPurchaseModal (copy), emitPerformanceMetrics (copy), Constants (copy)
		local v192 = p7.props.purchaseAnalyticsMetadata or {}

		logUnifiedPurchaseTelemetryCounter(UnifiedPurchaseTelemetry.UnifiedProductPurchaseModalShownCounter, v192.surface, v192.productType)
		p7.emitUnifiedProductPurchaseFlowEvent(UnifiedPurchaseEventNameEnum.BuyItemModalShown)

		if FFlagAddPerformanceMetricsToUnifiedPurchaseModal and (v192 and v192.surface) then
			emitPerformanceMetrics(Constants.PerformanceMetrics.IntervalName.ProductPurchaseContainerShown, v192.surface)
		end

		if p7.props.purchaseCallbacks and p7.props.purchaseCallbacks.onBuyItemButtonMounted then
			p7.props.purchaseCallbacks.onBuyItemButtonMounted(p25)
		end
	end
end
function v89.didMount(p26) -- line: 534
	-- upvalues: WindowState (copy), isRelevantRequestType (copy), GuiService (copy)
	local purchaseFlow = p26.props.purchaseFlow
	local requestType = p26.props.requestType

	if p26.props.windowState == WindowState.Shown and isRelevantRequestType(requestType, purchaseFlow) then
		p26:setState({
			isAnimating = true
		})
		p26.configContextActionService(p26.props.windowState)
		GuiService.SetPurchasePromptIsShown(true)
	end
end
function v89.willUpdate(p27, p28) -- line: 548
	if p27.props.expectedPrice ~= p28.expectedPrice then
		p27:setState({})
	end
end
function v89.didUpdate(p29, p30, _) -- line: 554
	-- upvalues: FFlagEnablePurchaseFlowUUIDMigration (copy), PromptState (copy), HttpService (copy), LoggingProtocol (copy), PurchaseFlowUUIDTelemetry (copy), Players (copy), isRelevantRequestType (copy), GuiService (copy), WindowState (copy), RequestType (copy), PublishAssetAnalytics (copy)
	if not FFlagEnablePurchaseFlowUUIDMigration and (p29.props.promptState ~= p30.promptState and p29.props.promptState == PromptState.None) then
		local guid = HttpService:GenerateGUID(false)

		p29.props.setPurchaseFlowUUID(guid)
		LoggingProtocol.default:logRobloxTelemetryCounter(PurchaseFlowUUIDTelemetry.ProductPurchaseContainerMigrationCounter, 1, {
			method = "ProductPurchaseContainerDidUpdate"
		})
	end

	if Players.LocalPlayer.GameplayPaused then
		p29.props.onAnalyticEvent("PurchasePromptGamePausedDetected", {
			place_id = game.PlaceId
		})
		p29.props.hideWindow()
	end

	local purchaseFlow = p29.props.purchaseFlow
	local requestType = p29.props.requestType

	if p30.windowState ~= p29.props.windowState and isRelevantRequestType(requestType, purchaseFlow) then
		p29:setState({
			isAnimating = true
		})
		p29.configContextActionService(p29.props.windowState)
		GuiService:SetPurchasePromptIsShown(p29.props.windowState == WindowState.Shown)

		if p29.props.windowState == WindowState.Hidden then
			p29.props.completeRequest()
		end
	end

	if requestType == RequestType.AvatarCreationFee and p29.props.promptState == PromptState.PurchaseComplete and p30.promptState ~= PromptState.PurchaseComplete then
		PublishAssetAnalytics.sendPageLoad(PublishAssetAnalytics.Section.ProcessCompleteModal)
	end

	if p30.promptState ~= p29.props.promptState then
		p29.emitPurchaseFlowEvent("ViewShown")
	end
end
function v89.getMessageKeysFromPromptState(p32) -- line: 613
	-- upvalues: PromptState (copy), PurchaseError (copy), LocalizationService (copy), isGenericChallengeResponse (copy)
	local promptState = p32.props.promptState
	local productInfo = p32.props.productInfo
	local purchaseError = p32.props.purchaseError

	if promptState == PromptState.PurchaseComplete then
		return {
			messageText = {
				key = "CoreScripts.PurchasePrompt.PurchaseMessage.Succeeded",
				params = {
					ITEM_NAME = productInfo.name
				}
			},
			okText = {
				key = "CoreScripts.PurchasePrompt.Button.OK"
			},
			titleText = {
				key = "CoreScripts.PurchasePrompt.Title.BuyItem"
			}
		}
	end

	if promptState == PromptState.U13PaymentModal then
		return {
			messageText = {
				key = "CoreScripts.PurchasePrompt.PurchaseDetails.ScaryModalOne"
			},
			okText = {
				key = "CoreScripts.PurchasePrompt.Button.OK"
			},
			titleText = {
				key = "CoreScripts.PurchasePrompt.Title.BuyItem"
			}
		}
	end

	if promptState == PromptState.U13MonthlyThreshold1Modal then
		return {
			messageText = {
				key = "CoreScripts.PurchasePrompt.PurchaseDetails.ScaryModalTwo"
			},
			okText = {
				key = "CoreScripts.PurchasePrompt.Button.OK"
			},
			titleText = {
				key = "CoreScripts.PurchasePrompt.Title.BuyItem"
			}
		}
	end

	if promptState == PromptState.U13MonthlyThreshold2Modal then
		return {
			messageText = {
				key = "CoreScripts.PurchasePrompt.PurchaseDetails.ScaryModalParental"
			},
			okText = {
				key = "CoreScripts.PurchasePrompt.Button.OK"
			},
			titleText = {
				key = "CoreScripts.PurchasePrompt.Title.BuyItem"
			}
		}
	end

	if promptState == PromptState.ParentalConsentWarningPaymentModal13To17 then
		return {
			messageText = {
				key = "CoreScripts.PurchasePrompt.PurchaseDetails.ParentalConsent"
			},
			okText = {
				key = "CoreScripts.PurchasePrompt.Button.OK"
			},
			titleText = {
				key = "CoreScripts.PurchasePrompt.Title.BuyItem"
			}
		}
	end

	if promptState == PromptState.Error then
		if purchaseError == PurchaseError.UnknownFailure then
			return {
				messageText = {
					key = LocalizationService.getErrorKey(purchaseError),
					params = {
						ITEM_NAME = productInfo.name
					}
				},
				okText = {
					key = "CoreScripts.PurchasePrompt.Button.OK"
				},
				titleText = {
					key = "CoreScripts.PremiumModal.Title.Error"
				}
			}
		end

		if purchaseError == PurchaseError.TwoFactorNeededSettings or isGenericChallengeResponse(purchaseError) then
			return {
				messageText = {
					key = "CoreScripts.PurchasePrompt.PurchaseFailed.Enable2SVLogout"
				},
				okText = {
					key = "CoreScripts.PurchasePrompt.Button.Settings"
				},
				cancelText = {
					key = "CoreScripts.PurchasePrompt.CancelPurchase.Cancel"
				},
				titleText = {
					key = "CoreScripts.PurchasePrompt.Title.VerificationRequired"
				}
			}
		end

		return {
			messageText = {
				key = LocalizationService.getErrorKey(purchaseError)
			},
			okText = {
				key = "CoreScripts.PurchasePrompt.Button.OK"
			},
			titleText = {
				key = "CoreScripts.PremiumModal.Title.Error"
			}
		}
	end
end
function v89.determinePrompt(p33) -- line: 682
	-- upvalues: FFlagEnableBlackbirdUpsellInUnifiedPurchaseModal (copy), WindowState (copy), PromptState (copy), isRelevantRequestType (copy), FFlagUnifiedPurchaseAddSkeleton (copy), FFlagEnableUnifiedProductPurchaseFlow (copy), FFlagEnableUnifiedPurchaseFlowForDevSubs (copy), RequestType (copy), PurchaseClientSessionIdType (copy), RobloxSubscriptionPurchaseApp (copy), RobloxSubscriptionFlowCompleteReason (copy), FFlagAddOnRobloxSubscriptionUpsellSuccessCallbackToUnifiedPurchaseModal (copy), SurfaceName (copy), AppContext (copy), SurfaceContext (copy), FFlagEnableDiscountInfoInUnifiedPurchaseModal (copy), FFlagPurchasePromptCartPricingEnabled (copy), deriveCartPricingView (copy), getUnifiedPurchaseModalType (copy), UnifiedPurchaseModalTypeEnum (copy), shouldShowBlackbirdUpsell (copy), FFlagBlackbirdUpsellGateResaleAndTimedOption (copy), getBlackbirdUpsellBannerProductInfo (copy), FFlagEnableSubscriptionUpsellUnifiedPurchaseEventTelemetry (copy), UnifiedPurchaseEventNameEnum (copy), FFlagEnableBlackbirdUpsellImpressionGating (copy), BlackbirdUpsellImpressionTracker (copy), FFlagAddCenterDialogForUnifiedPurchaseModal (copy), Roact (copy), UnifiedProductPurchaseModalV2 (copy), FFlagPurchasePromptSubtitleForTimedOptions (copy), FFlagSkipBuyDelayForExperienceShop (copy), UnifiedProductPurchaseModal (copy), FFlagPurchasePromptPriceShouldUseProductInfoPrice (copy), getPlayerPrice (copy), FFlagUnifiedPurchaseFlowMarketplaceUIImprovements (copy), ProductPurchaseSurface (copy), DesktopUpsellExperiment (copy), ProductPurchaseModal (copy), ProductPurchase (copy), RobuxUpsellModal (copy), ProductPurchaseRobuxUpsell (copy), GetFFlagOpenVngTosForVngRobuxUpsell (copy), getAppFeaturePolicies (copy), LeaveRobloxAlert (copy), InteractiveAlert (copy), RobloxTranslator (copy), ButtonType (copy), PurchaseError (copy), isGenericChallengeResponse (copy), React (copy), ProductPurchasePrompt (copy), Images (copy), Animator (copy), VerifiedParentalConsentDialog (copy), RobuxUpsellModalTooExpensiveFallback (copy), FFlagPurchaseModalTimedOptionExtension (copy)
	local purchaseFlow = p33.props.purchaseFlow
	local promptState = p33.props.promptState
	local expectedPrice = p33.props.expectedPrice
	local requestType = p33.props.requestType
	local purchaseError = p33.props.purchaseError
	local productInfo = p33.props.productInfo
	local accountInfo = p33.props.accountInfo
	local isTestPurchase = p33.props.isTestPurchase

	if FFlagEnableBlackbirdUpsellInUnifiedPurchaseModal and p33.props.windowState ~= WindowState.Shown then
		return nil
	end

	if promptState == PromptState.None or not isRelevantRequestType(requestType, purchaseFlow, if not FFlagUnifiedPurchaseAddSkeleton then nil else promptState) then
		return nil
	end

	if promptState == PromptState.PromptPurchase or promptState == PromptState.PurchaseInProgress or FFlagUnifiedPurchaseAddSkeleton and promptState == PromptState.InitializingPurchase then
		if FFlagEnableUnifiedProductPurchaseFlow and p33.props.isUserEligibleForUnifiedPurchaseFlow then
			local productPrice = p33.props.productPrice
			local v151 = not not FFlagEnableUnifiedPurchaseFlowForDevSubs and (requestType == RequestType.DeveloperSubscription and (productInfo.displayPrice ~= nil and productPrice == 0))

			local function v152() -- line: 722
				-- upvalues: p33 (copy), PromptState (copy), WindowState (copy), PurchaseClientSessionIdType (copy), RobloxSubscriptionPurchaseApp (copy), RobloxSubscriptionFlowCompleteReason (copy), FFlagAddOnRobloxSubscriptionUpsellSuccessCallbackToUnifiedPurchaseModal (copy), SurfaceName (copy), AppContext (copy), SurfaceContext (copy)
				p33.props.setPromptState(PromptState.BlackbirdUpsellInProgress)
				p33.props.setWindowState(WindowState.Suspended)

				local purchaseFlowUUID = p33.props.purchaseFlowUUID
				local v194 = if not purchaseFlowUUID or purchaseFlowUUID == "" then nil else purchaseFlowUUID
				local v195 = if not v194 then nil else {
					clientSessionIdType = PurchaseClientSessionIdType.PurchaseFlowUUID,
					clientSessionId = v194
				}

				RobloxSubscriptionPurchaseApp.initiateRobloxSubscriptionPurchase({
					showBackButton = true
				}, {
					onFlowComplete = function(p34) -- line: 741
						-- upvalues: RobloxSubscriptionFlowCompleteReason (copy), FFlagAddOnRobloxSubscriptionUpsellSuccessCallbackToUnifiedPurchaseModal (copy), p33 (copy)
						if p34 == RobloxSubscriptionFlowCompleteReason.UpsellPurchaseSucceeded then
							if FFlagAddOnRobloxSubscriptionUpsellSuccessCallbackToUnifiedPurchaseModal and p33.props.purchaseCallbacks and p33.props.purchaseCallbacks.onRobloxSubscriptionUpsellSuccess then
								p33.props.purchaseCallbacks.onRobloxSubscriptionUpsellSuccess()
							end

							p33.props.retryPurchaseAfterUpsell()

							return
						end

						if p34 == RobloxSubscriptionFlowCompleteReason.UpsellDismissed then
							p33.props.completeRequest()

							return
						end

						if p34 == RobloxSubscriptionFlowCompleteReason.UpsellPurchaseFailed then
							p33.props.completeRequest()

							return
						end

						p33.props.completeRequest()
					end,
					onBackButtonActivated = function() -- line: 763
						-- upvalues: p33 (copy), PromptState (copy), WindowState (copy)
						p33.props.setPromptState(PromptState.PromptPurchase)
						p33.props.setWindowState(WindowState.Shown)
					end
				}, nil, SurfaceName.UnifiedProductPurchaseModal, if AppContext.get() ~= AppContext.Enum.IN_APP then SurfaceContext.InGame else SurfaceContext.InApp, nil, if not v195 then nil else {
					clientSessionId = v195
				})
			end

			local v153 = nil

			if FFlagEnableDiscountInfoInUnifiedPurchaseModal then
				v153 = if not v151 then p33.props.price else nil
			end

			local productPrice2 = nil

			if FFlagPurchasePromptCartPricingEnabled then
				local v155 = deriveCartPricingView(p33.props.cartPricingResponse)
				local v156 = getUnifiedPurchaseModalType(requestType)

				productPrice2 = p33.props.productPrice

				if not v151 and v155 ~= nil and v156 == UnifiedPurchaseModalTypeEnum.MultiItem then
					productPrice2 = v155.priceAfterDiscount
				end
			end

			local v157 = nil

			if FFlagEnableBlackbirdUpsellInUnifiedPurchaseModal then
				v157 = shouldShowBlackbirdUpsell(v153, p33.props.requestType, v151, if not FFlagBlackbirdUpsellGateResaleAndTimedOption then nil else p33.props.productPayload)
			end

			local v158 = if not FFlagEnableBlackbirdUpsellInUnifiedPurchaseModal or (not v157 or not p33.props.robloxSubscriptionProducts) then nil else getBlackbirdUpsellBannerProductInfo(p33.props.robloxSubscriptionProducts)
			local v159 = if not FFlagEnableSubscriptionUpsellUnifiedPurchaseEventTelemetry and not FFlagEnableBlackbirdUpsellImpressionGating then p33.onBuyItemButtonMounted else function(p35) -- line: 816
				-- upvalues: p33 (copy), FFlagEnableSubscriptionUpsellUnifiedPurchaseEventTelemetry (copy), v158 (copy), UnifiedPurchaseEventNameEnum (copy), FFlagEnableBlackbirdUpsellImpressionGating (copy), BlackbirdUpsellImpressionTracker (copy)
				p33.onBuyItemButtonMounted(p35)

				if FFlagEnableSubscriptionUpsellUnifiedPurchaseEventTelemetry and v158 then
					p33.emitUnifiedProductPurchaseFlowEvent(UnifiedPurchaseEventNameEnum.SubscriptionUpsellBannerShown)
				end

				if FFlagEnableBlackbirdUpsellImpressionGating and v158 then
					BlackbirdUpsellImpressionTracker.incrementImpressionCount()
				end
			end
			local v160 = nil

			if FFlagPurchasePromptCartPricingEnabled then
				function v160(_: boolean, t3: {[any]: any}?) -- line: 833
					-- upvalues: p33 (copy)
					if t3 ~= nil then
						p33.props.fetchCartPricing(t3)
					end
				end
			end

			if FFlagAddCenterDialogForUnifiedPurchaseModal and AppContext.get() == AppContext.Enum.IN_APP then
				return Roact.createElement(UnifiedProductPurchaseModalV2, {
					product = {
						itemIcon = productInfo.imageUrl,
						itemName = productInfo.name,
						itemRobuxCost = if not v151 then if not FFlagPurchasePromptCartPricingEnabled then p33.props.productPrice else productPrice2 else nil,
						itemDisplayPrice = if not v151 then nil else productInfo.displayPrice,
						itemPrice = if not FFlagEnableDiscountInfoInUnifiedPurchaseModal then nil else v153,
						model = p33.props.humanoidModel
					},
					subtitleView = if not FFlagPurchasePromptSubtitleForTimedOptions then nil else p33.props.subtitleView,
					buttons = {
						buyItemActivated = p33.confirmButtonPressed,
						buyItemEnableInputDelayed = p33.isWindowShowAndDoneAnimating() and (p33.buyButtonUsesFoundationInputDelay and not (FFlagSkipBuyDelayForExperienceShop and p33.isFromShopSkip())),
						cancelActivated = p33.cancelButtonPressed,
						isDisabled = promptState == PromptState.PurchaseInProgress
					},
					postPurchaseActions = p33.props.postPurchaseActions,
					setPostPurchaseActions = p33.props.setPostPurchaseActions,
					onBuyItemButtonMounted = v159,
					purchaseModalType = getUnifiedPurchaseModalType(p33.props.requestType),
					robuxBalanceAmount = accountInfo.balance,
					isTestPurchase = isTestPurchase,
					isLoading = if not FFlagUnifiedPurchaseAddSkeleton then nil else promptState == PromptState.InitializingPurchase,
					isCartPricingLoading = if not FFlagPurchasePromptCartPricingEnabled then nil else p33.props.isCartPricingLoading,
					onBlackbirdUpsellActivated = if not FFlagEnableBlackbirdUpsellInUnifiedPurchaseModal then nil else v152,
					BlackbirdUpsellBannerProductInfo = v158,
					cartPricingResponse = if not FFlagPurchasePromptCartPricingEnabled then nil else p33.props.cartPricingResponse,
					onCartOfferAppliedChanged = if not FFlagPurchasePromptCartPricingEnabled then nil else v160
				})
			end

			return Roact.createElement(UnifiedProductPurchaseModal, {
				product = {
					itemIcon = productInfo.imageUrl,
					itemName = productInfo.name,
					itemRobuxCost = if not v151 then if not FFlagPurchasePromptPriceShouldUseProductInfoPrice then getPlayerPrice(productInfo, accountInfo.membershipType == 4, expectedPrice) else p33.props.productPrice else nil,
					itemDisplayPrice = if not v151 then nil else productInfo.displayPrice,
					itemPrice = if not FFlagEnableDiscountInfoInUnifiedPurchaseModal then nil else v153,
					model = p33.props.humanoidModel
				},
				buttons = {
					buyItemActivated = p33.confirmButtonPressed,
					buyItemEnableInputDelayed = p33.isWindowShowAndDoneAnimating() and (p33.buyButtonUsesFoundationInputDelay and not (FFlagSkipBuyDelayForExperienceShop and p33.isFromShopSkip())),
					cancelActivated = p33.cancelButtonPressed,
					isDisabled = promptState == PromptState.PurchaseInProgress
				},
				postPurchaseActions = p33.props.postPurchaseActions,
				setPostPurchaseActions = p33.props.setPostPurchaseActions,
				onBuyItemButtonMounted = v159,
				purchaseModalType = getUnifiedPurchaseModalType(p33.props.requestType),
				robuxBalanceAmount = accountInfo.balance,
				isTestPurchase = isTestPurchase,
				onBlackbirdUpsellActivated = if not FFlagEnableBlackbirdUpsellInUnifiedPurchaseModal then nil else v152,
				BlackbirdUpsellBannerProductInfo = v158,
				hideUserRobuxBalance = v151 or if not FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then nil else p33.props.purchaseAnalyticsMetadata and p33.props.purchaseAnalyticsMetadata.surface == ProductPurchaseSurface.Catalog
			})
		end

		if DesktopUpsellExperiment.shouldShowNewModal() then
			return Roact.createElement(ProductPurchaseModal, {
				screenSize = p33.state.screenSize,
				product = {
					itemIcon = productInfo.imageUrl,
					itemName = productInfo.name,
					itemRobuxCost = if not FFlagPurchasePromptPriceShouldUseProductInfoPrice then getPlayerPrice(productInfo, accountInfo.membershipType == 4, expectedPrice) else p33.props.productPrice
				},
				balanceAmount = accountInfo.balance,
				balanceAmountValid = game:DefineFastFlag("BalanceNotShowingInExperimentIssueFix", false) and not accountInfo.hasFailed,
				buttons = {
					isDisabled = promptState == PromptState.PurchaseInProgress,
					buyItemActivated = p33.confirmButtonPressed,
					buyItemControllerIcon = if not p33.props.isGamepadEnabled then nil else "rbxasset://textures/ui/Controls/DesignSystem/ButtonA.png",
					buyItemIsDelayedInput = p33.hasDelayedInput(),
					buyItemEnableInputDelayed = p33.isWindowShowAndDoneAnimating(),
					cancelActivated = p33.cancelButtonPressed
				}
			})
		end

		return Roact.createElement(ProductPurchase, {
			screenSize = p33.state.screenSize,
			isDisabled = promptState == PromptState.PurchaseInProgress,
			model = p33.props.humanoidModel,
			itemIcon = productInfo.imageUrl,
			itemName = productInfo.name,
			itemRobuxCost = if not FFlagPurchasePromptPriceShouldUseProductInfoPrice then getPlayerPrice(productInfo, accountInfo.membershipType == 4, expectedPrice) else p33.props.productPrice,
			currentBalance = accountInfo.balance,
			currentBalanceValid = not accountInfo.hasFailed,
			testPurchase = isTestPurchase,
			isDelayedInput = p33.hasDelayedInput(),
			enableInputDelayed = p33.isWindowShowAndDoneAnimating(),
			buyItemControllerIcon = if not p33.props.isGamepadEnabled then nil else "rbxasset://textures/ui/Controls/DesignSystem/ButtonA.png",
			cancelControllerIcon = if not p33.props.isGamepadEnabled then nil else "rbxasset://textures/ui/Controls/DesignSystem/ButtonB.png",
			buyItemActivated = p33.confirmButtonPressed,
			cancelPurchaseActivated = p33.cancelButtonPressed,
			isLuobu = p33.state.isLuobu
		})
	end

	if promptState == PromptState.RobuxUpsell or promptState == PromptState.UpsellInProgress then
		if DesktopUpsellExperiment.shouldShowNewModal() then
			return Roact.createElement(RobuxUpsellModal, {
				screenSize = p33.state.screenSize,
				product = {
					model = p33.props.humanoidModel,
					itemIcon = productInfo.imageUrl,
					itemName = productInfo.name,
					itemRobuxCost = if not FFlagPurchasePromptPriceShouldUseProductInfoPrice then getPlayerPrice(productInfo, accountInfo.membershipType == 4, expectedPrice) else p33.props.productPrice
				},
				upsell = {
					balanceAmount = accountInfo.balance,
					robuxPurchaseAmount = p33.props.robuxPurchaseAmount,
					robuxPurchaseAmountBeforeBonus = p33.props.robuxAmountBeforeBonus,
					robuxPurchaseCost = p33.props.robuxPurchaseCost
				},
				buttons = {
					buyItemActivated = function() -- line: 1001
						-- upvalues: p33 (copy)
						p33.confirmButtonPressed()
						p33.emitPurchaseFlowEvent("UserInput", "Buy")
					end,
					buyItemDisabled = promptState == PromptState.UpsellInProgress,
					buyItemControllerIcon = if not p33.props.isGamepadEnabled then nil else "rbxasset://textures/ui/Controls/DesignSystem/ButtonA.png",
					buyItemisDelayedInput = p33.hasDelayedInput(),
					buyItemEnableInputDelayed = p33.isWindowShowAndDoneAnimating() and not (FFlagSkipBuyDelayForExperienceShop and p33.isFromShopSkip()),
					cancelPurchaseActivated = function() -- line: 1011
						-- upvalues: p33 (copy)
						p33.cancelButtonPressed()
						p33.emitPurchaseFlowEvent("UserInput", "Cancel")
					end,
					cancelControllerIcon = if not p33.props.isGamepadEnabled then nil else "rbxasset://textures/ui/Controls/DesignSystem/ButtonB.png",
					opensBuyRobuxPage = DesktopUpsellExperiment.getVariant() == DesktopUpsellExperiment.variants.OpenRobuxStore
				}
			})
		end

		return Roact.createElement(ProductPurchaseRobuxUpsell, {
			screenSize = p33.state.screenSize,
			isDisabled = promptState == PromptState.UpsellInProgress,
			model = p33.props.humanoidModel,
			itemIcon = productInfo.imageUrl,
			itemName = productInfo.name,
			itemRobuxCost = if not FFlagPurchasePromptPriceShouldUseProductInfoPrice then getPlayerPrice(productInfo, accountInfo.membershipType == 4, expectedPrice) else p33.props.productPrice,
			robuxPurchaseAmount = p33.props.robuxPurchaseAmount,
			robuxPurchaseAmountBeforeBonus = p33.props.robuxAmountBeforeBonus,
			balanceAmount = accountInfo.balance,
			isDelayedInput = p33.hasDelayedInput(),
			enableInputDelayed = p33.isWindowShowAndDoneAnimating() and not (FFlagSkipBuyDelayForExperienceShop and p33.isFromShopSkip()),
			buyItemControllerIcon = if not p33.props.isGamepadEnabled then nil else "rbxasset://textures/ui/Controls/DesignSystem/ButtonA.png",
			cancelControllerIcon = if not p33.props.isGamepadEnabled then nil else "rbxasset://textures/ui/Controls/DesignSystem/ButtonB.png",
			buyItemActivated = function() -- line: 1042
				-- upvalues: p33 (copy)
				p33.confirmButtonPressed()
				p33.emitPurchaseFlowEvent("UserInput", "Buy")
			end,
			cancelPurchaseActivated = function() -- line: 1046
				-- upvalues: p33 (copy)
				p33.cancelButtonPressed()
				p33.emitPurchaseFlowEvent("UserInput", "Cancel")
			end,
			isLuobu = p33.state.isLuobu,
			isVng = GetFFlagOpenVngTosForVngRobuxUpsell() and getAppFeaturePolicies().getShowVNGTosForRobuxUpsell()
		})
	end

	if promptState == PromptState.LeaveRobloxWarning then
		return Roact.createElement(LeaveRobloxAlert, {
			screenSize = p33.state.screenSize,
			cancelActivated = p33.cancelButtonPressed,
			continueActivated = p33.confirmButtonPressed
		})
	end

	if promptState == PromptState.PurchaseComplete and requestType == RequestType.AvatarCreationFee then
		return Roact.createElement(InteractiveAlert, {
			bodyText = RobloxTranslator:FormatByKey("CoreScripts.PublishAvatarPrompt.PurchaseCompleteDescription"),
			buttonStackInfo = {
				buttons = {{
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = p33.confirmButtonPressed,
						text = RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.ResultModalOk"),
						inputIcon = if not p33.props.isGamepadEnabled then nil else "rbxasset://textures/ui/Controls/DesignSystem/ButtonA.png"
					}
				}}
			},
			screenSize = p33.state.screenSize,
			title = RobloxTranslator:FormatByKey("CoreScripts.BulkPurchasePrompt.CompletedPrompt.SuccessHeading")
		})
	end

	if promptState == PromptState.Error and purchaseError == PurchaseError.TwoFactorNeededSettings or isGenericChallengeResponse(purchaseError) then
		return React.createElement(ProductPurchasePrompt, {
			includeCancelButton = true,
			screenSize = p33.state.screenSize,
			titleIcon = Images["icons/status/error_large"],
			promptState = promptState,
			productInfo = productInfo,
			purchaseError = purchaseError,
			economicRestrictionError = p33.props.economicRestrictionError or {},
			isGamepadEnabled = p33.props.isGamepadEnabled,
			cancelButtonPressed = p33.cancelButtonPressed,
			confirmButtonPressed = p33.confirmButtonPressed,
			isGenericChallengeResponse = isGenericChallengeResponse,
			useUnifiedPurchaseCompletionModal = if not FFlagEnableUnifiedProductPurchaseFlow then nil else p33.props.isUserEligibleForUnifiedPurchaseFlow
		})
	end

	if promptState == PromptState.EnablePurchaseVPCModal then
		return Roact.createElement(Animator, {
			shouldAnimate = true,
			shouldShow = promptState == PromptState.EnablePurchaseVPCModal,
			renderChildren = function() -- line: 1102
				-- upvalues: Roact (copy), VerifiedParentalConsentDialog (copy), p33 (copy), promptState (copy)
				return Roact.createElement(VerifiedParentalConsentDialog, {
					isActionable = false,
					screenSize = p33.state.screenSize,
					modalType = p33.getVPCModalType(promptState),
					onDismiss = function() -- line: 1107
						-- upvalues: p33 (copy)
						p33.confirmButtonPressed()
					end
				})
			end
		})
	end

	if promptState == PromptState.Error and purchaseError == PurchaseError.NotEnoughRobuxXbox and DesktopUpsellExperiment.shouldShowNewModal() then
		return Roact.createElement(RobuxUpsellModalTooExpensiveFallback, {
			screenSize = p33.state.screenSize,
			product = {
				itemIcon = productInfo.imageUrl,
				itemName = productInfo.name,
				itemRobuxCost = if not FFlagPurchasePromptPriceShouldUseProductInfoPrice then getPlayerPrice(productInfo, accountInfo.membershipType == 4, expectedPrice) else p33.props.productPrice
			},
			balanceAmount = accountInfo.balance,
			doneActivated = function() -- line: 1130
				-- upvalues: p33 (copy)
				p33.cancelButtonPressed()
				p33.emitPurchaseFlowEvent("UserInput", "Cancel")
			end
		})
	end

	return React.createElement(ProductPurchasePrompt, {
		includeCancelButton = false,
		screenSize = p33.state.screenSize,
		promptState = promptState,
		productInfo = productInfo,
		purchaseError = purchaseError,
		economicRestrictionError = p33.props.economicRestrictionError or {},
		isGamepadEnabled = p33.props.isGamepadEnabled,
		cancelButtonPressed = p33.cancelButtonPressed,
		confirmButtonPressed = p33.confirmButtonPressed,
		isGenericChallengeResponse = isGenericChallengeResponse,
		useUnifiedPurchaseCompletionModal = if not FFlagEnableUnifiedProductPurchaseFlow then nil else p33.props.isUserEligibleForUnifiedPurchaseFlow,
		isMultiItem = getUnifiedPurchaseModalType(p33.props.requestType) == UnifiedPurchaseModalTypeEnum.MultiItem,
		timedOptionDays = if not FFlagPurchasePromptSubtitleForTimedOptions then nil else p33.props.timedOptionDays,
		completionMessage = if not FFlagPurchaseModalTimedOptionExtension then nil else p33.props.completionMessage
	})
end
function v89.render(p36) -- line: 1158
	-- upvalues: FFlagSetMenuOnPurchasePrompt (copy), GuiService (copy), Roact (copy), Animator2 (copy), FFlagEnableBlackbirdUpsellInUnifiedPurchaseModal (copy), WindowState (copy), RequestType (copy), PromptState (copy), PublishAssetAnalytics (copy), FFlagEnableUnifiedProductPurchaseFlow (copy), ExternalEventConnection (copy), CoreGui (copy)
	local promptState = p36.props.promptState
	local v163 = p36:determinePrompt()

	if FFlagSetMenuOnPurchasePrompt then
		if v163 ~= nil then
			p36.menuOpenedBySelf = true
		end

		GuiService:SetMenuIsOpen(v163 ~= nil, "ProductPurchaseContainer")
	end

	return Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		[Roact.Change.AbsoluteSize] = p36.changeScreenSize,
		BackgroundTransparency = 1
	}, {
		Animator = Roact.createElement(Animator2, {
			shouldShow = if not FFlagEnableBlackbirdUpsellInUnifiedPurchaseModal then p36.props.windowState ~= WindowState.Hidden else p36.props.windowState == WindowState.Shown,
			onShown = function() -- line: 1178
				-- upvalues: p36 (copy), RequestType (copy), promptState (copy), PromptState (copy), PublishAssetAnalytics (copy)
				if p36.props.requestType == RequestType.AvatarCreationFee and promptState == PromptState.PromptPurchase then
					PublishAssetAnalytics.sendPageLoad(PublishAssetAnalytics.Section.BuyItemModal)
				end

				p36:setState({
					isAnimating = false,
					doneAnimatingTime = os.clock()
				})
			end,
			onHidden = function() -- line: 1190
				-- upvalues: p36 (copy)
				p36:setState({
					isAnimating = nil,
					doneAnimatingTime = nil
				})
			end,
			skipAnimation = if not FFlagEnableUnifiedProductPurchaseFlow then nil else p36.props.isUserEligibleForUnifiedPurchaseFlow,
			[Roact.Ref] = p36.animatorRef
		}, {
			Prompt = v163,
			ModalFix = v163 ~= nil and Roact.createElement("ImageButton", {
				BackgroundTransparency = 0,
				Modal = true,
				Size = UDim2.new(0, 0, 0, 0)
			}) or nil
		}),
		OnCoreGuiMenuOpened = Roact.createElement(ExternalEventConnection, {
			event = GuiService.MenuOpened,
			callback = function() -- line: 1211
				-- upvalues: FFlagSetMenuOnPurchasePrompt (copy), p36 (copy)
				if FFlagSetMenuOnPurchasePrompt and p36.menuOpenedBySelf then
					p36.menuOpenedBySelf = false

					return
				end

				if p36.props.hideWindow then
					p36.props.hideWindow()
				end
			end
		}),
		OnUserGuiRenderingChanged = Roact.createElement(ExternalEventConnection, {
			event = CoreGui.UserGuiRenderingChanged,
			callback = function(p37, p38) -- line: 1223
				-- upvalues: p36 (copy)
				if not p37 or not p38 then
					p36.props.hideWindow()
				end
			end
		})
	})
end

local function mapStateToProps(p39) -- line: 1233
	-- upvalues: isMockingPurchases (copy), SelectedRobuxPackage (copy), FFlagEnableUnifiedProductPurchaseFlow (copy), FFlagPurchasePromptPriceShouldUseProductInfoPrice (copy), selectProductPrice (copy), v65 (copy), FFlagPurchasePromptSubtitleForTimedOptions (copy), FFlagPurchaseModalTimedOptionExtension (copy), FFlagEnableBlackbirdUpsellInUnifiedPurchaseModal (copy), FFlagBlackbirdUpsellGateResaleAndTimedOption (copy), FFlagSkipBuyDelayForExperienceShop (copy), FFlagPurchasePromptCartPricingEnabled (copy), selectCartPricingResponse (copy), selectIsCartPricingFetching (copy)
	local v165 = isMockingPurchases(p39.promptRequest.requestType)
	local v166 = if not p39.abVariations then nil else p39.abVariations.DesktopUpsellExpVariant

	return {
		purchaseFlowUUID = p39.purchaseFlowUUID,
		purchaseFlow = p39.purchaseFlow,
		promptState = p39.promptState,
		requestType = p39.promptRequest.requestType,
		humanoidModel = p39.promptRequest.humanoidModel,
		expectedPrice = p39.promptRequest.expectedPrice,
		windowState = p39.windowState,
		purchaseError = p39.purchaseError,
		economicRestrictionError = p39.economicRestrictionError,
		productInfo = p39.productInfo,
		accountInfo = p39.accountInfo,
		robuxPurchaseAmount = SelectedRobuxPackage.getRobuxPurchaseAmount(p39),
		robuxAmountBeforeBonus = SelectedRobuxPackage.getRobuxAmountBeforeBonus(p39),
		robuxPurchaseCost = SelectedRobuxPackage.getPrice(p39),
		isTestPurchase = v165,
		isGamepadEnabled = p39.gamepadEnabled,
		desktopUpsellExpVariant = v166,
		postPurchaseActions = if not FFlagEnableUnifiedProductPurchaseFlow then nil else p39.postPurchaseActions,
		purchaseCallbacks = if not FFlagEnableUnifiedProductPurchaseFlow then nil else p39.purchaseCallbacks,
		isUserEligibleForUnifiedPurchaseFlow = if not FFlagEnableUnifiedProductPurchaseFlow then nil else p39.isUserEligibleForUnifiedPurchaseFlow,
		purchaseAnalyticsMetadata = if not FFlagEnableUnifiedProductPurchaseFlow then nil else p39.purchaseAnalyticsMetadata,
		productPrice = if not FFlagPurchasePromptPriceShouldUseProductInfoPrice then nil else selectProductPrice(p39),
		price = if not v65 then nil else v65(p39),
		timedOptionDays = if not FFlagPurchasePromptSubtitleForTimedOptions or not p39.productPayload then nil else p39.productPayload.timedOptionDays,
		completionMessage = if not FFlagPurchaseModalTimedOptionExtension or not p39.purchaseOptions then nil else p39.purchaseOptions.completionMessage,
		robloxSubscriptionProducts = if not FFlagEnableBlackbirdUpsellInUnifiedPurchaseModal then nil else p39.robloxSubscriptionProducts,
		productPayload = if not FFlagBlackbirdUpsellGateResaleAndTimedOption and not FFlagSkipBuyDelayForExperienceShop then nil else p39.productPayload,
		cartPricingResponse = if not FFlagPurchasePromptCartPricingEnabled then nil else selectCartPricingResponse(p39),
		isCartPricingLoading = if not FFlagPurchasePromptCartPricingEnabled then nil else selectIsCartPricingFetching(p39)
	}
end
local function mapDispatchToProps(p40) -- line: 1285
	-- upvalues: SetPurchaseFlowUUID (copy), purchaseItem (copy), completePurchase (copy), launchRobuxUpsell (copy), openSecuritySettings (copy), initiateUserPurchaseSettingsPrecheck (copy), hideWindow (copy), retryPurchaseAfterUpsell (copy), SetWindowState (copy), FFlagAddCursorProviderToPurchasePromptApp (copy), GuiService (copy), completeRequest (copy), sendEvent (copy), SetPostPurchaseActions (copy), SetPromptState (copy), FFlagPurchasePromptCartPricingEnabled (copy), fetchCartPricing (copy)
	return {
		setPurchaseFlowUUID = function(p41) -- line: 1287
			-- upvalues: p40 (copy), SetPurchaseFlowUUID (copy)
			p40(SetPurchaseFlowUUID(p41))
		end,
		onBuy = function() -- line: 1290
			-- upvalues: p40 (copy), purchaseItem (copy)
			p40(purchaseItem())
		end,
		completePurchase = function() -- line: 1293
			-- upvalues: p40 (copy), completePurchase (copy)
			p40(completePurchase())
		end,
		onScaryModalConfirm = function() -- line: 1296
			-- upvalues: p40 (copy), launchRobuxUpsell (copy)
			p40(launchRobuxUpsell())
		end,
		onOpenSecuritySettings = function(s1: string?) -- line: 1299
			-- upvalues: p40 (copy), openSecuritySettings (copy)
			if s1 then
				p40(openSecuritySettings(s1))

				return
			end

			p40(openSecuritySettings())
		end,
		onRobuxUpsell = function() -- line: 1306
			-- upvalues: p40 (copy), initiateUserPurchaseSettingsPrecheck (copy)
			p40(initiateUserPurchaseSettingsPrecheck())
		end,
		hideWindow = function() -- line: 1309
			-- upvalues: p40 (copy), hideWindow (copy)
			p40(hideWindow())
		end,
		retryPurchaseAfterUpsell = function() -- line: 1312
			-- upvalues: p40 (copy), retryPurchaseAfterUpsell (copy)
			p40(retryPurchaseAfterUpsell())
		end,
		setWindowState = function(p42) -- line: 1315
			-- upvalues: p40 (copy), SetWindowState (copy)
			p40(SetWindowState(p42))
		end,
		completeRequest = function() -- line: 1318
			-- upvalues: FFlagAddCursorProviderToPurchasePromptApp (copy), GuiService (copy), p40 (copy), completeRequest (copy)
			if FFlagAddCursorProviderToPurchasePromptApp then
				GuiService.SelectedCoreObject = nil
			end

			p40(completeRequest())
		end,
		onAnalyticEvent = function(p43, p44) -- line: 1324
			-- upvalues: p40 (copy), sendEvent (copy)
			p40(sendEvent(p43, p44))
		end,
		setPostPurchaseActions = function(p45) -- line: 1327
			-- upvalues: p40 (copy), SetPostPurchaseActions (copy)
			p40(SetPostPurchaseActions(p45))
		end,
		setPromptState = function(p46) -- line: 1330
			-- upvalues: p40 (copy), SetPromptState (copy)
			p40(SetPromptState(p46))
		end,
		fetchCartPricing = if not FFlagPurchasePromptCartPricingEnabled then nil else function(t4: {[any]: any}?) -- line: 1334
			-- upvalues: p40 (copy), fetchCartPricing (copy)
			p40(fetchCartPricing(t4))
		end
	}
end

return (connectToStore(mapStateToProps, mapDispatchToProps)(v89))
