local CorePackages = game:GetService("CorePackages")

local tutils = require(CorePackages.Packages.tutils)
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local skeleton = Foundation.Skeleton
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local Cryo = require(CorePackages.Packages.Cryo)
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local module = require("@luauforge/bundled/eie")
local getSafeAreaSize = require("@luauforge/bundled/fCf").getSafeAreaSize
local module2 = require("@luauforge/bundled/gxM")
local module3 = require("@luauforge/bundled/egx")
local roactAnalytics = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").RoactAnalytics

local memoize = require("@game/CorePackages/Workspace/Packages/AppCommonLib").memoize
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local t = require(CorePackages.Packages.t)

local module4 = require("@luauforge/bundled/dzE")

local peekViewState = require("@luauforge/bundled/dCI").PeekViewState
local withStyle = UIBlox.Style.withStyle

local module5 = require("@luauforge/bundled/ehL")
require(CorePackages.Packages.ReactFocusNavigation)
local focusNavigationEventNameEnum = module5.FocusNavigationEventNameEnum

local module6 = require("@luauforge/bundled/dFm")
local formFactor = require("@luauforge/bundled/dGN").Enums.FormFactor
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/AppCommonLib").IsVRAppBuild
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local module7 = require("@luauforge/bundled/dXA")
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local module8 = require("@luauforge/deferred/gOU")
require("@luauforge/bundled/dKT")
local module9 = require("@luauforge/deferred/gJK")
local module10 = require("@luauforge/bundled/dPN")
local fFlagEnableSplitPane = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableSplitPane
local v5 = if fFlagEnableSplitPane then require("@luauforge/bundled/fCo") else nil
local module11 = require("@luauforge/bundled/fCe")
local module12 = require("@luauforge/deferred/gOV")

local module13 = require("@luauforge/deferred/gQz")
local module14 = require("@luauforge/deferred/gQD")
local module15 = require("@luauforge/deferred/gQE")
local module16 = require("@luauforge/deferred/gQG")
local module17 = require("@luauforge/bundled/dXh")
local AvatarExperienceCatalog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
local setSelectedTimedOption = AvatarExperienceCatalog.State.Actions.SetSelectedTimedOption

local useShouldFetchCartPricingForPurchasePrompt = AvatarExperienceCatalog.Hooks.useShouldFetchCartPricingForPurchasePrompt
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local avatarRoute = AvatarExperienceNavigation.AvatarRoute.AvatarRoute
local module20 = require("@luauforge/deferred/gJH")
local module21 = require("@luauforge/deferred/gLe")
local module22 = require("@luauforge/bundled/gJS")
local module23 = require("@luauforge/deferred/gQH")
local module24 = require("@luauforge/bundled/fCE")
local module25 = require("@luauforge/bundled/fDz")
local module26 = require("@luauforge/bundled/fCF")
local itemData = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").State.Selectors.ItemData
local module27 = require("@luauforge/bundled/dQQ")
local module28 = require("@luauforge/bundled/dKU")
local setItemDetailsPeekViewState = module28.Actions.SetItemDetailsPeekViewState
local setItemTryOnPeekViewState = module28.Actions.SetItemTryOnPeekViewState
local module29 = require("@luauforge/deferred/gQI")
local module30 = require("@luauforge/deferred/gQJ")
local module31 = require("@luauforge/deferred/gQL")
local module32 = require("@luauforge/deferred/gQM")
local module33 = require("@luauforge/deferred/fCu")
local module34 = require("@luauforge/deferred/gQN")
local module35 = require("@luauforge/deferred/gQQ")
local useTableWrappedCallbackRef = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.useTableWrappedCallbackRef

local getTryOnItemReducerKey = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Utils.getTryOnItemReducerKey

local module36 = require("@luauforge/deferred/gQR")
local module37 = require("@luauforge/deferred/gQS")
local module38 = require("@luauforge/deferred/gQU")
local module39 = require("@luauforge/deferred/gQT")

local module40 = require("@luauforge/bundled/fDf")
local module41 = require("@luauforge/bundled/dVl")
local module42 = require("@luauforge/deferred/gQV")
local module43 = require("@luauforge/bundled/dPU")
local module44 = require("@luauforge/deferred/gRf")
local module45 = require("@luauforge/bundled/fCd")
local module46 = require("@luauforge/deferred/gPx")
local module47 = require("@luauforge/deferred/gPw")
local module48 = require("@luauforge/deferred/gRg")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local module51 = require("@luauforge/deferred/gRh")
local module52 = require("@luauforge/bundled/dVo")

local module53 = require("@luauforge/deferred/gRk")

local module54 = require("@luauforge/deferred/gPP")
local module55 = require("@luauforge/bundled/dPP")
local fFlagAXEnableHomeTryOnComplexView = SharedFlags.FFlagAXEnableHomeTryOnComplexView
local defineFastFlag = game:DefineFastFlag("AXExternalItemDetailsOverlay", false)

local defineFastFlag2 = game:DefineFastFlag("AXItemDetailsShouldNotHaveQuickMenuButton", false)
local defineFastFlag3 = game:DefineFastFlag("AXPeekViewContentShouldNotBeSelectable", false)
local defineFastFlag4 = game:DefineFastFlag("AXItemDetailsSduiScrollSuppression", false)
local fFlagAXDurablesForMIS = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXDurablesForMIS

local fFlagAXDurablesSupportWithPostPurchaseFix = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXDurablesSupportWithPostPurchaseFix

local fFlagAXFixHomeAvatarsUnifiedPurchase = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXFixHomeAvatarsUnifiedPurchase
local fFlagAXDurables2Option = AvatarExperienceFlags.FFlagAXDurables2Option
local fFlagAXBackgroundsEquipTryOnCounters = AvatarExperienceFlags.FFlagAXBackgroundsEquipTryOnCounters
local fFlagAXItemDetailsPartialAssetInfoFix = AvatarExperienceFlags.FFlagAXItemDetailsPartialAssetInfoFix
local fFlagAXItemDetailsSdui = AvatarExperienceFlags.FFlagAXItemDetailsSdui
local fFlagAXItemDetailsSduiActions = AvatarExperienceFlags.FFlagAXItemDetailsSduiActions
local fFlagAXItemDetailsSduiFillView = AvatarExperienceFlags.FFlagAXItemDetailsSduiFillView
local fFlagAXItemDetailsSduiBodyActions = AvatarExperienceFlags.FFlagAXItemDetailsSduiBodyActions
local fFlagAXItemDetailsSduiImpressionsAndExposure = AvatarExperienceFlags.FFlagAXItemDetailsSduiImpressionsAndExposure
local fFlagAXItemDetailsSduiTryOnSimpleView = AvatarExperienceFlags.FFlagAXItemDetailsSduiTryOnSimpleView
local fFlagAXItemDetailsDescriptionLinks = AvatarExperienceFlags.FFlagAXItemDetailsDescriptionLinks
local module56 = require("@luauforge/deferred/gOW")
local itemDetailsSduiEntryPoint = module56.ItemDetailsSduiEntryPoint

