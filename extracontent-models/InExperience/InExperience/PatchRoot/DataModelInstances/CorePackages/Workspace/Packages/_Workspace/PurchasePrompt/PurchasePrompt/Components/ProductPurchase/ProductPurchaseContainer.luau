local GuiService = game:GetService("GuiService")
local ContextActionService = game:GetService("ContextActionService")

local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent
local PurchasePromptDeps = require(parent.PurchasePromptDeps)
local Roact = PurchasePromptDeps.Roact
local React = require(parent.React)

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local CachedPolicyService = require(parent.CachedPolicyService)
local RobloxTranslator = require(parent.RobloxTranslator)

local UIBlox = PurchasePromptDeps.UIBlox
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Images = UIBlox.App.ImageSet.Images

local IAPExperience = require(parent.IAPExperience)
local ProductPurchase = IAPExperience.ProductPurchase
local ProductPurchaseRobuxUpsell = IAPExperience.ProductPurchaseRobuxUpsell
local LeaveRobloxAlert = IAPExperience.LeaveRobloxAlert
local Animator = IAPExperience.Animator
local UnifiedProductPurchaseModal = IAPExperience.UnifiedProductPurchaseModal
local UnifiedProductPurchaseModalV2 = IAPExperience.UnifiedProductPurchaseModalV2

local RobloxSubscriptionPurchaseApp = require(parent.RobloxSubscriptionPurchaseApp)
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
local isGenericChallengeResponse = require(PurchasePrompt.Utils.isGenericChallengeResponse)
local SelectedRobuxPackage = require(PurchasePrompt.Utils.SelectedRobuxPackage)
local PurchasePromptLite = require(parent.PurchasePromptLite)
local ProductPurchaseSurface = PurchasePromptLite.Enums.ProductPurchaseSurface
local logUnifiedPurchaseTelemetryCounter = require(PurchasePrompt.Utils.logUnifiedPurchaseTelemetryCounter)
local emitPerformanceMetrics = require(PurchasePrompt.Utils.emitPerformanceMetrics)

local initiateUserPurchaseSettingsPrecheck = require(PurchasePrompt.Thunks.initiateUserPurchaseSettingsPrecheck)
local VerifiedParentalConsentDialog = require(parent.VerifiedParentalConsentDialog)
local verifiedParentalConsentDialog = VerifiedParentalConsentDialog.VerifiedParentalConsentDialog
local VPCModalType = require(PurchasePrompt.Enums.VPCModalType)
local Animator2 = require(script.Parent.Animator)
local SharedFlags = require(parent.SharedFlags)
local FFlagAddCursorProviderToPurchasePromptApp = SharedFlags.FFlagAddCursorProviderToPurchasePromptApp
local getUnifiedPurchaseModalType = require(PurchasePrompt.Utils.getUnifiedPurchaseModalType)
local selectProductPrice = require(PurchasePrompt.Selectors.selectProductPrice)
local selectPrice = require(PurchasePrompt.Selectors.selectPrice)
local SetPromptState = require(PurchasePrompt.Actions.SetPromptState)
local FFlagAddSurfaceAndProductTypeToPromptCounter = require(PurchasePrompt.Flags.FFlagAddSurfaceAndProductTypeToPromptCounter)

local HttpService = game:GetService("HttpService")
local SetPurchaseFlowUUID = require(PurchasePrompt.Actions.SetPurchaseFlowUUID)
local SetPostPurchaseActions = require(PurchasePrompt.Actions.SetPostPurchaseActions)
local sendUnifiedPurchaseEventLog = require(PurchasePrompt.Utils.sendUnifiedPurchaseEventLog)
local UnifiedPurchaseEventNameEnum = require(PurchasePrompt.Enums.UnifiedPurchaseEventNameEnum)
local Constants = require(PurchasePrompt.Misc.Constants)

local FFlagEnablePurchaseFlowUUIDMigration = require(PurchasePrompt.Flags.FFlagEnablePurchaseFlowUUIDMigration)
local SharedFlags2 = require(parent.SharedFlags)
local FFlagEnableLaunchAfterPurchase = SharedFlags2.FFlagEnableLaunchAfterPurchase
local experienceService

if FFlagEnableLaunchAfterPurchase then
	local ExperienceService = require(parent.ExperienceService)
	experienceService = ExperienceService.ExperienceService
else
	experienceService = nil
end

local LoggingProtocol = require(parent.LoggingProtocol)

local PurchaseFlowUUIDTelemetry = require(PurchasePrompt.Events.PurchaseFlowUUIDTelemetry)
local UnifiedPurchaseTelemetry = require(PurchasePrompt.Events.UnifiedPurchaseTelemetry)
local AppContext = require(PurchasePrompt.Utils.AppContext)
local fetchCartPricing = require(PurchasePrompt.Thunks.fetchCartPricing)
local fetchInGameItemCartPricing = require(PurchasePrompt.Thunks.fetchInGameItemCartPricing)
local selectCartPricingResponse = require(PurchasePrompt.Selectors.selectCartPricingResponse)
local selectIsCartPricingFetching = require(PurchasePrompt.Selectors.selectIsCartPricingFetching)

local FFlagPurchasePromptUnifiedEventsUseOfferAdjustedPrice = SharedFlags.FFlagPurchasePromptUnifiedEventsUseOfferAdjustedPrice

local FFlagPurchasePromptGamePausedOnlyHideShownWindow = require(PurchasePrompt.Flags.FFlagPurchasePromptGamePausedOnlyHideShownWindow)
local deriveCartPricingView = IAPExperience.deriveCartPricingView

local DesktopUpsellExperiment = IAPExperience.Utility.DesktopUpsellExperiment
local ProductPurchaseModal = IAPExperience.ProductPurchaseModal
local RobuxUpsellModal = IAPExperience.RobuxUpsellModal
local RobuxUpsellModalTooExpensiveFallback = IAPExperience.RobuxUpsellModalTooExpensiveFallback

local shouldShowBlackbirdUpsell = require(PurchasePrompt.Utils.shouldShowBlackbirdUpsell)
local extended = Roact.Component:extend(script.Name)
local ProductPurchasePrompt = require(script.Parent.ProductPurchasePrompt)
local VIPServerPostPurchaseContainer = require(PurchasePrompt.Components.VIPServerPostPurchase.VIPServerPostPurchaseContainer)

local SharedFlags3 = require(parent.SharedFlags)
local GetFFlagOpenVngTosForVngRobuxUpsell = SharedFlags3.GetFFlagOpenVngTosForVngRobuxUpsell
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local getAppFeaturePolicies = UniversalAppPolicy.getAppFeaturePolicies
local UnifiedPurchaseModalTypeEnum = IAPExperience.Enums.UnifiedPurchaseModalTypeEnum

local SharedFlags4 = require(parent.SharedFlags)
local FFlagUnifiedPurchaseFlowMarketplaceUIImprovements = SharedFlags4.FFlagUnifiedPurchaseFlowMarketplaceUIImprovements

local SharedFlags5 = require(parent.SharedFlags)
local FFlagAddPerformanceMetricsToUnifiedPurchaseModal = SharedFlags5.FFlagAddPerformanceMetricsToUnifiedPurchaseModal
local SharedFlags6 = require(parent.SharedFlags)
local FFlagEnableUnifiedPurchaseFlowForDevSubs = SharedFlags6.FFlagEnableUnifiedPurchaseFlowForDevSubs

local SharedFlags7 = require(parent.SharedFlags)
local FFlagAddCenterDialogForUnifiedPurchaseModal = SharedFlags7.FFlagAddCenterDialogForUnifiedPurchaseModal
local SharedFlags8 = require(parent.SharedFlags)
local FFlagUnifiedPurchaseAddSkeleton = SharedFlags8.FFlagUnifiedPurchaseAddSkeleton

