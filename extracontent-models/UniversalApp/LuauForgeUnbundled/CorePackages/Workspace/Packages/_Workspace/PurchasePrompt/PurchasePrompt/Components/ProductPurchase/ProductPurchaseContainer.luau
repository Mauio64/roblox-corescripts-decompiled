local GuiService = game:GetService("GuiService")
local ContextActionService = game:GetService("ContextActionService")

local PurchasePromptDeps = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptDeps")
local roact = PurchasePromptDeps.Roact
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/React")

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local CachedPolicyService = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/CachedPolicyService")
local RobloxTranslator = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/RobloxTranslator")

local uiBlox = PurchasePromptDeps.UIBlox
local interactiveAlert = uiBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = uiBlox.App.Button.Enum.ButtonType
local images = uiBlox.App.ImageSet.Images

local IAPExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/IAPExperience")
local productPurchase = IAPExperience.ProductPurchase
local productPurchaseRobuxUpsell = IAPExperience.ProductPurchaseRobuxUpsell
local leaveRobloxAlert = IAPExperience.LeaveRobloxAlert
local animator = IAPExperience.Animator
local unifiedProductPurchaseModal = IAPExperience.UnifiedProductPurchaseModal
local unifiedProductPurchaseModalV2 = IAPExperience.UnifiedProductPurchaseModalV2

local RobloxSubscriptionPurchaseApp = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/RobloxSubscriptionPurchaseApp")
local getBlackbirdUpsellBannerProductInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/getBlackbirdUpsellBannerProductInfo")
local robloxSubscriptionFlowCompleteReason = RobloxSubscriptionPurchaseApp.RobloxSubscriptionFlowCompleteReason
local surfaceName = RobloxSubscriptionPurchaseApp.SurfaceName
local surfaceContext = RobloxSubscriptionPurchaseApp.SurfaceContext
local purchaseClientSessionIdType = RobloxSubscriptionPurchaseApp.PurchaseClientSessionIdType

local SetButtonState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetButtonState")
local PurchaseFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseFlow")
local RequestType = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/RequestType")
local PromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PromptState")
local WindowState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/WindowState")
local PurchaseError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseError")
local module14 = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/hideWindow")
local module15 = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/retryPurchaseAfterUpsell")
local module16 = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/completeRequest")
local purchaseItem = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/purchaseItem")
local module18 = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/completePurchase")
local launchRobuxUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/launchRobuxUpsell")
local openSecuritySettings = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/openSecuritySettings")
local isMockingPurchases = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/isMockingPurchases")
local connectToStore = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/connectToStore")
local sendEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/sendEvent")
local PublishAssetAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/PublishAssetAnalytics")

local ExternalEventConnection = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Components/Connection/ExternalEventConnection")
local LocalizationService = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Localization/LocalizationService")
local module27 = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/isGenericChallengeResponse")
local SelectedRobuxPackage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/SelectedRobuxPackage")
local productPurchaseSurface = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptLite").Enums.ProductPurchaseSurface
local logUnifiedPurchaseTelemetryCounter = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/logUnifiedPurchaseTelemetryCounter")
local emitPerformanceMetrics = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/emitPerformanceMetrics")

local initiateUserPurchaseSettingsPrecheck = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/initiateUserPurchaseSettingsPrecheck")
local verifiedParentalConsentDialog = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/VerifiedParentalConsentDialog").VerifiedParentalConsentDialog
local VPCModalType = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/VPCModalType")
local module33 = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Components/ProductPurchase/Animator")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags")
local fFlagAddCursorProviderToPurchasePromptApp = SharedFlags.FFlagAddCursorProviderToPurchasePromptApp
local getUnifiedPurchaseModalType = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/getUnifiedPurchaseModalType")
local selectProductPrice = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Selectors/selectProductPrice")
local selectPrice = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Selectors/selectPrice")
local SetPromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetPromptState")
local FFlagAddSurfaceAndProductTypeToPromptCounter = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagAddSurfaceAndProductTypeToPromptCounter")

local HttpService = game:GetService("HttpService")
local SetPurchaseFlowUUID = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetPurchaseFlowUUID")
local SetPostPurchaseActions = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetPostPurchaseActions")
local sendUnifiedPurchaseEventLog = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/sendUnifiedPurchaseEventLog")
local UnifiedPurchaseEventNameEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/UnifiedPurchaseEventNameEnum")
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Misc/Constants")

local FFlagEnablePurchaseFlowUUIDMigration = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagEnablePurchaseFlowUUIDMigration")
local fFlagEnableLaunchAfterPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagEnableLaunchAfterPurchase

local experienceService = if fFlagEnableLaunchAfterPurchase then require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/ExperienceService").ExperienceService else nil

local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/LoggingProtocol")

local PurchaseFlowUUIDTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Events/PurchaseFlowUUIDTelemetry")
local UnifiedPurchaseTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Events/UnifiedPurchaseTelemetry")
local AppContext = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/AppContext")
local module50 = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/fetchCartPricing")
local module51 = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/fetchInGameItemCartPricing")
local selectCartPricingResponse = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Selectors/selectCartPricingResponse")
local selectIsCartPricingFetching = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Selectors/selectIsCartPricingFetching")

local fFlagPurchasePromptUnifiedEventsUseOfferAdjustedPrice = SharedFlags.FFlagPurchasePromptUnifiedEventsUseOfferAdjustedPrice

local FFlagPurchasePromptGamePausedOnlyHideShownWindow = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagPurchasePromptGamePausedOnlyHideShownWindow")
local deriveCartPricingView = IAPExperience.deriveCartPricingView

