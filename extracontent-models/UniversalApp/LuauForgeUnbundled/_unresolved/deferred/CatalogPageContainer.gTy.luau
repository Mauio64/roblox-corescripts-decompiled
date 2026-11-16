local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")

local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)

local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable
local Cryo = require(CorePackages.Packages.Cryo)
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local externalEventConnection = RoactUtils.ExternalEventConnection
local isGamepadInput = RoactUtils.isGamepadInput
local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService
local UIBlox = require(CorePackages.Packages.UIBlox)
local images = UIBlox.App.ImageSet.Images

local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local module3 = require("@luauforge/bundled/dMd")
local AvatarExperienceCatalog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")

local module5 = require("@luauforge/deferred/gTv")

local module6 = require("@luauforge/bundled/dCp")
local module7 = require("@luauforge/bundled/fuD")
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute

local avatarExperienceAnalyticsService = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").AvatarExperienceAnalyticsService
local module9 = require("@luauforge/bundled/dYT")
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy
local module10 = require("@luauforge/bundled/eda")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices

local module11 = require("@luauforge/deferred/gfe")

local module12 = require("@luauforge/deferred/gmV")

local module13 = require("@luauforge/deferred/gfb")
local module14 = require("@luauforge/bundled/dTM")
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)

local focusNavigationEventNameEnum = require("@luauforge/bundled/eeo").FocusNavigationEventNameEnum
local useFocusOnMount = require("@luauforge/bundled/eeo").useFocusOnMount
local compositionTags = require("@luauforge/bundled/gns").CompositionTags

local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local module15 = require("@luauforge/deferred/ggF")
local module16 = require("@luauforge/deferred/gTz")

local module17 = require("@luauforge/deferred/gTA")
local v5 = if require("@luauforge/deferred/gTh")() then require("@luauforge/deferred/gTi") else require("@luauforge/deferred/gTk")
local module18 = require("@luauforge/deferred/gTl")
local module19 = require("@luauforge/deferred/goQ")
local module20 = require("@luauforge/deferred/gTC")
local module21 = require("@luauforge/bundled/fox")

local module22 = require("@luauforge/bundled/geT")
local module23 = require("@luauforge/bundled/fvF")

local peekViewState = require("@luauforge/bundled/dzD").PeekViewState
local module24 = require("@luauforge/bundled/dHL")
local setItemDetailsPeekViewState = module24.Actions.SetItemDetailsPeekViewState
local setTryOnManagerPeekViewState = module24.Actions.SetTryOnManagerPeekViewState
local module25 = require("@luauforge/deferred/fuT")

local module26 = require("@luauforge/bundled/gnZ")
local fullView = AvatarExperienceCommon.Enums.FullView
local module27 = require("@luauforge/deferred/gUK")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums")
local module29 = require("@luauforge/deferred/fos")

local module30 = require("@luauforge/deferred/gmX")

local module31 = require("@luauforge/bundled/gfm")
local module32 = require("@luauforge/bundled/goe")
local itemData = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").State.Selectors.ItemData

local module33 = require("@luauforge/bundled/dHq")
local MockAppStorageService = require("@game/CoreGui/RobloxGui/Modules/TestHelpers/MockAppStorageService")
require("@luauforge/bundled/dHK")

local module35 = require("@luauforge/deferred/gmB")

local module36 = require("@luauforge/deferred/gqf")

local module37 = require("@luauforge/deferred/gmj")
local module38 = require("@luauforge/deferred/gmk")

local module39 = require("@luauforge/deferred/gml")

local sendAXCounterV2 = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").sendAXCounterV2
local module40 = require("@luauforge/bundled/dMx")

local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/AppCommonLib").IsVRAppBuild

local module41 = require("@luauforge/bundled/frs")
local module42 = require("@luauforge/deferred/gmD")
local module43 = require("@luauforge/bundled/dMB")
local ixpServiceWrapper = require("@luauforge/bundled/fvx").IXPServiceWrapper
local appUserLayers = require("@luauforge/bundled/dMA").AppUserLayers
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")

local module45 = require("@luauforge/deferred/gmC")
local module46 = require("@luauforge/bundled/fuJ")

local module47 = require("@luauforge/deferred/gTe")
local module48 = require("@luauforge/bundled/dSW")
local axAvatarsTabIXP = AvatarExperienceCommon.Experiments.AXAvatarsTabIXP
local getBackendLayerNamesForCatalog = AvatarExperienceCommon.Utils.getBackendLayerNamesForCatalog

local module49 = require("@luauforge/deferred/gUL")
local module50 = require("@luauforge/deferred/gmE")

