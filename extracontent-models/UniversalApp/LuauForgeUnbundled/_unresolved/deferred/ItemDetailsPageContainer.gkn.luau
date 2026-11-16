local CorePackages = game:GetService("CorePackages")

local tutils = require(CorePackages.Packages.tutils)
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local skeleton = Foundation.Skeleton
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local Cryo = require(CorePackages.Packages.Cryo)
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local module = require("@luauforge/bundled/eeH")
local getSafeAreaSize = require("@luauforge/bundled/fuE").getSafeAreaSize
local module2 = require("@luauforge/bundled/fTi")
local module3 = require("@luauforge/bundled/eda")
local roactAnalytics = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").RoactAnalytics

local memoize = require("@game/CorePackages/Workspace/Packages/AppCommonLib").memoize
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local t = require(CorePackages.Packages.t)

local module4 = require("@luauforge/bundled/dwB")

local peekViewState = require("@luauforge/bundled/dzD").PeekViewState
local withStyle = UIBlox.Style.withStyle

local module5 = require("@luauforge/bundled/eeo")
require(CorePackages.Packages.ReactFocusNavigation)
local focusNavigationEventNameEnum = module5.FocusNavigationEventNameEnum

local module6 = require("@luauforge/bundled/dCh")
local formFactor = require("@luauforge/bundled/dDI").Enums.FormFactor
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/AppCommonLib").IsVRAppBuild
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local module7 = require("@luauforge/bundled/dUd")
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local module8 = require("@luauforge/deferred/gko")
require("@luauforge/bundled/dHK")
local module9 = require("@luauforge/deferred/gfe")
local module10 = require("@luauforge/bundled/dMx")
local fFlagEnableSplitPane = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableSplitPane
local v5 = if fFlagEnableSplitPane then require("@luauforge/bundled/fuN") else nil
local module11 = require("@luauforge/bundled/fuD")
local module12 = require("@luauforge/deferred/gkp")

local module13 = require("@luauforge/deferred/glU")
local module14 = require("@luauforge/deferred/glY")
local module15 = require("@luauforge/deferred/glZ")
local module16 = require("@luauforge/deferred/gmb")
local module17 = require("@luauforge/bundled/dTM")
local AvatarExperienceCatalog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
local setSelectedTimedOption = AvatarExperienceCatalog.State.Actions.SetSelectedTimedOption

local useShouldFetchCartPricingForPurchasePrompt = AvatarExperienceCatalog.Hooks.useShouldFetchCartPricingForPurchasePrompt
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local avatarRoute = AvatarExperienceNavigation.AvatarRoute.AvatarRoute
local module20 = require("@luauforge/deferred/gfb")
local module21 = require("@luauforge/deferred/ggy")
local module22 = require("@luauforge/bundled/gfm")
local module23 = require("@luauforge/deferred/gmc")
local module24 = require("@luauforge/bundled/fvd")
local module25 = require("@luauforge/bundled/fvZ")
local module26 = require("@luauforge/bundled/fve")
local itemData = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").State.Selectors.ItemData
local module27 = require("@luauforge/bundled/dNA")
local module28 = require("@luauforge/bundled/dHL")
local setItemDetailsPeekViewState = module28.Actions.SetItemDetailsPeekViewState
local setItemTryOnPeekViewState = module28.Actions.SetItemTryOnPeekViewState
local module29 = require("@luauforge/deferred/gmd")
local module30 = require("@luauforge/deferred/gme")
local module31 = require("@luauforge/deferred/gmg")
local module32 = require("@luauforge/deferred/gmh")
local module33 = require("@luauforge/deferred/fuT")
local module34 = require("@luauforge/deferred/gmi")
local module35 = require("@luauforge/deferred/gml")
local useTableWrappedCallbackRef = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.useTableWrappedCallbackRef

local getTryOnItemReducerKey = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Utils.getTryOnItemReducerKey