local module57 = require("@luauforge/deferred/gRl")

local module58 = require("@luauforge/deferred/gRu")
local getItemDetailsEntryContext = module56.getItemDetailsEntryContext
local fFlagEnableMarketplacePurchaseDeepLinkAttribution = SharedFlags.FFlagEnableMarketplacePurchaseDeepLinkAttribution
local fFlagAppIaHomeShowCampaignTab = SharedFlags.FFlagAppIaHomeShowCampaignTab
local campaignEligibility = require("@luauforge/bundled/fJt").CampaignEligibility

local robloxSubscriptionSignals = require("@luauforge/bundled/fHh").RobloxSubscriptionSignals

local reportBackgroundUserActionCounter = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").reportBackgroundUserActionCounter

local v6 = {
	toastMessage = "Feature.Avatar.Message.InvalidItem",
	isLocalized = false,
	toastType = module4.InformationMessage
}

local function fn(p2)
	return p2.AvatarExperience.Common.ItemDetailsExpanded
end

local function fn2(p2): boolean
	return p2.FormFactor == formFactor.WIDE
end

local extended = Roact.PureComponent:extend("ItemDetails")

local strictInterface = t.strictInterface
local v7 = {}
v7.itemId = t.string
v7.itemType = t.string
v7.itemSubType = t.optional(t.string)
v7.isFirstItemDetails = t.optional(t.boolean)
v7.fromContentFeed = t.optional(t.boolean)
v7.fromProfile = t.optional(t.boolean)
local v8 = if fFlagAXItemDetailsSduiBodyActions then t.optional(t.boolean) else nil
v7.isInAvatarExperience = v8
v7.showDropDownTopBar = t.optional(t.boolean)
v7.showRobuxBalance = t.optional(t.boolean)
v7.simpleView = t.optional(t.boolean)
v7.hideTab = t.optional(t.boolean)
v7.shouldNavigateDown = t.optional(t.boolean)
v7.fromSurface = t.optional(t.number)
local v9 = if fFlagAXFixHomeAvatarsUnifiedPurchase then t.optional(t.table) else nil
v7.avatarUnifiedAttribution = v9
v7.itemSubTypeName = t.optional(t.string)
v7.mountAsFullView = t.optional(t.boolean)
v7.assetType = t.optional(t.string)
v7.mountAnimation = t.optional(t.boolean)

local v10 = if fFlagEnableMarketplacePurchaseDeepLinkAttribution then t.optional(t.string) else nil
v7.deepLinkId = v10
v7.itemDetailsPeekViewRefs = t.optional(t.table)
v7.resultsListRef = t.optional(t.table)
v7.detail = t.optional(t.string)
v7.prevNavPage = t.optional(t.string)
v7.prevNavHistory = t.optional(t.table)
v7.showFullWithNoPeekView = t.optional(t.boolean)
v7.widgetInfo = t.optional(t.table)
v7.onItemDetailsClosed = t.optional(t.callback)
v7.itemDetailsExpanded = t.boolean
v7.actionBarContainerRef = t.table
v7.contentFrameRef = t.table
local v11 = if fFlagAXItemDetailsSduiBodyActions then t.table else nil
v7.sduiAttributionPlayRef = v11

v7.navigation = t.table
v7.avatarRoute = avatarRoute.Interface

v7.isSceneFullView = t.boolean
v7.itemData = t.optional(module21)
local v12 = if fFlagAXItemDetailsSdui then t.string else nil
v7.fetchingState = v12
v7.peekViewShowing = t.boolean
v7.topBarHeight = t.number
v7.playerMembership = t.optional(t.enum(Enum.MembershipType))
v7.lastInputGroup = t.string
v7.itemDetailsTryOnViewState = t.any
v7.itemDetailsViewState = t.any
v7.screenSize = t.Vector2
v7.globalGuiInset = t.table
v7.wideMode = t.boolean
local v13 = if fFlagAXDurablesForMIS then t.number else nil
v7.numberOfTryOnItems = v13
local v14 = if fFlagAXDurablesForMIS then t.boolean else nil
v7.isCurrentItemInTryOns = v14
local v15 = if fFlagAXDurablesForMIS then t.boolean else nil
v7.isAvatarEditorOpaqueRoute = v15

v7.closeAllPeekViews = t.callback
v7.closeFiltersAndItemDetails = t.callback
v7.closeFocusedScreen = t.callback
v7.setItemDetailsExpanded = t.callback
v7.setCurrentToastMessage = t.callback
v7.openItemPrompt = t.callback
v7.redeemQRCodeItemPrompt = t.callback
v7.setItemDetailsPeekViewState = t.callback
v7.setItemTryOnPeekViewState = t.callback
v7.isPortrait = t.optional(t.boolean)
local v16 = if fFlagAXDurablesForMIS then t.callback else nil
v7.setSelectedTimedOption = v16
local v17 = if fFlagAXDurablesForMIS then t.callback else nil
v7.toggleTryOnThunk = v17
local v18 = if fFlagAXDurablesForMIS or fFlagAXItemDetailsSduiBodyActions then t.callback else nil
v7.closeMatchingScreens = v18
local v19 = if fFlagAXItemDetailsSduiBodyActions then t.callback else nil
v7.toggleItemTryOn = v19
local v20 = if fFlagAXItemDetailsSdui then t.callback else nil
v7.fetchAssetOrBundleInfo = v20
local v21 = if fFlagAXItemDetailsSduiActions then t.callback else nil
v7.maybePromptForR15Upgrade = v21
local v22 = if fFlagAXItemDetailsSduiActions then t.callback else nil
v7.sendDetailedCatalogAnalytics = v22

v7.networking = t.callback
v7.analytics = t.table
local v23 = if fFlagAXItemDetailsSdui then t.table else nil
v7.appAnalytics = v23

v7.peekViewFullViewEnabled = t.boolean
v7.showPremiumContent = t.boolean

v7.overlayClosedCallback = t.callback
local v24 = if fFlagAXDurablesForMIS then t.table else nil
v7.localization = v24
v7.deviceSafePadding = t.table
local v25 = if fFlagAppIaHomeShowCampaignTab then t.optional(t.boolean) else nil
v7.shouldShowNewPlusBanner = v25
local v26 = if fFlagAppIaHomeShowCampaignTab then t.optional(t.table) else nil
v7.newPlusBannerLocalizations = v26
extended.validateProps = strictInterface(v7)