local SharedFlags9 = require(parent.SharedFlags)
local FFlagEnableSubscriptionUpsellUnifiedPurchaseEventTelemetry = SharedFlags9.FFlagEnableSubscriptionUpsellUnifiedPurchaseEventTelemetry

local defineFastFlag = game:DefineFastFlag("RemoveDelayedInputForUnifiedPurchaseModal", true)

local SharedFlags10 = require(parent.SharedFlags)
local FFlagPurchasePromptSubtitleForTimedOptions = SharedFlags10.FFlagPurchasePromptSubtitleForTimedOptions
local SharedFlags11 = require(parent.SharedFlags)
local FFlagPurchaseModalTimedOptionExtension = SharedFlags11.FFlagPurchaseModalTimedOptionExtension

local SharedFlags12 = require(parent.SharedFlags)
local FFlagAddOnRobloxSubscriptionUpsellSuccessCallbackToUnifiedPurchaseModal = SharedFlags12.FFlagAddOnRobloxSubscriptionUpsellSuccessCallbackToUnifiedPurchaseModal

local SharedFlags13 = require(parent.SharedFlags)
local FFlagEnableBlackbirdUpsellImpressionGating = SharedFlags13.FFlagEnableBlackbirdUpsellImpressionGating
local BlackbirdUpsellImpressionTracker = require(PurchasePrompt.Utils.BlackbirdUpsellImpressionTracker)
local FFlagBlackbirdUpsellGateResaleAndTimedOption = require(PurchasePrompt.Flags.FFlagBlackbirdUpsellGateResaleAndTimedOption)
local FFlagSetMenuOnPurchasePrompt = require(PurchasePrompt.Flags.FFlagSetMenuOnPurchasePrompt)
local FFlagSkipBuyDelayForExperienceShop = require(PurchasePrompt.Flags.FFlagSkipBuyDelayForExperienceShop)

local FFlagPurchasePromptIgnoreConfirmWhilePurchaseInProgress = require(PurchasePrompt.Flags.FFlagPurchasePromptIgnoreConfirmWhilePurchaseInProgress)

local SharedFlags14 = require(parent.SharedFlags)
local FFlagLuaAppsEnablePromptVIPServerPurchase = SharedFlags14.FFlagLuaAppsEnablePromptVIPServerPurchase

local function isRelevantRequestType(p, p2, p3)
	if
		FFlagUnifiedPurchaseAddSkeleton
		and p3 == PromptState.InitializingPurchase
		and p2 == PurchaseFlow.RobuxUpsellV2
	then
		return true
	end

	if p2 == PurchaseFlow.RobuxUpsellV2 or p2 == PurchaseFlow.LargeRobuxUpsell then
		return false
	end

	return (p == RequestType.Asset or p == RequestType.Bundle or p == RequestType.GamePass or p == RequestType.Product or p == RequestType.AvatarCreationFee or p == RequestType.Experience or p == RequestType.Look or FFlagEnableUnifiedPurchaseFlowForDevSubs and p == RequestType.DeveloperSubscription)
		and true
		or FFlagLuaAppsEnablePromptVIPServerPurchase and p == RequestType.VIPServer
end

local function isShowingVIPServerPostPurchase(props): boolean -- 3 equivalent calls inferred from this helper
	return props.promptState == PromptState.PurchaseComplete and props.requestType == RequestType.VIPServer
end

local function getIsFiatProduct(p, p2, p3: number): boolean
	if not FFlagEnableUnifiedPurchaseFlowForDevSubs or p ~= RequestType.DeveloperSubscription then
		return false
	end

	return p2.displayPrice ~= nil and p3 == 0
end

local function promptStateToViewName(promptState) -- 1 equivalent call inferred from this helper
	return ({
		[PromptState.RobuxUpsell] = "PurchaseModal",
		[PromptState.UpsellInProgress] = "RobuxPurchasePending"
	})[promptState]
end