local module51 = require("@luauforge/deferred/gUM")

local module52 = require("@luauforge/deferred/gTu")
local fFlagAXMakeupReleaseFTUX = AvatarExperienceFlags.FFlagAXMakeupReleaseFTUX
local fFlagAXBackendDrivenCatalogLayers = AvatarExperienceFlags.FFlagAXBackendDrivenCatalogLayers
local fFlagAXCatalogDeepLinkSearchProps = AvatarExperienceFlags.FFlagAXCatalogDeepLinkSearchProps
local defineFastFlag = game:DefineFastFlag("AXItemCardComponentsMemoExposure", false)

local defineFastString = game:DefineFastString(
	"AXItemCardComponentsMemoLayerName",
	"AvatarExperience.UA.MarketplaceView"
)

local defineFastFlag2 = game:DefineFastFlag("AXEnableIXPCounters2", false)
local defineFastFlag3 = game:DefineFastFlag("AXCustomizeOverhaulCatalogExposure2", false)

local module53 = require("@luauforge/deferred/gTt")

local module54 = require("@luauforge/bundled/dPG")

local defineFastString2 = game:DefineFastString(
	"AXMISExperimentLayerName",
	appUserLayers.AvatarExperienceUAMarketplaceView
)
local defineFastFlag4 = game:DefineFastFlag("AXMISExposureLogging", false)

local defineFastString3 = game:DefineFastString(
	"AXTaxonomyM20ExperimentLayerName",
	appUserLayers.AvatarExperienceUAMarketplaceView
)

local fFlagAXExpandPeekViewOnFirstScroll = AvatarExperienceFlags.FFlagAXExpandPeekViewOnFirstScroll
local fFlagAXEnableCategoryPillsExposureLogging = AvatarExperienceFlags.FFlagAXEnableCategoryPillsExposureLogging
local fFlagAXHideMenuOnScroll = AvatarExperienceFlags.FFlagAXHideMenuOnScroll
local fFlagAXFixCatalogRefreshRendering = AvatarExperienceFlags.FFlagAXFixCatalogRefreshRendering
local fFlagBasedExposureLoggingCatalogPage = AvatarExperienceFlags.FFlagBasedExposureLoggingCatalogPage

local fFlagAXEnableTaxonomyM20ExposureLoggingCatalog = AvatarExperienceFlags.FFlagAXEnableTaxonomyM20ExposureLoggingCatalog

local fFlagAXMoveCatalogFilterToL1NavigationExposureLogging = AvatarExperienceFlags.FFlagAXMoveCatalogFilterToL1NavigationExposureLogging

local fFlagFlyoutNavigationInMarketplace = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagFlyoutNavigationInMarketplace
local module55 = require("@luauforge/bundled/dHC")

local v6 = if fFlagFlyoutNavigationInMarketplace and module55 then require("@luauforge/deferred/gTq") else nil

local fFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup = AvatarExperienceFlags.FFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup
local fFlagAXHideCatalogShortcutsInFullView = AvatarExperienceFlags.FFlagAXHideCatalogShortcutsInFullView

local defineFastFlag5 = game:DefineFastFlag("FFlagAXCatalogCategoriesSDUIExposureLogging", false)
local defineFastString4 = game:DefineFastString(
	"FStringAXCatalogCategoriesSDUIExposureLayer",
	appUserLayers.AvatarExperienceUAMarketplaceView
)

local defineFastFlag6 = game:DefineFastFlag("AXTestSkeletonInCatalogExposureLogging", false)

local defineFastString5 = game:DefineFastString(
	"AXTestSkeletonInCatalogLayerName",
	"AvatarExperience.UA.MarketplaceView"
)

local useTTINavigationTracking = require("@luauforge/bundled/fwS").useTTINavigationTracking

local fFlagFixNavigateToCatalogMetric = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagFixNavigateToCatalogMetric

local fFlagAXCatalogM41CategoriesExposureLogging = AvatarExperienceFlags.FFlagAXCatalogM41CategoriesExposureLogging
local fFlagAXMeTabTopScrim = AvatarExperienceFlags.FFlagAXMeTabTopScrim
local widgetsPercievedTTIManager = require("@luauforge/bundled/ggZ").WidgetsPercievedTTIManager
local fFlagAXHideMenuOnScrollExposureLogging = AvatarExperienceFlags.FFlagAXHideMenuOnScrollExposureLogging