function extended:init()
	self.actionBarHeaderRef = Roact.createRef()
	self.backButtonRef = Roact.createRef()

	if fFlagAXItemDetailsSdui then
		self.sduiScrollingFrameRef = Roact.createRef()
	end

	local v27 = module54() and { scrollingEnabled = true } or nil

	if self.props.itemData and self.props.itemData.timedOptions then
		for k, timedOption in self.props.itemData.timedOptions do
			if timedOption.selected then
				local days = timedOption.days

				if days == 0 then
					days = nil
				end

				v27.selectedTimedOptionDays = days
				break
			end
		end
	end

	self.state = v27

	if self.props.showRobuxBalance then
		self.robuxBalanceRef = Roact.createRef()
	end

	self.timedOptionDeeplinkUpdated = false
	function self.onTimedOptionSelected(p2)
		local v28 = self.props.itemData.timedOptions[p2] and self.props.itemData.timedOptions[p2].days or 0

		if v28 == 0 then
			v28 = Roact.None
		end

		self:setState({ selectedTimedOptionDays = v28 })

		if fFlagAXDurablesForMIS then
			self.timedOptionDeeplinkUpdated = true
		end
	end

	if fFlagAppIaHomeShowCampaignTab then
		function self.onNewPlusBannerHeightChanged(p2)
			if (self.state == nil and 0 or self.state.newPlusBannerHeight or 0) ~= p2 then
				self:setState({ newPlusBannerHeight = p2 })
			end
		end
	end

	if fFlagAXDurablesForMIS then
		function self.updateTimedOptionSelection()
			local v28 = Cryo.List.findWhere(self.props.itemData.timedOptions, function(p2): boolean
				return p2.days == self.state.selectedTimedOptionDays
			end) or #self.props.itemData.timedOptions

			self.props.setSelectedTimedOption(self.props.itemId, self.props.itemType, v28)

			module17.closeFocusedScreen(self.props.navigation)
		end
	end

	function self.closeBriefView()
		local analytics = self.props.analytics

		local itemId = self.props.itemId
		local itemType = self.props.itemType

		analytics.closeItemDetailPage(itemId, itemType)

		self.props.closeFiltersAndItemDetails(self.props.navigation)
	end

	function self.onItemInvalid()
		if self.isMounted then
			self.closeBriefView()
			self.props.setCurrentToastMessage(v6)
		end
	end

	if fFlagAXItemDetailsSduiActions then
		self.sduiActionHandlers = module37({
			getAttributionPlay = fFlagAXItemDetailsSduiBodyActions and function()
				return self.props.sduiAttributionPlayRef.current
			end or nil,
			tryOn = fFlagAXItemDetailsSduiBodyActions and {
				toggleTryOn = function(p2, p3, p4)
					self.props.toggleItemTryOn(
						self.props.networking,
						self.props.analytics,
						p3,
						p4,
						p2,
						true,
						self.props.avatarRoute,
						self.props.navigation
					)
				end,
				getShownItemSubType = function()
					return module41.GetItemSubType(self.props.itemType, self.props.itemData)
				end,
				closeMatchingScreens = function(p2, p3)
					self.props.closeMatchingScreens(p2, p3)
				end
			} or nil,
			getNavigation = function()
				return self.props.navigation
			end,
			isInAvatarExperience = fFlagAXItemDetailsSduiBodyActions and function(): boolean
				return self.props.isInAvatarExperience ~= false
			end or nil,
			getScreenItem = function()
				local itemData2 = self.props.itemData
				local screenItem = {
					itemId = self.props.itemId,
					itemType = self.props.itemType,
					collectibleItemId = 0
				}
				local v28 = if itemData2 then itemData2.collectibleItemId else nil
				screenItem.collectibleItemId = v28
				return screenItem
			end,
			getScreenSize = function()
				return self.props.screenSize
			end,
			getResultsListRef = function()
				return self.props.resultsListRef
			end,
			maybePromptForR15Upgrade = function(p2, p3, p4, p5, p6, p7)
				return self.props.maybePromptForR15Upgrade(p2, p3, p4, p5, p6, p7)
			end,
			sendRecommendedItemClickAnalytics = function(p2, p3, p4, p5)
				self.props.sendDetailedCatalogAnalytics(
					module43.AnalyticsContext.ItemDetailsRecommendedItem,
					self.props.analytics.clickCatalogItem,
					p2,
					p3,
					p4,
					module10.NumRecommendedItems,
					p5
				)
			end
		})
	end

	if fFlagAXItemDetailsDescriptionLinks then
		self.openDescriptionLinkItem = module39({
			getNavigation = function()
				return self.props.navigation
			end,
			getResultsListRef = function()
				return self.props.resultsListRef
			end
		})
	end

	function self.renderContentCallback(p2, p3)
		return self:renderContent(p2, p3)
	end

	self.getRenderTopBarCallback = memoize(function(p2)
		return function()
			return self:renderTopBar(p2)
		end
	end)

	self.getRenderActionBarCallback = memoize(function(p2, p3, p4, p5, p6)
		return function()
			return self:renderActionBar(p2, p3, p4, p5, p6)
		end
	end)

	function self.setPeekViewState(p2)
		if self:getIsTryOnPage() then
			self.props.setItemTryOnPeekViewState(p2)
		else
			self.props.setItemDetailsPeekViewState(p2)
		end
	end

	function self.closePeekView()
		self.setPeekViewState(peekViewState.Brief)
	end

	if fFlagAXDurablesForMIS then
		function self.getShouldShowSecondaryButton(): boolean
			if
				fFlagAXDurables2Option
				or fFlagAppIaHomeShowCampaignTab and self:getIsTryOnPage()
				or (self.props.fromProfile or self.props.isAvatarEditorOpaqueRoute)
			then
				return false
			end

			if
				self.props.itemData
				and self.props.itemData.timedOptions
				and self.props.numberOfTryOnItems > 1
			then
				return true
			end

			if self.props.isCurrentItemInTryOns then
				return false
			end

			return true
		end

		function self.onTryOnSecondaryButtonActivated()
			local itemSubType = module41.GetItemSubType(self.props.itemType, self.props.itemData)

			local v28 = self.props.itemData
				and self.props.itemData.timedOptions
				and (Cryo.List.findWhere(self.props.itemData.timedOptions, function(p2): boolean
					return p2.days == self.state.selectedTimedOptionDays
				end) or #self.props.itemData.timedOptions)
				or nil

			if fFlagAXBackgroundsEquipTryOnCounters then
				reportBackgroundUserActionCounter.reportIfAvatarBackgroundAsset(
					"TryOn",
					self.props.itemType,
					itemSubType
				)
			end

			self.props.toggleTryOnThunk(
				self.props.networking,
				self.props.analytics,
				self.props.itemType,
				itemSubType,
				self.props.itemId,
				true,
				self.props.avatarRoute,
				self.props.navigation,
				v28
			)

			self.props.closeMatchingScreens(self.props.navigation, {
				avatarScreen.Checkout,
				avatarScreen.ItemDetails
			})
		end
	end

	if module54() then
		function self.setItemDetailsScrollingEnabled(p2)
			self:setState({ scrollingEnabled = p2 })
		end
	end
end

function extended:getBriefViewHeight()
	local v27 = module43.ActionBar.ActionBarHeight + module43.ActionBar.ActionBarGradientHeight

	if fFlagAppIaHomeShowCampaignTab and self:getIsTryOnPage() and self.state ~= nil then
		v27 += self.state.newPlusBannerHeight or 0
	end

	return v27 + 20
end

function extended:renderTopBar(p2)
	local theme = p2.Theme
	local fromProfile = self.props.fromProfile
	local topBarHeight = self.props.topBarHeight

	local name = if self.props.itemData then self.props.itemData.name else nil

	local isTryOnPage = self:getIsTryOnPage()
	local v27

	if isTryOnPage then
		v27 = self.props.itemDetailsTryOnViewState
	else
		v27 = self.props.itemDetailsViewState
	end

	local v28 = fromProfile and 0
		or (self.props.showDropDownTopBar and (v27 == peekViewState.Full or fFlagAXEnableHomeTryOnComplexView and v27 == peekViewState.Extended) or not self.props.isPortrait)
		and 0
		or 1

	local createElement = Roact.createElement
	local v30 = {
		BackgroundTransparency = v28,
		BackgroundColor3 = theme.BackgroundDefault.Color,
		BorderSizePixel = 0,
		Position = 0,
		Size = 0,
		ZIndex = 2,
		Visible = 0
	}

	local v31 = if self.props.isPortrait then UDim2.fromScale(0, 0) else UDim2.new(0, 0, 0, -self.props.deviceSafePadding.top)
	v30.Position = v31

	v30.Size = UDim2.new(
		1,
		(self.props.isPortrait or self.props.fromProfile or isTryOnPage) and 0 or self.props.deviceSafePadding.right,
		0,
		topBarHeight + (self.props.isPortrait and 0 or self.props.deviceSafePadding.top)
	)

	v30.Visible = self.topBarNavVisible

	local v33 = if not self.props.isPortrait then Roact.createElement("UIPadding", {
		PaddingTop = UDim.new(0, self.props.deviceSafePadding.top)
	}) else nil
	local v34

	if isVRAppBuild() then
		v34 = Roact.createElement(module16, {
			topBarHeight = topBarHeight,
			title = name,
			closeFocusedScreen = self.props.closeFocusedScreen,
			navigation = self.props.navigation
		})
	else
		local createElement2 = Roact.createElement
		local backButtonRefsByRef = { [Roact.Ref] = self.backButtonRef }

		local v36 = if not defineFastFlag3 then self.props.contentFrameRef else nil
		backButtonRefsByRef.NextSelectionDown = v36

		backButtonRefsByRef.itemId = self.props.itemId
		backButtonRefsByRef.itemType = self.props.itemType
		backButtonRefsByRef.itemData = self.props.itemData
		backButtonRefsByRef.dropDownTopBar = self.props.showDropDownTopBar
		backButtonRefsByRef.peekViewState = v27
		backButtonRefsByRef.closePeekView = self.closePeekView
		backButtonRefsByRef.showRobuxBalance = self.props.showRobuxBalance
		v34 = createElement2(module15, backButtonRefsByRef)
	end

	return createElement("Frame", v30, { UIPadding = v33, TopBar = v34 })
end

function extended:renderActionBar(p2, props2, p3, p4, selectedTimedOptionDays)
	local itemId = self.props.itemId
	local itemType = self.props.itemType

	local theme = props2.Theme
	local font = props2.Font
	local v27 = font.BaseSize * font.Header1.RelativeSize

	local name = p4 and p4.name

	if fFlagAXDurablesSupportWithPostPurchaseFix then
		selectedTimedOptionDays = self.state.selectedTimedOptionDays
	end

	local createElement = Roact.createElement
	local actionBarContainerRefsByRef = {
		BackgroundTransparency = 1,
		Size = UDim2.new(
			1,
			(self.props.isPortrait or self.props.fromProfile or self:getIsTryOnPage()) and 0 or self.props.deviceSafePadding.right,
			0,
			p3
		),
		Position = UDim2.fromScale(0, 1),
		AnchorPoint = Vector2.new(0, 1),
		ZIndex = 3,
		[Roact.Ref] = self.props.actionBarContainerRef
	}

	local createElement2 = Roact.createElement
	local v30 = {
		itemId = itemId,
		itemType = itemType,
		showTimedOptionInBuyButton = p4 and p4.timedOptions and true or nil,
		hidePrice = p4 and p4.timedOptions and true or nil,
		timedOptions = 0,
		selectedTimedOptionDays = 0,
		setSelectedTimedOptionDays = 0,
		showSecondaryButton = 0,
		secondaryButtonText = 0,
		onSecondaryButtonActivated = 0,
		headerPadding = 24,
		leftPadding = 20,
		bottomPadding = 20,
		rightPadding = 20,
		topPadding = 4,
		ZIndex = 1,
		shouldShowNewPlusBanner = 0,
		newPlusBannerLocalizations = 0,
		onNewPlusBannerHeightChanged = 0
	}
	local v31 = if fFlagAXDurables2Option and p4 then p4.timedOptions else nil
	v30.timedOptions = v31

	if not self.state then
		selectedTimedOptionDays = nil
	end

	v30.selectedTimedOptionDays = selectedTimedOptionDays
	v30.setSelectedTimedOptionDays = self.onTimedOptionSelected

	local v32 = if fFlagAXDurablesForMIS then self:getShouldShowSecondaryButton() else nil
	v30.showSecondaryButton = v32
	local v33

	if fFlagAXDurablesForMIS then
		if self.props.isCurrentItemInTryOns then
			v33 = self.props.localization.updateSecondaryButtonText
		else
			v33 = self.props.localization.tryOnSecondaryButtonText
		end
	end

	v30.secondaryButtonText = v33
	local v34

	if fFlagAXDurablesForMIS then
		if self.props.isCurrentItemInTryOns then
			v34 = self.updateTimedOptionSelection
		else
			v34 = self.onTryOnSecondaryButtonActivated
		end
	end

	v30.onSecondaryButtonActivated = v34

	local v35 = if fFlagAppIaHomeShowCampaignTab and self:getIsTryOnPage() then self.props.shouldShowNewPlusBanner else nil
	v30.shouldShowNewPlusBanner = v35

	local v36 = if fFlagAppIaHomeShowCampaignTab and self:getIsTryOnPage() then self.props.newPlusBannerLocalizations else nil
	v30.newPlusBannerLocalizations = v36

	local v37 = if fFlagAppIaHomeShowCampaignTab and self:getIsTryOnPage() then self.onNewPlusBannerHeightChanged else nil
	v30.onNewPlusBannerHeightChanged = v37
	return createElement("Frame", actionBarContainerRefsByRef, {
		BuyActionBar = createElement2(module42, v30),
		ActionBarHeader = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -48, 0, v27),
			Position = UDim2.new(0, 24, 0, 5),
			ZIndex = 2,
			[Roact.Ref] = self.actionBarHeaderRef
		}, {
			NameLabel = name and Roact.createElement("TextLabel", {
				Position = UDim2.fromOffset(0, 0),
				BackgroundTransparency = 1,
				FontFace = normalizeFontFace(props2.Tokens.Typography.HeadingSmall.Font),
				Size = UDim2.new(1, 0, 0, v27),
				Text = name,
				TextSize = v27,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextColor3 = theme.TextEmphasis.Color,
				TextTruncate = Enum.TextTruncate.AtEnd
			}) or Roact.createElement(skeleton, { Size = UDim2.new(1, 0, 0, v27) })
		})
	})