function extended:init()
	self.state = {
		screenSize = Vector2.new(0, 0),
		isLuobu = false,
		analyticId = HttpService:GenerateGUID(false)
	}

	if not FFlagEnablePurchaseFlowUUIDMigration then
		self.props.setPurchaseFlowUUID(HttpService:GenerateGUID(false))
		LoggingProtocol.default:logRobloxTelemetryCounter(
			PurchaseFlowUUIDTelemetry.ProductPurchaseContainerMigrationCounter,
			1,
			{ method = "ProductPurchaseContainerInit" }
		)
	end

	coroutine.wrap(function()
		if CachedPolicyService:IsSubjectToChinaPolicies() then
			self:setState({ isLuobu = true })
		end
	end)()

	function self.emitPurchaseFlowEvent(purchase_event_type, input_type)
		local view_name = promptStateToViewName(self.props.promptState) -- inferred equivalent call

		if not view_name then
			return
		end

		local v = {
			purchase_flow_uuid = self.props.purchaseFlowUUID,
			purchase_flow = "InGameRobuxUpsell",
			view_name = view_name,
			purchase_event_type = purchase_event_type,
			input_type = input_type,
			event_metadata = HttpService:JSONEncode({
				universe_id = tostring(game.GameId),
				item_product_id = tostring(self.props.productInfo.productId),
				item_name = self.props.productInfo.name,
				price = tostring(self.props.productInfo.price),
				user_balance = tostring(self.props.accountInfo.balance) or nil,
				package_robux_amount = tostring(self.props.robuxPurchaseAmount) or nil
			})
		}

		self.props.onAnalyticEvent("UserPurchaseFlow", v)
	end

	function self.emitUnifiedProductPurchaseFlowEvent(event_name)
		local purchaseAnalyticsMetadata = self.props.purchaseAnalyticsMetadata or {}
		local robux_price

		if FFlagPurchasePromptUnifiedEventsUseOfferAdjustedPrice and self.props.productPrice ~= nil then
			robux_price = self.props.productPrice
		else
			robux_price = purchaseAnalyticsMetadata.price
		end

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
			product_universeid = purchaseAnalyticsMetadata.productUniverseId
		})
	end

	function self.changeScreenSize(p)
		if self.state.screenSize ~= p.AbsoluteSize then
			self:setState({ screenSize = p.AbsoluteSize })
		end
	end

	function self.isFromShopSkip(): boolean
		return self.props.productPayload ~= nil and self.props.productPayload.isFromInExperienceShop == true
	end

	function self.hasDelayedInput(): boolean
		if not defineFastFlag and self.props.isTestPurchase then
			return false
		end

		local promptState = self.props.promptState

		if
			promptState == PromptState.PromptPurchase
			and self.buyButtonUsesFoundationInputDelay
			and not (FFlagSkipBuyDelayForExperienceShop and self.isFromShopSkip())
		then
			return true
		end

		if defineFastFlag then
			if
				FFlagSkipBuyDelayForExperienceShop
				and self.isFromShopSkip()
				and (promptState == PromptState.RobuxUpsell or promptState == PromptState.UpsellInProgress)
			then
				return false
			end

			return promptState == PromptState.PurchaseInProgress
				or promptState == PromptState.RobuxUpsell
				or promptState == PromptState.UpsellInProgress
		elseif
			FFlagSkipBuyDelayForExperienceShop
			and self.isFromShopSkip()
			and (promptState == PromptState.PromptPurchase or promptState == PromptState.RobuxUpsell or promptState == PromptState.UpsellInProgress)
		then
			return false
		else
			return promptState == PromptState.PromptPurchase
				or promptState == PromptState.PurchaseInProgress
				or promptState == PromptState.RobuxUpsell
				or promptState == PromptState.UpsellInProgress
		end
	end

	function self.isWindowShowAndDoneAnimating(): boolean
		return self.state.isAnimating == false
	end

	self.buyButtonUsesFoundationInputDelay = AppContext.get() == AppContext.Enum.IN_EXPERIENCE

	function self.canConfirmInput()
		if Players.LocalPlayer.GameplayPaused then
			return false
		end

		local windowShowAndDoneAnimating = self.isWindowShowAndDoneAnimating()

		if not self.hasDelayedInput() then
			return windowShowAndDoneAnimating
		end

		local v

		if self.state.doneAnimatingTime then
			v = os.clock() - self.state.doneAnimatingTime > 2.5
		else
			v = false
		end

		return windowShowAndDoneAnimating and v
	end

	function self.getConfirmButtonAction(p, p2, p3)
		if
			p == PromptState.None
			or not isRelevantRequestType(p2)
			or FFlagPurchasePromptIgnoreConfirmWhilePurchaseInProgress and p == PromptState.PurchaseInProgress
		then
			return nil
		end

		if p == PromptState.PromptPurchase or p == PromptState.PurchaseInProgress then
			if self.props.isUserEligibleForUnifiedPurchaseFlow then
				local purchaseAnalyticsMetadata = self.props.purchaseAnalyticsMetadata or {}

				logUnifiedPurchaseTelemetryCounter(
					UnifiedPurchaseTelemetry.UnifiedProductPurchaseModalBuyItemButtonClickedCounter,
					purchaseAnalyticsMetadata.surface,
					purchaseAnalyticsMetadata.productType
				)

				self.emitUnifiedProductPurchaseFlowEvent(UnifiedPurchaseEventNameEnum.BuyItemModalBuyClicked)
			end

			return self.props.onBuy
		end

		if FFlagPurchasePromptIgnoreConfirmWhilePurchaseInProgress and p == PromptState.UpsellInProgress then
			return nil
		end

		if p == PromptState.RobuxUpsell or p == PromptState.UpsellInProgress or p == PromptState.LeaveRobloxWarning then
			return self.props.onRobuxUpsell
		end

		if
			p == PromptState.U13PaymentModal
			or p == PromptState.U13MonthlyThreshold1Modal
			or p == PromptState.U13MonthlyThreshold2Modal
			or p == PromptState.ParentalConsentWarningPaymentModal13To17
		then
			return self.props.onScaryModalConfirm
		end

		if p == PromptState.Error and p3 == PurchaseError.TwoFactorNeededSettings then
			return self.props.onOpenSecuritySettings
		end

		if isGenericChallengeResponse(p3) then
			return function()
				self.props.onOpenSecuritySettings(p3)
			end
		end

		return self.props.hideWindow
	end

	function self.getCancelButtonAction(p, p2)
		if p == PromptState.None or not isRelevantRequestType(p2) then
			return nil
		end

		return self.props.hideWindow
	end

	function self.confirmButtonPressed()
		if
			self.props.requestType == RequestType.AvatarCreationFee
			and self.props.promptState == PromptState.PromptPurchase
		then
			PublishAssetAnalytics.sendButtonClicked(
				PublishAssetAnalytics.Section.BuyItemModal,
				PublishAssetAnalytics.Element.Buy
			)
		end

		local confirmButtonAction = self.getConfirmButtonAction(
			self.props.promptState,
			self.props.requestType,
			self.props.purchaseError
		)

		if confirmButtonAction ~= nil and self.canConfirmInput() then
			confirmButtonAction()
		end
	end

	function self.launchAfterPurchaseButtonShown()
		self.emitUnifiedProductPurchaseFlowEvent(UnifiedPurchaseEventNameEnum.LaunchAfterPurchaseButtonShown)
	end

	function self.launchAfterPurchaseButtonPressed()
		self.emitUnifiedProductPurchaseFlowEvent(UnifiedPurchaseEventNameEnum.LaunchAfterPurchaseButtonClicked)
		local launchAfterPurchaseRootPlaceId = self.props.launchAfterPurchaseRootPlaceId
		local onLaunchAfterPurchase

		if FFlagEnableLaunchAfterPurchase then
			onLaunchAfterPurchase = self.props.purchaseCallbacks and self.props.purchaseCallbacks.onLaunchAfterPurchase
		else
			onLaunchAfterPurchase = nil
		end

		self.confirmButtonPressed()
		task.defer(function()
			local placeId = tonumber(launchAfterPurchaseRootPlaceId)

			if placeId == nil or experienceService == nil then
				return
			end

			self.emitUnifiedProductPurchaseFlowEvent(UnifiedPurchaseEventNameEnum.ExperienceLaunchedAfterPurchase)

			if onLaunchAfterPurchase then
				onLaunchAfterPurchase()
			end

			experienceService:LaunchExperience({ placeId = placeId }, "PurchaseCompletionPlayButton")
		end)
	end

	function self.cancelButtonPressed()
		if
			self.props.requestType == RequestType.AvatarCreationFee
			and self.props.promptState == PromptState.PromptPurchase
		then
			PublishAssetAnalytics.sendButtonClicked(
				PublishAssetAnalytics.Section.BuyItemModal,
				PublishAssetAnalytics.Element.Cancel
			)
		end

		if self.props.isUserEligibleForUnifiedPurchaseFlow then
			logUnifiedPurchaseTelemetryCounter(
				UnifiedPurchaseTelemetry.UnifiedProductPurchaseModalCancelButtonClickedCounter,
				self.props.purchaseAnalyticsMetadata.surface,
				self.props.purchaseAnalyticsMetadata.productType
			)
		end

		local cancelButtonAction = self.getCancelButtonAction(self.props.promptState, self.props.requestType)

		if cancelButtonAction ~= nil then
			cancelButtonAction()
		end
	end

	function self.configContextActionService(p)
		if p == WindowState.Shown then
			ContextActionService:BindCoreAction("ProductPurchaseConfirmButtonBind", function(_, p2, _)
				if FFlagLuaAppsEnablePromptVIPServerPurchase and isShowingVIPServerPostPurchase(self.props) then -- inferred equivalent call
					return Enum.ContextActionResult.Pass
				end

				if p2 == Enum.UserInputState.Begin then
					self.confirmButtonPressed()
				end
			end, false, Enum.KeyCode.ButtonA)
			ContextActionService:BindCoreAction("ProductPurchaseCancelButtonBind", function(_, p2, _)
				if FFlagLuaAppsEnablePromptVIPServerPurchase and isShowingVIPServerPostPurchase(self.props) then -- inferred equivalent call
					return Enum.ContextActionResult.Pass
				end

				if p2 == Enum.UserInputState.Begin then
					self.cancelButtonPressed()
				end
			end, false, Enum.KeyCode.ButtonB)
		else
			ContextActionService:UnbindCoreAction("ProductPurchaseConfirmButtonBind")
			ContextActionService:UnbindCoreAction("ProductPurchaseCancelButtonBind")
		end
	end

	function self.getVPCModalType(p)
		if p == PromptState.EnablePurchaseVPCModal then
			return VPCModalType.toRawValue(VPCModalType.EnablePurchase)
		end

		return VPCModalType.toRawValue(VPCModalType.None)
	end

	function self.onBuyItemButtonMounted(p)
		local purchaseAnalyticsMetadata = self.props.purchaseAnalyticsMetadata or {}

		logUnifiedPurchaseTelemetryCounter(
			UnifiedPurchaseTelemetry.UnifiedProductPurchaseModalShownCounter,
			purchaseAnalyticsMetadata.surface,
			purchaseAnalyticsMetadata.productType
		)

		self.emitUnifiedProductPurchaseFlowEvent(UnifiedPurchaseEventNameEnum.BuyItemModalShown)

		if
			FFlagAddPerformanceMetricsToUnifiedPurchaseModal
			and purchaseAnalyticsMetadata
			and purchaseAnalyticsMetadata.surface
		then
			emitPerformanceMetrics(
				Constants.PerformanceMetrics.IntervalName.ProductPurchaseContainerShown,
				purchaseAnalyticsMetadata.surface
			)
		end

		if self.props.purchaseCallbacks and self.props.purchaseCallbacks.onBuyItemButtonMounted then
			self.props.purchaseCallbacks.onBuyItemButtonMounted(p)
		end
	end