local fFlagAXMakeupCategoryPositionExperimentExposureLogging = AvatarExperienceFlags.FFlagAXMakeupCategoryPositionExperimentExposureLogging
local defineFastFlag7 = game:DefineFastFlag("AXVirtualizedListConfigExposureLogging", false)

local defineFastFlag8 = game:DefineFastFlag("AXWidgetListWindowSizeByMemoryTierLogExposure", false)
local defineFastFlag9 = game:DefineFastFlag("AXCatalogSduiExposureLogging", false)

local fFlagAXCatalogItemCardDarkerBackgroundLogExposure = AvatarExperienceFlags.FFlagAXCatalogItemCardDarkerBackgroundLogExposure
local module56 = require("@luauforge/deferred/gUN")
local module57 = require("@luauforge/deferred/gUO")
local useCatalogPageTimeoutPrompt = AvatarExperienceCatalog.Hooks.useCatalogPageTimeoutPrompt
local useCatalogPageMakeupReleaseFtux = AvatarExperienceCatalog.Hooks.useCatalogPageMakeupReleaseFtux

local useShouldFetchCartPricingForPurchasePrompt = AvatarExperienceCatalog.Hooks.useShouldFetchCartPricingForPurchasePrompt

local defineFastFlag10 = game:DefineFastFlag("AXMarketplaceViewDefaultExposureLogging", false)

local module58 = require("@luauforge/deferred/gUP")

local module59 = require("@luauforge/bundled/dCn")

local iconsactionstruncationExpand = images["icons/actions/truncationExpand"]

local catalogCategories = module3.Enums.CatalogCategories

local function selectTryOnManagerViewState(p2)
	return p2.AvatarExperience.Common.ItemDetailsPeekView.tryOnManagerViewState
end

local extended = Roact.PureComponent:extend("CatalogPage")

local strictInterface = t.strictInterface
local v7 = {}

v7.fullView = t.optional(t.userdata)
v7.isPortrait = t.optional(t.boolean)
v7.itemDetailsExpanded = t.optional(t.boolean)
v7.tryOnManagerPeekViewState = t.optional(t.valueOf(peekViewState))

v7.openItemPrompt = t.callback
v7.setItemDetailsPeekViewState = t.callback
v7.navigateIntoQuickMenu = t.optional(t.callback)
v7.setFullView = t.callback
v7.resetNavigationHistory = t.callback
v7.instantResetNavigationHistory = t.callback
v7.setTryOnManagerPeekViewState = t.callback
v7.resetSearchCategoryAndSubcategory = t.callback

v7.namedRefs = t.table

v7.prevNavPage = t.optional(t.string)
v7.prevNavHistory = t.optional(t.table)

v7.navigation = t.optional(t.table)
v7.avatarRoute = t.optional(t.table)

v7.avatarExperienceAnalytics = t.optional(t.table)
v7.networking = t.optional(t.callback)
v7.appAnalytics = t.optional(t.table)
v7.avatarEditorAnalytics = t.optional(t.table)
v7.catalogAnalytics = t.optional(t.table)

v7.show3dView = t.optional(t.boolean)

v7.itemId = t.optional(t.string)
v7.itemType = t.optional(t.string)
v7.isFirstItemDetails = t.optional(t.boolean)

v7.creatorName = t.optional(t.string)
v7.salesTypeFilter = t.optional(t.string)
local v8 = if fFlagAXCatalogDeepLinkSearchProps then t.optional(t.string) else nil
v7.sortType = v8
local v9 = if fFlagAXCatalogDeepLinkSearchProps then t.optional(t.string) else nil
v7.sortAggregation = v9
local v10 = if fFlagAXCatalogDeepLinkSearchProps then t.optional(t.string) else nil
v7.minPrice = v10
local v11 = if fFlagAXCatalogDeepLinkSearchProps then t.optional(t.string) else nil
v7.maxPrice = v11
local v12 = if fFlagAXCatalogDeepLinkSearchProps then t.optional(t.string) else nil
v7.includeNotForSale = v12
local v13 = if fFlagAXCatalogDeepLinkSearchProps then t.optional(t.string) else nil
v7.topics = v13
local v14 = if fFlagAXCatalogDeepLinkSearchProps then t.optional(t.string) else nil
v7.wearTimeFilter = v14

v7.is10ftUI = t.boolean

v7.androidBackButtonConnection = t.table
v7.overlayClosedCallback = t.callback
v7.defaultFocusRef = t.optional(t.callback)

local v15 = if fFlagAXFixCatalogRefreshRendering then t.optional(t.boolean) else nil
v7.fetchItemFailed = v15
local v16 = if fFlagAXFixCatalogRefreshRendering then t.optional(t.boolean) else nil
v7.wasItemEquipped = v16
v7.category = t.optional(t.string)
v7.subcategory = t.optional(t.string)
v7.taxonomy = t.optional(t.string)
extended.validateProps = strictInterface(v7)