end

function extended:renderContent(bottomPadding, loadingHeight)
	local itemId = self.props.itemId
	local itemType = self.props.itemType
	local itemSubType = self.props.itemSubType
	local itemDetailsPeekViewRefs = self.props.itemDetailsPeekViewRefs
	local resultsListRef = self.props.resultsListRef
	local peekViewFullViewEnabled = self.props.peekViewFullViewEnabled
	local assetType = self.props.assetType

	if not itemId then
		return nil
	end

	if fFlagAXItemDetailsSdui then
		local v27

		if fFlagAXItemDetailsSduiBodyActions then
			local navigation = self.props.navigation
			local isInAvatarExperience = self.props.isInAvatarExperience ~= false
			local v29 = if fFlagAXItemDetailsSduiTryOnSimpleView then self.props.simpleView == true else nil
			v27 = getItemDetailsEntryContext(navigation, isInAvatarExperience, v29)
		end

		local v28 = fFlagAXItemDetailsSduiFillView and bottomPadding ~= nil
		local createElement = Roact.createElement

		local v31 = if v28 then UDim2.fromScale(1, 1) else UDim2.new(1, 0, 0, 0)
		local v30 = {
			itemId = itemId,
			itemType = itemType,
			entryContext = v27,
			Size = v31,
			AutomaticSize = Enum.AutomaticSize.Y,
			scrollingFrameRef = 0,
			ref = 0,
			actionHandlers = 0,
			actionBarHeaderRef = 0,
			bottomPadding = 0,
			loadingHeight = 0,
			setParentScrollingEnabled = 0
		}
		local v32 = if fFlagAXItemDetailsSdui then self.sduiScrollingFrameRef else nil
		v30.scrollingFrameRef = v32
		local v33 = if self.props.showFullWithNoPeekView then self.props.contentFrameRef else nil
		v30.ref = v33
		local v34 = if fFlagAXItemDetailsSduiActions then self.sduiActionHandlers else nil
		v30.actionHandlers = v34
		v30.actionBarHeaderRef = self.actionBarHeaderRef
		v30.bottomPadding = bottomPadding
		v30.loadingHeight = loadingHeight

		local v35 = if defineFastFlag4 and module54() then self.setItemDetailsScrollingEnabled else nil
		v30.setParentScrollingEnabled = v35
		local element = createElement(itemDetailsSduiEntryPoint, v30)

		if not fFlagAXItemDetailsSduiImpressionsAndExposure then
			return element
		end

		local createElement2 = Roact.createElement
		local v37 = {
			navigation = self.props.navigation,
			simpleView = self.props.simpleView,
			Size = 0
		}
		local v38 = if v28 then UDim2.fromScale(1, 1) else nil
		v37.Size = v38
		return createElement2(module13, v37, { SduiBody = element })
	else
		local createElement = Roact.createElement
		local v28 = {
			actionBarHeaderRef = self.actionBarHeaderRef,
			clipDetails = not peekViewFullViewEnabled,
			itemId = itemId,
			itemType = itemType,
			itemSubType = itemSubType,
			assetType = assetType,
			onItemInvalid = self.onItemInvalid,
			showFullWithNoPeekView = self.props.showFullWithNoPeekView,
			bottomDockedContainerHeight = self:getBriefViewHeight(),
			resultsListRef = resultsListRef,
			itemDetailsPeekViewRefs = itemDetailsPeekViewRefs,
			ref = 0,
			setItemDetailsScrollingEnabled = 0,
			simpleView = 0,
			onWearTimeSelection = 0,
			openDescriptionLinkItem = 0
		}

		local v29 = if self.props.showFullWithNoPeekView then self.props.contentFrameRef else nil
		v28.ref = v29
		local v30 = if module54() then self.setItemDetailsScrollingEnabled else nil
		v28.setItemDetailsScrollingEnabled = v30

		v28.simpleView = self.props.simpleView
		v28.onWearTimeSelection = self.onTimedOptionSelected
		local v31 = if fFlagAXItemDetailsDescriptionLinks then self.openDescriptionLinkItem else nil
		v28.openDescriptionLinkItem = v31
		return createElement(module12, v28)
	end