end

function extended.didMount(object)
	local purchaseFlow = object.props.purchaseFlow
	local requestType = object.props.requestType

	if object.props.windowState == WindowState.Shown and isRelevantRequestType(requestType, purchaseFlow) then
		object:setState({ isAnimating = true })

		object.configContextActionService(object.props.windowState)

		GuiService.SetPurchasePromptIsShown(true)
	end
end

function extended.willUpdate(object, p)
	if object.props.expectedPrice ~= p.expectedPrice then
		object:setState({})
	end
end

function extended.didUpdate(object, p, _)
	if
		not FFlagEnablePurchaseFlowUUIDMigration
		and object.props.promptState ~= p.promptState
		and object.props.promptState == PromptState.None
	then
		local guid = HttpService:GenerateGUID(false)
		object.props.setPurchaseFlowUUID(guid)

		LoggingProtocol.default:logRobloxTelemetryCounter(
			PurchaseFlowUUIDTelemetry.ProductPurchaseContainerMigrationCounter,
			1,
			{ method = "ProductPurchaseContainerDidUpdate" }
		)
	end

	if FFlagPurchasePromptGamePausedOnlyHideShownWindow then
		if Players.LocalPlayer.GameplayPaused and object.props.windowState == WindowState.Shown then
			object.props.onAnalyticEvent("PurchasePromptGamePausedDetected", {
				place_id = game.PlaceId
			})
			object.props.hideWindow()
		end
	elseif Players.LocalPlayer.GameplayPaused then
		object.props.onAnalyticEvent("PurchasePromptGamePausedDetected", { place_id = game.PlaceId })
		object.props.hideWindow()
	end

	local purchaseFlow = object.props.purchaseFlow
	local requestType = object.props.requestType

	if p.windowState ~= object.props.windowState and isRelevantRequestType(requestType, purchaseFlow) then
		object:setState({ isAnimating = true })

		object.configContextActionService(object.props.windowState)

		GuiService:SetPurchasePromptIsShown(object.props.windowState == WindowState.Shown)

		if object.props.windowState == WindowState.Hidden then
			object.props.completeRequest()
		end
	end

	if
		requestType == RequestType.AvatarCreationFee
		and object.props.promptState == PromptState.PurchaseComplete
		and p.promptState ~= PromptState.PurchaseComplete
	then
		PublishAssetAnalytics.sendPageLoad(PublishAssetAnalytics.Section.ProcessCompleteModal)
	end

	if p.promptState ~= object.props.promptState then
		object.emitPurchaseFlowEvent("ViewShown")
	end
end

function extended.getMessageKeysFromPromptState(p)
	local promptState = p.props.promptState
	local productInfo = p.props.productInfo
	local purchaseError = p.props.purchaseError

	if promptState == PromptState.PurchaseComplete then
		return {
			messageText = {
				key = "CoreScripts.PurchasePrompt.PurchaseMessage.Succeeded",
				params = { ITEM_NAME = productInfo.name }
			},
			okText = { key = "CoreScripts.PurchasePrompt.Button.OK" },
			titleText = { key = "CoreScripts.PurchasePrompt.Title.BuyItem" }
		}
	end

	if promptState == PromptState.U13PaymentModal then
		return {
			messageText = { key = "CoreScripts.PurchasePrompt.PurchaseDetails.ScaryModalOne" },
			okText = { key = "CoreScripts.PurchasePrompt.Button.OK" },
			titleText = { key = "CoreScripts.PurchasePrompt.Title.BuyItem" }
		}
	end

	if promptState == PromptState.U13MonthlyThreshold1Modal then
		return {
			messageText = { key = "CoreScripts.PurchasePrompt.PurchaseDetails.ScaryModalTwo" },
			okText = { key = "CoreScripts.PurchasePrompt.Button.OK" },
			titleText = { key = "CoreScripts.PurchasePrompt.Title.BuyItem" }
		}
	end

	if promptState == PromptState.U13MonthlyThreshold2Modal then
		return {
			messageText = { key = "CoreScripts.PurchasePrompt.PurchaseDetails.ScaryModalParental" },
			okText = { key = "CoreScripts.PurchasePrompt.Button.OK" },
			titleText = { key = "CoreScripts.PurchasePrompt.Title.BuyItem" }
		}
	end

	if promptState == PromptState.ParentalConsentWarningPaymentModal13To17 then
		return {
			messageText = { key = "CoreScripts.PurchasePrompt.PurchaseDetails.ParentalConsent" },
			okText = { key = "CoreScripts.PurchasePrompt.Button.OK" },
			titleText = { key = "CoreScripts.PurchasePrompt.Title.BuyItem" }
		}
	end

	if promptState ~= PromptState.Error then
		return
	end

	if purchaseError == PurchaseError.UnknownFailure then
		return {
			messageText = {
				key = LocalizationService.getErrorKey(purchaseError),
				params = { ITEM_NAME = productInfo.name }
			},
			okText = { key = "CoreScripts.PurchasePrompt.Button.OK" },
			titleText = { key = "CoreScripts.PremiumModal.Title.Error" }
		}
	end

	if purchaseError == PurchaseError.TwoFactorNeededSettings or isGenericChallengeResponse(purchaseError) then
		return {
			messageText = { key = "CoreScripts.PurchasePrompt.PurchaseFailed.Enable2SVLogout" },
			okText = { key = "CoreScripts.PurchasePrompt.Button.Settings" },
			cancelText = { key = "CoreScripts.PurchasePrompt.CancelPurchase.Cancel" },
			titleText = { key = "CoreScripts.PurchasePrompt.Title.VerificationRequired" }
		}
	end

	return {
		messageText = {
			key = LocalizationService.getErrorKey(purchaseError)
		},
		okText = { key = "CoreScripts.PurchasePrompt.Button.OK" },
		titleText = { key = "CoreScripts.PremiumModal.Title.Error" }
	}
end