function extended:init()
	self.topBarRef = Roact.createRef()
	self.sceneUIContainerRef = Roact.createRef()
	self.titleDropDownRef = Roact.createRef()
	self.topBarRenderRightRef = Roact.createRef()
	self.refinementButtonsRef = Roact.createRef()
	self.multiTryOnBottomBarRef = Roact.createRef()
	self.quickButtonsRef = Roact.createRef()

	self.itemDetailsPeekViewRefs = RoactGamepad.createRefCache()

	self:setState({
		lastInputIsGamepad = isGamepadInput((UserInputService:GetLastInputType()))
	})

	function self.setDefaultRefOverride(p2)
		self:setState({
			defaultRefOverride = p2 or Roact.None
		})
	end

	function self.changeView()
		local avatarExperienceAnalytics = self.props.avatarExperienceAnalytics

		local newFullViewEnum = module7.getNewFullViewEnum(self.props.fullView)
		self.props.setFullView(
			avatarExperienceAnalytics,
			self.props.avatarRoute.opaque.name,
			newFullViewEnum
		)
	end

	function self.setUIFullView()
		local avatarExperienceAnalytics = self.props.avatarExperienceAnalytics

		if self.props.isPortrait then
			self.props.setFullView(
				avatarExperienceAnalytics,
				avatarScreen.CatalogSearch,
				fullView.UIFullView
			)
		end
	end

	function self.isAvatarScreen(p2)
		return (rawget(avatarScreen, p2))
	end

	function self.topBarBackButtonActivated()
		if fFlagAXExpandPeekViewOnFirstScroll and self.props.fullView == fullView.UIFullView then
			local avatarExperienceAnalytics = self.props.avatarExperienceAnalytics
			self.props.setFullView(
				avatarExperienceAnalytics,
				self.props.avatarRoute.opaque.name,
				fullView.None
			)
		else
			local navigation = self.props.navigation
			local avatarEditorAnalytics = self.props.avatarEditorAnalytics

			local prevNavPage = self.props.prevNavPage
			local prevNavHistory = self.props.prevNavHistory

			if prevNavPage and prevNavHistory then
				if self.isAvatarScreen(prevNavPage) then
					self.props.navigation.navigate(prevNavPage)
				else
					self.props.resetNavigationHistory(prevNavHistory)
				end
			else
				local v17 = if self.props.is10ftUI then avatarScreen.AvatarExperienceLandingPage else module6.Home
				navigation.navigate(v17)
			end

			avatarEditorAnalytics.catalogToAvatarBackButton()
		end
	end

	self.defaultChildRef = Roact.createRef()

	function self.lastInputTypeChangedCallback(p2)
		local gamepadInput = isGamepadInput(p2)

		if gamepadInput ~= self.state.lastInputIsGamepad then
			self:setState({ lastInputIsGamepad = gamepadInput })
		end
	end

	self.titleDropDown = module17("Feature.Avatar.Action.Marketplace", self.props.overlayClosedCallback)

	self.backButton = module18(self.topBarBackButtonActivated)

	function self.onConfirmSearchCallback()
		self.props.resetSearchCategoryAndSubcategory()

		if module41() and self.setUIFullView then
			self.setUIFullView()
		end
	end

	sendAXCounterV2(module40.Counter.TopLevelPageInitialView.Catalog)

	if fFlagAXEnableCategoryPillsExposureLogging then
		ixpServiceWrapper:LogFlagLinkedUserLayerExposure(appUserLayers.AvatarExperienceUAAllViews)
	end

	if fFlagAXEnableTaxonomyM20ExposureLoggingCatalog then
		ixpServiceWrapper:LogFlagLinkedUserLayerExposure(defineFastString3)
	end

	if defineFastFlag6 then
		ixpServiceWrapper:LogFlagLinkedUserLayerExposure(defineFastString5)
	end
end

function extended:getBestDefaultRefForPage()
	if self.state.defaultRefOverride then
		return self.state.defaultRefOverride
	end

	return self.defaultChildRef
end

if defineFastFlag2 then
	function extended:sendExperimentCountersOnce() end
end

