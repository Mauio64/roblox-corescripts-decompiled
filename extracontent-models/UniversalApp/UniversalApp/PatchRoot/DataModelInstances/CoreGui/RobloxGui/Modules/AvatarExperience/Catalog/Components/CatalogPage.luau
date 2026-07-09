local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local Modules = CoreGui.RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Focusable = RoactGamepad.Focusable
local Cryo = require(CorePackages.Packages.Cryo)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local ExternalEventConnection = RoactUtils.ExternalEventConnection
local isGamepadInput = RoactUtils.isGamepadInput
local useRoactService = require(CorePackages.Workspace.Packages.RobloxAppHooks).useRoactService
local Images = require(CorePackages.Packages.UIBlox).App.ImageSet.Images
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local AvatarExperienceCatalog = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)
local GetHeadShapeInventoryStore = require(Modules.AvatarExperience.AvatarRefinement.HeadRefinement.Stores.GetHeadShapeInventoryStore)
local AppPage = require(Modules.LuaApp.AppPage)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local AvatarScreenProperties = AvatarExperienceNavigation.AvatarRoute.AvatarScreenProperties
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local Analytics = require(Modules.AvatarExperience.Common.Services.Analytics)
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local NavigationEventsLogger = require(Modules.AvatarExperience.Common.Components.RoactNavigation.Debug.NavigationEventsLogger)
local withStackVisibilityWrapper = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withStackVisibilityWrapper)
local withMappedNavigationParams = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withMappedNavigationParams)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local FocusNavigationEventNameEnum = require(CorePackages.Workspace.Packages.FocusNavigationUtils).FocusNavigationEventNameEnum
local useFocusOnMount = require(CorePackages.Workspace.Packages.FocusNavigationUtils).useFocusOnMount
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local withNamedRefs = require(Modules.AvatarExperience.Common.Context.withNamedRefs)
local useTopBarSearchSignal = require(Modules.LuaApp.Context.useTopBarSearchSignal)
local makeTitleDropDown = require(Modules.AvatarExperience.Common.Components.TopBar.makeTitleDropDown)
local v45 = if not require(Modules.AvatarExperience.Flags.GetFFlagAXTransitionMenuV2)() then require(Modules.AvatarExperience.Common.Components.AXTransitionSegmentedMenu_DEPRECATED) else require(Modules.AvatarExperience.Common.Components.AXTransitionSegmentedMenu)
local makeAvatarBackButton = require(Modules.AvatarExperience.Common.Components.TopBar.makeAvatarBackButton)
local AvatarExperienceView = require(Modules.AvatarExperience.Common.Components.AvatarExperienceView)
local NavigationItemsView = require(Modules.AvatarExperience.Catalog.Components.NavigationItemsView)
local TopBar = require(Modules.LuaApp.Components.TopBar.TopBar)
local GamepadFocusHandlerForPage = require(Modules.AvatarExperience.Common.Components.GamepadFocusHandlerForPage)
local BoundInputsUpdater = require(Modules.AvatarExperience.Common.Components.BoundInputsUpdater)
local Analytics2 = require(Modules.AvatarExperience.AvatarEditor.Services.Analytics)
local Analytics3 = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local PeekViewState = require(CorePackages.Workspace.Packages.PeekView).PeekViewState
local AvatarExperienceRodux = require(CorePackages.Workspace.Packages.AvatarExperienceRodux)
local SetItemDetailsPeekViewState = AvatarExperienceRodux.Actions.SetItemDetailsPeekViewState
local SetTryOnManagerPeekViewState = AvatarExperienceRodux.Actions.SetTryOnManagerPeekViewState
local OpenItemPrompt = require(Modules.AvatarExperience.Common.Thunks.OpenItemPrompt)
local SetFullView = require(Modules.AvatarExperience.Common.Thunks.SetFullView)
local FullView = AvatarExperienceCommon.Enums.FullView
local OpenQuickMenu = require(Modules.AvatarExperience.Common.Thunks.OpenQuickMenu)
local RobloxAppEnums = require(CorePackages.Workspace.Packages.RobloxAppEnums)
local AndroidBackButtonConnection = require(Modules.LuaApp.Navigation.AndroidBackButtonConnection)
local isAvatarRouteVisible = require(Modules.AvatarExperience.Common.Components.RoactNavigation.Utils.isAvatarRouteVisible)
local selectIsPortrait = require(Modules.AvatarExperience.Common.Selectors.selectIsPortrait)
local selectIsFullView = require(Modules.AvatarExperience.Common.Selectors.selectIsFullView)
local ResetNavigationHistory = require(Modules.LuaApp.Thunks.ResetNavigationHistory)
local InstantResetNavigationHistory = require(Modules.LuaApp.Thunks.InstantResetNavigationHistory)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local OnFocusExposureLogger = require(Modules.AvatarExperience.Catalog.Components.OnFocusExposureLogger)
local OnFocusExperimentExposureLogger = require(Modules.AvatarExperience.Catalog.Components.OnFocusExperimentExposureLogger)
local useAvatarExperienceFocusNavigationBindings = require(Modules.AvatarExperience.Common.Hooks.useAvatarExperienceFocusNavigationBindings)
local useOpenQuickMenuCallback = require(Modules.AvatarExperience.Common.Hooks.useOpenQuickMenuCallback)
local useQuickMenuAvailable = require(Modules.AvatarExperience.Common.Hooks.useQuickMenuAvailable)
local useOverlayClosedCallback = require(Modules.AvatarExperience.Common.Hooks.useOverlayClosedCallback)
local useUiModeInfo = require(CorePackages.Workspace.Packages.RobloxAppHooks).useUiModeInfo
local UiMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).UiMode
local sendAXCounterV2 = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).sendAXCounterV2
local Constants = require(Modules.AvatarExperience.Common.Constants)
local IsVRAppBuild = require(CorePackages.Workspace.Packages.AppCommonLib).IsVRAppBuild
local GetFFlagAvatarAutocompleteEnabledForAll = require(Modules.AvatarExperience.Flags.GetFFlagAvatarAutocompleteEnabledForAll)
local GetFFlagLooksIXPLogging = require(Modules.AvatarExperience.Flags.GetFFlagLooksIXPLogging)
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)
local IXPServiceWrapper = require(CorePackages.Workspace.Packages.IxpServiceWrapper).IXPServiceWrapper
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagDynamicHeadsMigration = AvatarExperienceFlags.FFlagDynamicHeadsMigration
local AvatarMarketplaceBackendIXPTests = require(Modules.AvatarExperience.Flags.AvatarMarketplaceBackendIXPTests)
local UniversalAppCameraIXPTest = require(Modules.AvatarExperience.Flags.UniversalAppCameraIXPTest)
local AXDisableAlwaysRenderedScreensIXP = require(Modules.AvatarExperience.Experiments.AXDisableAlwaysRenderedScreensIXP)
local AXCatalogPerfReduxReductionIXP = require(Modules.AvatarExperience.Experiments.AXCatalogPerfReduxReductionIXP)
local AXAvatarsTabIXP = AvatarExperienceCommon.Experiments.AXAvatarsTabIXP
local getBackendLayerNamesForCatalog = AvatarExperienceCommon.Utils.getBackendLayerNamesForCatalog
local GetFFlagAXDisableRelevanceRecommendationsLayerExposure = require(Modules.AvatarExperience.Flags.GetFFlagAXDisableRelevanceRecommendationsLayerExposure)
local GetFFlagAXDisableSortsLayerExposure = require(Modules.AvatarExperience.Flags.GetFFlagAXDisableSortsLayerExposure)
local GetFFlagAXDisableRecommendationsAndSearchLayerExposure = require(Modules.AvatarExperience.Flags.GetFFlagAXDisableRecommendationsAndSearchLayerExposure)
local GetFlagAXEnableInitialTopLevelPageCounter = require(Modules.AvatarExperience.Flags.GetFlagAXEnableInitialTopLevelPageCounter)
local FFlagAXMigrateCatalogPageInputBindings = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateCatalogPageInputBindings
local GetFStringAXCatalogAndEditorExposureLayerName = require(Modules.AvatarExperience.Flags.GetFStringAXCatalogAndEditorExposureLayerName)
local FFlagAXAvatarTimeoutFlow = AvatarExperienceFlags.FFlagAXAvatarTimeoutFlow
local FFlagAXRefetchAvatarOnTimeout = AvatarExperienceFlags.FFlagAXRefetchAvatarOnTimeout
local FFlagAXMISEnableMultiShopping = AvatarExperienceFlags.FFlagAXMISEnableMultiShopping
local FFlagAXMakeupReleaseFTUX = AvatarExperienceFlags.FFlagAXMakeupReleaseFTUX
local FFlagAXOpaqueMarketplaceTopbar = AvatarExperienceFlags.FFlagAXOpaqueMarketplaceTopbar
local FFlagAXBackendDrivenCatalogLayers = AvatarExperienceFlags.FFlagAXBackendDrivenCatalogLayers
local v105 = game:DefineFastFlag("AXItemCardComponentsMemoExposure", false)
local v106 = game:DefineFastString("AXItemCardComponentsMemoLayerName", "AvatarExperience.UA.MarketplaceView")
local v107 = game:DefineFastFlag("AXEnableIXPCounters2", false)
local v108 = game:DefineFastFlag("AXCustomizeOverhaulCatalogExposure2", false)
local FFlagAXCatalogAndEditorExposureUseFStringLayer = require(Modules.AvatarExperience.Flags.FFlagAXCatalogAndEditorExposureUseFStringLayer)
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local GetCatalogCategoriesStore = require(Modules.AvatarExperience.Catalog.Stores.GetCatalogCategoriesStore)
local v112 = game:DefineFastString("AXMISExperimentLayerName", AppUserLayers.AvatarExperienceUAMarketplaceView)
local v113 = game:DefineFastFlag("AXMISExposureLogging", false)
local v114 = game:DefineFastString("AXTaxonomyM20ExperimentLayerName", AppUserLayers.AvatarExperienceUAMarketplaceView)
local FFlagAXExpandPeekViewOnFirstScroll = AvatarExperienceFlags.FFlagAXExpandPeekViewOnFirstScroll
local FFlagAXEnableCategoryPillsExposureLogging = AvatarExperienceFlags.FFlagAXEnableCategoryPillsExposureLogging
local FFlagAXHideMenuOnScroll = AvatarExperienceFlags.FFlagAXHideMenuOnScroll
local FFlagAXFixCatalogRefreshRendering = AvatarExperienceFlags.FFlagAXFixCatalogRefreshRendering
local FFlagBasedExposureLoggingCatalogPage = AvatarExperienceFlags.FFlagBasedExposureLoggingCatalogPage
local FFlagAXEnableTaxonomyM20ExposureLoggingCatalog = AvatarExperienceFlags.FFlagAXEnableTaxonomyM20ExposureLoggingCatalog
local FFlagAXMoveCatalogFilterToL1NavigationExposureLogging = AvatarExperienceFlags.FFlagAXMoveCatalogFilterToL1NavigationExposureLogging
local FFlagEnableLeftNavOnConsole = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableLeftNavOnConsole
local FFlagFlyoutNavigationInMarketplace = require(CorePackages.Workspace.Packages.SharedFlags).FFlagFlyoutNavigationInMarketplace
local FFlagEnableFlyoutSidePanel = require(Modules.LuaApp.Flags.FFlagEnableFlyoutSidePanel)
local v125 = if not FFlagFlyoutNavigationInMarketplace or not FFlagEnableFlyoutSidePanel then nil else require(Modules.AvatarExperience.Common.Components.TopBar.MeTabFlyoutLeftItem)
local FFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup = AvatarExperienceFlags.FFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup
local FFlagAXHideCatalogShortcutsInFullView = AvatarExperienceFlags.FFlagAXHideCatalogShortcutsInFullView
local v128 = game:DefineFastFlag("FFlagAXCatalogCategoriesSDUIExposureLogging", false)
local v129 = game:DefineFastString("FStringAXCatalogCategoriesSDUIExposureLayer", AppUserLayers.AvatarExperienceUAMarketplaceView)
local useTTINavigationTracking = require(CorePackages.Workspace.Packages.TTINavigationTracking).useTTINavigationTracking
local FFlagAXCatalogM41CategoriesExposureLogging = AvatarExperienceFlags.FFlagAXCatalogM41CategoriesExposureLogging
local WidgetsPercievedTTIManager = require(CorePackages.Workspace.Packages.AvatarExperienceTTIPerformance).WidgetsPercievedTTIManager
local FFlagAXHideMenuOnScrollExposureLogging = AvatarExperienceFlags.FFlagAXHideMenuOnScrollExposureLogging
local FFlagAXMakeupCategoryPositionExperimentExposureLogging = AvatarExperienceFlags.FFlagAXMakeupCategoryPositionExperimentExposureLogging
local v135 = game:DefineFastFlag("AXVirtualizedListConfigExposureLogging", false)
local FFlagAXCatalogItemCardDarkerBackgroundLogExposure = AvatarExperienceFlags.FFlagAXCatalogItemCardDarkerBackgroundLogExposure
local useCatalogPageFocusNavigationBindings = require(script.Parent.useCatalogPageFocusNavigationBindings)
local useCatalogPageRevertToLastEquippedStateHook = require(script.Parent.useCatalogPageRevertToLastEquippedStateHook)
local useCatalogPageTimeoutPrompt = AvatarExperienceCatalog.Hooks.useCatalogPageTimeoutPrompt
local useCatalogPageMakeupReleaseFtux = AvatarExperienceCatalog.Hooks.useCatalogPageMakeupReleaseFtux
local FFlagLuaAppsDefaultSelection = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppsDefaultSelection
local RefetchAvatarData = require(Modules.AvatarExperience.AvatarEditor.Thunks.RefetchAvatarData)
local mutedError = require(Modules.LuaApp.mutedError)
local v144 = Images["icons/actions/truncationExpand"]
local CatalogCategories = AvatarExperienceCommon.Enums.CatalogCategories

