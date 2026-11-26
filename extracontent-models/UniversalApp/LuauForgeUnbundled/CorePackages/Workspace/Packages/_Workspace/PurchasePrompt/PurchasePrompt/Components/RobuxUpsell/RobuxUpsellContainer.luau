local GuiService = game:GetService("GuiService")

local PurchasePromptDeps = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptDeps")
local IAPExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/IAPExperience")
local roact = PurchasePromptDeps.Roact
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/React")

local coreScriptsRootProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/CoreScriptsRoactCommon").CoreScriptsRootProvider
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/FocusNavigationUtils")
local focusRoot = FocusNavigationUtils.FocusRoot
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local Navigation = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/Navigation")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/Cryo")
local selectPrice = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Selectors/selectPrice")

local PromptNativeUpsellSuggestions = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/PromptNativeUpsellSuggestions")
local SetPostPurchaseActions = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetPostPurchaseActions")
local SetPromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetPromptState")
local SetButtonState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetButtonState")

local PurchaseFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseFlow")
local PromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PromptState")

require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Models/RobuxUpsell")

local getUpsellSuggestionsTypes = IAPExperience.Api.PaymentsGateway.GetUpsellSuggestionsTypes

local module14 = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/completeRequest")
local module15 = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/purchaseItem")
local launchRobuxUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/launchRobuxUpsell")
local module17 = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/openRobuxStore")
local module18 = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/openSecuritySettings")
local module19 = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/openTermsOfUse")
local initiateUserPurchaseSettingsPrecheck = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/initiateUserPurchaseSettingsPrecheck")
local module21 = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/retryPurchaseAfterUpsell")
local module22 = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/fetchCartPricing")
local module23 = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/fetchInGameItemCartPricing")
local RequestType = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/RequestType")
local selectCartPricingResponse = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Selectors/selectCartPricingResponse")
local selectIsCartPricingFetching = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Selectors/selectIsCartPricingFetching")
local sendEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/sendEvent")
local isMockingPurchases = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/isMockingPurchases")
local getPlayerPrice = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/getPlayerPrice")
local isLinksAllowed = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/isLinksAllowed")
local SelectedRobuxPackage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/SelectedRobuxPackage")
local connectToStore = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/connectToStore")

local ExternalEventConnection = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Components/Connection/ExternalEventConnection")

local GetFFLagUseCoreScriptsRootProviderForUpsellModal = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/GetFFLagUseCoreScriptsRootProviderForUpsellModal")
local FFlagSetMenuOnPurchasePrompt = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagSetMenuOnPurchasePrompt")
local upsellSuggestionsAPIMaxPackages = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").UpsellSuggestionsAPIMaxPackages
local RobuxUpsellOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Components/RobuxUpsell/RobuxUpsellOverlay")
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/RobloxAppEnums").AppPage

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags")
local fFlagLuaAppsEnablePromptVIPServerPurchase = SharedFlags.FFlagLuaAppsEnablePromptVIPServerPurchase
local fFlagEnableRobuxUpsellPlusButtonExperiment = IAPExperience.Flags.FFlagEnableRobuxUpsellPlusButtonExperiment

local fFlagAddOnRobloxSubscriptionUpsellSuccessCallbackToUnifiedPurchaseModal = SharedFlags.FFlagAddOnRobloxSubscriptionUpsellSuccessCallbackToUnifiedPurchaseModal
local FFlagSkipBuyDelayForExperienceShop = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagSkipBuyDelayForExperienceShop")
local getBlackbirdUpsellBannerProductInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/getBlackbirdUpsellBannerProductInfo")
local startRobuxUpsellPlusPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/startRobuxUpsellPlusPurchase")
local extended = roact.Component:extend("RobuxUpsellContainer")