function extended:didMount()
	if not self.props.is10ftUI and module30(self.props) then
		self.props.androidBackButtonConnection.connect(self.topBarBackButtonActivated)
	end

	if defineFastFlag2 then
		self:sendExperimentCountersOnce()
	end

	if defineFastFlag3 then
		local logLayerExposure = module43.logLayerExposure

		local v17 = if module53 then module52() else appUserLayers.AvatarExperienceUAAllViews
		logLayerExposure(v17)
	end

	if defineFastFlag4 then
		ixpServiceWrapper:LogFlagLinkedUserLayerExposure(defineFastString2)
	end

	if defineFastFlag then
		ixpServiceWrapper:LogFlagLinkedUserLayerExposure(defineFastString)
	end
end

function extended.willUnmount(p2)
	p2.props.androidBackButtonConnection.disconnect()
end

function extended.didUpdate(p2, p3)
	if not p2.props.is10ftUI then
		if module30(p3) or not module30(p2.props) then
			if module30(p3) and not module30(p2.props) then
				p2.props.androidBackButtonConnection.disconnect()
			end
		else
			p2.props.androidBackButtonConnection.connect(p2.topBarBackButtonActivated)
		end
	end
end

function extended:willUpdate(p2)
	if fFlagAXExpandPeekViewOnFirstScroll and p2.fullView ~= self.props.fullView then
		self.backButton = module18(self.topBarBackButtonActivated, self:getBackButtonIcon(p2.fullView))
	end
end

if fFlagAXExpandPeekViewOnFirstScroll then
	function extended:getBackButtonIcon(p3)
		if (p3 or self.props.fullView) == fullView.UIFullView then
			return iconsactionstruncationExpand
		end

		return nil
	end
end

function extended:renderTopBar()
	local isPortrait = self.props.isPortrait
	local show3dView = self.props.show3dView

	return withLocalization({ title = "Feature.Avatar.Action.Marketplace" })(function(p2)
		local v17 = module41() and 3 or 2
		local v18, v19, v20

		if not isVRAppBuild() then
			v18 = if fFlagFlyoutNavigationInMarketplace and module55 then v6 else self.backButton
			v19 = if self.props.is10ftUI then self.titleDropDown else v5
			v20 = { module21.SearchButton }
		end

		local v21 = if isPortrait then show3dView else false
		local createElement = Roact.createElement
		local container = module21.Container
		local topBarRefsByRef = {}
		topBarRefsByRef.forceCompactMode = true
		topBarRefsByRef.searchType = RobloxAppEnums.SearchTypes.Catalog
		topBarRefsByRef.titleText = p2.title
		topBarRefsByRef.tag = compositionTags.ContentRegion.Header
		topBarRefsByRef.sideMarginOverride = 0
		topBarRefsByRef.ZIndex = v17
		topBarRefsByRef.transparentBackground = v21

		if not fFlagAXMeTabTopScrim then
			v21 = nil
		end

		topBarRefsByRef.showTopScrim = v21
		topBarRefsByRef.hideSiteMessageBanner = isPortrait
		topBarRefsByRef[Roact.Ref] = self.topBarRef
		topBarRefsByRef.setDefaultRefOverride = self.setDefaultRefOverride
		topBarRefsByRef.NextSelectionDown = self.defaultChildRef
		topBarRefsByRef.NextSelectionRight = self.sceneUIContainerRef
		topBarRefsByRef.onConfirmSearchCallback = self.onConfirmSearchCallback
		topBarRefsByRef.leftItem = v18
		topBarRefsByRef.centerItem = v19
		topBarRefsByRef.rightItems = v20
		topBarRefsByRef.useParentSizeForCenterItem = true
		topBarRefsByRef.shouldNavigateToSearchLandingPage = true
		return createElement(container, topBarRefsByRef)
	end)
end