local function selectTryOnManagerViewState(p1) -- line: 220
	return p1.AvatarExperience.Common.ItemDetailsPeekView.tryOnManagerViewState
end
local function selectIsTryOnButtonShowing(p2) -- line: 224
	-- upvalues: Cryo (copy)
	local TryOnItems = p2.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems

	return #Cryo.Dictionary.values(TryOnItems) > 1
end

local v148 = Roact.PureComponent:extend("CatalogPage")

v148.validateProps = t.strictInterface({
	fullView = t.optional(t.userdata),
	isPortrait = t.optional(t.boolean),
	itemDetailsExpanded = t.optional(t.boolean),
	tryOnManagerPeekViewState = t.optional(t.valueOf(PeekViewState)),
	tryOnItems = t.optional(t.table),
	openItemPrompt = t.callback,
	setItemDetailsPeekViewState = t.callback,
	navigateIntoQuickMenu = t.optional(t.callback),
	setFullView = t.callback,
	resetNavigationHistory = t.callback,
	instantResetNavigationHistory = t.callback,
	setTryOnManagerPeekViewState = t.callback,
	resetSearchCategoryAndSubcategory = t.callback,
	namedRefs = t.table,
	prevNavPage = t.optional(t.string),
	prevNavHistory = t.optional(t.table),
	navigation = t.optional(t.table),
	avatarRoute = t.optional(t.table),
	avatarExperienceAnalytics = t.optional(t.table),
	networking = t.optional(t.callback),
	appAnalytics = t.optional(t.table),
	avatarEditorAnalytics = t.optional(t.table),
	catalogAnalytics = t.optional(t.table),
	show3dView = t.optional(t.boolean),
	itemId = t.optional(t.string),
	itemType = t.optional(t.string),
	isFirstItemDetails = t.optional(t.boolean),
	is10ftUI = t.boolean,
	focusController = if not FFlagAXMigrateAXToGlobalAutofocus then t.table else nil,
	androidBackButtonConnection = t.table,
	overlayClosedCallback = t.callback,
	defaultFocusRef = if not FFlagLuaAppsDefaultSelection then nil else t.optional(t.callback),
	fetchItemFailed = if not FFlagAXFixCatalogRefreshRendering then nil else t.optional(t.boolean),
	wasItemEquipped = if not FFlagAXFixCatalogRefreshRendering then nil else t.optional(t.boolean),
	category = t.optional(t.string),
	subcategory = t.optional(t.string),
	taxonomy = t.optional(t.string)
})