local module36 = require("@luauforge/deferred/gmm")
local module37 = require("@luauforge/deferred/gmn")
local module38 = require("@luauforge/deferred/gmp")
local module39 = require("@luauforge/deferred/gmo")

local module40 = require("@luauforge/bundled/fvF")
local module41 = require("@luauforge/bundled/dRQ")
local module42 = require("@luauforge/deferred/gmq")
local module43 = require("@luauforge/bundled/dME")
local module44 = require("@luauforge/deferred/gmA")
local module45 = require("@luauforge/bundled/fuC")
local module46 = require("@luauforge/deferred/gkR")
local module47 = require("@luauforge/deferred/gkQ")
local module48 = require("@luauforge/deferred/gmB")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local module51 = require("@luauforge/deferred/gmC")
local module52 = require("@luauforge/bundled/dRT")

local module53 = require("@luauforge/deferred/gmF")

local module54 = require("@luauforge/deferred/glj")
local module55 = require("@luauforge/bundled/dMz")
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
local fFlagAXItemDetailsSduiBodyActions = AvatarExperienceFlags.FFlagAXItemDetailsSduiBodyActions
local fFlagAXItemDetailsSduiImpressionsAndExposure = AvatarExperienceFlags.FFlagAXItemDetailsSduiImpressionsAndExposure
local fFlagAXItemDetailsSduiTryOnSimpleView = AvatarExperienceFlags.FFlagAXItemDetailsSduiTryOnSimpleView
local fFlagAXItemDetailsDescriptionLinks = AvatarExperienceFlags.FFlagAXItemDetailsDescriptionLinks
local module56 = require("@luauforge/deferred/gkq")
local itemDetailsSduiEntryPoint = module56.ItemDetailsSduiEntryPoint

local module57 = require("@luauforge/deferred/gmG")

local module58 = require("@luauforge/deferred/gmQ")
local getItemDetailsEntryContext = module56.getItemDetailsEntryContext
local fFlagEnableMarketplacePurchaseDeepLinkAttribution = SharedFlags.FFlagEnableMarketplacePurchaseDeepLinkAttribution

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
extended.validateProps = strictInterface(v7)

function extended:init()
	self.actionBarHeaderRef = Roact.createRef()
	self.backButtonRef = Roact.createRef()

	if fFlagAXItemDetailsSdui then
		self.sduiScrollingFrameRef = Roact.createRef()
	end

	local v25 = module54() and { scrollingEnabled = true } or nil

	if self.props.itemData and self.props.itemData.timedOptions then
		for k, timedOption in self.props.itemData.timedOptions do
			if timedOption.selected then
				local days = timedOption.days

				if days == 0 then
					days = nil
				end

				v25.selectedTimedOptionDays = days
				break
			end
		end
	end

	self.state = v25

	if self.props.showRobuxBalance then
		self.robuxBalanceRef = Roact.createRef()
	end

	self.timedOptionDeeplinkUpdated = false
	function self.onTimedOptionSelected(p2)
		local v26 = self.props.itemData.timedOptions[p2] and self.props.itemData.timedOptions[p2].days or 0

		if v26 == 0 then
			v26 = Roact.None
		end

		self:setState({ selectedTimedOptionDays = v26 })

		if fFlagAXDurablesForMIS then
			self.timedOptionDeeplinkUpdated = true
		end
	end

	if fFlagAXDurablesForMIS then
		function self.updateTimedOptionSelection()
			local v26 = Cryo.List.findWhere(self.props.itemData.timedOptions, function(p2): boolean
				return p2.days == self.state.selectedTimedOptionDays
			end) or #self.props.itemData.timedOptions

			self.props.setSelectedTimedOption(self.props.itemId, self.props.itemType, v26)

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
				local v26 = if itemData2 then itemData2.collectibleItemId else nil
				screenItem.collectibleItemId = v26
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

	function self.renderContentCallback()
		return self:renderContent()
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

			local v26 = self.props.itemData
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
				v26
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
	return module43.ActionBar.ActionBarHeight + module43.ActionBar.ActionBarGradientHeight + 20