function extended:determinePrompt()
	local purchaseFlow = self.props.purchaseFlow
	local promptState = self.props.promptState
	local requestType = self.props.requestType
	local purchaseError = self.props.purchaseError

	local productInfo = self.props.productInfo
	local accountInfo = self.props.accountInfo
	local isTestPurchase = self.props.isTestPurchase

	if not (self.props.windowState == WindowState.Shown and promptState ~= PromptState.None) then
		return nil
	end

	local v

	if FFlagUnifiedPurchaseAddSkeleton then
		v = promptState
	end

	if not isRelevantRequestType(requestType, purchaseFlow, v) then
		return nil
	end

	if
		promptState == PromptState.PromptPurchase
		or promptState == PromptState.PurchaseInProgress
		or FFlagUnifiedPurchaseAddSkeleton and promptState == PromptState.InitializingPurchase
	then
		if self.props.isUserEligibleForUnifiedPurchaseFlow then
			local productPrice = self.props.productPrice
			local hideUserRobuxBalance

			if
				FFlagEnableUnifiedPurchaseFlowForDevSubs
				and requestType == RequestType.DeveloperSubscription
				and productInfo.displayPrice ~= nil
			then
				hideUserRobuxBalance = productPrice == 0
			else
				hideUserRobuxBalance = false
			end

			local function fn()
				self.props.setPromptState(PromptState.BlackbirdUpsellInProgress)
				self.props.setWindowState(WindowState.Suspended)

				local purchaseFlowUUID = self.props.purchaseFlowUUID

				if not purchaseFlowUUID or purchaseFlowUUID == "" then
					purchaseFlowUUID = nil
				end

				local clientSessionId = purchaseFlowUUID
					and {
						clientSessionIdType = PurchaseClientSessionIdType.PurchaseFlowUUID,
						clientSessionId = purchaseFlowUUID
					}
					or nil

				local initiateRobloxSubscriptionPurchase = RobloxSubscriptionPurchaseApp.initiateRobloxSubscriptionPurchase

				local unifiedProductPurchaseModal = SurfaceName.UnifiedProductPurchaseModal
				local v2

				if AppContext.get() == AppContext.Enum.IN_APP then
					v2 = SurfaceContext.InApp
				else
					v2 = SurfaceContext.InGame
				end

				initiateRobloxSubscriptionPurchase({ showBackButton = true }, {
					onFlowComplete = function(p)
						if p == RobloxSubscriptionFlowCompleteReason.UpsellPurchaseSucceeded then
							if
								FFlagAddOnRobloxSubscriptionUpsellSuccessCallbackToUnifiedPurchaseModal
								and self.props.purchaseCallbacks
								and self.props.purchaseCallbacks.onRobloxSubscriptionUpsellSuccess
							then
								self.props.purchaseCallbacks.onRobloxSubscriptionUpsellSuccess()
							end

							self.props.retryPurchaseAfterUpsell()
						else
							if p == RobloxSubscriptionFlowCompleteReason.UpsellDismissed then
								self.props.completeRequest()
								return
							end

							if p == RobloxSubscriptionFlowCompleteReason.UpsellPurchaseFailed then
							end

							self.props.completeRequest()
						end
					end,
					onBackButtonActivated = function()
						self.props.setPromptState(PromptState.PromptPurchase)
						self.props.setWindowState(WindowState.Shown)
					end
				}, nil, unifiedProductPurchaseModal, v2, nil, clientSessionId and {
					clientSessionId = clientSessionId
				} or nil)
			end

			local price

			if not hideUserRobuxBalance then
				price = self.props.price
			end

			local v2 = deriveCartPricingView(self.props.cartPricingResponse)
			local unifiedPurchaseModalType = getUnifiedPurchaseModalType(requestType)
			local itemRobuxCost = self.props.productPrice

			if
				not hideUserRobuxBalance
				and v2 ~= nil
				and unifiedPurchaseModalType == UnifiedPurchaseModalTypeEnum.MultiItem
			then
				itemRobuxCost = v2.priceAfterDiscount
			end

			local requestType2 = self.props.requestType
			local productPayload

			if FFlagBlackbirdUpsellGateResaleAndTimedOption then
				productPayload = self.props.productPayload
			end

			local blackbirdUpsellBannerProductInfo

			if
				shouldShowBlackbirdUpsell(price, requestType2, hideUserRobuxBalance, productPayload)
				and self.props.robloxSubscriptionProducts
			then
				blackbirdUpsellBannerProductInfo = getBlackbirdUpsellBannerProductInfo(self.props.robloxSubscriptionProducts)
			else
				blackbirdUpsellBannerProductInfo = nil
			end

			local function onBuyItemButtonMounted(p)
				self.onBuyItemButtonMounted(p)

				if FFlagEnableSubscriptionUpsellUnifiedPurchaseEventTelemetry and blackbirdUpsellBannerProductInfo then
					self.emitUnifiedProductPurchaseFlowEvent(UnifiedPurchaseEventNameEnum.SubscriptionUpsellBannerShown)
				end

				if FFlagEnableBlackbirdUpsellImpressionGating and blackbirdUpsellBannerProductInfo then
					BlackbirdUpsellImpressionTracker.incrementImpressionCount()
				end
			end

			if not (FFlagEnableSubscriptionUpsellUnifiedPurchaseEventTelemetry or FFlagEnableBlackbirdUpsellImpressionGating) then
				onBuyItemButtonMounted = self.onBuyItemButtonMounted
			end

			local function fn2(_: boolean, p)
				if p ~= nil then
					local requestType3 = self.props.requestType

					if requestType3 == RequestType.GamePass or requestType3 == RequestType.Product then
						self.props.fetchInGameItemCartPricing(p)
					else
						self.props.fetchCartPricing(p)
					end
				end
			end

			if FFlagAddCenterDialogForUnifiedPurchaseModal and AppContext.get() == AppContext.Enum.IN_APP then
				local createElement = Roact.createElement
				local product = {
					itemIcon = productInfo.imageUrl,
					itemName = productInfo.name,
					itemRobuxCost = 0,
					itemDisplayPrice = 0,
					itemPrice = 0,
					model = 0
				}

				if hideUserRobuxBalance then
					itemRobuxCost = nil
				end

				product.itemRobuxCost = itemRobuxCost
				local itemDisplayPrice

				if hideUserRobuxBalance then
					itemDisplayPrice = productInfo.displayPrice
				end

				product.itemDisplayPrice = itemDisplayPrice
				product.itemPrice = price
				product.model = self.props.humanoidModel
				local subtitleView

				if FFlagPurchasePromptSubtitleForTimedOptions then
					subtitleView = self.props.subtitleView
				end

				local buttons = {
					buyItemActivated = self.confirmButtonPressed,
					buyItemEnableInputDelayed = 0,
					cancelActivated = 0,
					isDisabled = 0
				}
				local buyItemEnableInputDelayed = self.isWindowShowAndDoneAnimating()
					and self.buyButtonUsesFoundationInputDelay

				if buyItemEnableInputDelayed then
					buyItemEnableInputDelayed = not (FFlagSkipBuyDelayForExperienceShop and self.isFromShopSkip())
				end

				buttons.buyItemEnableInputDelayed = buyItemEnableInputDelayed

				buttons.cancelActivated = self.cancelButtonPressed
				buttons.isDisabled = promptState == PromptState.PurchaseInProgress
				local v3 = {
					product = product,
					subtitleView = subtitleView,
					buttons = buttons,
					postPurchaseActions = self.props.postPurchaseActions,
					setPostPurchaseActions = self.props.setPostPurchaseActions,
					onBuyItemButtonMounted = onBuyItemButtonMounted,
					purchaseModalType = getUnifiedPurchaseModalType(self.props.requestType),
					robuxBalanceAmount = accountInfo.balance,
					isTestPurchase = isTestPurchase,
					isLoading = 0,
					isCartPricingLoading = 0,
					onBlackbirdUpsellActivated = 0,
					BlackbirdUpsellBannerProductInfo = 0,
					cartPricingResponse = 0,
					onCartOfferAppliedChanged = 0
				}
				local isLoading

				if FFlagUnifiedPurchaseAddSkeleton then
					isLoading = promptState == PromptState.InitializingPurchase
				end

				v3.isLoading = isLoading

				v3.isCartPricingLoading = self.props.isCartPricingLoading
				v3.onBlackbirdUpsellActivated = fn
				v3.BlackbirdUpsellBannerProductInfo = blackbirdUpsellBannerProductInfo
				v3.cartPricingResponse = self.props.cartPricingResponse
				v3.onCartOfferAppliedChanged = fn2
				return createElement(UnifiedProductPurchaseModalV2, v3)
			else
				local createElement = Roact.createElement
				local product = {
					itemIcon = productInfo.imageUrl,
					itemName = productInfo.name,
					itemRobuxCost = 0,
					itemDisplayPrice = 0,
					itemPrice = 0,
					model = 0
				}
				local itemRobuxCost2

				if not hideUserRobuxBalance then
					itemRobuxCost2 = self.props.productPrice
				end

				product.itemRobuxCost = itemRobuxCost2
				local itemDisplayPrice

				if hideUserRobuxBalance then
					itemDisplayPrice = productInfo.displayPrice
				end

				product.itemDisplayPrice = itemDisplayPrice
				product.itemPrice = price
				product.model = self.props.humanoidModel

				local buttons = {
					buyItemActivated = self.confirmButtonPressed,
					buyItemEnableInputDelayed = 0,
					cancelActivated = 0,
					isDisabled = 0
				}
				local buyItemEnableInputDelayed = self.isWindowShowAndDoneAnimating()
					and self.buyButtonUsesFoundationInputDelay

				if buyItemEnableInputDelayed then
					buyItemEnableInputDelayed = not (FFlagSkipBuyDelayForExperienceShop and self.isFromShopSkip())
				end

				buttons.buyItemEnableInputDelayed = buyItemEnableInputDelayed

				buttons.cancelActivated = self.cancelButtonPressed
				buttons.isDisabled = promptState == PromptState.PurchaseInProgress
				local v3 = {
					product = product,
					buttons = buttons,
					postPurchaseActions = self.props.postPurchaseActions,
					setPostPurchaseActions = self.props.setPostPurchaseActions,
					onBuyItemButtonMounted = onBuyItemButtonMounted,
					purchaseModalType = getUnifiedPurchaseModalType(self.props.requestType),
					robuxBalanceAmount = accountInfo.balance,
					isTestPurchase = isTestPurchase,
					isMonthlyPrice = 0,
					isFreeWithRobloxPlus = 0,
					isCartPricingLoading = 0,
					onBlackbirdUpsellActivated = 0,
					BlackbirdUpsellBannerProductInfo = 0,
					cartPricingResponse = 0,
					onCartOfferAppliedChanged = 0,
					hideUserRobuxBalance = 0
				}
				local isMonthlyPrice

				if FFlagLuaAppsEnablePromptVIPServerPurchase then
					isMonthlyPrice = productInfo.isMonthlyPrice
				end

				v3.isMonthlyPrice = isMonthlyPrice
				local isFreeWithRobloxPlus

				if FFlagLuaAppsEnablePromptVIPServerPurchase then
					isFreeWithRobloxPlus = productInfo.isFreeWithRobloxPlus
				end

				v3.isFreeWithRobloxPlus = isFreeWithRobloxPlus

				v3.isCartPricingLoading = self.props.isCartPricingLoading
				v3.onBlackbirdUpsellActivated = fn
				v3.BlackbirdUpsellBannerProductInfo = blackbirdUpsellBannerProductInfo
				v3.cartPricingResponse = self.props.cartPricingResponse
				v3.onCartOfferAppliedChanged = fn2

				if not hideUserRobuxBalance then
					if FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then
						hideUserRobuxBalance = self.props.purchaseAnalyticsMetadata
							and self.props.purchaseAnalyticsMetadata.surface == ProductPurchaseSurface.Catalog
					else
						hideUserRobuxBalance = nil
					end
				end

				v3.hideUserRobuxBalance = hideUserRobuxBalance
				return createElement(UnifiedProductPurchaseModal, v3)
			end
		elseif DesktopUpsellExperiment.shouldShowNewModal() then
			return Roact.createElement(ProductPurchaseModal, {
				screenSize = self.state.screenSize,
				product = {
					itemIcon = productInfo.imageUrl,
					itemName = productInfo.name,
					itemRobuxCost = self.props.productPrice
				},
				balanceAmount = accountInfo.balance,
				balanceAmountValid = game:DefineFastFlag("BalanceNotShowingInExperimentIssueFix", false) and not accountInfo.hasFailed,
				buttons = {
					isDisabled = promptState == PromptState.PurchaseInProgress,
					buyItemActivated = self.confirmButtonPressed,
					buyItemControllerIcon = self.props.isGamepadEnabled and "rbxasset://textures/ui/Controls/DesignSystem/ButtonA.png" or nil,
					buyItemIsDelayedInput = self.hasDelayedInput(),
					buyItemEnableInputDelayed = self.isWindowShowAndDoneAnimating(),
					cancelActivated = self.cancelButtonPressed
				}
			})
		else
			return Roact.createElement(ProductPurchase, {
				screenSize = self.state.screenSize,
				isDisabled = promptState == PromptState.PurchaseInProgress,
				model = self.props.humanoidModel,
				itemIcon = productInfo.imageUrl,
				itemName = productInfo.name,
				itemRobuxCost = self.props.productPrice,
				currentBalance = accountInfo.balance,
				currentBalanceValid = not accountInfo.hasFailed,
				testPurchase = isTestPurchase,
				isDelayedInput = self.hasDelayedInput(),
				enableInputDelayed = self.isWindowShowAndDoneAnimating(),
				buyItemControllerIcon = self.props.isGamepadEnabled and "rbxasset://textures/ui/Controls/DesignSystem/ButtonA.png" or nil,
				cancelControllerIcon = self.props.isGamepadEnabled and "rbxasset://textures/ui/Controls/DesignSystem/ButtonB.png" or nil,
				buyItemActivated = self.confirmButtonPressed,
				cancelPurchaseActivated = self.cancelButtonPressed,
				isLuobu = self.state.isLuobu
			})
		end
	elseif promptState == PromptState.RobuxUpsell or promptState == PromptState.UpsellInProgress then
		if DesktopUpsellExperiment.shouldShowNewModal() then
			local createElement = Roact.createElement
			local v2 = {
				screenSize = self.state.screenSize,
				product = {
					model = self.props.humanoidModel,
					itemIcon = productInfo.imageUrl,
					itemName = productInfo.name,
					itemRobuxCost = self.props.productPrice
				},
				upsell = {
					balanceAmount = accountInfo.balance,
					robuxPurchaseAmount = self.props.robuxPurchaseAmount,
					robuxPurchaseAmountBeforeBonus = self.props.robuxAmountBeforeBonus,
					robuxPurchaseCost = self.props.robuxPurchaseCost
				},
				buttons = 0
			}

			local buttons = {
				buyItemActivated = function()
					self.confirmButtonPressed()
					self.emitPurchaseFlowEvent("UserInput", "Buy")
				end,
				buyItemDisabled = promptState == PromptState.UpsellInProgress,
				buyItemControllerIcon = self.props.isGamepadEnabled and "rbxasset://textures/ui/Controls/DesignSystem/ButtonA.png" or nil,
				buyItemisDelayedInput = self.hasDelayedInput(),
				buyItemEnableInputDelayed = 0,
				cancelPurchaseActivated = 0,
				cancelControllerIcon = 0,
				opensBuyRobuxPage = 0
			}
			local buyItemEnableInputDelayed = self.isWindowShowAndDoneAnimating()

			if buyItemEnableInputDelayed then
				buyItemEnableInputDelayed = not (FFlagSkipBuyDelayForExperienceShop and self.isFromShopSkip())
			end

			buttons.buyItemEnableInputDelayed = buyItemEnableInputDelayed

			function buttons.cancelPurchaseActivated()
				self.cancelButtonPressed()
				self.emitPurchaseFlowEvent("UserInput", "Cancel")
			end
			buttons.cancelControllerIcon = self.props.isGamepadEnabled
				and "rbxasset://textures/ui/Controls/DesignSystem/ButtonB.png"
				or nil
			buttons.opensBuyRobuxPage = DesktopUpsellExperiment.getVariant() == DesktopUpsellExperiment.variants.OpenRobuxStore
			v2.buttons = buttons
			return createElement(RobuxUpsellModal, v2)
		else
			local createElement = Roact.createElement
			local v2 = {
				screenSize = self.state.screenSize,
				isDisabled = promptState == PromptState.UpsellInProgress,
				model = self.props.humanoidModel,
				itemIcon = productInfo.imageUrl,
				itemName = productInfo.name,
				itemRobuxCost = self.props.productPrice,
				robuxPurchaseAmount = self.props.robuxPurchaseAmount,
				robuxPurchaseAmountBeforeBonus = self.props.robuxAmountBeforeBonus,
				balanceAmount = accountInfo.balance,
				isDelayedInput = self.hasDelayedInput(),
				enableInputDelayed = 0,
				buyItemControllerIcon = 0,
				cancelControllerIcon = 0,
				buyItemActivated = 0,
				cancelPurchaseActivated = 0,
				isLuobu = 0,
				isVng = 0
			}
			local enableInputDelayed = self.isWindowShowAndDoneAnimating()

			if enableInputDelayed then
				enableInputDelayed = not (FFlagSkipBuyDelayForExperienceShop and self.isFromShopSkip())
			end

			v2.enableInputDelayed = enableInputDelayed

			v2.buyItemControllerIcon = self.props.isGamepadEnabled
				and "rbxasset://textures/ui/Controls/DesignSystem/ButtonA.png"
				or nil
			v2.cancelControllerIcon = self.props.isGamepadEnabled
				and "rbxasset://textures/ui/Controls/DesignSystem/ButtonB.png"
				or nil

			function v2.buyItemActivated()
				self.confirmButtonPressed()
				self.emitPurchaseFlowEvent("UserInput", "Buy")
			end
			function v2.cancelPurchaseActivated()
				self.cancelButtonPressed()
				self.emitPurchaseFlowEvent("UserInput", "Cancel")
			end
			v2.isLuobu = self.state.isLuobu
			v2.isVng = GetFFlagOpenVngTosForVngRobuxUpsell() and getAppFeaturePolicies().getShowVNGTosForRobuxUpsell()
			return createElement(ProductPurchaseRobuxUpsell, v2)
		end
	else
		if promptState == PromptState.LeaveRobloxWarning then
			return Roact.createElement(LeaveRobloxAlert, {
				screenSize = self.state.screenSize,
				cancelActivated = self.cancelButtonPressed,
				continueActivated = self.confirmButtonPressed
			})
		end

		if FFlagLuaAppsEnablePromptVIPServerPurchase and isShowingVIPServerPostPurchase(self.props) then -- inferred equivalent call
			return React.createElement(VIPServerPostPurchaseContainer, {
				onClose = self.props.hideWindow
			})
		end

		if promptState == PromptState.PurchaseComplete and requestType == RequestType.AvatarCreationFee then
			return Roact.createElement(InteractiveAlert, {
				bodyText = RobloxTranslator:FormatByKey("CoreScripts.PublishAvatarPrompt.PurchaseCompleteDescription"),
				buttonStackInfo = {
					buttons = {
						{
							buttonType = ButtonType.PrimarySystem,
							props = {
								onActivated = self.confirmButtonPressed,
								text = RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.ResultModalOk"),
								inputIcon = self.props.isGamepadEnabled and "rbxasset://textures/ui/Controls/DesignSystem/ButtonA.png" or nil
							}
						}
					}
				},
				screenSize = self.state.screenSize,
				title = RobloxTranslator:FormatByKey("CoreScripts.BulkPurchasePrompt.CompletedPrompt.SuccessHeading")
			})
		end

		if
			promptState == PromptState.Error and purchaseError == PurchaseError.TwoFactorNeededSettings
			or isGenericChallengeResponse(purchaseError)
		then
			local createElement = React.createElement
			local v2 = {
				screenSize = self.state.screenSize,
				titleIcon = Images["icons/status/error_large"],
				promptState = promptState,
				productInfo = productInfo,
				purchaseError = purchaseError,
				economicRestrictionError = self.props.economicRestrictionError or {},
				isGamepadEnabled = self.props.isGamepadEnabled,
				cancelButtonPressed = self.cancelButtonPressed,
				confirmButtonPressed = self.confirmButtonPressed,
				includeCancelButton = true,
				isGenericChallengeResponse = isGenericChallengeResponse,
				useUnifiedPurchaseCompletionModal = self.props.isUserEligibleForUnifiedPurchaseFlow,
				surface = 0,
				productType = 0
			}
			local surface

			if FFlagAddSurfaceAndProductTypeToPromptCounter then
				surface = self.props.purchaseAnalyticsMetadata and self.props.purchaseAnalyticsMetadata.surface
			end

			v2.surface = surface
			local productType

			if FFlagAddSurfaceAndProductTypeToPromptCounter then
				productType = self.props.purchaseAnalyticsMetadata and self.props.purchaseAnalyticsMetadata.productType
			end

			v2.productType = productType
			return createElement(ProductPurchasePrompt, v2)
		else
			if promptState == PromptState.EnablePurchaseVPCModal then
				return Roact.createElement(Animator, {
					shouldAnimate = true,
					shouldShow = promptState == PromptState.EnablePurchaseVPCModal,
					renderChildren = function()
						return Roact.createElement(verifiedParentalConsentDialog, {
							screenSize = self.state.screenSize,
							isActionable = false,
							modalType = self.getVPCModalType(promptState),
							onDismiss = function()
								self.confirmButtonPressed()
							end
						})
					end
				})
			end

			if
				promptState == PromptState.Error
				and purchaseError == PurchaseError.NotEnoughRobuxXbox
				and DesktopUpsellExperiment.shouldShowNewModal()
			then
				return Roact.createElement(RobuxUpsellModalTooExpensiveFallback, {
					screenSize = self.state.screenSize,
					product = {
						itemIcon = productInfo.imageUrl,
						itemName = productInfo.name,
						itemRobuxCost = self.props.productPrice
					},
					balanceAmount = accountInfo.balance,
					doneActivated = function()
						self.cancelButtonPressed()
						self.emitPurchaseFlowEvent("UserInput", "Cancel")
					end
				})
			end

			local v2 = FFlagEnableLaunchAfterPurchase

			if v2 then
				if promptState == PromptState.PurchaseComplete then
					v2 = self.props.launchAfterPurchaseRootPlaceId ~= nil
				else
					v2 = false
				end
			end

			local createElement = React.createElement
			local v3 = {
				screenSize = self.state.screenSize,
				promptState = promptState,
				productInfo = productInfo,
				purchaseError = purchaseError,
				economicRestrictionError = self.props.economicRestrictionError or {},
				isGamepadEnabled = self.props.isGamepadEnabled,
				cancelButtonPressed = self.cancelButtonPressed,
				confirmButtonPressed = self.confirmButtonPressed,
				includeCancelButton = false,
				isGenericChallengeResponse = isGenericChallengeResponse,
				useUnifiedPurchaseCompletionModal = self.props.isUserEligibleForUnifiedPurchaseFlow,
				isMultiItem = getUnifiedPurchaseModalType(self.props.requestType) == UnifiedPurchaseModalTypeEnum.MultiItem,
				timedOptionDays = 0,
				completionMessage = 0,
				launchAfterPurchaseButtonPressed = 0,
				launchAfterPurchaseButtonShown = 0,
				surface = 0,
				productType = 0
			}
			local timedOptionDays

			if FFlagPurchasePromptSubtitleForTimedOptions then
				timedOptionDays = self.props.timedOptionDays
			end

			v3.timedOptionDays = timedOptionDays
			local completionMessage

			if FFlagPurchaseModalTimedOptionExtension then
				completionMessage = self.props.completionMessage
			end

			v3.completionMessage = completionMessage
			local launchAfterPurchaseButtonPressed

			if v2 then
				launchAfterPurchaseButtonPressed = self.launchAfterPurchaseButtonPressed
			end

			v3.launchAfterPurchaseButtonPressed = launchAfterPurchaseButtonPressed
			local launchAfterPurchaseButtonShown

			if v2 then
				launchAfterPurchaseButtonShown = self.launchAfterPurchaseButtonShown
			end

			v3.launchAfterPurchaseButtonShown = launchAfterPurchaseButtonShown
			local surface

			if FFlagAddSurfaceAndProductTypeToPromptCounter then
				surface = self.props.purchaseAnalyticsMetadata and self.props.purchaseAnalyticsMetadata.surface
			end

			v3.surface = surface
			local productType

			if FFlagAddSurfaceAndProductTypeToPromptCounter then
				productType = self.props.purchaseAnalyticsMetadata and self.props.purchaseAnalyticsMetadata.productType
			end

			v3.productType = productType
			return createElement(ProductPurchasePrompt, v3)
		end
	end

	return nil