function extended:init()
	self.state = { screenSize = Vector2.new(0, 0) }

	self.isRobloxPlusUpsellStarting = false

	function self.changeScreenSize(p2)
		if self.state.screenSize ~= p2.AbsoluteSize then
			self:setState({ screenSize = p2.AbsoluteSize })
		end
	end
	function self.fetchCartPricingForPurchasePrompt(p2, p3)
		if p3 == nil then
			return nil
		end

		local requestType = self.props.requestType

		if requestType == RequestType.GamePass or requestType == RequestType.Product then
			return self.props.fetchInGameItemCartPricing(p3)
		end

		return self.props.fetchCartPricing(p3)
	end

	function self.navigateToBuyRobux()
		self.props.navigation.navigate(appPage.PurchaseRobux)
	end

	function self.navigateToTermsOfUse()
		self.props.openTermsOfUse(self.props.navigation)
	end

	function self.openRobloxPlusUpsell()
		if self.isRobloxPlusUpsellStarting then
			return
		end

		self.isRobloxPlusUpsellStarting = true

		startRobuxUpsellPlusPurchase({
			purchaseFlowUUID = self.props.purchaseFlowUUID,
			setPromptState = self.props.setPromptState,
			setWindowState = self.props.setWindowState,
			onRobloxSubscriptionUpsellSuccess = self.props.onRobloxSubscriptionUpsellSuccess,
			retryPurchaseAfterUpsell = self.props.retryPurchaseAfterUpsell,
			completeRequest = self.props.completeRequest,
			onFlowEnded = function()
				self.isRobloxPlusUpsellStarting = false
			end
		})
	end
end

function extended:getRobloxPlusPromptKey()
	local purchaseFlowUUID = self.props.purchaseFlowUUID

	if type(purchaseFlowUUID) == "string" and purchaseFlowUUID ~= "" then
		return purchaseFlowUUID
	end

	local productPayload = self.props.productPayload
	local id = if type(productPayload) == "table" then productPayload.id else nil

	if id == nil then
		return nil
	end

	return (tostring(id))
end

function extended:isRobuxUpsellModalVisible(): boolean
	local purchaseFlow = self.props.purchaseFlow
	return (purchaseFlow == PurchaseFlow.RobuxUpsellV2 or purchaseFlow == PurchaseFlow.LargeRobuxUpsell)
		and self.props.promptState == PromptState.RobuxUpsell
end