end

function extended:renderTopBar(p2)
	local theme = p2.Theme
	local fromProfile = self.props.fromProfile
	local topBarHeight = self.props.topBarHeight

	local name = if self.props.itemData then self.props.itemData.name else nil

	local isTryOnPage = self:getIsTryOnPage()
	local v25

	if isTryOnPage then
		v25 = self.props.itemDetailsTryOnViewState
	else
		v25 = self.props.itemDetailsViewState
	end

	local v26 = fromProfile and 0
		or (self.props.showDropDownTopBar and (v25 == peekViewState.Full or fFlagAXEnableHomeTryOnComplexView and v25 == peekViewState.Extended) or not self.props.isPortrait)
		and 0
		or 1

	local createElement = Roact.createElement
	local v28 = {
		BackgroundTransparency = v26,
		BackgroundColor3 = theme.BackgroundDefault.Color,
		BorderSizePixel = 0,
		Position = 0,
		Size = 0,
		ZIndex = 2,
		Visible = 0
	}

	local v29 = if self.props.isPortrait then UDim2.fromScale(0, 0) else UDim2.new(0, 0, 0, -self.props.deviceSafePadding.top)
	v28.Position = v29

	v28.Size = UDim2.new(
		1,
		(self.props.isPortrait or self.props.fromProfile or isTryOnPage) and 0 or self.props.deviceSafePadding.right,
		0,
		topBarHeight + (self.props.isPortrait and 0 or self.props.deviceSafePadding.top)
	)

	v28.Visible = self.topBarNavVisible

	local v31 = if not self.props.isPortrait then Roact.createElement("UIPadding", {
		PaddingTop = UDim.new(0, self.props.deviceSafePadding.top)
	}) else nil
	local v32

	if isVRAppBuild() then
		v32 = Roact.createElement(module16, {
			topBarHeight = topBarHeight,
			title = name,
			closeFocusedScreen = self.props.closeFocusedScreen,
			navigation = self.props.navigation
		})
	else
		local createElement2 = Roact.createElement
		local backButtonRefsByRef = { [Roact.Ref] = self.backButtonRef }

		local v34 = if not defineFastFlag3 then self.props.contentFrameRef else nil
		backButtonRefsByRef.NextSelectionDown = v34

		backButtonRefsByRef.itemId = self.props.itemId
		backButtonRefsByRef.itemType = self.props.itemType
		backButtonRefsByRef.itemData = self.props.itemData
		backButtonRefsByRef.dropDownTopBar = self.props.showDropDownTopBar
		backButtonRefsByRef.peekViewState = v25
		backButtonRefsByRef.closePeekView = self.closePeekView
		backButtonRefsByRef.showRobuxBalance = self.props.showRobuxBalance
		v32 = createElement2(module15, backButtonRefsByRef)
	end

	return createElement("Frame", v28, { UIPadding = v31, TopBar = v32 })
end