local desktopUpsellExperiment = IAPExperience.Utility.DesktopUpsellExperiment
local productPurchaseModal = IAPExperience.ProductPurchaseModal
local robuxUpsellModal = IAPExperience.RobuxUpsellModal
local robuxUpsellModalTooExpensiveFallback = IAPExperience.RobuxUpsellModalTooExpensiveFallback

local shouldShowBlackbirdUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/shouldShowBlackbirdUpsell")
local extended = roact.Component:extend("ProductPurchaseContainer")
local ProductPurchasePrompt = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Components/ProductPurchase/ProductPurchasePrompt")
local VIPServerPostPurchaseContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Components/VIPServerPostPurchase/VIPServerPostPurchaseContainer")

local getFFlagOpenVngTosForVngRobuxUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").GetFFlagOpenVngTosForVngRobuxUpsell
local getAppFeaturePolicies = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/UniversalAppPolicy").getAppFeaturePolicies
local unifiedPurchaseModalTypeEnum = IAPExperience.Enums.UnifiedPurchaseModalTypeEnum

local fFlagUnifiedPurchaseFlowMarketplaceUIImprovements = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagUnifiedPurchaseFlowMarketplaceUIImprovements

local fFlagAddPerformanceMetricsToUnifiedPurchaseModal = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagAddPerformanceMetricsToUnifiedPurchaseModal
local fFlagEnableUnifiedPurchaseFlowForDevSubs = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagEnableUnifiedPurchaseFlowForDevSubs

local fFlagAddCenterDialogForUnifiedPurchaseModal = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagAddCenterDialogForUnifiedPurchaseModal
local fFlagUnifiedPurchaseAddSkeleton = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagUnifiedPurchaseAddSkeleton

local fFlagEnableSubscriptionUpsellUnifiedPurchaseEventTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagEnableSubscriptionUpsellUnifiedPurchaseEventTelemetry

local defineFastFlag = game:DefineFastFlag("RemoveDelayedInputForUnifiedPurchaseModal", true)

local fFlagPurchasePromptSubtitleForTimedOptions = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagPurchasePromptSubtitleForTimedOptions
local fFlagPurchaseModalTimedOptionExtension = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagPurchaseModalTimedOptionExtension

local fFlagAddOnRobloxSubscriptionUpsellSuccessCallbackToUnifiedPurchaseModal = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagAddOnRobloxSubscriptionUpsellSuccessCallbackToUnifiedPurchaseModal

local fFlagEnableBlackbirdUpsellImpressionGating = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagEnableBlackbirdUpsellImpressionGating
local BlackbirdUpsellImpressionTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/BlackbirdUpsellImpressionTracker")
local FFlagBlackbirdUpsellGateResaleAndTimedOption = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagBlackbirdUpsellGateResaleAndTimedOption")
local FFlagSetMenuOnPurchasePrompt = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagSetMenuOnPurchasePrompt")
local FFlagSkipBuyDelayForExperienceShop = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagSkipBuyDelayForExperienceShop")

local fFlagLuaAppsEnablePromptVIPServerPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagLuaAppsEnablePromptVIPServerPurchase

local function isRelevantRequestType(p2, p3, p4)
	if
		fFlagUnifiedPurchaseAddSkeleton
		and p4 == PromptState.InitializingPurchase
		and p3 == PurchaseFlow.RobuxUpsellV2
	then
		return true
	end

	if p3 == PurchaseFlow.RobuxUpsellV2 or p3 == PurchaseFlow.LargeRobuxUpsell then
		return false
	end

	return (p2 == RequestType.Asset or p2 == RequestType.Bundle or p2 == RequestType.GamePass or p2 == RequestType.Product or p2 == RequestType.AvatarCreationFee or p2 == RequestType.Experience or p2 == RequestType.Look or fFlagEnableUnifiedPurchaseFlowForDevSubs and p2 == RequestType.DeveloperSubscription)
		and true
		or fFlagLuaAppsEnablePromptVIPServerPurchase and p2 == RequestType.VIPServer
end

local function isShowingVIPServerPostPurchase(p2): boolean
	return p2.promptState == PromptState.PurchaseComplete and p2.requestType == RequestType.VIPServer
end

local function getIsFiatProduct(p2, p3, p4): boolean
	if not fFlagEnableUnifiedPurchaseFlowForDevSubs or p2 ~= RequestType.DeveloperSubscription then
		return false
	end

	return p3.displayPrice ~= nil and p4 == 0
end

local function promptStateToViewName(p2)
	return ({
		[PromptState.RobuxUpsell] = "PurchaseModal",
		[PromptState.UpsellInProgress] = "RobuxPurchasePending"
	})[p2]
end