function extended:render()
	local v17 = self.props.fullView == fullView.SceneFullView
	local v18 = self.props.fullView == fullView.UIFullView
	local show3dView = self.props.show3dView
	local namedRefs = self.props.namedRefs

	local v19 = self.props.avatarRoute.current.name == avatarScreen.SortAndFilters

	local v20 = self.quickButtonsRef

	if self.props.avatarRoute.current.name == avatarScreen.TryOnManager then
		v20 = namedRefs[avatarScreen.TryOnManager]
	elseif self.props.avatarRoute.current.name == avatarScreen.LookDetails then
		v20 = namedRefs[avatarScreen.LookDetails]
	elseif v19 then
		v20 = namedRefs[avatarScreen.SortAndFilters]
	end

	local createElement = Roact.createElement
	local frame = focusable.Frame
	local v21 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		defaultChild = self:getBestDefaultRefForPage(),
		restorePreviousChildFocus = false,
		ref = namedRefs[avatarScreen.Catalog]
	}
	local children = {
		LastInputTypeChangedConnection = Roact.createElement(externalEventConnection, {
			event = UserInputService.LastInputTypeChanged,
			callback = self.lastInputTypeChangedCallback
		}),
		NavigationEventsLogger = Roact.createElement(module11, { pageName = "Catalog" }),
		UniversalAppCameraExposure = Roact.createElement(module35, {
			ixpTest = module46
		}),
		RelevanceRecommendationsExposure = 0,
		RecommendationsAndSearchExposure = 0,
		SortsExposure = 0,
		SearchWidgetsExposure = 0,
		OnFocusExperimentExposureLogger = 0,
		AvatarExperienceView = 0
	}

	local v22 = if not module49() then Roact.createElement(module35, {
		ixpTest = module45.RelevanceRecommendations
	}) else nil
	children.RelevanceRecommendationsExposure = v22

	local v23 = if not module51() then Roact.createElement(module35, {
		ixpTest = module45.RecommendationsAndSearch
	}) else nil
	children.RecommendationsAndSearchExposure = v23

	children.SortsExposure = (module42() or not module50())
		and Roact.createElement(module35, { ixpTest = module45.Sorts })

	children.SearchWidgetsExposure = module42()
		and Roact.createElement(module35, { ixpTest = module45.SearchWidgets })

	local createElement2 = Roact.createElement

	local v27 = if module47.isEnabled() then module47 else nil
	local v28 = if module48.isEnabled() then module48 else nil
	local v29 = if axAvatarsTabIXP.isEnabled() then axAvatarsTabIXP else nil

	local v30 = if fFlagAXBackendDrivenCatalogLayers then getBackendLayerNamesForCatalog() else nil
	local v25 = {
		ixpTests = { v27, v28, v29 },
		layers = v30,
		flagIXPTestLayers = 0
	}
	local v31

	if fFlagBasedExposureLoggingCatalogPage then
		v31 = {
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			nil
		}

		local avatarExperienceUAMarketplaceView = if defineFastFlag10 then appUserLayers.AvatarExperienceUAMarketplaceView else nil
		local avatarExperienceUAAllViews

		if fFlagAXMoveCatalogFilterToL1NavigationExposureLogging then
			avatarExperienceUAAllViews = appUserLayers.AvatarExperienceUAAllViews
		end

		local v32 = if defineFastFlag5 then defineFastString4 else nil
		local avatarExperienceUAMarketplaceView2

		if fFlagAXCatalogM41CategoriesExposureLogging then
			avatarExperienceUAMarketplaceView2 = appUserLayers.AvatarExperienceUAMarketplaceView
		end

		local avatarExperienceUAMarketplaceView3

		if fFlagAXHideMenuOnScrollExposureLogging then
			avatarExperienceUAMarketplaceView3 = appUserLayers.AvatarExperienceUAMarketplaceView
		end

		local avatarExperienceUAMarketplaceView4 = if defineFastFlag7 then appUserLayers.AvatarExperienceUAMarketplaceView else nil

		local avatarExperienceUAMarketplaceView5 = if defineFastFlag8 then appUserLayers.AvatarExperienceUAMarketplaceView else nil
		local avatarExperienceUAMarketplaceView6

		if fFlagAXMakeupCategoryPositionExperimentExposureLogging then
			avatarExperienceUAMarketplaceView6 = appUserLayers.AvatarExperienceUAMarketplaceView
		end

		local avatarExperienceUAAllViews2

		if fFlagAXCatalogItemCardDarkerBackgroundLogExposure then
			avatarExperienceUAAllViews2 = appUserLayers.AvatarExperienceUAAllViews
		end

		local v33 = if defineFastFlag9 then appUserLayers.AvatarExperienceUAAllViews else nil
		v31[1], v31[2], v31[3], v31[4], v31[5], v31[6], v31[7], v31[8], v31[9], v31[10] = avatarExperienceUAMarketplaceView, avatarExperienceUAAllViews, v32, avatarExperienceUAMarketplaceView2, avatarExperienceUAMarketplaceView3, avatarExperienceUAMarketplaceView4, avatarExperienceUAMarketplaceView5, avatarExperienceUAMarketplaceView6, avatarExperienceUAAllViews2, v33
	end

	v25.flagIXPTestLayers = v31
	children.OnFocusExperimentExposureLogger = createElement2(module36, v25)

	children.AvatarExperienceView = Roact.createElement(module19, {
		changeViewFunction = self.changeView,
		allowAdaptiveScrolling = true,
		adaptiveScrollingProps = (fFlagAXHideMenuOnScroll or fFlagAXExpandPeekViewOnFirstScroll) and {
			enableExpandPeekViewOnUpwardScroll = fFlagAXExpandPeekViewOnFirstScroll and true or nil,
			enableAnimatedVisibility = fFlagAXHideMenuOnScroll and true or nil
		} or nil,
		isDisabled = not show3dView,
		isSceneFullView = v17,
		isUIFullView = v18,
		topBar = self:renderTopBar(),
		refinementButtonsRef = self.refinementButtonsRef,
		quickButtonsRef = self.quickButtonsRef,
		[Roact.Ref] = self.sceneUIContainerRef,
		NextSelectionDown = self.defaultChildRef,
		NextSelectionLeft = self.topBarRef,
		defaultChildRef = self.defaultChildRef,
		multiTryOnBottomBarRef = self.multiTryOnBottomBarRef,
		itemDetailsPeekViewRefs = self.itemDetailsPeekViewRefs,
		showUndoRedo = true,
		showSaveButton = false
	}, {
		NavigationAndItemsList = Roact.createElement(module20, {
			defaultChildRef = self.defaultChildRef,
			defaultFocusRef = self.props.defaultFocusRef,
			NextSelectionUp = self.topBarRef,
			NextSelectionRight = v20,
			multiTryOnBottomBarRef = self.multiTryOnBottomBarRef,
			itemDetailsPeekViewRefs = self.itemDetailsPeekViewRefs
		})
	})
	return createElement(frame, v21, children)