function v148.init(p3) -- line: 292
	-- upvalues: Roact (copy), RoactGamepad (copy), UserInputService (copy), isGamepadInput (copy), Utils (copy), AvatarScreen (copy), FullView (copy), FFlagAXExpandPeekViewOnFirstScroll (copy), AppPage (copy), makeTitleDropDown (copy), makeAvatarBackButton (copy), GetFFlagAvatarAutocompleteEnabledForAll (copy), GetFlagAXEnableInitialTopLevelPageCounter (copy), sendAXCounterV2 (copy), Constants (copy), FFlagAXEnableCategoryPillsExposureLogging (copy), IXPServiceWrapper (copy), AppUserLayers (copy), FFlagAXEnableTaxonomyM20ExposureLoggingCatalog (copy), v114 (copy)
	p3.topBarRef = Roact.createRef()
	p3.sceneUIContainerRef = Roact.createRef()
	p3.titleDropDownRef = Roact.createRef()
	p3.topBarRenderRightRef = Roact.createRef()
	p3.refinementButtonsRef = Roact.createRef()
	p3.multiTryOnBottomBarRef = Roact.createRef()
	p3.quickButtonsRef = Roact.createRef()
	p3.itemDetailsPeekViewRefs = RoactGamepad.createRefCache()

	local LastInputType = UserInputService:GetLastInputType()

	p3:setState({
		lastInputIsGamepad = isGamepadInput(LastInputType)
	})

	function p3.setDefaultRefOverride(p4) -- line: 309
		-- upvalues: p3 (copy), Roact (copy)
		p3:setState({
			defaultRefOverride = p4 or Roact.None
		})
	end
	function p3.changeView() -- line: 315
		-- upvalues: p3 (copy), Utils (copy)
		local avatarExperienceAnalytics = p3.props.avatarExperienceAnalytics
		local v227 = Utils.getNewFullViewEnum(p3.props.fullView)

		p3.props.setFullView(avatarExperienceAnalytics, p3.props.avatarRoute.opaque.name, v227)
	end
	function p3.setUIFullView() -- line: 322
		-- upvalues: p3 (copy), AvatarScreen (copy), FullView (copy)
		local avatarExperienceAnalytics = p3.props.avatarExperienceAnalytics

		if p3.props.isPortrait then
			p3.props.setFullView(avatarExperienceAnalytics, AvatarScreen.CatalogSearch, FullView.UIFullView)
		end
	end
	function p3.isAvatarScreen(p5) -- line: 330
		-- upvalues: AvatarScreen (copy)
		return (rawget(AvatarScreen, p5))
	end
	function p3.topBarBackButtonActivated() -- line: 334
		-- upvalues: FFlagAXExpandPeekViewOnFirstScroll (copy), p3 (copy), FullView (copy), AvatarScreen (copy), AppPage (copy)
		if FFlagAXExpandPeekViewOnFirstScroll and p3.props.fullView == FullView.UIFullView then
			local avatarExperienceAnalytics = p3.props.avatarExperienceAnalytics

			p3.props.setFullView(avatarExperienceAnalytics, p3.props.avatarRoute.opaque.name, FullView.None)

			return
		end

		local navigation = p3.props.navigation
		local avatarEditorAnalytics = p3.props.avatarEditorAnalytics
		local prevNavPage = p3.props.prevNavPage
		local prevNavHistory = p3.props.prevNavHistory

		if prevNavPage and prevNavHistory then
			if p3.isAvatarScreen(prevNavPage) then
				p3.props.navigation.navigate(prevNavPage)
			else
				p3.props.resetNavigationHistory(prevNavHistory)
			end
		else
			local v235 = if not p3.props.is10ftUI then AppPage.Home else AvatarScreen.AvatarExperienceLandingPage

			navigation.navigate(v235)
		end

		avatarEditorAnalytics.catalogToAvatarBackButton()
	end

	p3.defaultChildRef = Roact.createRef()

	function p3.lastInputTypeChangedCallback(p6) -- line: 362
		-- upvalues: isGamepadInput (copy), p3 (copy)
		local v237 = isGamepadInput(p6)

		if v237 ~= p3.state.lastInputIsGamepad then
			p3:setState({
				lastInputIsGamepad = v237
			})
		end
	end

	p3.titleDropDown = makeTitleDropDown("Feature.Avatar.Action.Marketplace", p3.props.overlayClosedCallback)
	p3.backButton = makeAvatarBackButton(p3.topBarBackButtonActivated)

	function p3.onConfirmSearchCallback() -- line: 375
		-- upvalues: p3 (copy), GetFFlagAvatarAutocompleteEnabledForAll (copy)
		p3.props.resetSearchCategoryAndSubcategory()

		if GetFFlagAvatarAutocompleteEnabledForAll() and p3.setUIFullView then
			p3.setUIFullView()
		end
	end

	if GetFlagAXEnableInitialTopLevelPageCounter() then
		sendAXCounterV2(Constants.Counter.TopLevelPageInitialView.Catalog)
	end

	if FFlagAXEnableCategoryPillsExposureLogging then
		IXPServiceWrapper:LogFlagLinkedUserLayerExposure(AppUserLayers.AvatarExperienceUAAllViews)
	end

	if FFlagAXEnableTaxonomyM20ExposureLoggingCatalog then
		IXPServiceWrapper:LogFlagLinkedUserLayerExposure(v114)
	end