end

function extended:getIsTryOnPage(): boolean
	return self.props.navigation.state.routeName == avatarScreen.TryOnItem
end

function extended:getItemDetailsComponent(p3)
	if isVRAppBuild() then
		return module31
	end

	if p3 then
		return module30
	end

	if self.props.showFullWithNoPeekView then
		return module31
	end

	return module29
end

function extended:render()
	return withSelectionCursorProvider(function(p2)
		return withStyle(function(p3)
			return self:renderWithProviders(p2, p3)
		end)
	end)
end

function extended:renderWithProviders(p2, p3)
	local isSceneFullView = self.props.isSceneFullView
	local itemId = self.props.itemId
	local key = self.props.navigation.state.key

	local itemDetailsPeekViewRefs = self.props.itemDetailsPeekViewRefs

	local isTryOnPage = self:getIsTryOnPage()
	local wideMode = self.props.wideMode
	local v27

	if isTryOnPage then
		v27 = self.props.itemDetailsTryOnViewState
	else
		v27 = self.props.itemDetailsViewState
	end

	if not itemId then
		return
	end

	local fromProfile = self.props.fromProfile

	local isPortrait = self.props.isPortrait

	local v29 = true

	local v30 = UDim2.fromScale(0, 0)
	local v31 = UDim2.fromScale(1, 1)

	if not isPortrait then
		if fromProfile or isTryOnPage then
			local offset = getSafeAreaSize(self.props.screenSize, self.props.globalGuiInset).X.Offset

			local v32 = math.min(offset, 640)

			if isTryOnPage and v32 < offset then
				v29 = false
			end

			v30 = UDim2.fromOffset((offset - v32) / 2, 0)
			v31 = UDim2.new(0, v32, 1, 0)
		else
			local fromScale = UDim2.fromScale
			local v32 = if fFlagEnableSplitPane then v5.getLandscapeNavWidth() else module10.LandscapeNavWidth
			v30 = fromScale(v32, 0)

			local fromScale2 = UDim2.fromScale

			local v33 = if fFlagEnableSplitPane then v5.getLandscapeSceneWidth() else module10.LandscapeSceneWidth
			v31 = fromScale2(v33, 1)
		end
	end

	local briefViewHeight = self:getBriefViewHeight()

	local v32 = self:getItemDetailsComponent(wideMode and fromProfile and not isTryOnPage)

	if fFlagEnableSplitPane and fromProfile and not isTryOnPage and v5.isSupportPaneLayoutActive() then
		if not isPortrait then
			v30, v31 = v5.getOverlayLayoutOverSupportPane()
		end

		v32 = module31
	end

	local v33

	if fFlagAXItemDetailsSdui and fFlagAXItemDetailsSduiFillView and v32 == module29 then
		v33 = getSafeAreaSize(self.props.screenSize, self.props.globalGuiInset).Y.Offset - briefViewHeight
	end

	local createElement = Roact.createElement
	local v35 = {
		["BackgroundTransparency"] = nil,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		Visible = not isSceneFullView
	}

	local ref = Roact.Ref
	local v36 = if itemDetailsPeekViewRefs then itemDetailsPeekViewRefs[key] or nil else nil
	v35[ref] = v36

	local v37 = if not module53() then Roact.createElement(module48, {
		ixpTest = module51.ItemDetailsPage
	}) else nil

	local v38 = if module55.isEnabled() then Roact.createElement(module48, {
		ixpTest = module55
	}) else nil
	local children = {
		ItemDetailsExposure = v37,
		ItemDetails3DPreviewExposure = v38,
		NavigationEventsLogger = Roact.createElement(module9, {
			pageName = "ItemDetails:" .. key
		}),
		ItemDetailsContent = 0
	}

	local createElement2 = Roact.createElement
	local getRenderActionBarCallback = self.getRenderActionBarCallback

	local itemData2 = self.props.itemData
	local v40 = if self.state then self.state.selectedTimedOptionDays else nil
	local v39 = {}
	v39.renderBottomBar = getRenderActionBarCallback(p2, p3, briefViewHeight, itemData2, v40)

	v39.renderContent = self.renderContentCallback
	v39.renderTopBar = self.getRenderTopBarCallback(p3)
	v39.isTryOnPage = isTryOnPage
	v39.peekViewState = v27
	v39.setPeekViewState = self.setPeekViewState
	v39.actionBarContainerRef = self.props.actionBarContainerRef
	v39.contentFrameRef = self.props.contentFrameRef
	v39.closeBriefView = self.closeBriefView
	v39.viewPosition = v30
	v39.viewSize = v31
	v39.briefViewHeight = briefViewHeight

	if not fFlagAXItemDetailsSdui or v32 == module29 then
		briefViewHeight = nil
	end

	v39.bottomPadding = briefViewHeight

	v39.loadingHeight = v33
	v39.showDropShadow = v29

	v39.analytics = self.props.analytics
	v39.avatarRoute = self.props.avatarRoute
	v39.closeAllPeekViews = self.props.closeAllPeekViews
	v39.closeFocusedScreen = self.props.closeFocusedScreen
	v39.fromProfile = self.props.fromProfile
	v39.itemDetailsExpanded = self.props.itemDetailsExpanded
	v39.itemId = self.props.itemId
	v39.itemType = self.props.itemType
	v39.lastInputGroup = self.props.lastInputGroup
	v39.mountAnimation = self.props.mountAnimation
	v39.mountAsFullView = self.props.mountAsFullView
	v39.navigation = self.props.navigation
	v39.peekViewFullViewEnabled = self.props.peekViewFullViewEnabled
	v39.peekViewShowing = self.props.peekViewShowing
	v39.setItemDetailsExpanded = self.props.setItemDetailsExpanded
	v39.topBarHeight = self.props.topBarHeight
	local v41 = if module54() then self.state.scrollingEnabled else nil
	v39.scrollingEnabled = v41

	local v42 = if fFlagAXItemDetailsSdui then self.sduiScrollingFrameRef else nil
	v39.scrollingFrameRef = v42
	children.ItemDetailsContent = createElement2(v32, v39)
	return createElement("Frame", v35, children)