end

local function mapStateToProps(p2)
	return {
		fullView = module32(p2, avatarScreen.Catalog),
		isPortrait = module31(p2),
		itemDetailsExpanded = p2.AvatarExperience.Common.ItemDetailsExpanded,
		tryOnManagerPeekViewState = p2.AvatarExperience.Common.ItemDetailsPeekView.tryOnManagerViewState
	}
end

local function mapDispatchToProps(callback)
	return {
		openItemPrompt = function(p2, p3, p4, p5, p6)
			callback(module25(p2, p3, p4, p5, p6))
		end,
		setItemDetailsPeekViewState = function(p2)
			callback(setItemDetailsPeekViewState(p2))
		end,
		navigateIntoQuickMenu = function(p2, p3)
			callback(module27(p2, p3))
		end,
		setFullView = function(p2, p3, p4)
			callback(module26(p2, p3, p4))
		end,
		resetNavigationHistory = function(p2)
			return callback(module33(nil, p2))
		end,
		instantResetNavigationHistory = function(p2)
			return callback(MockAppStorageService(nil, p2))
		end,
		setTryOnManagerPeekViewState = function(p2)
			callback(setTryOnManagerPeekViewState(p2))
		end,
		resetSearchCategoryAndSubcategory = function()
			if not module54.getCatalogSearchSelectionStore().changeCategory(
				module40.DefaultCatalogCategoryId,
				nil
			) then
				module59("Failed to select subcategory in ResetSearchCategoryAndSubcategory thunk")
			end
		end
	}
end

local v17 = RoactRodux.connect(mapStateToProps, mapDispatchToProps)(extended)

local v18 = roactServices.connect({
	avatarExperienceAnalytics = avatarExperienceAnalyticsService,
	networking = module10,
	appAnalytics = module9,
	avatarEditorAnalytics = module22,
	catalogAnalytics = module23
})(v17)

local v19 = module15((module13(module12((roactAppPolicy.connect(function(p2, p3)
	return { show3dView = p2.getCatalogShow3dView() }
end)(v18))), nil)))