end
function v148.getBestDefaultRefForPage(p7) -- line: 397
	if p7.state.defaultRefOverride then
		return p7.state.defaultRefOverride
	end

	return p7.defaultChildRef
end

if not FFlagAXMigrateCatalogPageInputBindings then
	function v148.getInputBindings(p8) -- line: 406
		-- upvalues: AvatarScreenProperties (copy), Cryo (copy), AvatarScreen (copy), FFlagAXMISEnableMultiShopping (copy), RoactGamepad (copy), NavigationUtils (copy), PeekViewState (copy)
		local avatarRoute = p8.props.avatarRoute
		local name = avatarRoute.current.name
		local isMultiTryOn = AvatarScreenProperties[avatarRoute.opaque.name].isMultiTryOn
		local v165 = #Cryo.Dictionary.values(p8.props.tryOnItems) > 1
		local t1 = {
			OpenTryOnManager = if name == AvatarScreen.TryOnManager or (not isMultiTryOn and not FFlagAXMISEnableMultiShopping or not v165) then nil else RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonY, function() -- line: 416
				-- upvalues: NavigationUtils (copy), p8 (copy), AvatarScreen (copy)
				NavigationUtils.closeFiltersAndItemDetails(p8.props.navigation)
				p8.props.navigation.navigate(AvatarScreen.TryOnManager)
			end, {
				key = "Feature.Catalog.Label.TryOns"
			})
		}

		if name == AvatarScreen.ItemDetails then
			return (Cryo.Dictionary.join(t1, {
				NavigateBack = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonB, function() -- line: 427
					-- upvalues: NavigationUtils (copy), p8 (copy)
					NavigationUtils.closeFocusedScreen(p8.props.navigation)
				end),
				OpenItemPrompt = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonX, function() -- line: 430
					-- upvalues: p8 (copy), avatarRoute (copy)
					p8.props.openItemPrompt(p8.props.networking, p8.props.catalogAnalytics, p8.props.overlayClosedCallback, p8.props.navigation, avatarRoute)
				end, {
					key = "Feature.Catalog.Action.Buy"
				}),
				OpenCatalogContextMenu = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonL3, function() -- line: 441
					-- upvalues: p8 (copy), AvatarScreen (copy), avatarRoute (copy)
					p8.props.navigation.navigate(AvatarScreen.CatalogContextMenu, {
						itemId = avatarRoute.current.params.itemId,
						itemType = avatarRoute.current.params.itemType,
						onOverlayClosed = p8.props.overlayClosedCallback
					})
				end, {
					key = "Feature.Catalog.Action.ItemOptions"
				})
			}))
		end

		if name == AvatarScreen.TryOnManager then
			return (Cryo.Dictionary.join(t1, {
				OpenCloseTryOnManager = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonY, function() -- line: 453
					-- upvalues: p8 (copy), PeekViewState (copy)
					local tryOnManagerPeekViewState = p8.props.tryOnManagerPeekViewState

					if tryOnManagerPeekViewState == PeekViewState.Full or tryOnManagerPeekViewState == PeekViewState.Extended then
						p8.props.setTryOnManagerPeekViewState(PeekViewState.Brief)

						return
					end

					p8.props.setTryOnManagerPeekViewState(PeekViewState.Full)
				end, {
					key = "Feature.Catalog.Label.TryOns"
				})
			}))
		end

		if name == AvatarScreen.LookDetails then
			t1 = Cryo.Dictionary.join(t1, {
				OpenCloseTryOnManager = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonY, function() -- line: 466
					-- upvalues: p8 (copy), PeekViewState (copy)
					local tryOnManagerPeekViewState = p8.props.tryOnManagerPeekViewState

					if tryOnManagerPeekViewState == PeekViewState.Full or tryOnManagerPeekViewState == PeekViewState.Extended then
						p8.props.setTryOnManagerPeekViewState(PeekViewState.Brief)

						return
					end

					p8.props.setTryOnManagerPeekViewState(PeekViewState.Full)
				end, {
					key = "Feature.Catalog.Label.TryOns"
				})
			})
		end

		return t1
	end
end

if v107 then
	function v148.sendExperimentCountersOnce(_) -- line: 484
	end
end

function v148.didMount(p10) -- line: 487
	-- upvalues: isAvatarRouteVisible (copy), v107 (copy), v108 (copy), IxpUtils (copy), FFlagAXCatalogAndEditorExposureUseFStringLayer (copy), GetFStringAXCatalogAndEditorExposureLayerName (copy), AppUserLayers (copy), v113 (copy), IXPServiceWrapper (copy), v112 (copy), v105 (copy), v106 (copy)
	if not p10.props.is10ftUI and isAvatarRouteVisible(p10.props) then
		p10.props.androidBackButtonConnection.connect(p10.topBarBackButtonActivated)
	end

	if v107 then
		p10:sendExperimentCountersOnce()
	end

	if v108 then
		IxpUtils.logLayerExposure(if not FFlagAXCatalogAndEditorExposureUseFStringLayer then AppUserLayers.AvatarExperienceUAAllViews else GetFStringAXCatalogAndEditorExposureLayerName())
	end

	if v113 then
		IXPServiceWrapper:LogFlagLinkedUserLayerExposure(v112)
	end

	if v105 then
		IXPServiceWrapper:LogFlagLinkedUserLayerExposure(v106)
	end