function extended:init()
	self.state = {
		screenSize = Vector2.new(0, 0),
		isLuobu = false,
		analyticId = HttpService:GenerateGUID(false)
	}

	if not FFlagEnablePurchaseFlowUUIDMigration then
		self.props.setPurchaseFlowUUID(HttpService:GenerateGUID(false))
		LoggingProtocol.default:logRobloxTelemetryCounter(PurchaseFlowUUIDTelemetry.ProductPurchaseContainerMigrationCounter, 1, {
			method = "ProductPurchaseContainerInit"
		})
	end

	coroutine.wrap(function()
		if CachedPolicyService:IsSubjectToChinaPolicies() then
			self:setState({ isLuobu = true })
		end
	end)()

	function self.emitPurchaseFlowEvent(p2, p3)
		local promptState = self.props.promptState
		local v6 = ({
			[PromptState.RobuxUpsell] = "PurchaseModal",
			[PromptState.UpsellInProgress] = "RobuxPurchasePending"
		})[promptState]

		if not v6 then
			return
		end

		local v7 = {
			purchase_flow_uuid = self.props.purchaseFlowUUID,
			purchase_flow = "InGameRobuxUpsell",
			view_name = v6,
			purchase_event_type = p2,
			input_type = p3,
			event_metadata = HttpService:JSONEncode({
				universe_id = tostring(game.GameId),
				item_product_id = tostring(self.props.productInfo.productId),
				item_name = self.props.productInfo.name,
				price = tostring(self.props.productInfo.price),
				user_balance = tostring(self.props.accountInfo.balance) or nil,
				package_robux_amount = tostring(self.props.robuxPurchaseAmount) or nil
			})
		}

		self.props.onAnalyticEvent("UserPurchaseFlow", v7)
	end

	function self.emitUnifiedProductPurchaseFlowEvent(p2)
		local purchaseAnalyticsMetadata = self.props.purchaseAnalyticsMetadata or {}

		local v5 = if fFlagPurchasePromptUnifiedEventsUseOfferAdjustedPrice and self.props.productPrice ~= nil then self.props.productPrice else purchaseAnalyticsMetadata.price
		sendUnifiedPurchaseEventLog({
			event_name = p2,
			purchase_flow_uuid = purchaseAnalyticsMetadata.purchaseFlowUUID,
			product_id = purchaseAnalyticsMetadata.productId,
			product_type = purchaseAnalyticsMetadata.productType,
			product_target_id = purchaseAnalyticsMetadata.productTargetId,
			robux_price = v5,
			surface = purchaseAnalyticsMetadata.surface,
			user_roblox_balance = purchaseAnalyticsMetadata.userRobuxBalance,
			salelocation_universeid = purchaseAnalyticsMetadata.saleLocationUniverseId,
			product_universeid = purchaseAnalyticsMetadata.productUniverseId
		})
	end

	function self.changeScreenSize(p2)
		if self.state.screenSize ~= p2.AbsoluteSize then
			self:setState({ screenSize = p2.AbsoluteSize })
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

		local v5 = if self.state.doneAnimatingTime then os.clock() - self.state.doneAnimatingTime > 2.5 else false

		return windowShowAndDoneAnimating and v5
	end

	function self.getConfirmButtonAction(p2, p3, p4)
		if p2 == PromptState.None or not isRelevantRequestType(p3) then
			return nil
		end

		if p2 == PromptState.PromptPurchase or p2 == PromptState.PurchaseInProgress then
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

		if
			p2 == PromptState.RobuxUpsell
			or p2 == PromptState.UpsellInProgress
			or p2 == PromptState.LeaveRobloxWarning
		then
			return self.props.onRobuxUpsell
		end

		if
			p2 == PromptState.U13PaymentModal
			or p2 == PromptState.U13MonthlyThreshold1Modal
			or p2 == PromptState.U13MonthlyThreshold2Modal
			or p2 == PromptState.ParentalConsentWarningPaymentModal13To17
		then
			return self.props.onScaryModalConfirm
		end

		if p2 == PromptState.Error and p4 == PurchaseError.TwoFactorNeededSettings then
			return self.props.onOpenSecuritySettings
		end

		if module27(p4) then
			return function()
				self.props.onOpenSecuritySettings(p4)
			end
		end

		return self.props.hideWindow
	end

	function self.getCancelButtonAction(p2, p3)
		if p2 == PromptState.None or not isRelevantRequestType(p3) then
			return nil
		end

		return self.props.hideWindow
	end

	function self.confirmButtonPressed()
		if
			self.props.requestType == RequestType.AvatarCreationFee
			and self.props.promptState == PromptState.PromptPurchase
		then
			PublishAssetAnalytics.sendButtonClicked(PublishAssetAnalytics.Section.BuyItemModal, PublishAssetAnalytics.Element.Buy)
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

		if fFlagEnableLaunchAfterPurchase then
			onLaunchAfterPurchase = self.props.purchaseCallbacks
				and self.props.purchaseCallbacks.onLaunchAfterPurchase
		else
			onLaunchAfterPurchase = nil
		end

		self.confirmButtonPressed()
		task.defer(function()
			local v5 = tonumber(launchAfterPurchaseRootPlaceId)

			if v5 == nil or experienceService == nil then
				return
			end

			self.emitUnifiedProductPurchaseFlowEvent(UnifiedPurchaseEventNameEnum.ExperienceLaunchedAfterPurchase)

			if onLaunchAfterPurchase then
				onLaunchAfterPurchase()
			end

			experienceService:LaunchExperience({ placeId = v5 }, "PurchaseCompletionPlayButton")
		end)
	end

	function self.cancelButtonPressed()
		if
			self.props.requestType == RequestType.AvatarCreationFee
			and self.props.promptState == PromptState.PromptPurchase
		then
			PublishAssetAnalytics.sendButtonClicked(PublishAssetAnalytics.Section.BuyItemModal, PublishAssetAnalytics.Element.Cancel)
		end

		if self.props.isUserEligibleForUnifiedPurchaseFlow then
			logUnifiedPurchaseTelemetryCounter(
				UnifiedPurchaseTelemetry.UnifiedProductPurchaseModalCancelButtonClickedCounter,
				self.props.purchaseAnalyticsMetadata.surface,
				self.props.purchaseAnalyticsMetadata.productType
			)
		end

		local cancelButtonAction = self.getCancelButtonAction(
			self.props.promptState,
			self.props.requestType
		)

		if cancelButtonAction ~= nil then
			cancelButtonAction()
		end
	end

	function self.configContextActionService(p2)
		if p2 == WindowState.Shown then
			ContextActionService:BindCoreAction("ProductPurchaseConfirmButtonBind", function(p3, p4, p5)
				if fFlagLuaAppsEnablePromptVIPServerPurchase then
					local props = self.props
					local v5 = props.promptState == PromptState.PurchaseComplete
						and props.requestType == RequestType.VIPServer

					if v5 then
						return Enum.ContextActionResult.Pass
					end
				end

				if p4 == Enum.UserInputState.Begin then
					self.confirmButtonPressed()
				end
			end, false, Enum.KeyCode.ButtonA)
			ContextActionService:BindCoreAction("ProductPurchaseCancelButtonBind", function(p3, p4, p5)
				if fFlagLuaAppsEnablePromptVIPServerPurchase then
					local props = self.props
					local v5 = props.promptState == PromptState.PurchaseComplete
						and props.requestType == RequestType.VIPServer

					if v5 then
						return Enum.ContextActionResult.Pass
					end
				end

				if p4 == Enum.UserInputState.Begin then
					self.cancelButtonPressed()
				end
			end, false, Enum.KeyCode.ButtonB)
		else
			ContextActionService:UnbindCoreAction("ProductPurchaseConfirmButtonBind")
			ContextActionService:UnbindCoreAction("ProductPurchaseCancelButtonBind")
		end
	end

	function self.getVPCModalType(p2)
		if p2 == PromptState.EnablePurchaseVPCModal then
			return VPCModalType.toRawValue(VPCModalType.EnablePurchase)
		end

		return VPCModalType.toRawValue(VPCModalType.None)
	end

	function self.onBuyItemButtonMounted(p2)
		local purchaseAnalyticsMetadata = self.props.purchaseAnalyticsMetadata or {}

		logUnifiedPurchaseTelemetryCounter(
			UnifiedPurchaseTelemetry.UnifiedProductPurchaseModalShownCounter,
			purchaseAnalyticsMetadata.surface,
			purchaseAnalyticsMetadata.productType
		)

		self.emitUnifiedProductPurchaseFlowEvent(UnifiedPurchaseEventNameEnum.BuyItemModalShown)

		if
			fFlagAddPerformanceMetricsToUnifiedPurchaseModal
			and purchaseAnalyticsMetadata
			and purchaseAnalyticsMetadata.surface
		then
			emitPerformanceMetrics(
				Constants.PerformanceMetrics.IntervalName.ProductPurchaseContainerShown,
				purchaseAnalyticsMetadata.surface
			)
		end

		if self.props.purchaseCallbacks and self.props.purchaseCallbacks.onBuyItemButtonMounted then
			self.props.purchaseCallbacks.onBuyItemButtonMounted(p2)
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