function extended:createElement()
	local props = self.props
	local state = self.state
	local v5 = if self:isRobuxUpsellModalVisible() then self:getRobloxPlusPromptKey() else nil
	local v6

	if v5 == nil then
		v6 = false
	else
		v6 = props.isUserEligibleForUnifiedPurchaseFlow
			and props.experimentVariant == getUpsellSuggestionsTypes.ExperimentVariant.PlusPromotion
	end

	local v7 = getBlackbirdUpsellBannerProductInfo(props.robloxSubscriptionProducts)
	local initialDiscountPercentage = if v7 then v7.initialDiscountPercentage else nil

	if type(initialDiscountPercentage) ~= "number" then
		initialDiscountPercentage = nil
	end

	if
		props.purchaseFlow ~= PurchaseFlow.RobuxUpsellV2 and props.purchaseFlow ~= PurchaseFlow.LargeRobuxUpsell
		or fFlagEnableRobuxUpsellPlusButtonExperiment
		and props.promptState == PromptState.BlackbirdUpsellInProgress
	then
		return nil
	end

	local v8 = isLinksAllowed()

	local imageUrl = props.productInfo.imageUrl

	if string.find(props.productInfo.imageUrl, "assetid=0") then
		imageUrl = nil
	end

	local createElement = roact.createElement
	local changeScreenSizesByAbsoluteSize = {
		Size = UDim2.new(1, 0, 1, 0),
		[roact.Change.AbsoluteSize] = self.changeScreenSize,
		BackgroundTransparency = 1
	}

	local createElement2 = roact.createElement
	local v11 = {}
	v11.screenSize = state.screenSize
	v11.virtualItemPrice = props.virtualItemPrice

	v11.requestType = props.requestType

	v11.promptState = props.promptState
	v11.purchaseFlow = props.purchaseFlow
	v11.purchaseError = props.purchaseError
	v11.economicRestrictionError = props.economicRestrictionError
	v11.useUpsellSuggestions = upsellSuggestionsAPIMaxPackages > 1
	v11.upsellSuggestions = props.robuxSuggestions
	v11.selectedUpsellIndex = props.robuxPackageSelection
	v11.virtualItemBadgeType = props.virtualItemBadgeType
	function v11.onUpsellSuggestionsSelected(p2)
		props.onUpsellSuggestionsSelected(
			props.robuxSuggestions,
			p2,
			props.virtualItemBadgeType,
			props.experimentVariant
		)
	end

	v11.useUnifiedProductPurchaseModal = self.props.isUserEligibleForUnifiedPurchaseFlow
	v11.purchaseAnalyticsMetadata = self.props.purchaseAnalyticsMetadata
	v11.cartPricingResponse = props.cartPricingResponse
	v11.collectibleItemId = props.collectibleItemId
	v11.isCartPricingLoading = props.isCartPricingLoading
	v11.onCartOfferAppliedChanged = self.fetchCartPricingForPurchasePrompt
	v11.postPurchaseActions = props.postPurchaseActions
	v11.setPostPurchaseActions = props.setPostPurchaseActions
	local v12 = if v6 then self.openRobloxPlusUpsell else nil
	v11.onRobloxPlusButtonActivated = v12
	v11.robloxPlusDiscountPercentage = initialDiscountPercentage

	local v13 = if fFlagLuaAppsEnablePromptVIPServerPurchase then props.productInfo.isMonthlyPrice else nil
	v11.isMonthlyPrice = v13

	v11.robuxProviderId = props.robuxProductId
	v11.robuxProductId = props.productId

	v11.itemIcon = imageUrl
	v11.itemProductId = props.productInfo.productId
	v11.itemName = props.productInfo.name
	v11.itemRobuxCost = getPlayerPrice(
		props.productInfo,
		props.accountInfo.membershipType == 4,
		props.expectedPrice
	)

	v11.iapRobuxAmount = props.robuxPurchaseAmount or 0
	v11.iapCostStr = props.price
	v11.beforeRobuxBalance = props.accountInfo.balance

	v11.isTestPurchase = props.isTestPurchase
	v11.isGamepadEnabled = props.isGamepadEnabled
	local v14 = if FFlagSkipBuyDelayForExperienceShop then props.isFromInExperienceShop else nil
	v11.isFromInExperienceShop = v14

	v11.purchaseItem = props.purchaseItem
	v11.promptRobuxPurchase = props.promptRobuxPurchase
	local v15 = if self.props.isUserEligibleForUnifiedPurchaseFlow then self.navigateToBuyRobux else props.openRobuxStore
	v11.openRobuxStore = v15

	local v16 = if v8 then self.navigateToTermsOfUse or nil else nil
	v11.openTermsOfUse = v16
	local v17 = if v8 then props.openSecuritySettings or nil else nil
	v11.openSecuritySettings = v17
	v11.dispatchFetchPurchaseWarning = props.dispatchFetchPurchaseWarning
	v11.endPurchase = props.completeRequest

	v11.onAnalyticEvent = props.onAnalyticEvent

	v11.humanoidModel = props.humanoidModel
	return createElement("Frame", changeScreenSizesByAbsoluteSize, {
		Prompt = createElement2(RobuxUpsellOverlay, v11),
		ModalFix = roact.createElement("ImageButton", {
			BackgroundTransparency = 0,
			Modal = true,
			Size = UDim2.new(0, 0, 0, 0)
		}),
		OnCoreGuiMenuOpened = roact.createElement(ExternalEventConnection, {
			event = GuiService.MenuOpened,
			callback = function()
				if FFlagSetMenuOnPurchasePrompt and self.menuOpenedBySelf then
					self.menuOpenedBySelf = false
				else
					props.completeRequest()
				end
			end
		})
	})
end

function extended:render()
	local element = self:createElement()

	if FFlagSetMenuOnPurchasePrompt then
		if element ~= nil then
			self.menuOpenedBySelf = true
		end

		GuiService:SetMenuIsOpen(element ~= nil, "RobuxUpsellContainer")
	end

	if GetFFLagUseCoreScriptsRootProviderForUpsellModal() then
		return roact.createElement(coreScriptsRootProvider, {}, {
			FocusNavigationCoreScriptsWrapper = React.createElement(
				focusRoot,
				{
					surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.CentralOverlay,
					isIsolated = true,
					isAutoFocusRoot = true
				},
				{ RobuxUpsellContainer = element }
			)
		})
	end

	return element
end