end
function v148.willUnmount(p11) -- line: 515
	p11.props.androidBackButtonConnection.disconnect()
end
function v148.didUpdate(p12, p13) -- line: 519
	-- upvalues: isAvatarRouteVisible (copy)
	if not p12.props.is10ftUI then
		if not isAvatarRouteVisible(p13) and isAvatarRouteVisible(p12.props) then
			p12.props.androidBackButtonConnection.connect(p12.topBarBackButtonActivated)

			return
		end

		if isAvatarRouteVisible(p13) and not isAvatarRouteVisible(p12.props) then
			p12.props.androidBackButtonConnection.disconnect()
		end
	end
end
function v148.willUpdate(p14, p15) -- line: 529
	-- upvalues: FFlagAXExpandPeekViewOnFirstScroll (copy), makeAvatarBackButton (copy)
	if FFlagAXExpandPeekViewOnFirstScroll and p15.fullView ~= p14.props.fullView then
		p14.backButton = makeAvatarBackButton(p14.topBarBackButtonActivated, p14:getBackButtonIcon(p15.fullView))
	end
end

if FFlagAXExpandPeekViewOnFirstScroll then
	function v148.getBackButtonIcon(p16, p17) -- line: 537
		-- upvalues: FullView (copy), v144 (copy)
		if not p17 then
			p17 = p16.props.fullView
		end

		if p17 == FullView.UIFullView then
			return v144
		end

		return nil
	end
end

function v148.renderTopBar(p18) -- line: 551
	-- upvalues: withLocalization (copy), GetFFlagAvatarAutocompleteEnabledForAll (copy), IsVRAppBuild (copy), FFlagFlyoutNavigationInMarketplace (copy), FFlagEnableFlyoutSidePanel (copy), v125 (copy), v45 (copy), TopBar (copy), Roact (copy), RobloxAppEnums (copy), FFlagAXOpaqueMarketplaceTopbar (copy), FFlagEnableLeftNavOnConsole (copy)
	local isPortrait = p18.props.isPortrait
	local show3dView = p18.props.show3dView

	return withLocalization({
		title = "Feature.Avatar.Action.Marketplace"
	})(function(p19) -- line: 557
		-- upvalues: GetFFlagAvatarAutocompleteEnabledForAll (copy), IsVRAppBuild (copy), FFlagFlyoutNavigationInMarketplace (copy), FFlagEnableFlyoutSidePanel (copy), v125 (copy), p18 (copy), v45 (copy), TopBar (copy), Roact (copy), RobloxAppEnums (copy), FFlagAXOpaqueMarketplaceTopbar (copy), FFlagEnableLeftNavOnConsole (copy), isPortrait (copy), show3dView (copy)
		local n1 = 2

		if GetFFlagAvatarAutocompleteEnabledForAll() then
			n1 = 3
		end

		local v242, v243, v244

		if IsVRAppBuild() then
			v242 = nil
			v243 = nil
			v244 = nil
		else
			v243 = if not FFlagFlyoutNavigationInMarketplace or not FFlagEnableFlyoutSidePanel then p18.backButton else v125
			v242 = if not p18.props.is10ftUI then v45 else p18.titleDropDown
			v244 = { TopBar.SearchButton }
		end

		return Roact.createElement(TopBar.Container, {
			forceCompactMode = true,
			searchType = RobloxAppEnums.SearchTypes.Catalog,
			titleText = p19.title,
			ZIndex = n1,
			transparentBackground = if not FFlagAXOpaqueMarketplaceTopbar and not FFlagEnableLeftNavOnConsole or isPortrait then show3dView else false,
			hideSiteMessageBanner = isPortrait,
			[Roact.Ref] = p18.topBarRef,
			setDefaultRefOverride = p18.setDefaultRefOverride,
			NextSelectionDown = p18.defaultChildRef,
			NextSelectionRight = p18.sceneUIContainerRef,
			onConfirmSearchCallback = p18.onConfirmSearchCallback,
			leftItem = v243,
			centerItem = v242,
			rightItems = v244,
			useParentSizeForCenterItem = true,
			shouldNavigateToSearchLandingPage = true
		})
	end)