local function CatalogPageContainer(p2)
	if not fFlagFixNavigateToCatalogMetric then
		useTTINavigationTracking("NavigateTo_Catalog")
	end

	local v20 = useRoactService(module10)
	local v21 = useDispatch()

	React.useEffect(function()
		local v22 = module5(false)

		if v22 then
			v22.getInventory(false)
		end
	end, {})

	widgetsPercievedTTIManager.Hooks.useRenderAndMountedTracking()
	local current = React.useRef(module29()).current
	local v22 = module39()

	local v23 = useRoactService(module23)
	local v24 = module16()

	local v25 = module38()
	local v26 = useAvatarRoute()

	local v27 = v26.current.name == avatarScreen.ItemDetails
	local v28 = v26.current.name == avatarScreen.LookDetails
		or v26.current.name == avatarScreen.TryOnManager

	local v29 = useShouldFetchCartPricingForPurchasePrompt((useSelector((React.useCallback(function(p3)
		if v26.current and v26.current.params then
			return itemData(
				p3.AvatarExperience.Common,
				v26.current.params.itemId,
				v26.current.params.itemType
			)
		end

		return nil
	end, { v26 })))))

	local v30 = module37(v22)

	local v31 = React.useCallback(function(p3)
		p3.cancelled = true
		module14.closeFocusedScreen(p2.navigation)
	end, { p2.navigation })

	local v32 = React.useCallback(function()
		v21(module25(v20, v23, v22, p2.navigation, v26, nil, nil, false, nil, nil, nil, v29))
	end, { v21, v20, v23, v22, p2.navigation, v26, v29 })

	local v33 = React.useCallback(function()
		p2.navigation.navigate(avatarScreen.CatalogContextMenu, {
			itemId = v26.current.params.itemId,
			itemType = v26.current.params.itemType,
			onOverlayClosed = v22
		})
	end, { p2.navigation, v26, v22 })

	local v34 = useSelector(selectTryOnManagerViewState)

	local v35 = React.useCallback(function()
		local v36 = if v34 == peekViewState.Full or v34 == peekViewState.Extended then peekViewState.Brief else peekViewState.Full
		v21(setTryOnManagerPeekViewState(v36))
	end, { v34, v21 })

	local v36 = React.useCallback(function()
		v24:fire(avatarScreen.Catalog)
	end, { v24 })

	local v37 = React.useMemo(function()
		local v38 = {
			[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
			[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack,
			[Enum.KeyCode.ButtonStart] = focusNavigationEventNameEnum.OpenQuickMenu,
			[Enum.KeyCode.ButtonX] = focusNavigationEventNameEnum.OpenBuyCatalogItemPrompt,
			[Enum.KeyCode.ButtonL3] = focusNavigationEventNameEnum.OpenCatalogContextMenu
		}
		local buttonY = Enum.KeyCode.ButtonY
		local v39 = if v28 then focusNavigationEventNameEnum.ToggleTryOnManager else focusNavigationEventNameEnum.Search
		v38[buttonY] = v39
		return v38
	end, { v28 })
	local v38

	if fFlagAXHideCatalogShortcutsInFullView then
		local v39 = not useSelector((React.useCallback(function(p3): boolean
			return module32(p3, v26.opaque.name) == fullView.SceneFullView
		end, { v26.opaque.name })))

		if not (v39 and v27) then
			v31 = nil
		end

		if not (v39 and v25) then
			v30 = nil
		end

		if not (v39 and v27) then
			v32 = nil
		end

		if not (v39 and v27) then
			v33 = nil
		end

		if not v39 then
			v36 = nil
		end

		if not (v39 and v28) then
			v35 = nil
		end

		v38 = module56(v37, {
			onNavigateBack = v31,
			onOpenQuickMenu = v30,
			onOpenBuyItemPrompt = v32,
			onOpenContextMenu = v33,
			onToggleSearch = v36,
			onToggleTryOnManager = v35
		})
	else
		if not v27 then
			v31 = nil
		end

		if not v25 then
			v30 = nil
		end

		if not v27 then
			v32 = nil
		end

		if not v27 then
			v33 = nil
		end

		if not v28 then
			v35 = nil
		end

		v38 = module56(v37, {
			onNavigateBack = v31,
			onOpenQuickMenu = v30,
			onOpenBuyItemPrompt = v32,
			onOpenContextMenu = v33,
			onToggleSearch = v36,
			onToggleTryOnManager = v35
		})
	end

	local v39 = React.useCallback(function()
		v21(module58(v20, true))
	end, { v21, v20 })

	local navigation = p2.navigation

	if v26.opaque.name ~= avatarScreen.Catalog then
		v39 = nil
	end

	useCatalogPageTimeoutPrompt(navigation, v39)

	if fFlagAXMakeupReleaseFTUX then
		local v41 = React.useCallback(function()
			module54.getCatalogSelectionStore().changeCategory(catalogCategories.Makeup:rawValue(), nil)
		end, {})

		useCatalogPageMakeupReleaseFtux(v26, p2.navigation, v41)
	end

	local v41, v42 = ReactFocusNavigation.useMostRecentOrDefaultFocusBehavior(v38)
	local v43 = useFocusOnMount(v41)

	local joined = Cryo.Dictionary.join(p2, {
		overlayClosedCallback = v22,
		androidBackButtonConnection = current,
		is10ftUI = false,
		defaultFocusRef = v43
	})

	if fFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup then
		module57()
	end

	return React.createElement(
		"Frame",
		{ BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ref = v42 },
		React.createElement(v19, joined)
	)
end

return CatalogPageContainer