end

function extended:fetchAssetOrBundleInfoIfNeeded()
	local itemId = self.props.itemId
	local itemType = self.props.itemType

	if itemId and itemType then
		self.props.fetchAssetOrBundleInfo(
			self.props.networking,
			self.props.appAnalytics,
			tostring(itemId),
			itemType
		)
	end
end

function extended:reportItemInvalidIfNeeded()
	local itemDetailsKey = module41.GetItemDetailsKey(self.props.itemId, self.props.itemType)

	if not module14(
		self.props.fetchingState,
		self.props.itemData,
		itemDetailsKey,
		self.reportedInvalidItemKey
	) then
		return
	end

	self.reportedInvalidItemKey = itemDetailsKey
	self.onItemInvalid()
end

function extended:didUpdate(data, p2)
	if
		fFlagAXItemDetailsSdui
		and (data.itemId ~= self.props.itemId or data.itemType ~= self.props.itemType)
	then
		self:fetchAssetOrBundleInfoIfNeeded()
	end

	if fFlagAXItemDetailsSdui then
		self:reportItemInvalidIfNeeded()
	end

	if not self.timedOptionDeeplinkUpdated and self.props.itemData and self.props.itemData.timedOptions then
		for k, timedOption in self.props.itemData.timedOptions do
			if timedOption.selected then
				local v28 = timedOption.days == 0

				self.onTimedOptionSelected(k)

				if not fFlagAXDurablesForMIS then
					self.timedOptionDeeplinkUpdated = true
				end

				break
			end
		end
	end

	if
		fFlagAXDurablesSupportWithPostPurchaseFix
		and self.props.itemData
		and self.props.itemData.timedOptions
		and self.props.itemData.isOwned
		and not (data.itemData and data.itemData.isOwned)
	then
		for k, timedOption in self.props.itemData.timedOptions do
			if timedOption.selected then
				self.onTimedOptionSelected(k)
				return
			end
		end
	end
end

function extended:didMount()
	if fFlagAXItemDetailsSdui then
		self:fetchAssetOrBundleInfoIfNeeded()
	end

	if self.props.redeemQRCodeItem and module52 then
		self.props.redeemQRCodeItemPrompt(
			self.props.networking,
			self.props.analytics,
			self.props.itemId,
			self.props.itemType
		)
	end

	if self.props.showFullWithNoPeekView then
		self.setPeekViewState(peekViewState.Full)
	end

	self.isMounted = true
end

function extended:willUnmount()
	self.isMounted = false

	local v27 = self.props.avatarRoute.current.name == avatarScreen.ItemDetails
	local v28 = self.props.navigation.state.routeName == avatarScreen.ItemDetails

	if module17.isFirstItemDetailsPage(self.props.navigation) and not (v27 and v28) then
		self.props.setItemDetailsPeekViewState(peekViewState.Closed)

		if self.props.onItemDetailsClosed ~= nil then
			self.props.onItemDetailsClosed()
		end
	end