end
function v148.render(p20) -- line: 605
	-- upvalues: FullView (copy), AvatarScreen (copy), Roact (copy), Focusable (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), FFlagAXMigrateCatalogPageInputBindings (copy), BoundInputsUpdater (copy), ExternalEventConnection (copy), UserInputService (copy), NavigationEventsLogger (copy), OnFocusExposureLogger (copy), UniversalAppCameraIXPTest (copy), GetFFlagAXDisableRelevanceRecommendationsLayerExposure (copy), AvatarMarketplaceBackendIXPTests (copy), GetFFlagAXDisableRecommendationsAndSearchLayerExposure (copy), GetFFlagLooksIXPLogging (copy), GetFFlagAXDisableSortsLayerExposure (copy), OnFocusExperimentExposureLogger (copy), AXDisableAlwaysRenderedScreensIXP (copy), AXCatalogPerfReduxReductionIXP (copy), AXAvatarsTabIXP (copy), FFlagAXBackendDrivenCatalogLayers (copy), getBackendLayerNamesForCatalog (copy), FFlagBasedExposureLoggingCatalogPage (copy), FFlagAXMoveCatalogFilterToL1NavigationExposureLogging (copy), AppUserLayers (copy), v128 (copy), v129 (copy), FFlagAXCatalogM41CategoriesExposureLogging (copy), FFlagAXHideMenuOnScrollExposureLogging (copy), v135 (copy), FFlagAXMakeupCategoryPositionExperimentExposureLogging (copy), FFlagAXCatalogItemCardDarkerBackgroundLogExposure (copy), AvatarExperienceView (copy), FFlagAXHideMenuOnScroll (copy), FFlagAXExpandPeekViewOnFirstScroll (copy), GamepadFocusHandlerForPage (copy), NavigationItemsView (copy), FFlagLuaAppsDefaultSelection (copy)
	local v180 = p20.props.fullView == FullView.SceneFullView
	local v181 = p20.props.fullView == FullView.UIFullView
	local show3dView = p20.props.show3dView
	local namedRefs = p20.props.namedRefs
	local v184 = p20.props.avatarRoute.current.name == AvatarScreen.SortAndFilters
	local quickButtonsRef = p20.quickButtonsRef

	if p20.props.avatarRoute.current.name == AvatarScreen.TryOnManager then
		quickButtonsRef = namedRefs[AvatarScreen.TryOnManager]
	elseif p20.props.avatarRoute.current.name == AvatarScreen.LookDetails then
		quickButtonsRef = namedRefs[AvatarScreen.LookDetails]
	elseif v184 then
		quickButtonsRef = namedRefs[AvatarScreen.SortAndFilters]
	end

	return Roact.createElement(Focusable.Frame, {
		BackgroundTransparency = 1,
		restorePreviousChildFocus = false,
		Size = UDim2.new(1, 0, 1, 0),
		focusController = if not FFlagAXMigrateAXToGlobalAutofocus then p20.props.focusController else nil,
		defaultChild = p20:getBestDefaultRefForPage(),
		inputBindings = if not FFlagAXMigrateCatalogPageInputBindings then p20:getInputBindings() else nil,
		ref = namedRefs[AvatarScreen.Catalog]
	}, {
		BoundInputsUpdater = if not FFlagAXMigrateAXToGlobalAutofocus then Roact.createElement(BoundInputsUpdater) else nil,
		LastInputTypeChangedConnection = Roact.createElement(ExternalEventConnection, {
			event = UserInputService.LastInputTypeChanged,
			callback = p20.lastInputTypeChangedCallback
		}),
		NavigationEventsLogger = Roact.createElement(NavigationEventsLogger, {
			pageName = "Catalog"
		}),
		UniversalAppCameraExposure = Roact.createElement(OnFocusExposureLogger, {
			ixpTest = UniversalAppCameraIXPTest
		}),
		RelevanceRecommendationsExposure = if not GetFFlagAXDisableRelevanceRecommendationsLayerExposure() then Roact.createElement(OnFocusExposureLogger, {
			ixpTest = AvatarMarketplaceBackendIXPTests.RelevanceRecommendations
		}) else nil,
		RecommendationsAndSearchExposure = if not GetFFlagAXDisableRecommendationsAndSearchLayerExposure() then Roact.createElement(OnFocusExposureLogger, {
			ixpTest = AvatarMarketplaceBackendIXPTests.RecommendationsAndSearch
		}) else nil,
		SortsExposure = (GetFFlagLooksIXPLogging() or not GetFFlagAXDisableSortsLayerExposure()) and Roact.createElement(OnFocusExposureLogger, {
			ixpTest = AvatarMarketplaceBackendIXPTests.Sorts
		}),
		SearchWidgetsExposure = GetFFlagLooksIXPLogging() and Roact.createElement(OnFocusExposureLogger, {
			ixpTest = AvatarMarketplaceBackendIXPTests.SearchWidgets
		}),
		OnFocusExperimentExposureLogger = Roact.createElement(OnFocusExperimentExposureLogger, {
			ixpTests = {
				if not AXDisableAlwaysRenderedScreensIXP.isEnabled() then nil else AXDisableAlwaysRenderedScreensIXP,
				if not AXCatalogPerfReduxReductionIXP.isEnabled() then nil else AXCatalogPerfReduxReductionIXP,
				if not AXAvatarsTabIXP.isEnabled() then nil else AXAvatarsTabIXP
			},
			layers = if not FFlagAXBackendDrivenCatalogLayers then nil else getBackendLayerNamesForCatalog(),
			flagIXPTestLayers = if not FFlagBasedExposureLoggingCatalogPage then nil else {
				if not FFlagAXMoveCatalogFilterToL1NavigationExposureLogging then nil else AppUserLayers.AvatarExperienceUAAllViews,
				if not v128 then nil else v129,
				if not FFlagAXCatalogM41CategoriesExposureLogging then nil else AppUserLayers.AvatarExperienceUAMarketplaceView,
				if not FFlagAXHideMenuOnScrollExposureLogging then nil else AppUserLayers.AvatarExperienceUAMarketplaceView,
				if not v135 then nil else AppUserLayers.AvatarExperienceUAMarketplaceView,
				if not FFlagAXMakeupCategoryPositionExperimentExposureLogging then nil else AppUserLayers.AvatarExperienceUAMarketplaceView,
				if not FFlagAXCatalogItemCardDarkerBackgroundLogExposure then nil else AppUserLayers.AvatarExperienceUAAllViews
			}
		}),
		AvatarExperienceView = Roact.createElement(AvatarExperienceView, {
			changeViewFunction = p20.changeView,
			allowAdaptiveScrolling = true,
			adaptiveScrollingProps = if not FFlagAXHideMenuOnScroll and not FFlagAXExpandPeekViewOnFirstScroll then nil else {
				enableExpandPeekViewOnUpwardScroll = not not FFlagAXExpandPeekViewOnFirstScroll or nil,
				enableAnimatedVisibility = not not FFlagAXHideMenuOnScroll or nil
			},
			isDisabled = not show3dView,
			isSceneFullView = v180,
			isUIFullView = v181,
			topBar = p20:renderTopBar(),
			refinementButtonsRef = p20.refinementButtonsRef,
			quickButtonsRef = p20.quickButtonsRef,
			[Roact.Ref] = p20.sceneUIContainerRef,
			NextSelectionDown = p20.defaultChildRef,
			NextSelectionLeft = p20.topBarRef,
			defaultChildRef = p20.defaultChildRef,
			multiTryOnBottomBarRef = p20.multiTryOnBottomBarRef,
			itemDetailsPeekViewRefs = p20.itemDetailsPeekViewRefs,
			showUndoRedo = true,
			showSaveButton = false
		}, {
			GamepadFocusHandlerForPage = if not FFlagAXMigrateAXToGlobalAutofocus then Roact.createElement(GamepadFocusHandlerForPage, {
				captureFocusOnMount = true,
				focusController = p20.props.focusController
			}) else nil,
			NavigationAndItemsList = Roact.createElement(NavigationItemsView, {
				defaultChildRef = p20.defaultChildRef,
				defaultFocusRef = if not FFlagLuaAppsDefaultSelection then nil else p20.props.defaultFocusRef,
				NextSelectionUp = p20.topBarRef,
				NextSelectionRight = quickButtonsRef,
				multiTryOnBottomBarRef = p20.multiTryOnBottomBarRef,
				itemDetailsPeekViewRefs = p20.itemDetailsPeekViewRefs
			})
		})
	})
end

local function mapStateToProps(p21) -- line: 742
	-- upvalues: selectIsFullView (copy), AvatarScreen (copy), selectIsPortrait (copy), FFlagAXMigrateCatalogPageInputBindings (copy)
	return {
		fullView = selectIsFullView(p21, AvatarScreen.Catalog),
		isPortrait = selectIsPortrait(p21),
		itemDetailsExpanded = p21.AvatarExperience.Common.ItemDetailsExpanded,
		tryOnManagerPeekViewState = p21.AvatarExperience.Common.ItemDetailsPeekView.tryOnManagerViewState,
		tryOnItems = if not FFlagAXMigrateCatalogPageInputBindings then p21.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems else nil
	}