function extended:renderActionBar(p2, props2, p3, p4, selectedTimedOptionDays)
	local itemId = self.props.itemId
	local itemType = self.props.itemType

	local theme = props2.Theme
	local font = props2.Font
	local v25 = font.BaseSize * font.Header1.RelativeSize

	local name = p4 and p4.name

	local font2 = font.Header1.Font

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
	local v28 = {
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
		ZIndex = 1
	}
	local v29 = if fFlagAXDurables2Option and p4 then p4.timedOptions else nil
	v28.timedOptions = v29

	if not self.state then
		selectedTimedOptionDays = nil
	end

	v28.selectedTimedOptionDays = selectedTimedOptionDays
	v28.setSelectedTimedOptionDays = self.onTimedOptionSelected

	local v30 = if fFlagAXDurablesForMIS then self:getShouldShowSecondaryButton() else nil
	v28.showSecondaryButton = v30
	local v31

	if fFlagAXDurablesForMIS then
		if self.props.isCurrentItemInTryOns then
			v31 = self.props.localization.updateSecondaryButtonText
		else
			v31 = self.props.localization.tryOnSecondaryButtonText
		end
	end

	v28.secondaryButtonText = v31
	local v32

	if fFlagAXDurablesForMIS then
		if self.props.isCurrentItemInTryOns then
			v32 = self.updateTimedOptionSelection
		else
			v32 = self.onTryOnSecondaryButtonActivated
		end
	end

	v28.onSecondaryButtonActivated = v32
	local children = {
		BuyActionBar = createElement2(module42, v28),
		ActionBarHeader = 0
	}

	local createElement3 = Roact.createElement
	local actionBarHeaderRefsByRef = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -48, 0, v25),
		Position = UDim2.new(0, 24, 0, 5),
		ZIndex = 2,
		[Roact.Ref] = self.actionBarHeaderRef
	}
	local v35

	if name then
		local createElement4 = Roact.createElement
		local v37 = {
			Position = UDim2.fromOffset(0, 0),
			BackgroundTransparency = 1,
			Font = 0,
			FontFace = 0,
			Size = 0,
			Text = 0,
			TextSize = 0,
			TextXAlignment = 0,
			TextColor3 = 0,
			TextTruncate = 0
		}

		if foundationFontFaceMigration then
			font2 = nil
		end

		v37.Font = font2

		local v38 = if foundationFontFaceMigration then normalizeFontFace(props2.Tokens.Typography.HeadingSmall.Font) else nil
		v37.FontFace = v38

		v37.Size = UDim2.new(1, 0, 0, v25)
		v37.Text = name
		v37.TextSize = v25
		v37.TextXAlignment = Enum.TextXAlignment.Left
		v37.TextColor3 = theme.TextEmphasis.Color
		v37.TextTruncate = Enum.TextTruncate.AtEnd
		v35 = createElement4("TextLabel", v37)
			or Roact.createElement(skeleton, { Size = UDim2.new(1, 0, 0, v25) })
	else
		v35 = Roact.createElement(skeleton, { Size = UDim2.new(1, 0, 0, v25) })
	end

	children.ActionBarHeader = createElement3("Frame", actionBarHeaderRefsByRef, {
		NameLabel = v35
	})
	return createElement("Frame", actionBarContainerRefsByRef, children)
end