end

local function mapStateToProps(data, data2)
	local itemId = data2.itemId
	local itemType = data2.itemType
	local v27 = itemData(data.AvatarExperience.Common, itemId, itemType)
	local tryOnItems

	if fFlagAXDurablesForMIS then
		tryOnItems = data.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
	end

	local v28

	if fFlagAXDurablesForMIS then
		v28 = tryOnItems and tryOnItems[getTryOnItemReducerKey(itemId, itemType)] ~= nil
	end

	local key = data2.navigation.state.key

	local avatarRoute2 = data2.avatarRoute
	local key2 = avatarRoute2.current.key
	local v29 = data2.navigation.state.routeName == avatarScreen.TryOnItem

	local v30 = fFlagAXDurablesForMIS
		and data2.avatarRoute.opaque
		and data2.avatarRoute.opaque.name == avatarScreen.AvatarEditor

	if (v29 or fFlagAXItemDetailsPartialAssetInfoFix) and v27 ~= nil and v27.name == nil then
		v27 = nil
	end

	local v31 = {
		isSceneFullView = module11.getIsSceneFullViewFromState(data, avatarRoute2),
		itemData = 0,
		fetchingState = 0,
		wideMode = 0,
		peekViewShowing = 0,
		topBarHeight = 0,
		itemDetailsExpanded = 0,
		playerMembership = 0,
		itemDetailsTryOnViewState = 0,
		itemDetailsViewState = 0,
		screenSize = 0,
		globalGuiInset = 0,
		isPortrait = 0,
		numberOfTryOnItems = 0,
		isCurrentItemInTryOns = 0,
		isAvatarEditorOpaqueRoute = 0
	}

	if (v29 or fFlagAXItemDetailsPartialAssetInfoFix) and v27 ~= nil and v27.name == nil then
		v27 = nil
	end

	v31.itemData = v27

	local v32 = if fFlagAXItemDetailsSdui then performFetch.GetStatus(
		data,
		module41.GetItemDetailsKey(itemId, itemType)
	) else nil
	v31.fetchingState = v32

	v31.wideMode = data.FormFactor == formFactor.WIDE
	v31.peekViewShowing = key2 == key
	v31.topBarHeight = module11.getTopBarHeightAvatarScene(data)
	v31.itemDetailsExpanded = data.AvatarExperience.Common.ItemDetailsExpanded
	v31.playerMembership = data.Users[data.LocalUserId] and data.Users[data.LocalUserId].membership
		or Enum.MembershipType.None

	v31.itemDetailsTryOnViewState = data.AvatarExperience.Common.ItemDetailsPeekView.tryOnViewState
	v31.itemDetailsViewState = data.AvatarExperience.Common.ItemDetailsPeekView.viewState
	v31.screenSize = data.ScreenSize
	v31.globalGuiInset = data.GlobalGuiInset
	v31.isPortrait = module22(data)
	local v33 = if fFlagAXDurablesForMIS then tutils.fieldCount(tryOnItems) else nil
	v31.numberOfTryOnItems = v33

	if not fFlagAXDurablesForMIS then
		v28 = nil
	end

	v31.isCurrentItemInTryOns = v28

	if not fFlagAXDurablesForMIS then
		v30 = nil
	end

	v31.isAvatarEditorOpaqueRoute = v30
	return v31
end

local function mapDispatchToProps(callback)
	return {
		closeAllPeekViews = function(p2)
			callback(module23(p2))
		end,
		closeFiltersAndItemDetails = function(p2)
			callback(module24(p2))
		end,
		closeFocusedScreen = function(p2)
			callback(module8(p2))
		end,
		setItemDetailsExpanded = function(p2)
			callback(module27(p2))
		end,
		setCurrentToastMessage = function(p2)
			callback(module6(p2))
		end,
		openItemPrompt = function(p2, p3, p4, p5, p6)
			callback(module33(p2, p3, p4, p5, p6))
		end,
		redeemQRCodeItemPrompt = function(p2, p3, p4, p5)
			callback(module44(p2, p3, p4, p5))
		end,
		fetchAssetOrBundleInfo = fFlagAXItemDetailsSdui and function(p2, p3, p4, p5)
			return callback(module45(p2, p3, p4, p5))
		end or nil,
		maybePromptForR15Upgrade = fFlagAXItemDetailsSduiActions and function(p2, p3, p4, p5, p6, p7)
			return callback(module46(p2, p3, p4, p5, p6, false, p7))
		end or nil,
		sendDetailedCatalogAnalytics = fFlagAXItemDetailsSduiActions and function(p2, p3, p4, p5, p6, p7, p8)
			callback(module47(p2, p3, p4, p5, p6, p7, p8))
		end or nil,
		setItemDetailsPeekViewState = function(p2)
			callback(setItemDetailsPeekViewState(p2))
		end,
		setItemTryOnPeekViewState = function(p2)
			callback(setItemTryOnPeekViewState(p2))
		end,
		setSelectedTimedOption = fFlagAXDurablesForMIS and function(p2, p3, p4)
			callback(setSelectedTimedOption({
				itemId = p2,
				itemType = p3,
				selectedTimedOptionIndex = p4
			}))
		end or nil,
		closeMatchingScreens = (fFlagAXDurablesForMIS or fFlagAXItemDetailsSduiBodyActions) and function(p2, p3)
			callback(module26(p2, p3))
		end or nil,
		toggleItemTryOn = fFlagAXItemDetailsSduiBodyActions and function(p2, p3, p4, p5, p6, p7, p8, p9)
			callback(module25(p2, p3, p4, p5, p6, p7, p8, p9))
		end or nil,
		toggleTryOnThunk = fFlagAXDurablesForMIS and function(p2, p3, p4, p5, p6, p7, p8, p9, p10)
			callback(module25(p2, p3, p4, p5, p6, p7, p8, p9, nil, false, false, p10))
		end or nil
	}
end

local v27 = module32(extended)

local v28 = module20((RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v27)))

local v29 = roactAppPolicy.connect(function(p2, p3)
	return {
		peekViewFullViewEnabled = p2.getItemDetailsFullView(),
		showPremiumContent = p2.getShowCatalogPremiumContent()
	}
end)(v28)