end
local function mapDispatchToProps(p22: ((...any) -> ...any)) -- line: 754
	-- upvalues: OpenItemPrompt (copy), SetItemDetailsPeekViewState (copy), OpenQuickMenu (copy), SetFullView (copy), ResetNavigationHistory (copy), InstantResetNavigationHistory (copy), SetTryOnManagerPeekViewState (copy), GetCatalogCategoriesStore (copy), Constants (copy), mutedError (copy)
	return {
		openItemPrompt = function(p23, p24, p25, p26, p27) -- line: 756
			-- upvalues: p22 (copy), OpenItemPrompt (copy)
			p22(OpenItemPrompt(p23, p24, p25, p26, p27))
		end,
		setItemDetailsPeekViewState = function(p28) -- line: 759
			-- upvalues: p22 (copy), SetItemDetailsPeekViewState (copy)
			p22(SetItemDetailsPeekViewState(p28))
		end,
		navigateIntoQuickMenu = function(p29, p30) -- line: 762
			-- upvalues: p22 (copy), OpenQuickMenu (copy)
			p22(OpenQuickMenu(p29, p30))
		end,
		setFullView = function(p31, p32, p33) -- line: 765
			-- upvalues: p22 (copy), SetFullView (copy)
			p22(SetFullView(p31, p32, p33))
		end,
		resetNavigationHistory = function(p34) -- line: 768
			-- upvalues: p22 (copy), ResetNavigationHistory (copy)
			return p22(ResetNavigationHistory(nil, p34))
		end,
		instantResetNavigationHistory = function(p35) -- line: 771
			-- upvalues: p22 (copy), InstantResetNavigationHistory (copy)
			return p22(InstantResetNavigationHistory(nil, p35))
		end,
		setTryOnManagerPeekViewState = function(p36) -- line: 774
			-- upvalues: p22 (copy), SetTryOnManagerPeekViewState (copy)
			p22(SetTryOnManagerPeekViewState(p36))
		end,
		resetSearchCategoryAndSubcategory = function() -- line: 777
			-- upvalues: GetCatalogCategoriesStore (copy), Constants (copy), mutedError (copy)
			if not GetCatalogCategoriesStore.getCatalogSearchSelectionStore().changeCategory(Constants.DefaultCatalogCategoryId, nil) then
				mutedError("Failed to select subcategory in ResetSearchCategoryAndSubcategory thunk")
			end
		end
	}
end

local v151 = RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v148)
local v152 = RoactServices.connect({
	avatarExperienceAnalytics = Analytics,
	networking = RoactNetworking,
	appAnalytics = RoactAnalytics,
	avatarEditorAnalytics = Analytics2,
	catalogAnalytics = Analytics3
})(v151)
local u153 = withNamedRefs((withMappedNavigationParams(withStackVisibilityWrapper((RoactAppPolicy.connect(function(p37, _) -- line: 797
	return {
		show3dView = p37.getCatalogShow3dView()
	}
end)(v152))), nil)))