function extended.willUpdate(object, p2)
	if object.props.expectedPrice ~= p2.expectedPrice then
		object:setState({})
	end
end

function extended.didUpdate(object, p2, p3)
	if
		not FFlagEnablePurchaseFlowUUIDMigration
		and object.props.promptState ~= p2.promptState
		and object.props.promptState == PromptState.None
	then
		local guid = HttpService:GenerateGUID(false)
		object.props.setPurchaseFlowUUID(guid)

		LoggingProtocol.default:logRobloxTelemetryCounter(PurchaseFlowUUIDTelemetry.ProductPurchaseContainerMigrationCounter, 1, {
			method = "ProductPurchaseContainerDidUpdate"
		})
	end

	if FFlagPurchasePromptGamePausedOnlyHideShownWindow then
		if Players.LocalPlayer.GameplayPaused and object.props.windowState == WindowState.Shown then
			object.props.onAnalyticEvent("PurchasePromptGamePausedDetected", {
				place_id = game.PlaceId
			})
			object.props.hideWindow()
		end
	elseif Players.LocalPlayer.GameplayPaused then
		object.props.onAnalyticEvent("PurchasePromptGamePausedDetected", {
			place_id = game.PlaceId
		})
		object.props.hideWindow()
	end

	local purchaseFlow = object.props.purchaseFlow
	local requestType = object.props.requestType

	if p2.windowState ~= object.props.windowState and isRelevantRequestType(requestType, purchaseFlow) then
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
		and p2.promptState ~= PromptState.PurchaseComplete
	then
		PublishAssetAnalytics.sendPageLoad(PublishAssetAnalytics.Section.ProcessCompleteModal)
	end

	if p2.promptState ~= object.props.promptState then
		object.emitPurchaseFlowEvent("ViewShown")
	end
end

