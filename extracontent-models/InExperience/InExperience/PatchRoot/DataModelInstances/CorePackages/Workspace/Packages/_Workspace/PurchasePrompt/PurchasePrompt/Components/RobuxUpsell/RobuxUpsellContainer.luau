local GuiService = game:GetService("GuiService")

local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent
local PurchasePromptDeps = require(parent.PurchasePromptDeps)
local IAPExperience = require(parent.IAPExperience)
local Roact = PurchasePromptDeps.Roact
local React = require(parent.React)

local CoreScriptsRoactCommon = require(parent.CoreScriptsRoactCommon)
local CoreScriptsRootProvider = CoreScriptsRoactCommon.CoreScriptsRootProvider
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local Navigation = require(parent.Navigation)
local Cryo = require(parent.Cryo)
local selectPrice = require(PurchasePrompt.Selectors.selectPrice)

local PromptNativeUpsellSuggestions = require(PurchasePrompt.Actions.PromptNativeUpsellSuggestions)
local SetPostPurchaseActions = require(PurchasePrompt.Actions.SetPostPurchaseActions)
local SetPromptState = require(PurchasePrompt.Actions.SetPromptState)
local SetWindowState = require(PurchasePrompt.Actions.SetWindowState)

local PurchaseFlow = require(PurchasePrompt.Enums.PurchaseFlow)
local PromptState = require(PurchasePrompt.Enums.PromptState)

require(PurchasePrompt.Models.RobuxUpsell)

local GetUpsellSuggestionsTypes = IAPExperience.Api.PaymentsGateway.GetUpsellSuggestionsTypes

local completeRequest = require(PurchasePrompt.Thunks.completeRequest)
local purchaseItem = require(PurchasePrompt.Thunks.purchaseItem)
local launchRobuxUpsell = require(PurchasePrompt.Thunks.launchRobuxUpsell)
local openRobuxStore = require(PurchasePrompt.Thunks.openRobuxStore)
local openSecuritySettings = require(PurchasePrompt.Thunks.openSecuritySettings)
local openTermsOfUse = require(PurchasePrompt.Thunks.openTermsOfUse)
local initiateUserPurchaseSettingsPrecheck = require(PurchasePrompt.Thunks.initiateUserPurchaseSettingsPrecheck)
local retryPurchaseAfterUpsell = require(PurchasePrompt.Thunks.retryPurchaseAfterUpsell)
local fetchCartPricing = require(PurchasePrompt.Thunks.fetchCartPricing)
local fetchInGameItemCartPricing = require(PurchasePrompt.Thunks.fetchInGameItemCartPricing)
local RequestType = require(PurchasePrompt.Enums.RequestType)
local selectCartPricingResponse = require(PurchasePrompt.Selectors.selectCartPricingResponse)
local selectIsCartPricingFetching = require(PurchasePrompt.Selectors.selectIsCartPricingFetching)
local sendEvent = require(PurchasePrompt.Thunks.sendEvent)
local isMockingPurchases = require(PurchasePrompt.Utils.isMockingPurchases)
local getPlayerPrice = require(PurchasePrompt.Utils.getPlayerPrice)
local isLinksAllowed = require(PurchasePrompt.Utils.isLinksAllowed)
local SelectedRobuxPackage = require(PurchasePrompt.Utils.SelectedRobuxPackage)
local connectToStore = require(PurchasePrompt.connectToStore)

local ExternalEventConnection = require(PurchasePrompt.Components.Connection.ExternalEventConnection)

local GetFFLagUseCoreScriptsRootProviderForUpsellModal = require(PurchasePrompt.Flags.GetFFLagUseCoreScriptsRootProviderForUpsellModal)
local FFlagSetMenuOnPurchasePrompt = require(PurchasePrompt.Flags.FFlagSetMenuOnPurchasePrompt)
local SharedFlags = require(parent.SharedFlags)
local UpsellSuggestionsAPIMaxPackages = SharedFlags.UpsellSuggestionsAPIMaxPackages
local RobuxUpsellOverlay = require(script.Parent.RobuxUpsellOverlay)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage

local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppsEnablePromptVIPServerPurchase = SharedFlags2.FFlagLuaAppsEnablePromptVIPServerPurchase
local FFlagEnableRobuxUpsellPlusButtonExperiment = IAPExperience.Flags.FFlagEnableRobuxUpsellPlusButtonExperiment

local FFlagAddOnRobloxSubscriptionUpsellSuccessCallbackToUnifiedPurchaseModal = SharedFlags2.FFlagAddOnRobloxSubscriptionUpsellSuccessCallbackToUnifiedPurchaseModal
local FFlagSkipBuyDelayForExperienceShop = require(PurchasePrompt.Flags.FFlagSkipBuyDelayForExperienceShop)
local getBlackbirdUpsellBannerProductInfo = require(PurchasePrompt.Utils.getBlackbirdUpsellBannerProductInfo)
local startRobuxUpsellPlusPurchase = require(PurchasePrompt.Utils.startRobuxUpsellPlusPurchase)
local extended = Roact.Component:extend(script.Name)

function extended:init()
	self.state = { screenSize = Vector2.new(0, 0) }

	self.isRobloxPlusUpsellStarting = false

	function self.changeScreenSize(p)
		if self.state.screenSize ~= p.AbsoluteSize then
			self:setState({ screenSize = p.AbsoluteSize })
		end
	end
	function self.fetchCartPricingForPurchasePrompt(_: boolean, p)
		if p == nil then
			return nil
		end

		local requestType = self.props.requestType

		if requestType == RequestType.GamePass or requestType == RequestType.Product then
			return self.props.fetchInGameItemCartPricing(p)
		end

		return self.props.fetchCartPricing(p)
	end

	function self.navigateToBuyRobux()
		self.props.navigation.navigate(AppPage.PurchaseRobux)
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
	local id

	if type(productPayload) == "table" then
		id = productPayload.id
	end

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
	local v

	if self:isRobuxUpsellModalVisible() then
		v = self:getRobloxPlusPromptKey()
	end

	local v2

	if v == nil then
		v2 = false
	else
		v2 = props.isUserEligibleForUnifiedPurchaseFlow
			and props.experimentVariant == GetUpsellSuggestionsTypes.ExperimentVariant.PlusPromotion
	end

	local blackbirdUpsellBannerProductInfo = getBlackbirdUpsellBannerProductInfo(props.robloxSubscriptionProducts)
	local initialDiscountPercentage

	if blackbirdUpsellBannerProductInfo then
		initialDiscountPercentage = blackbirdUpsellBannerProductInfo.initialDiscountPercentage
	end

	if type(initialDiscountPercentage) ~= "number" then
		initialDiscountPercentage = nil
	end

	if
		props.purchaseFlow ~= PurchaseFlow.RobuxUpsellV2 and props.purchaseFlow ~= PurchaseFlow.LargeRobuxUpsell
		or FFlagEnableRobuxUpsellPlusButtonExperiment and props.promptState == PromptState.BlackbirdUpsellInProgress
	then
		return nil
	end

	local linksAllowed = isLinksAllowed()

	local imageUrl = props.productInfo.imageUrl

	if string.find(props.productInfo.imageUrl, "assetid=0") then
		imageUrl = nil
	end

	local createElement = Roact.createElement
	local changeScreenSizesByAbsoluteSize = {
		Size = UDim2.new(1, 0, 1, 0),
		[Roact.Change.AbsoluteSize] = self.changeScreenSize,
		BackgroundTransparency = 1
	}

	local createElement2 = Roact.createElement
	local v3 = {}
	v3.screenSize = state.screenSize
	v3.virtualItemPrice = props.virtualItemPrice

	v3.requestType = props.requestType

	v3.promptState = props.promptState
	v3.purchaseFlow = props.purchaseFlow
	v3.purchaseError = props.purchaseError
	v3.economicRestrictionError = props.economicRestrictionError
	v3.useUpsellSuggestions = UpsellSuggestionsAPIMaxPackages > 1
	v3.upsellSuggestions = props.robuxSuggestions
	v3.selectedUpsellIndex = props.robuxPackageSelection
	v3.virtualItemBadgeType = props.virtualItemBadgeType
	function v3.onUpsellSuggestionsSelected(p: number)
		props.onUpsellSuggestionsSelected(
			props.robuxSuggestions,
			p,
			props.virtualItemBadgeType,
			props.experimentVariant
		)
	end

	v3.useUnifiedProductPurchaseModal = self.props.isUserEligibleForUnifiedPurchaseFlow
	v3.purchaseAnalyticsMetadata = self.props.purchaseAnalyticsMetadata
	v3.cartPricingResponse = props.cartPricingResponse
	v3.collectibleItemId = props.collectibleItemId
	v3.isCartPricingLoading = props.isCartPricingLoading
	v3.onCartOfferAppliedChanged = self.fetchCartPricingForPurchasePrompt
	v3.postPurchaseActions = props.postPurchaseActions
	v3.setPostPurchaseActions = props.setPostPurchaseActions
	local onRobloxPlusButtonActivated

	if v2 then
		onRobloxPlusButtonActivated = self.openRobloxPlusUpsell
	end

	v3.onRobloxPlusButtonActivated = onRobloxPlusButtonActivated
	v3.robloxPlusDiscountPercentage = initialDiscountPercentage
	local isMonthlyPrice

	if FFlagLuaAppsEnablePromptVIPServerPurchase then
		isMonthlyPrice = props.productInfo.isMonthlyPrice
	end

	v3.isMonthlyPrice = isMonthlyPrice

	v3.robuxProviderId = props.robuxProductId
	v3.robuxProductId = props.productId

	v3.itemIcon = imageUrl
	v3.itemProductId = props.productInfo.productId
	v3.itemName = props.productInfo.name
	v3.itemRobuxCost = getPlayerPrice(props.productInfo, props.accountInfo.membershipType == 4, props.expectedPrice)

	v3.iapRobuxAmount = props.robuxPurchaseAmount or 0
	v3.iapCostStr = props.price
	v3.beforeRobuxBalance = props.accountInfo.balance

	v3.isTestPurchase = props.isTestPurchase
	v3.isGamepadEnabled = props.isGamepadEnabled
	local isFromInExperienceShop

	if FFlagSkipBuyDelayForExperienceShop then
		isFromInExperienceShop = props.isFromInExperienceShop
	end

	v3.isFromInExperienceShop = isFromInExperienceShop

	v3.purchaseItem = props.purchaseItem
	v3.promptRobuxPurchase = props.promptRobuxPurchase
	local openRobuxStore2

	if self.props.isUserEligibleForUnifiedPurchaseFlow then
		openRobuxStore2 = self.navigateToBuyRobux
	else
		openRobuxStore2 = props.openRobuxStore
	end

	v3.openRobuxStore = openRobuxStore2
	local openTermsOfUse2

	if linksAllowed then
		openTermsOfUse2 = self.navigateToTermsOfUse or nil
	end

	v3.openTermsOfUse = openTermsOfUse2
	local openSecuritySettings2

	if linksAllowed then
		openSecuritySettings2 = props.openSecuritySettings or nil
	end

	v3.openSecuritySettings = openSecuritySettings2
	v3.dispatchFetchPurchaseWarning = props.dispatchFetchPurchaseWarning
	v3.endPurchase = props.completeRequest

	v3.onAnalyticEvent = props.onAnalyticEvent

	v3.humanoidModel = props.humanoidModel
	return createElement("Frame", changeScreenSizesByAbsoluteSize, {
		Prompt = createElement2(RobuxUpsellOverlay, v3),
		ModalFix = Roact.createElement("ImageButton", {
			BackgroundTransparency = 0,
			Modal = true,
			Size = UDim2.new(0, 0, 0, 0)
		}),
		OnCoreGuiMenuOpened = Roact.createElement(ExternalEventConnection, {
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
		return Roact.createElement(CoreScriptsRootProvider, {}, {
			FocusNavigationCoreScriptsWrapper = React.createElement(
				FocusRoot,
				{
					surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay,
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
	local mockingPurchases = isMockingPurchases(data.promptRequest.requestType)

	local collectibleItemId = data.productInfo.collectibleItemId

	if type(collectibleItemId) ~= "string" or collectibleItemId == "" then
		collectibleItemId = data.promptRequest.collectibleItemId

		if type(collectibleItemId) ~= "string" or collectibleItemId == "" then
			collectibleItemId = nil
		end
	end

	local v = {
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
		isTestPurchase = mockingPurchases,
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
	local isFromInExperienceShop

	if FFlagSkipBuyDelayForExperienceShop then
		isFromInExperienceShop = data.productPayload and data.productPayload.isFromInExperienceShop
	end

	v.isFromInExperienceShop = isFromInExperienceShop

	v.humanoidModel = data.promptRequest.humanoidModel
	v.isUserEligibleForUnifiedPurchaseFlow = data.isUserEligibleForUnifiedPurchaseFlow
	v.purchaseAnalyticsMetadata = data.purchaseAnalyticsMetadata
	v.purchaseFlowUUID = data.purchaseFlowUUID
	v.virtualItemPrice = selectPrice(data)
	v.collectibleItemId = collectibleItemId
	v.cartPricingResponse = selectCartPricingResponse(data)
	v.isCartPricingLoading = selectIsCartPricingFetching(data)
	v.postPurchaseActions = data.postPurchaseActions
	v.productPayload = data.productPayload
	v.robloxSubscriptionProducts = data.robloxSubscriptionProducts
	local onRobloxSubscriptionUpsellSuccess

	if FFlagAddOnRobloxSubscriptionUpsellSuccessCallbackToUnifiedPurchaseModal and data.purchaseCallbacks then
		onRobloxSubscriptionUpsellSuccess = data.purchaseCallbacks.onRobloxSubscriptionUpsellSuccess
	end

	v.onRobloxSubscriptionUpsellSuccess = onRobloxSubscriptionUpsellSuccess
	return v
end, function(callback)
	return {
		purchaseItem = function()
			return callback(purchaseItem())
		end,
		fetchCartPricing = function(p)
			return callback(fetchCartPricing(p))
		end,
		fetchInGameItemCartPricing = function(p)
			return callback(fetchInGameItemCartPricing(p))
		end,
		promptRobuxPurchase = function()
			return callback(launchRobuxUpsell())
		end,
		openRobuxStore = function()
			return callback(openRobuxStore())
		end,
		openSecuritySettings = function()
			return callback(openSecuritySettings())
		end,
		openTermsOfUse = function(p)
			return callback(openTermsOfUse(p))
		end,
		dispatchFetchPurchaseWarning = function()
			return callback(initiateUserPurchaseSettingsPrecheck())
		end,
		completeRequest = function()
			GuiService.SelectedCoreObject = nil
			return callback(completeRequest())
		end,
		retryPurchaseAfterUpsell = function()
			return callback(retryPurchaseAfterUpsell())
		end,
		setPromptState = function(p)
			return callback(SetPromptState(p))
		end,
		setWindowState = function(p)
			return callback(SetWindowState(p))
		end,
		onUpsellSuggestionsSelected = function(p, p2: number, p3: string, p4: string?)
			return callback(PromptNativeUpsellSuggestions(p, p2, p3, p4))
		end,
		onAnalyticEvent = function(p, p2)
			return callback(sendEvent(p, p2))
		end,
		setPostPurchaseActions = function(p)
			callback(SetPostPurchaseActions(p))
		end
	}
end)(function(p)
	local navigation = Navigation.useNavigation()

	return Roact.createElement(extended, Cryo.Dictionary.join(p, { navigation = navigation }))
end))