end

function extended:render()
	local promptState = self.props.promptState
	local prompt = self:determinePrompt()

	if FFlagSetMenuOnPurchasePrompt then
		if prompt ~= nil then
			self.menuOpenedBySelf = true
		end

		GuiService:SetMenuIsOpen(prompt ~= nil, "ProductPurchaseContainer")
	end

	local createElement = Roact.createElement
	local changeScreenSizesByAbsoluteSize = {
		Size = UDim2.new(1, 0, 1, 0),
		[Roact.Change.AbsoluteSize] = self.changeScreenSize,
		BackgroundTransparency = 1
	}

	local createElement2 = Roact.createElement
	local animatorRefsByRef = {
		shouldShow = self.props.windowState == WindowState.Shown,
		onShown = function()
			if
				self.props.requestType == RequestType.AvatarCreationFee
				and promptState == PromptState.PromptPurchase
			then
				PublishAssetAnalytics.sendPageLoad(PublishAssetAnalytics.Section.BuyItemModal)
			end

			self:setState({ isAnimating = false, doneAnimatingTime = os.clock() })
		end,
		onHidden = function()
			self:setState({ isAnimating = nil, doneAnimatingTime = nil })
		end,
		skipAnimation = self.props.isUserEligibleForUnifiedPurchaseFlow,
		[Roact.Ref] = self.animatorRef
	}
	local modalFix

	if prompt ~= nil then
		modalFix = Roact.createElement("ImageButton", {
				BackgroundTransparency = 0,
				Modal = true,
				Size = UDim2.new(0, 0, 0, 0)
			})
			or nil
	end

	return createElement("Frame", changeScreenSizesByAbsoluteSize, {
		Animator = createElement2(Animator2, animatorRefsByRef, {
			Prompt = prompt,
			ModalFix = modalFix
		}),
		OnCoreGuiMenuOpened = Roact.createElement(ExternalEventConnection, {
			event = GuiService.MenuOpened,
			callback = function()
				if FFlagSetMenuOnPurchasePrompt and self.menuOpenedBySelf then
					self.menuOpenedBySelf = false
				elseif self.props.hideWindow then
					self.props.hideWindow()
				end
			end
		}),
		OnUserGuiRenderingChanged = Roact.createElement(ExternalEventConnection, {
			event = CoreGui.UserGuiRenderingChanged,
			callback = function(p, p2)
				if not (p and p2) then
					self.props.hideWindow()
				end
			end
		})
	})