return (connectToStore(function(data)
	local v5 = isMockingPurchases(data.promptRequest.requestType)

	local collectibleItemId = data.productInfo.collectibleItemId

	if type(collectibleItemId) ~= "string" or collectibleItemId == "" then
		collectibleItemId = data.promptRequest.collectibleItemId

		if type(collectibleItemId) ~= "string" or collectibleItemId == "" then
			collectibleItemId = nil
		end
	end

	local v6 = {
		purchaseFlow = data.purchaseFlow,
		requestType = data.promptRequest.requestType,
		expectedPrice = data.promptRequest.expectedPrice,
		promptState = data.promptState,
		purchaseError = data.purchaseError,
		economicRestrictionError = data.economicRestrictionError,
		productInfo = data.productInfo,
		accountInfo = data.accountInfo,
		robuxSuggestions = data.robuxUpsellSuggestions.products,
		robuxPackageSelection = data.robuxUpsellSuggestions.selection,
		virtualItemBadgeType = data.robuxUpsellSuggestions.virtualItemBadgeType,
		experimentVariant = data.robuxUpsellSuggestions.experimentVariant,
		robuxProductId = SelectedRobuxPackage.getRobuxProductId(data),
		productId = SelectedRobuxPackage.getProductId(data),
		robuxPurchaseAmount = SelectedRobuxPackage.getRobuxPurchaseAmount(data),
		robuxAmountBeforeBonus = SelectedRobuxPackage.getRobuxAmountBeforeBonus(data),
		price = SelectedRobuxPackage.getPrice(data),
		isTestPurchase = v5,
		isGamepadEnabled = data.gamepadEnabled,
		isFromInExperienceShop = 0,
		humanoidModel = 0,
		isUserEligibleForUnifiedPurchaseFlow = 0,
		purchaseAnalyticsMetadata = 0,
		purchaseFlowUUID = 0,
		virtualItemPrice = 0,
		collectibleItemId = 0,
		cartPricingResponse = 0,
		isCartPricingLoading = 0,
		postPurchaseActions = 0,
		productPayload = 0,
		robloxSubscriptionProducts = 0,
		onRobloxSubscriptionUpsellSuccess = 0
	}

	local v7 = if FFlagSkipBuyDelayForExperienceShop then data.productPayload and data.productPayload.isFromInExperienceShop else nil
	v6.isFromInExperienceShop = v7

	v6.humanoidModel = data.promptRequest.humanoidModel
	v6.isUserEligibleForUnifiedPurchaseFlow = data.isUserEligibleForUnifiedPurchaseFlow
	v6.purchaseAnalyticsMetadata = data.purchaseAnalyticsMetadata
	v6.purchaseFlowUUID = data.purchaseFlowUUID
	v6.virtualItemPrice = selectPrice(data)
	v6.collectibleItemId = collectibleItemId
	v6.cartPricingResponse = selectCartPricingResponse(data)
	v6.isCartPricingLoading = selectIsCartPricingFetching(data)
	v6.postPurchaseActions = data.postPurchaseActions
	v6.productPayload = data.productPayload
	v6.robloxSubscriptionProducts = data.robloxSubscriptionProducts

	local v8 = if fFlagAddOnRobloxSubscriptionUpsellSuccessCallbackToUnifiedPurchaseModal and data.purchaseCallbacks then data.purchaseCallbacks.onRobloxSubscriptionUpsellSuccess else nil
	v6.onRobloxSubscriptionUpsellSuccess = v8
	return v6
end, function(callback)
	return {
		purchaseItem = function()
			return callback(module15())
		end,
		fetchCartPricing = function(p2)
			return callback(module22(p2))
		end,
		fetchInGameItemCartPricing = function(p2)
			return callback(module23(p2))
		end,
		promptRobuxPurchase = function()
			return callback(launchRobuxUpsell())
		end,
		openRobuxStore = function()
			return callback(module17())
		end,
		openSecuritySettings = function()
			return callback(module18())
		end,
		openTermsOfUse = function(p2)
			return callback(module19(p2))
		end,
		dispatchFetchPurchaseWarning = function()
			return callback(initiateUserPurchaseSettingsPrecheck())
		end,
		completeRequest = function()
			GuiService.SelectedCoreObject = nil
			return callback(module14())
		end,
		retryPurchaseAfterUpsell = function()
			return callback(module21())
		end,
		setPromptState = function(p2)
			return callback(SetPromptState(p2))
		end,
		setWindowState = function(p2)
			return callback(SetButtonState(p2))
		end,
		onUpsellSuggestionsSelected = function(p2, p3, p4, p5)
			return callback(PromptNativeUpsellSuggestions(p2, p3, p4, p5))
		end,
		onAnalyticEvent = function(p2, p3)
			return callback(sendEvent(p2, p3))
		end,
		setPostPurchaseActions = function(p2)
			callback(SetPostPurchaseActions(p2))
		end
	}
end)(function(p2)
	local v5 = Navigation.useNavigation()

	return roact.createElement(extended, Cryo.Dictionary.join(p2, { navigation = v5 }))
end))