function extended.getMessageKeysFromPromptState(p2)
	local promptState = p2.props.promptState
	local productInfo = p2.props.productInfo
	local purchaseError = p2.props.purchaseError

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
			messageText = {
				key = "CoreScripts.PurchasePrompt.PurchaseDetails.ScaryModalOne"
			},
			okText = { key = "CoreScripts.PurchasePrompt.Button.OK" },
			titleText = { key = "CoreScripts.PurchasePrompt.Title.BuyItem" }
		}
	end

	if promptState == PromptState.U13MonthlyThreshold1Modal then
		return {
			messageText = {
				key = "CoreScripts.PurchasePrompt.PurchaseDetails.ScaryModalTwo"
			},
			okText = { key = "CoreScripts.PurchasePrompt.Button.OK" },
			titleText = { key = "CoreScripts.PurchasePrompt.Title.BuyItem" }
		}
	end

	if promptState == PromptState.U13MonthlyThreshold2Modal then
		return {
			messageText = {
				key = "CoreScripts.PurchasePrompt.PurchaseDetails.ScaryModalParental"
			},
			okText = { key = "CoreScripts.PurchasePrompt.Button.OK" },
			titleText = { key = "CoreScripts.PurchasePrompt.Title.BuyItem" }
		}
	end

	if promptState == PromptState.ParentalConsentWarningPaymentModal13To17 then
		return {
			messageText = {
				key = "CoreScripts.PurchasePrompt.PurchaseDetails.ParentalConsent"
			},
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

	if purchaseError == PurchaseError.TwoFactorNeededSettings or module27(purchaseError) then
		return {
			messageText = {
				key = "CoreScripts.PurchasePrompt.PurchaseFailed.Enable2SVLogout"
			},
			okText = { key = "CoreScripts.PurchasePrompt.Button.Settings" },
			cancelText = { key = "CoreScripts.PurchasePrompt.CancelPurchase.Cancel" },
			titleText = {
				key = "CoreScripts.PurchasePrompt.Title.VerificationRequired"
			}
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

	local v6 = if fFlagUnifiedPurchaseAddSkeleton then promptState else nil

	if not isRelevantRequestType(requestType, purchaseFlow, v6) then
		return nil
	end

	if
		promptState == PromptState.PromptPurchase
		or promptState == PromptState.PurchaseInProgress
		or fFlagUnifiedPurchaseAddSkeleton and promptState == PromptState.InitializingPurchase
	then
		if self.props.isUserEligibleForUnifiedPurchaseFlow then
			local productPrice = self.props.productPrice
			local v7

			if
				fFlagEnableUnifiedPurchaseFlowForDevSubs
				and requestType == RequestType.DeveloperSubscription
				and productInfo.displayPrice ~= nil
			then
				v7 = productPrice == 0
			else
				v7 = false
			end

			local function fn()
				self.props.setPromptState(PromptState.BlackbirdUpsellInProgress)
				self.props.setWindowState(WindowState.Suspended)

				local purchaseFlowUUID = self.props.purchaseFlowUUID

				if not purchaseFlowUUID or purchaseFlowUUID == "" then
					purchaseFlowUUID = nil
				end

				local v8 = purchaseFlowUUID
					and {
						clientSessionIdType = purchaseClientSessionIdType.PurchaseFlowUUID,
						clientSessionId = purchaseFlowUUID
					}
					or nil

				local initiateRobloxSubscriptionPurchase = RobloxSubscriptionPurchaseApp.initiateRobloxSubscriptionPurchase

				local unifiedProductPurchaseModal2 = surfaceName.UnifiedProductPurchaseModal
				local v12 = if AppContext.get() == AppContext.Enum.IN_APP then surfaceContext.InApp else surfaceContext.InGame
				initiateRobloxSubscriptionPurchase({ showBackButton = true }, {
					onFlowComplete = function(p2)
						if p2 == robloxSubscriptionFlowCompleteReason.UpsellPurchaseSucceeded then
							if
								fFlagAddOnRobloxSubscriptionUpsellSuccessCallbackToUnifiedPurchaseModal
								and self.props.purchaseCallbacks
								and self.props.purchaseCallbacks.onRobloxSubscriptionUpsellSuccess
							then
								self.props.purchaseCallbacks.onRobloxSubscriptionUpsellSuccess()
							end

							self.props.retryPurchaseAfterUpsell()
						else
							if p2 == robloxSubscriptionFlowCompleteReason.UpsellDismissed then
								self.props.completeRequest()
								return
							end

							if p2 == robloxSubscriptionFlowCompleteReason.UpsellPurchaseFailed then
							end

							self.props.completeRequest()
						end
					end,
					onBackButtonActivated = function()
						self.props.setPromptState(PromptState.PromptPurchase)
						self.props.setWindowState(WindowState.Shown)
					end
				}, nil, unifiedProductPurchaseModal2, v12, nil, v8 and {
					clientSessionId = v8
				} or nil)
			end

			local price = if not v7 then self.props.price else nil

			local v8 = deriveCartPricingView(self.props.cartPricingResponse)
			local v9 = getUnifiedPurchaseModalType(requestType)
			local v10 = self.props.productPrice

			if not v7 and v8 ~= nil and v9 == unifiedPurchaseModalTypeEnum.MultiItem then
				v10 = v8.priceAfterDiscount
			end

			local requestType2 = self.props.requestType

			local productPayload = if FFlagBlackbirdUpsellGateResaleAndTimedOption then self.props.productPayload else nil
			local v12

			if
				shouldShowBlackbirdUpsell(price, requestType2, v7, productPayload)
				and self.props.robloxSubscriptionProducts
			then
				v12 = getBlackbirdUpsellBannerProductInfo(self.props.robloxSubscriptionProducts)
			else
				v12 = nil
			end

			local function v13(p2)
				self.onBuyItemButtonMounted(p2)

				if fFlagEnableSubscriptionUpsellUnifiedPurchaseEventTelemetry and v12 then
					self.emitUnifiedProductPurchaseFlowEvent(UnifiedPurchaseEventNameEnum.SubscriptionUpsellBannerShown)
				end

				if fFlagEnableBlackbirdUpsellImpressionGating and v12 then
					BlackbirdUpsellImpressionTracker.incrementImpressionCount()
				end
			end

			if not (fFlagEnableSubscriptionUpsellUnifiedPurchaseEventTelemetry or fFlagEnableBlackbirdUpsellImpressionGating) then
				v13 = self.onBuyItemButtonMounted
			end

			local function fn2(p2, p3)
				if p3 ~= nil then
					local requestType3 = self.props.requestType

					if requestType3 == RequestType.GamePass or requestType3 == RequestType.Product then
						self.props.fetchInGameItemCartPricing(p3)
					else
						self.props.fetchCartPricing(p3)
					end
				end
			end

			if fFlagAddCenterDialogForUnifiedPurchaseModal and AppContext.get() == AppContext.Enum.IN_APP then
				local createElement = roact.createElement
				local v16 = {
					itemIcon = productInfo.imageUrl,
					itemName = productInfo.name,
					itemRobuxCost = 0,
					itemDisplayPrice = 0,
					itemPrice = 0,
					model = 0
				}

				if v7 then
					v10 = nil
				end

				v16.itemRobuxCost = v10
				local v17 = if v7 then productInfo.displayPrice else nil
				v16.itemDisplayPrice = v17
				v16.itemPrice = price
				v16.model = self.props.humanoidModel

				local v18 = if fFlagPurchasePromptSubtitleForTimedOptions then self.props.subtitleView else nil
				local v19 = {
					buyItemActivated = self.confirmButtonPressed,
					buyItemEnableInputDelayed = 0,
					cancelActivated = 0,
					isDisabled = 0
				}
				local v20 = self.isWindowShowAndDoneAnimating() and self.buyButtonUsesFoundationInputDelay

				if v20 then
					v20 = not (FFlagSkipBuyDelayForExperienceShop and self.isFromShopSkip())
				end

				v19.buyItemEnableInputDelayed = v20

				v19.cancelActivated = self.cancelButtonPressed
				v19.isDisabled = promptState == PromptState.PurchaseInProgress
				local v15 = {
					product = v16,
					subtitleView = v18,
					buttons = v19,
					postPurchaseActions = self.props.postPurchaseActions,
					setPostPurchaseActions = self.props.setPostPurchaseActions,
					onBuyItemButtonMounted = v13,
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

				local v21 = if fFlagUnifiedPurchaseAddSkeleton then promptState == PromptState.InitializingPurchase else nil
				v15.isLoading = v21

				v15.isCartPricingLoading = self.props.isCartPricingLoading
				v15.onBlackbirdUpsellActivated = fn
				v15.BlackbirdUpsellBannerProductInfo = v12
				v15.cartPricingResponse = self.props.cartPricingResponse
				v15.onCartOfferAppliedChanged = fn2
				return createElement(unifiedProductPurchaseModalV2, v15)
			else
				local createElement = roact.createElement
				local v16 = {
					itemIcon = productInfo.imageUrl,
					itemName = productInfo.name,
					itemRobuxCost = 0,
					itemDisplayPrice = 0,
					itemPrice = 0,
					model = 0
				}
				local v17 = if not v7 then self.props.productPrice else nil
				v16.itemRobuxCost = v17
				local v18 = if v7 then productInfo.displayPrice else nil
				v16.itemDisplayPrice = v18
				v16.itemPrice = price
				v16.model = self.props.humanoidModel

				local v19 = {
					buyItemActivated = self.confirmButtonPressed,
					buyItemEnableInputDelayed = 0,
					cancelActivated = 0,
					isDisabled = 0
				}
				local v20 = self.isWindowShowAndDoneAnimating() and self.buyButtonUsesFoundationInputDelay

				if v20 then
					v20 = not (FFlagSkipBuyDelayForExperienceShop and self.isFromShopSkip())
				end

				v19.buyItemEnableInputDelayed = v20

				v19.cancelActivated = self.cancelButtonPressed
				v19.isDisabled = promptState == PromptState.PurchaseInProgress
				local v15 = {
					product = v16,
					buttons = v19,
					postPurchaseActions = self.props.postPurchaseActions,
					setPostPurchaseActions = self.props.setPostPurchaseActions,
					onBuyItemButtonMounted = v13,
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

				local v21 = if fFlagLuaAppsEnablePromptVIPServerPurchase then productInfo.isMonthlyPrice else nil
				v15.isMonthlyPrice = v21

				local v22 = if fFlagLuaAppsEnablePromptVIPServerPurchase then productInfo.isFreeWithRobloxPlus else nil
				v15.isFreeWithRobloxPlus = v22

				v15.isCartPricingLoading = self.props.isCartPricingLoading
				v15.onBlackbirdUpsellActivated = fn
				v15.BlackbirdUpsellBannerProductInfo = v12
				v15.cartPricingResponse = self.props.cartPricingResponse
				v15.onCartOfferAppliedChanged = fn2

				if not v7 then
					if fFlagUnifiedPurchaseFlowMarketplaceUIImprovements then
						v7 = self.props.purchaseAnalyticsMetadata
							and self.props.purchaseAnalyticsMetadata.surface == productPurchaseSurface.Catalog
					else
						v7 = nil
					end
				end

				v15.hideUserRobuxBalance = v7
				return createElement(unifiedProductPurchaseModal, v15)
			end
		elseif desktopUpsellExperiment.shouldShowNewModal() then
			return roact.createElement(productPurchaseModal, {
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
			return roact.createElement(productPurchase, {
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
		if desktopUpsellExperiment.shouldShowNewModal() then
			local createElement = roact.createElement
			local v8 = {
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

			local v9 = {
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
			local v10 = self.isWindowShowAndDoneAnimating()

			if v10 then
				v10 = not (FFlagSkipBuyDelayForExperienceShop and self.isFromShopSkip())
			end

			v9.buyItemEnableInputDelayed = v10

			function v9.cancelPurchaseActivated()
				self.cancelButtonPressed()
				self.emitPurchaseFlowEvent("UserInput", "Cancel")
			end
			v9.cancelControllerIcon = self.props.isGamepadEnabled
				and "rbxasset://textures/ui/Controls/DesignSystem/ButtonB.png"
				or nil
			v9.opensBuyRobuxPage = desktopUpsellExperiment.getVariant() == desktopUpsellExperiment.variants.OpenRobuxStore
			v8.buttons = v9
			return createElement(robuxUpsellModal, v8)
		else
			local createElement = roact.createElement
			local v8 = {
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
			local v9 = self.isWindowShowAndDoneAnimating()

			if v9 then
				v9 = not (FFlagSkipBuyDelayForExperienceShop and self.isFromShopSkip())
			end

			v8.enableInputDelayed = v9

			v8.buyItemControllerIcon = self.props.isGamepadEnabled
				and "rbxasset://textures/ui/Controls/DesignSystem/ButtonA.png"
				or nil
			v8.cancelControllerIcon = self.props.isGamepadEnabled
				and "rbxasset://textures/ui/Controls/DesignSystem/ButtonB.png"
				or nil

			function v8.buyItemActivated()
				self.confirmButtonPressed()
				self.emitPurchaseFlowEvent("UserInput", "Buy")
			end
			function v8.cancelPurchaseActivated()
				self.cancelButtonPressed()
				self.emitPurchaseFlowEvent("UserInput", "Cancel")
			end
			v8.isLuobu = self.state.isLuobu
			v8.isVng = getFFlagOpenVngTosForVngRobuxUpsell()
				and getAppFeaturePolicies().getShowVNGTosForRobuxUpsell()
			return createElement(productPurchaseRobuxUpsell, v8)
		end
	else
		if promptState == PromptState.LeaveRobloxWarning then
			return roact.createElement(leaveRobloxAlert, {
				screenSize = self.state.screenSize,
				cancelActivated = self.cancelButtonPressed,
				continueActivated = self.confirmButtonPressed
			})
		end

		if fFlagLuaAppsEnablePromptVIPServerPurchase then
			local props2 = self.props
			local v7

			if props2.promptState == PromptState.PurchaseComplete then
				v7 = props2.requestType == RequestType.VIPServer
			else
				v7 = false
			end

			if v7 then
				return React.createElement(VIPServerPostPurchaseContainer, {
					onClose = self.props.hideWindow
				})
			end
		end

		if promptState == PromptState.PurchaseComplete and requestType == RequestType.AvatarCreationFee then
			return roact.createElement(interactiveAlert, {
				bodyText = RobloxTranslator:FormatByKey("CoreScripts.PublishAvatarPrompt.PurchaseCompleteDescription"),
				buttonStackInfo = {
					buttons = {
						{
							buttonType = buttonType.PrimarySystem,
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
			or module27(purchaseError)
		then
			local createElement = React.createElement
			local v8 = {
				screenSize = self.state.screenSize,
				titleIcon = images["icons/status/error_large"],
				promptState = promptState,
				productInfo = productInfo,
				purchaseError = purchaseError,
				economicRestrictionError = self.props.economicRestrictionError or {},
				isGamepadEnabled = self.props.isGamepadEnabled,
				cancelButtonPressed = self.cancelButtonPressed,
				confirmButtonPressed = self.confirmButtonPressed,
				includeCancelButton = true,
				isGenericChallengeResponse = module27,
				useUnifiedPurchaseCompletionModal = self.props.isUserEligibleForUnifiedPurchaseFlow,
				surface = 0,
				productType = 0
			}

			local v9 = if FFlagAddSurfaceAndProductTypeToPromptCounter then self.props.purchaseAnalyticsMetadata and self.props.purchaseAnalyticsMetadata.surface else nil
			v8.surface = v9

			local v10 = if FFlagAddSurfaceAndProductTypeToPromptCounter then self.props.purchaseAnalyticsMetadata and self.props.purchaseAnalyticsMetadata.productType else nil
			v8.productType = v10
			return createElement(ProductPurchasePrompt, v8)
		else
			if promptState == PromptState.EnablePurchaseVPCModal then
				return roact.createElement(animator, {
					shouldAnimate = true,
					shouldShow = promptState == PromptState.EnablePurchaseVPCModal,
					renderChildren = function()
						return roact.createElement(verifiedParentalConsentDialog, {
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
				and desktopUpsellExperiment.shouldShowNewModal()
			then
				return roact.createElement(robuxUpsellModalTooExpensiveFallback, {
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

			local v7 = fFlagEnableLaunchAfterPurchase

			if v7 then
				if promptState == PromptState.PurchaseComplete then
					v7 = self.props.launchAfterPurchaseRootPlaceId ~= nil
				else
					v7 = false
				end
			end

			local createElement = React.createElement
			local v9 = {
				screenSize = self.state.screenSize,
				promptState = promptState,
				productInfo = productInfo,
				purchaseError = purchaseError,
				economicRestrictionError = self.props.economicRestrictionError or {},
				isGamepadEnabled = self.props.isGamepadEnabled,
				cancelButtonPressed = self.cancelButtonPressed,
				confirmButtonPressed = self.confirmButtonPressed,
				includeCancelButton = false,
				isGenericChallengeResponse = module27,
				useUnifiedPurchaseCompletionModal = self.props.isUserEligibleForUnifiedPurchaseFlow,
				isMultiItem = getUnifiedPurchaseModalType(self.props.requestType) == unifiedPurchaseModalTypeEnum.MultiItem,
				timedOptionDays = 0,
				completionMessage = 0,
				launchAfterPurchaseButtonPressed = 0,
				launchAfterPurchaseButtonShown = 0,
				surface = 0,
				productType = 0
			}
			local v10 = if fFlagPurchasePromptSubtitleForTimedOptions then self.props.timedOptionDays else nil
			v9.timedOptionDays = v10
			local v11 = if fFlagPurchaseModalTimedOptionExtension then self.props.completionMessage else nil
			v9.completionMessage = v11

			local v12 = if v7 then self.launchAfterPurchaseButtonPressed else nil
			v9.launchAfterPurchaseButtonPressed = v12

			local v13 = if v7 then self.launchAfterPurchaseButtonShown else nil
			v9.launchAfterPurchaseButtonShown = v13

			local v14 = if FFlagAddSurfaceAndProductTypeToPromptCounter then self.props.purchaseAnalyticsMetadata and self.props.purchaseAnalyticsMetadata.surface else nil
			v9.surface = v14

			local v15 = if FFlagAddSurfaceAndProductTypeToPromptCounter then self.props.purchaseAnalyticsMetadata and self.props.purchaseAnalyticsMetadata.productType else nil
			v9.productType = v15
			return createElement(ProductPurchasePrompt, v9)
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

	local createElement = roact.createElement
	local changeScreenSizesByAbsoluteSize = {
		Size = UDim2.new(1, 0, 1, 0),
		[roact.Change.AbsoluteSize] = self.changeScreenSize,
		BackgroundTransparency = 1
	}

	local createElement2 = roact.createElement
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
		[roact.Ref] = self.animatorRef
	}

	local v8 = if prompt ~= nil then roact.createElement("ImageButton", {
		BackgroundTransparency = 0,
		Modal = true,
		Size = UDim2.new(0, 0, 0, 0)
	}) or nil else nil
	return createElement("Frame", changeScreenSizesByAbsoluteSize, {
		Animator = createElement2(module33, animatorRefsByRef, {
			Prompt = prompt,
			ModalFix = v8
		}),
		OnCoreGuiMenuOpened = roact.createElement(ExternalEventConnection, {
			event = GuiService.MenuOpened,
			callback = function()
				if FFlagSetMenuOnPurchasePrompt and self.menuOpenedBySelf then
					self.menuOpenedBySelf = false
				elseif self.props.hideWindow then
					self.props.hideWindow()
				end
			end
		}),
		OnUserGuiRenderingChanged = roact.createElement(ExternalEventConnection, {
			event = CoreGui.UserGuiRenderingChanged,
			callback = function(p2, p3)
				if not (p2 and p3) then
					self.props.hideWindow()
				end
			end
		})
	})
end

local function mapStateToProps(data)
	local v5 = isMockingPurchases(data.promptRequest.requestType)

	local v6 = if data.abVariations then data.abVariations.DesktopUpsellExpVariant else nil

	local v7 = {
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
		isTestPurchase = v5,
		isGamepadEnabled = data.gamepadEnabled,
		desktopUpsellExpVariant = v6,
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
	local v8 = if selectPrice then selectPrice(data) else nil
	v7.price = v8
	local v9 = if fFlagPurchasePromptSubtitleForTimedOptions and data.productPayload then data.productPayload.timedOptionDays else nil
	v7.timedOptionDays = v9

	local v10 = if fFlagPurchaseModalTimedOptionExtension and data.purchaseOptions then data.purchaseOptions.completionMessage else nil
	v7.completionMessage = v10

	local v11 = if fFlagEnableLaunchAfterPurchase and data.purchaseOptions and data.purchaseOptions.launchAfterPurchaseRootPlaceId ~= nil and data.purchaseOptions.launchAfterPurchaseRootPlaceId ~= "" then data.purchaseOptions.launchAfterPurchaseRootPlaceId else nil
	v7.launchAfterPurchaseRootPlaceId = v11

	v7.robloxSubscriptionProducts = data.robloxSubscriptionProducts

	local v12 = if FFlagBlackbirdUpsellGateResaleAndTimedOption or FFlagSkipBuyDelayForExperienceShop then data.productPayload else nil
	v7.productPayload = v12

	v7.cartPricingResponse = selectCartPricingResponse(data)
	v7.isCartPricingLoading = selectIsCartPricingFetching(data)
	return v7
end

local function mapDispatchToProps(callback)
	return {
		setPurchaseFlowUUID = function(p2)
			callback(SetPurchaseFlowUUID(p2))
		end,
		onBuy = function()
			callback(purchaseItem())
		end,
		completePurchase = function()
			callback(module18())
		end,
		onScaryModalConfirm = function()
			callback(launchRobuxUpsell())
		end,
		onOpenSecuritySettings = function(p2)
			if p2 then
				callback(openSecuritySettings(p2))
			else
				callback(openSecuritySettings())
			end
		end,
		onRobuxUpsell = function()
			callback(initiateUserPurchaseSettingsPrecheck())
		end,
		hideWindow = function()
			callback(module14())
		end,
		retryPurchaseAfterUpsell = function()
			callback(module15())
		end,
		setWindowState = function(p2)
			callback(SetButtonState(p2))
		end,
		completeRequest = function()
			if fFlagAddCursorProviderToPurchasePromptApp then
				GuiService.SelectedCoreObject = nil
			end

			callback(module16())
		end,
		onAnalyticEvent = function(p2, p3)
			callback(sendEvent(p2, p3))
		end,
		setPostPurchaseActions = function(p2)
			callback(SetPostPurchaseActions(p2))
		end,
		setPromptState = function(p2)
			callback(SetPromptState(p2))
		end,
		fetchCartPricing = function(p2)
			callback(module50(p2))
		end,
		fetchInGameItemCartPricing = function(p2)
			callback(module51(p2))
		end
	}
end

return (connectToStore(mapStateToProps, mapDispatchToProps)(extended))