end

local function mapStateToProps(data)
	local mockingPurchases = isMockingPurchases(data.promptRequest.requestType)
	local desktopUpsellExpVariant

	if data.abVariations then
		desktopUpsellExpVariant = data.abVariations.DesktopUpsellExpVariant
	end

	local v = {
		purchaseFlowUUID = data.purchaseFlowUUID,
		purchaseFlow = data.purchaseFlow,
		promptState = data.promptState,
		requestType = data.promptRequest.requestType,
		humanoidModel = data.promptRequest.humanoidModel,
		expectedPrice = data.promptRequest.expectedPrice,
		windowState = data.windowState,
		purchaseError = data.purchaseError,
		economicRestrictionError = data.economicRestrictionError,
		productInfo = data.productInfo,
		accountInfo = data.accountInfo,
		robuxPurchaseAmount = SelectedRobuxPackage.getRobuxPurchaseAmount(data),
		robuxAmountBeforeBonus = SelectedRobuxPackage.getRobuxAmountBeforeBonus(data),
		robuxPurchaseCost = SelectedRobuxPackage.getPrice(data),
		isTestPurchase = mockingPurchases,
		isGamepadEnabled = data.gamepadEnabled,
		desktopUpsellExpVariant = desktopUpsellExpVariant,
		postPurchaseActions = data.postPurchaseActions,
		purchaseCallbacks = data.purchaseCallbacks,
		isUserEligibleForUnifiedPurchaseFlow = data.isUserEligibleForUnifiedPurchaseFlow,
		purchaseAnalyticsMetadata = data.purchaseAnalyticsMetadata,
		productPrice = selectProductPrice(data),
		price = 0,
		timedOptionDays = 0,
		completionMessage = 0,
		launchAfterPurchaseRootPlaceId = 0,
		robloxSubscriptionProducts = 0,
		productPayload = 0,
		cartPricingResponse = 0,
		isCartPricingLoading = 0
	}
	local price

	if selectPrice then
		price = selectPrice(data)
	end

	v.price = price
	local timedOptionDays

	if FFlagPurchasePromptSubtitleForTimedOptions and data.productPayload then
		timedOptionDays = data.productPayload.timedOptionDays
	end

	v.timedOptionDays = timedOptionDays
	local completionMessage

	if FFlagPurchaseModalTimedOptionExtension and data.purchaseOptions then
		completionMessage = data.purchaseOptions.completionMessage
	end

	v.completionMessage = completionMessage
	local launchAfterPurchaseRootPlaceId

	if
		FFlagEnableLaunchAfterPurchase
		and data.purchaseOptions
		and data.purchaseOptions.launchAfterPurchaseRootPlaceId ~= nil
		and data.purchaseOptions.launchAfterPurchaseRootPlaceId ~= ""
	then
		launchAfterPurchaseRootPlaceId = data.purchaseOptions.launchAfterPurchaseRootPlaceId
	end

	v.launchAfterPurchaseRootPlaceId = launchAfterPurchaseRootPlaceId

	v.robloxSubscriptionProducts = data.robloxSubscriptionProducts
	local productPayload

	if FFlagBlackbirdUpsellGateResaleAndTimedOption or FFlagSkipBuyDelayForExperienceShop then
		productPayload = data.productPayload
	end

	v.productPayload = productPayload

	v.cartPricingResponse = selectCartPricingResponse(data)
	v.isCartPricingLoading = selectIsCartPricingFetching(data)
	return v