local function CatalogPageContainer(p39) -- line: 809
	-- upvalues: SharedFlags (copy), useTTINavigationTracking (copy), FFlagAXRefetchAvatarOnTimeout (copy), useRoactService (copy), RoactNetworking (copy), useDispatch (copy), FFlagDynamicHeadsMigration (copy), React (copy), GetHeadShapeInventoryStore (copy), WidgetsPercievedTTIManager (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), RoactGamepad (copy), AndroidBackButtonConnection (copy), useOverlayClosedCallback (copy), FFlagAXMigrateCatalogPageInputBindings (copy), Analytics3 (copy), useTopBarSearchSignal (copy), useQuickMenuAvailable (copy), useAvatarRoute (copy), AvatarScreen (copy), AvatarScreenProperties (copy), useSelector (copy), selectIsTryOnButtonShowing (copy), useOpenQuickMenuCallback (copy), NavigationUtils (copy), OpenItemPrompt (copy), selectTryOnManagerViewState (copy), PeekViewState (copy), SetTryOnManagerPeekViewState (copy), FocusNavigationEventNameEnum (copy), FFlagAXHideCatalogShortcutsInFullView (copy), selectIsFullView (copy), FullView (copy), useCatalogPageFocusNavigationBindings (copy), useAvatarExperienceFocusNavigationBindings (copy), FFlagAXAvatarTimeoutFlow (copy), RefetchAvatarData (copy), useCatalogPageTimeoutPrompt (copy), FFlagAXMakeupReleaseFTUX (copy), GetCatalogCategoriesStore (copy), CatalogCategories (copy), useCatalogPageMakeupReleaseFtux (copy), FFlagLuaAppsDefaultSelection (copy), ReactFocusNavigation (copy), useFocusOnMount (copy), Cryo (copy), useUiModeInfo (copy), UiMode (copy), FFlagEnableLeftNavOnConsole (copy), FFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup (copy), useCatalogPageRevertToLastEquippedStateHook (copy), u153 (ref)
	if SharedFlags.FFlagLuaAppNavigationTTITracking then
		useTTINavigationTracking("NavigateTo_Catalog")
	end

	local u191 = nil
	local u192 = nil

	if FFlagAXRefetchAvatarOnTimeout then
		u191 = useRoactService(RoactNetworking)
		u192 = useDispatch()
	end

	if FFlagDynamicHeadsMigration then
		React.useEffect(function() -- line: 822
			-- upvalues: GetHeadShapeInventoryStore (copy)
			local v259 = GetHeadShapeInventoryStore(false)

			if v259 then
				v259.getInventory(false)
			end
		end, {})
	end

	WidgetsPercievedTTIManager.Hooks.useRenderAndMountedTracking()

	local v193 = if not FFlagAXMigrateAXToGlobalAutofocus then React.useRef(RoactGamepad.createFocusController()).current else nil
	local current = React.useRef(AndroidBackButtonConnection()).current
	local v195 = useOverlayClosedCallback(if not FFlagAXMigrateAXToGlobalAutofocus then v193 else nil)
	local v216

	if FFlagAXMigrateCatalogPageInputBindings then
		if not FFlagAXRefetchAvatarOnTimeout then
			u191 = useRoactService(RoactNetworking)
			u192 = useDispatch()
		end

		local v196 = useRoactService(Analytics3)
		local v197 = useTopBarSearchSignal()
		local v198 = useQuickMenuAvailable()
		local v199 = useAvatarRoute()
		local v200 = v199.current.name == AvatarScreen.ItemDetails
		local v201 = v199.current.name == AvatarScreen.LookDetails or v199.current.name == AvatarScreen.TryOnManager
		local isMultiTryOn = AvatarScreenProperties[v199.opaque.name].isMultiTryOn
		local v203 = useSelector(selectIsTryOnButtonShowing)
		local v204 = v199.current.name ~= AvatarScreen.TryOnManager and (isMultiTryOn and v203)
		local v205 = useOpenQuickMenuCallback(v195)
		local v206 = React.useCallback(function(p40) -- line: 864
			-- upvalues: NavigationUtils (copy), p39 (copy)
			p40.cancelled = true
			NavigationUtils.closeFocusedScreen(p39.navigation)
		end, { p39.navigation })
		local v207 = React.useCallback(function() -- line: 870
			-- upvalues: u192 (ref), OpenItemPrompt (copy), u191 (ref), v196 (copy), v195 (copy), p39 (copy), v199 (copy)
			u192(OpenItemPrompt(u191, v196, v195, p39.navigation, v199))
		end, {
			u192,
			u191,
			v196,
			v195,
			p39.navigation,
			v199
		})
		local v208 = React.useCallback(function() -- line: 886
			-- upvalues: p39 (copy), AvatarScreen (copy), v199 (copy), v195 (copy)
			p39.navigation.navigate(AvatarScreen.CatalogContextMenu, {
				itemId = v199.current.params.itemId,
				itemType = v199.current.params.itemType,
				onOverlayClosed = v195
			})
		end, {
			p39.navigation,
			v199,
			v195
		})
		local v209 = useSelector(selectTryOnManagerViewState)
		local v210 = React.useCallback(function() -- line: 896
			-- upvalues: v209 (copy), PeekViewState (copy), u192 (ref), SetTryOnManagerPeekViewState (copy)
			local v261 = if v209 ~= PeekViewState.Full and v209 ~= PeekViewState.Extended then PeekViewState.Full else PeekViewState.Brief

			u192(SetTryOnManagerPeekViewState(v261))
		end, {
			v209,
			u192
		})
		local v211 = React.useCallback(function() -- line: 904
			-- upvalues: NavigationUtils (copy), p39 (copy), AvatarScreen (copy)
			NavigationUtils.closeFiltersAndItemDetails(p39.navigation)
			p39.navigation.navigate(AvatarScreen.TryOnManager)
		end, { p39.navigation })
		local v212 = React.useCallback(function() -- line: 909
			-- upvalues: v197 (copy), AvatarScreen (copy)
			v197:fire(AvatarScreen.Catalog)
		end, { v197 })
		local v213 = React.useMemo(function() -- line: 913
			-- upvalues: FocusNavigationEventNameEnum (copy), v201 (copy), v204 (copy)
			return {
				[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
				[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack,
				[Enum.KeyCode.ButtonStart] = FocusNavigationEventNameEnum.OpenQuickMenu,
				[Enum.KeyCode.ButtonX] = FocusNavigationEventNameEnum.OpenBuyCatalogItemPrompt,
				[Enum.KeyCode.ButtonL3] = FocusNavigationEventNameEnum.OpenCatalogContextMenu,
				[Enum.KeyCode.ButtonY] = if not v201 and not v204 then FocusNavigationEventNameEnum.Search else FocusNavigationEventNameEnum.ToggleTryOnManager
			}
		end, {
			v201,
			v204
		})

		if FFlagAXHideCatalogShortcutsInFullView then
			local v214 = React.useCallback(function(p41) -- line: 927
				-- upvalues: selectIsFullView (copy), v199 (copy), FullView (copy)
				return selectIsFullView(p41, v199.opaque.name) == FullView.SceneFullView
			end, { v199.opaque.name })
			local v215 = not useSelector(v214)

			v216 = useCatalogPageFocusNavigationBindings(v213, {
				onNavigateBack = if not v215 or not v200 then nil else v206,
				onOpenQuickMenu = if not v215 or not v198 then nil else v205,
				onOpenBuyItemPrompt = if not v215 or not v200 then nil else v207,
				onOpenContextMenu = if not v215 or not v200 then nil else v208,
				onToggleSearch = if not v215 then nil else v212,
				onToggleTryOnManager = if not v215 or not v201 then if not v204 then nil else v211 else v210
			})
		else
			v216 = useCatalogPageFocusNavigationBindings(v213, {
				onNavigateBack = if not v200 then nil else v206,
				onOpenQuickMenu = if not v198 then nil else v205,
				onOpenBuyItemPrompt = if not v200 then nil else v207,
				onOpenContextMenu = if not v200 then nil else v208,
				onToggleSearch = v212,
				onToggleTryOnManager = if not v201 then if not v204 then nil else v211 else v210
			})
		end
	else
		v216 = useAvatarExperienceFocusNavigationBindings({
			overlayClosedCallback = v195
		})
	end

	if FFlagAXAvatarTimeoutFlow then
		local v217 = useAvatarRoute()
		local v218 = if not FFlagAXRefetchAvatarOnTimeout then nil else React.useCallback(function() -- line: 967
			-- upvalues: u192 (ref), RefetchAvatarData (copy), u191 (ref)
			u192(RefetchAvatarData(u191, true))
		end, {
			u192,
			u191
		})

		useCatalogPageTimeoutPrompt(p39.navigation, if not FFlagAXRefetchAvatarOnTimeout or v217.opaque.name ~= AvatarScreen.Catalog then nil else v218)
	end

	if FFlagAXMakeupReleaseFTUX then
		local v219 = useAvatarRoute()
		local v220 = React.useCallback(function() -- line: 982
			-- upvalues: GetCatalogCategoriesStore (copy), CatalogCategories (copy)
			GetCatalogCategoriesStore.getCatalogSelectionStore().changeCategory(CatalogCategories.Makeup:rawValue(), nil)
		end, {})

		useCatalogPageMakeupReleaseFtux(v219, p39.navigation, v220)
	end

	local v221 = nil
	local v222 = nil

	if FFlagLuaAppsDefaultSelection then
		local v223

		v223, v222 = ReactFocusNavigation.useMostRecentOrDefaultFocusBehavior(v216)
		v221 = useFocusOnMount(v223)
	end

	local v224 = Cryo.Dictionary.join(p39, {
		focusController = if not FFlagAXMigrateAXToGlobalAutofocus then v193 else nil,
		overlayClosedCallback = v195,
		androidBackButtonConnection = current,
		is10ftUI = useUiModeInfo().uiMode == UiMode.TenFoot and not FFlagEnableLeftNavOnConsole,
		defaultFocusRef = if not FFlagLuaAppsDefaultSelection then nil else v221
	})

	if FFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup then
		useCatalogPageRevertToLastEquippedStateHook()
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		ref = if not FFlagLuaAppsDefaultSelection then v216 else v222
	}, React.createElement(u153, v224))
end

return CatalogPageContainer