function extended:renderContent()
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
		local v25

		if fFlagAXItemDetailsSduiBodyActions then
			local navigation = self.props.navigation
			local isInAvatarExperience = self.props.isInAvatarExperience ~= false
			local v27 = if fFlagAXItemDetailsSduiTryOnSimpleView then self.props.simpleView == true else nil
			v25 = getItemDetailsEntryContext(navigation, isInAvatarExperience, v27)
		end

		local createElement = Roact.createElement
		local v27 = {
			itemId = itemId,
			itemType = itemType,
			entryContext = v25,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			scrollingFrameRef = 0,
			ref = 0,
			actionHandlers = 0,
			setParentScrollingEnabled = 0
		}
		local v28 = if fFlagAXItemDetailsSdui then self.sduiScrollingFrameRef else nil
		v27.scrollingFrameRef = v28
		local v29 = if self.props.showFullWithNoPeekView then self.props.contentFrameRef else nil
		v27.ref = v29
		local v30 = if fFlagAXItemDetailsSduiActions then self.sduiActionHandlers else nil
		v27.actionHandlers = v30

		local v31 = if defineFastFlag4 and module54() then self.setItemDetailsScrollingEnabled else nil
		v27.setParentScrollingEnabled = v31
		local element = createElement(itemDetailsSduiEntryPoint, v27)

		if fFlagAXItemDetailsSduiImpressionsAndExposure then
			return Roact.createElement(
				module13,
				{
					navigation = self.props.navigation,
					simpleView = self.props.simpleView
				},
				{ SduiBody = element }
			)
		end

		return element
	else
		local createElement = Roact.createElement
		local v26 = {
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

		local v27 = if self.props.showFullWithNoPeekView then self.props.contentFrameRef else nil
		v26.ref = v27
		local v28 = if module54() then self.setItemDetailsScrollingEnabled else nil
		v26.setItemDetailsScrollingEnabled = v28

		v26.simpleView = self.props.simpleView
		v26.onWearTimeSelection = self.onTimedOptionSelected
		local v29 = if fFlagAXItemDetailsDescriptionLinks then self.openDescriptionLinkItem else nil
		v26.openDescriptionLinkItem = v29
		return createElement(module12, v26)
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
	local v25

	if isTryOnPage then
		v25 = self.props.itemDetailsTryOnViewState
	else
		v25 = self.props.itemDetailsViewState
	end

	if not itemId then
		return
	end

	local fromProfile = self.props.fromProfile

	local isPortrait = self.props.isPortrait

	local v27 = true

	local v28 = UDim2.fromScale(0, 0)
	local v29 = UDim2.fromScale(1, 1)

	if not isPortrait then
		if fromProfile or isTryOnPage then
			local offset = getSafeAreaSize(self.props.screenSize, self.props.globalGuiInset).X.Offset

			local v30 = math.min(offset, 640)

			if isTryOnPage and v30 < offset then
				v27 = false
			end

			v28 = UDim2.fromOffset((offset - v30) / 2, 0)
			v29 = UDim2.new(0, v30, 1, 0)
		else
			local fromScale = UDim2.fromScale
			local v30 = if fFlagEnableSplitPane then v5.getLandscapeNavWidth() else module10.LandscapeNavWidth
			v28 = fromScale(v30, 0)

			local fromScale2 = UDim2.fromScale

			local v31 = if fFlagEnableSplitPane then v5.getLandscapeSceneWidth() else module10.LandscapeSceneWidth
			v29 = fromScale2(v31, 1)
		end
	end

	local briefViewHeight = self:getBriefViewHeight()

	local v30 = self:getItemDetailsComponent(wideMode and fromProfile and not isTryOnPage)

	if fFlagEnableSplitPane and fromProfile and not isTryOnPage and v5.isSupportPaneLayoutActive() then
		if not isPortrait then
			v28, v29 = v5.getOverlayLayoutOverSupportPane()
		end

		v30 = module31
	end

	local createElement = Roact.createElement
	local v32 = {
		["BackgroundTransparency"] = nil,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		Visible = not isSceneFullView
	}

	local ref = Roact.Ref
	local v33 = if itemDetailsPeekViewRefs then itemDetailsPeekViewRefs[key] or nil else nil
	v32[ref] = v33

	local v34 = if not module53() then Roact.createElement(module48, {
		ixpTest = module51.ItemDetailsPage
	}) else nil

	local v35 = if module55.isEnabled() then Roact.createElement(module48, {
		ixpTest = module55
	}) else nil
	local children = {
		ItemDetailsExposure = v34,
		ItemDetails3DPreviewExposure = v35,
		NavigationEventsLogger = Roact.createElement(module9, {
			pageName = "ItemDetails:" .. key
		}),
		ItemDetailsContent = 0
	}

	local createElement2 = Roact.createElement
	local getRenderActionBarCallback = self.getRenderActionBarCallback

	local itemData2 = self.props.itemData
	local v37 = if self.state then self.state.selectedTimedOptionDays else nil
	local v36 = {
		renderBottomBar = getRenderActionBarCallback(p2, p3, briefViewHeight, itemData2, v37),
		renderContent = self.renderContentCallback,
		renderTopBar = self.getRenderTopBarCallback(p3),
		isTryOnPage = isTryOnPage,
		peekViewState = v25,
		setPeekViewState = self.setPeekViewState,
		actionBarContainerRef = self.props.actionBarContainerRef,
		contentFrameRef = self.props.contentFrameRef,
		closeBriefView = self.closeBriefView,
		viewPosition = v28,
		viewSize = v29,
		briefViewHeight = briefViewHeight,
		showDropShadow = v27,
		analytics = self.props.analytics,
		avatarRoute = self.props.avatarRoute,
		closeAllPeekViews = self.props.closeAllPeekViews,
		closeFocusedScreen = self.props.closeFocusedScreen,
		fromProfile = self.props.fromProfile,
		itemDetailsExpanded = self.props.itemDetailsExpanded,
		itemId = self.props.itemId,
		itemType = self.props.itemType,
		lastInputGroup = self.props.lastInputGroup,
		mountAnimation = self.props.mountAnimation,
		mountAsFullView = self.props.mountAsFullView,
		navigation = self.props.navigation,
		peekViewFullViewEnabled = self.props.peekViewFullViewEnabled,
		peekViewShowing = self.props.peekViewShowing,
		setItemDetailsExpanded = self.props.setItemDetailsExpanded,
		topBarHeight = self.props.topBarHeight,
		scrollingEnabled = 0,
		scrollingFrameRef = 0
	}
	local v38 = if module54() then self.state.scrollingEnabled else nil
	v36.scrollingEnabled = v38

	local v39 = if fFlagAXItemDetailsSdui then self.sduiScrollingFrameRef else nil
	v36.scrollingFrameRef = v39
	children.ItemDetailsContent = createElement2(v30, v36)
	return createElement("Frame", v32, children)
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
				local v26 = timedOption.days == 0

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

	local v25 = self.props.avatarRoute.current.name == avatarScreen.ItemDetails
	local v26 = self.props.navigation.state.routeName == avatarScreen.ItemDetails

	if module17.isFirstItemDetailsPage(self.props.navigation) and not (v25 and v26) then
		self.props.setItemDetailsPeekViewState(peekViewState.Closed)

		if self.props.onItemDetailsClosed ~= nil then
			self.props.onItemDetailsClosed()
		end
	end
end

local function mapStateToProps(data, data2)
	local itemId = data2.itemId
	local itemType = data2.itemType
	local v25 = itemData(data.AvatarExperience.Common, itemId, itemType)
	local tryOnItems

	if fFlagAXDurablesForMIS then
		tryOnItems = data.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
	end

	local v26

	if fFlagAXDurablesForMIS then
		v26 = tryOnItems and tryOnItems[getTryOnItemReducerKey(itemId, itemType)] ~= nil
	end

	local key = data2.navigation.state.key

	local avatarRoute2 = data2.avatarRoute
	local key2 = avatarRoute2.current.key
	local v27 = data2.navigation.state.routeName == avatarScreen.TryOnItem

	local v28 = fFlagAXDurablesForMIS
		and data2.avatarRoute.opaque
		and data2.avatarRoute.opaque.name == avatarScreen.AvatarEditor

	if (v27 or fFlagAXItemDetailsPartialAssetInfoFix) and v25 ~= nil and v25.name == nil then
		v25 = nil
	end

	local v29 = {
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

	if (v27 or fFlagAXItemDetailsPartialAssetInfoFix) and v25 ~= nil and v25.name == nil then
		v25 = nil
	end

	v29.itemData = v25

	local v30 = if fFlagAXItemDetailsSdui then performFetch.GetStatus(
		data,
		module41.GetItemDetailsKey(itemId, itemType)
	) else nil
	v29.fetchingState = v30

	v29.wideMode = data.FormFactor == formFactor.WIDE
	v29.peekViewShowing = key2 == key
	v29.topBarHeight = module11.getTopBarHeightAvatarScene(data)
	v29.itemDetailsExpanded = data.AvatarExperience.Common.ItemDetailsExpanded
	v29.playerMembership = data.Users[data.LocalUserId] and data.Users[data.LocalUserId].membership
		or Enum.MembershipType.None

	v29.itemDetailsTryOnViewState = data.AvatarExperience.Common.ItemDetailsPeekView.tryOnViewState
	v29.itemDetailsViewState = data.AvatarExperience.Common.ItemDetailsPeekView.viewState
	v29.screenSize = data.ScreenSize
	v29.globalGuiInset = data.GlobalGuiInset
	v29.isPortrait = module22(data)
	local v31 = if fFlagAXDurablesForMIS then tutils.fieldCount(tryOnItems) else nil
	v29.numberOfTryOnItems = v31

	if not fFlagAXDurablesForMIS then
		v26 = nil
	end

	v29.isCurrentItemInTryOns = v26

	if not fFlagAXDurablesForMIS then
		v28 = nil
	end

	v29.isAvatarEditorOpaqueRoute = v28
	return v29
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

local v25 = module32(extended)

local v26 = module20((RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v25)))

local v27 = roactAppPolicy.connect(function(p2, p3)
	return {
		peekViewFullViewEnabled = p2.getItemDetailsFullView(),
		showPremiumContent = p2.getShowCatalogPremiumContent()
	}
end)(v26)

local function ItemDetailsPageContainer(p2)
	local v28 = useSelector(fn)
	local v29 = useSelector(fn2)
	local fromProfile = p2.navigation.state.params.fromProfile
	local v30 = p2.navigation.state.routeName == avatarScreen.TryOnItem
	local v31

	if fFlagEnableSplitPane and fromProfile and not v30 and v5.isSupportPaneLayoutActive() then
		v31 = false
	else
		v31 = v29 and fromProfile and not v30
	end

	local showFullWithNoPeekView = p2.navigation.state.params.showFullWithNoPeekView
	local itemId = p2.navigation.state.params.itemId
	local itemType = p2.navigation.state.params.itemType

	local v32 = module(module3)
	local v33 = module(module40)
	local v34 = if fFlagAXItemDetailsSdui then module(roactAnalytics) else nil
	local v35 = if fFlagAXItemDetailsSduiBodyActions then module38() else nil
	local v36 = useDispatch()
	local v37

	if fFlagAXDurablesForMIS then
		v37 = module2({
			updateSecondaryButtonText = "Feature.Avatar.Action.Update",
			tryOnSecondaryButtonText = "Feature.Avatar.Action.TryOn"
		})
	end

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)

	local v38 = module35()
	local v39 = module34({ overlayClosedCallback = v38 })

	local v40 = useSelector((React.useCallback(function(p3)
		return itemData(p3.AvatarExperience.Common, itemId, itemType)
	end, { itemId, itemType })))
	local v41 = useShouldFetchCartPricingForPurchasePrompt(v40)

	local ref3 = if fFlagAXItemDetailsSduiBodyActions then React.useRef(nil) else nil
	local v42

	if fFlagAXItemDetailsSdui and fFlagAXItemDetailsSduiBodyActions then
		v42 = module58(itemId, itemType)
	end

	local v43 = React.useMemo(function()
		local v44 = {
			[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
			[Enum.KeyCode.ButtonX] = focusNavigationEventNameEnum.OpenItemDetailsPrompt
		}
		local buttonY = Enum.KeyCode.ButtonY
		local v45 = if v28 then focusNavigationEventNameEnum.CloseItemDetailsPeekView else focusNavigationEventNameEnum.OpenItemDetailsPeekView
		v44[buttonY] = v45

		v44[Enum.KeyCode.ButtonL3] = focusNavigationEventNameEnum.OpenCatalogContextMenu
		v44[Enum.KeyCode.ButtonL2] = focusNavigationEventNameEnum.MoveToItemDetails
		return v44
	end, { v28 })

	local v44 = React.useCallback(function(p3)
		if v30 then
			v36(setItemTryOnPeekViewState(p3))
		else
			v36(setItemDetailsPeekViewState(p3))
		end
	end, { v36, v30 })

	local v45 = React.useCallback(function()
		module17.closeFocusedScreen(p2.navigation)
	end, { p2.navigation })

	local v46 = React.useCallback(function()
		v36(module33(v32, v33, v38, p2.navigation, p2.avatarRoute, nil, nil, false, nil, nil, nil, v41))
	end, { v36, v32, v33, v38, p2.navigation, p2.avatarRoute, v41 })

	local v47 = React.useCallback(function()
		v44(peekViewState.Full)
	end, { v44 })

	local v48 = React.useCallback(function()
		v44(peekViewState.Brief)
	end, { v44 })

	local v49 = React.useCallback(function()
		local v50 = fromProfile or v30

		if fFlagEnableSplitPane and fromProfile and not v30 and v5.isSupportPaneLayoutActive() then
			v50 = false
		end

		p2.navigation.navigate(avatarScreen.CatalogContextMenu, {
			itemId = itemId,
			itemType = itemType,
			onOverlayClosed = v38,
			centered = v50
		})
	end, { p2.navigation, itemId, itemType, v38, fromProfile, v30 })

	if v31 or showFullWithNoPeekView or v28 then
		v47 = nil
	end

	if v31 or showFullWithNoPeekView or not v28 then
		v48 = nil
	end

	if showFullWithNoPeekView then
		v49 = nil
	end

	local v50 = {
		onGoBack = v45,
		onOpenItemPrompt = v46,
		onOpenPeekView = v47,
		onClosePeekView = v48,
		onOpenCatalogContextMenu = v49
	}

	local v51 = useTableWrappedCallbackRef((module36(ref2, v43, v50)))

	local v52 = useTableWrappedCallbackRef((module36(ref, v43, v50)))

	local v53 = useSignalState(module7.GetDisplayStore().getDeviceSafePadding)

	local join = Cryo.Dictionary.join
	local v54 = {
		actionBarContainerRef = v52,
		contentFrameRef = v51,
		overlayClosedCallback = v38,
		networking = v32,
		analytics = v33,
		appAnalytics = v34,
		itemDetailsExpanded = v28,
		localization = nil,
		deviceSafePadding = nil,
		sduiAttributionPlayRef = nil,
		isInAvatarExperience = nil
	}

	if not fFlagAXDurablesForMIS then
		v37 = nil
	end

	v54.localization = v37
	v54.deviceSafePadding = v53
	v54.sduiAttributionPlayRef = if fFlagAXItemDetailsSduiBodyActions then ref3 else nil

	if not fFlagAXItemDetailsSduiBodyActions then
		v35 = nil
	end

	v54.isInAvatarExperience = v35
	local v56 = join(p2, v54)

	local v57 = useNavigation()
	local v58 = useAvatarRoute()
	local v59 = v57.state.rnKey == v58.current.key or defineFastFlag and v57.state.key == v58.current.key

	local createElement = Roact.createElement
	local ref4 = Roact.Ref

	if defineFastFlag2 then
		v39 = nil
	end

	local v61 = {
		[ref4] = v39,
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		SelectionGroup = true,
		Visible = v59
	}

	local v62 = { ItemDetails = React.createElement(v27, v56), SduiAttributionPlay = 0 }

	local v63 = if fFlagAXItemDetailsSdui and fFlagAXItemDetailsSduiBodyActions and v42 then React.createElement(module57, {
		universeId = v42,
		itemId = itemId,
		itemType = itemType,
		itemSubType = module41.GetItemSubType(itemType, v40),
		attributionPlayRef = ref3
	}) else nil
	v62.SduiAttributionPlay = v63
	return createElement("Frame", v61, v62)
end

return ItemDetailsPageContainer