end

local function mapDispatchToProps(callback)
	return {
		setPurchaseFlowUUID = function(p)
			callback(SetPurchaseFlowUUID(p))
		end,
		onBuy = function()
			callback(purchaseItem())
		end,
		completePurchase = function()
			callback(completePurchase())
		end,
		onScaryModalConfirm = function()
			callback(launchRobuxUpsell())
		end,
		onOpenSecuritySettings = function(p: string?)
			if p then
				callback(openSecuritySettings(p))
			else
				callback(openSecuritySettings())
			end
		end,
		onRobuxUpsell = function()
			callback(initiateUserPurchaseSettingsPrecheck())
		end,
		hideWindow = function()
			callback(hideWindow())
		end,
		retryPurchaseAfterUpsell = function()
			callback(retryPurchaseAfterUpsell())
		end,
		setWindowState = function(p)
			callback(SetWindowState(p))
		end,
		completeRequest = function()
			if FFlagAddCursorProviderToPurchasePromptApp then
				GuiService.SelectedCoreObject = nil
			end

			callback(completeRequest())
		end,
		onAnalyticEvent = function(p, p2)
			callback(sendEvent(p, p2))
		end,
		setPostPurchaseActions = function(p)
			callback(SetPostPurchaseActions(p))
		end,
		setPromptState = function(p)
			callback(SetPromptState(p))
		end,
		fetchCartPricing = function(p)
			callback(fetchCartPricing(p))
		end,
		fetchInGameItemCartPricing = function(p)
			callback(fetchInGameItemCartPricing(p))
		end
	}
end

return (connectToStore(mapStateToProps, mapDispatchToProps)(extended))