local function ItemDetailsPageContainer(p2)
	local v30 = useSelector(fn)
	local v31 = useSelector(fn2)
	local fromProfile = p2.navigation.state.params.fromProfile
	local v32 = p2.navigation.state.routeName == avatarScreen.TryOnItem
	local v33

	if fFlagEnableSplitPane and fromProfile and not v32 and v5.isSupportPaneLayoutActive() then
		v33 = false
	else
		v33 = v31 and fromProfile and not v32
	end

	local showFullWithNoPeekView = p2.navigation.state.params.showFullWithNoPeekView
	local itemId = p2.navigation.state.params.itemId
	local itemType = p2.navigation.state.params.itemType

	local v34 = module(module3)
	local v35 = module(module40)
	local v36 = if fFlagAXItemDetailsSdui then module(roactAnalytics) else nil
	local v37 = if fFlagAXItemDetailsSduiBodyActions then module38() else nil
	local v38 = useDispatch()
	local v39

	if fFlagAXDurablesForMIS then
		v39 = module2({
			updateSecondaryButtonText = "Feature.Avatar.Action.Update",
			tryOnSecondaryButtonText = "Feature.Avatar.Action.TryOn"
		})
	end

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)

	local v40 = module35()
	local v41 = module34({ overlayClosedCallback = v40 })

	local v43 = useSelector((React.useCallback(function(p3)
		return itemData(p3.AvatarExperience.Common, itemId, itemType)
	end, { itemId, itemType })))
	local v44 = useShouldFetchCartPricingForPurchasePrompt(v43)

	local ref3 = if fFlagAXItemDetailsSduiBodyActions then React.useRef(nil) else nil
	local v45

	if fFlagAXItemDetailsSdui and fFlagAXItemDetailsSduiBodyActions then
		v45 = module58(itemId, itemType)
	end

	local v46 = React.useMemo(function()
		local v47 = {
			[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
			[Enum.KeyCode.ButtonX] = focusNavigationEventNameEnum.OpenItemDetailsPrompt
		}
		local buttonY = Enum.KeyCode.ButtonY
		local v48 = if v30 then focusNavigationEventNameEnum.CloseItemDetailsPeekView else focusNavigationEventNameEnum.OpenItemDetailsPeekView
		v47[buttonY] = v48

		v47[Enum.KeyCode.ButtonL3] = focusNavigationEventNameEnum.OpenCatalogContextMenu
		v47[Enum.KeyCode.ButtonL2] = focusNavigationEventNameEnum.MoveToItemDetails
		return v47
	end, { v30 })

	local v47 = React.useCallback(function(p3)
		if v32 then
			v38(setItemTryOnPeekViewState(p3))
		else
			v38(setItemDetailsPeekViewState(p3))
		end
	end, { v38, v32 })

	local v48 = React.useCallback(function()
		module17.closeFocusedScreen(p2.navigation)
	end, { p2.navigation })

	local v49 = React.useCallback(function()
		v38(module33(v34, v35, v40, p2.navigation, p2.avatarRoute, nil, nil, false, nil, nil, nil, v44))
	end, { v38, v34, v35, v40, p2.navigation, p2.avatarRoute, v44 })

	local v50 = React.useCallback(function()
		v47(peekViewState.Full)
	end, { v47 })

	local v51 = React.useCallback(function()
		v47(peekViewState.Brief)
	end, { v47 })

	local v52 = React.useCallback(function()
		local v53 = fromProfile or v32

		if fFlagEnableSplitPane and fromProfile and not v32 and v5.isSupportPaneLayoutActive() then
			v53 = false
		end

		p2.navigation.navigate(avatarScreen.CatalogContextMenu, {
			itemId = itemId,
			itemType = itemType,
			onOverlayClosed = v40,
			centered = v53
		})
	end, { p2.navigation, itemId, itemType, v40, fromProfile, v32 })

	if v33 or showFullWithNoPeekView or v30 then
		v50 = nil
	end

	if v33 or showFullWithNoPeekView or not v30 then
		v51 = nil
	end

	if showFullWithNoPeekView then
		v52 = nil
	end

	local v53 = {
		onGoBack = v48,
		onOpenItemPrompt = v49,
		onOpenPeekView = v50,
		onClosePeekView = v51,
		onOpenCatalogContextMenu = v52
	}

	local v55 = useTableWrappedCallbackRef((module36(ref2, v46, v53)))

	local v57 = useTableWrappedCallbackRef((module36(ref, v46, v53)))

	local v58 = useSignalState(module7.GetDisplayStore().getDeviceSafePadding)
	local v59

	if fFlagAppIaHomeShowCampaignTab then
		v59 = useSignalState(campaignEligibility.getIsEligible)
	end

	local v60

	if fFlagAppIaHomeShowCampaignTab then
		v60 = useSignalState(campaignEligibility.getCampaignLocalizations)
	end

	local v61

	if fFlagAppIaHomeShowCampaignTab then
		v61 = useSignalState(robloxSubscriptionSignals.get().getHasRobloxSubscription)
	end

	local v62 = if fFlagAppIaHomeShowCampaignTab then v59 == true and v60 ~= nil and not v61 else nil
	local join = Cryo.Dictionary.join
	local v63 = {
		actionBarContainerRef = v57,
		contentFrameRef = v55,
		overlayClosedCallback = v40,
		networking = v34,
		analytics = v35,
		appAnalytics = v36,
		itemDetailsExpanded = v30,
		localization = nil,
		deviceSafePadding = nil,
		shouldShowNewPlusBanner = nil,
		newPlusBannerLocalizations = nil,
		sduiAttributionPlayRef = nil,
		isInAvatarExperience = nil
	}

	if not fFlagAXDurablesForMIS then
		v39 = nil
	end

	v63.localization = v39
	v63.deviceSafePadding = v58

	if not fFlagAppIaHomeShowCampaignTab then
		v62 = nil
	end

	v63.shouldShowNewPlusBanner = v62

	if not fFlagAppIaHomeShowCampaignTab then
		v60 = nil
	end

	v63.newPlusBannerLocalizations = v60
	v63.sduiAttributionPlayRef = if fFlagAXItemDetailsSduiBodyActions then ref3 else nil

	if not fFlagAXItemDetailsSduiBodyActions then
		v37 = nil
	end

	v63.isInAvatarExperience = v37
	local v65 = join(p2, v63)

	local v66 = useNavigation()
	local v67 = useAvatarRoute()
	local v68 = v66.state.rnKey == v67.current.key or defineFastFlag and v66.state.key == v67.current.key

	local createElement = Roact.createElement
	local ref4 = Roact.Ref

	if defineFastFlag2 then
		v41 = nil
	end

	local v70 = {
		[ref4] = v41,
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		SelectionGroup = true,
		Visible = v68
	}

	local v71 = { ItemDetails = React.createElement(v29, v65), SduiAttributionPlay = 0 }

	local v72 = if fFlagAXItemDetailsSdui and fFlagAXItemDetailsSduiBodyActions and v45 then React.createElement(module57, {
		universeId = v45,
		itemId = itemId,
		itemType = itemType,
		itemSubType = module41.GetItemSubType(itemType, v43),
		attributionPlayRef = ref3
	}) else nil
	v71.SduiAttributionPlay = v72
	return createElement("Frame", v70, v71)
end

return ItemDetailsPageContainer
