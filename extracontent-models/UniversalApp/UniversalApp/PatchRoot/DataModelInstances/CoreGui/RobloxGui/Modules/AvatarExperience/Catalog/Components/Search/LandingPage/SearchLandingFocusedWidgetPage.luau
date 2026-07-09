local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Focusable = RoactGamepad.Focusable
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local AvatarExperienceSearch = require(CorePackages.Workspace.Packages.AvatarExperienceSearch)
local Foundation = require(CorePackages.Packages.Foundation)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useTokens = Foundation.Hooks.useTokens
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local Common = Modules.AvatarExperience.Common
local Utils = require(Modules.AvatarExperience.Common.Utils)
local NamedRefsContext = require(Common.Context.NamedRefsContext)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local Analytics = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals
local useOverlayClosedCallback = require(Common.Hooks.useOverlayClosedCallback)
local useAvatarExperienceFocusNavigationBindings = require(Common.Hooks.useAvatarExperienceFocusNavigationBindings)
local useFullView = require(Common.Hooks.useFullView)
local selectIsPortrait = require(Common.Selectors.selectIsPortrait)
local SearchLandingFocusedWidgetPageItemsView = require(Modules.AvatarExperience.Catalog.Components.Search.LandingPage.SearchLandingFocusedWidgetPageItemsView)
local BoundInputsUpdater = require(Common.Components.BoundInputsUpdater)
local NavigationEventsLogger = require(Common.Components.RoactNavigation.Debug.NavigationEventsLogger)
local AvatarExperienceView = require(Common.Components.AvatarExperienceView)
local GamepadFocusHandlerForPage = require(Common.Components.GamepadFocusHandlerForPage)
local withStackVisibilityWrapper = require(Common.Components.RoactNavigation.withStackVisibilityWrapper)
local SearchBar = AvatarExperienceSearch.Components.SearchBar
local TopBar = require(Modules.LuaApp.Components.TopBar.TopBar)
local FullView = AvatarExperienceCommon.Enums.FullView
local Counter = AvatarExperienceSearch.Enums.Counter
local SearchLandingPageWidgetEnum = AvatarExperienceSearch.Enums.SearchLandingPageWidgetEnum
local ClearResultsListFocusedWidget = require(Modules.AvatarExperience.Catalog.Actions.ClearResultsListFocusedWidget)
local SetResultsListFocusedWidget = require(Modules.AvatarExperience.Catalog.Actions.SetResultsListFocusedWidget)
local AXRecentlyViewedSearchItemsIXPTest = AvatarExperienceCommon.Experiments.AXRecentlyViewedSearchItemsIXPTest
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus

function selectTopBarHeight(p1) -- line: 60
	-- upvalues: TopBar (copy)
	return TopBar.selectTopBarHeight(p1)
end
function selectWidgetState(p2) -- line: 64
	return p2.AvatarExperience.Common.Widgets.ContextWidgetInfo
end
function selectWidgetInfo(p3, p4) -- line: 68
	local v46 = if not p3 then nil else p3[p4]

	if v46 and v46.Details then
		return v46.Details[p4]
	end

	return nil
end

local function SearchLandingFocusedWidgetPage() -- line: 73
	-- upvalues: useTokens (copy), useNavigation (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), React (copy), RoactGamepad (copy), useOverlayClosedCallback (copy), useRoactService (copy), Analytics (copy), useDispatch (copy), useFullView (copy), FullView (copy), useSelector (copy), getUseSelectorDeepEquals (copy), selectIsPortrait (copy), useAvatarExperienceFocusNavigationBindings (copy), NamedRefsContext (copy), Utils (copy), NavigationUtils (copy), AvatarScreen (copy), SearchLandingPageWidgetEnum (copy), IxpUtils (copy), AXRecentlyViewedSearchItemsIXPTest (copy), Counter (copy), SetResultsListFocusedWidget (copy), ClearResultsListFocusedWidget (copy), Focusable (copy), BoundInputsUpdater (copy), NavigationEventsLogger (copy), AvatarExperienceView (copy), Foundation (copy), SearchBar (copy), GamepadFocusHandlerForPage (copy), SearchLandingFocusedWidgetPageItemsView (copy)
	local v47 = useTokens()
	local v48 = useNavigation()
	local v49 = if not FFlagAXMigrateAXToGlobalAutofocus then React.useRef(RoactGamepad.createFocusController()).current else nil
	local v50 = React.useRef(nil)
	local v51 = useOverlayClosedCallback(if not FFlagAXMigrateAXToGlobalAutofocus then v49 else nil)
	local v52 = useRoactService(Analytics)
	local v53 = useDispatch()
	local v54, v55 = useFullView()
	local v56 = v54 == FullView.SceneFullView
	local v57 = v54 == FullView.UIFullView
	local v58 = useSelector(selectTopBarHeight, getUseSelectorDeepEquals())
	local v59 = useSelector(selectIsPortrait, getUseSelectorDeepEquals())
	local v60 = React.useRef(nil)
	local v61 = React.useRef(nil)
	local v62 = React.useRef(nil)
	local v63 = React.useRef(nil)
	local v64 = React.useRef(nil)
	local v65 = React.useMemo(function() -- line: 100
		-- upvalues: v51 (copy)
		return {
			overlayClosedCallback = v51
		}
	end, { v51 })
	local v66 = useAvatarExperienceFocusNavigationBindings(v65)
	local v67 = React.useContext(NamedRefsContext)
	local v68 = RoactGamepad.useRefCache()
	local v69 = v48.getParam("widgetType")
	local v70 = useSelector(selectWidgetState, getUseSelectorDeepEquals())
	local v71 = React.useMemo(function() -- line: 110
		-- upvalues: v70 (copy), v69 (copy)
		return selectWidgetInfo(v70, v69)
	end, {
		v70,
		v69
	})
	local v72 = React.useCallback(function() -- line: 115
		-- upvalues: Utils (copy), v54 (copy), v55 (copy)
		local v76 = Utils.getNewFullViewEnum(v54)

		v55(v76)
	end, {
		v54,
		v55
	})
	local v73 = React.useCallback(function() -- line: 120
		-- upvalues: NavigationUtils (copy), v48 (copy), AvatarScreen (copy)
		NavigationUtils.closeSearchLandingPageFocusedWidget(v48)
		v48.navigate(AvatarScreen.CatalogSearchLanding)
	end, { v48 })
	local v74 = React.useCallback(function(p5) -- line: 125
		-- upvalues: v73 (copy)
		p5:ReleaseFocus()
		v73()
	end, { v73 })
	local v75 = React.useCallback(function() -- line: 131
		-- upvalues: NavigationUtils (copy), v48 (copy), AvatarScreen (copy)
		NavigationUtils.closeSearchLandingPageFocusedWidget(v48)
		v48.navigate(AvatarScreen.Catalog)
	end, {
		v53,
		v48
	})

	React.useEffect(function() -- line: 136
		-- upvalues: v71 (copy), v52 (copy), v69 (copy), SearchLandingPageWidgetEnum (copy), IxpUtils (copy), AXRecentlyViewedSearchItemsIXPTest (copy), Counter (copy), v53 (copy), SetResultsListFocusedWidget (copy), ClearResultsListFocusedWidget (copy), v55 (copy), FullView (copy)
		if v71 then
			if v52 and v69 == SearchLandingPageWidgetEnum.RecentlyViewedItems then
				local v78 = IxpUtils.readTestVariable(AXRecentlyViewedSearchItemsIXPTest.EnabledTopVariant) or false
				local v79 = IxpUtils.readTestVariable(AXRecentlyViewedSearchItemsIXPTest.EnabledSaveInCatalog) or false

				v52.sendAXCounterV2(Counter.RecentlyViewedFocusedWidgetEntered, {
					isPositionTopVariant = tostring(v78),
					isGlobalSaveVariant = tostring(v79)
				})
			end

			v53(SetResultsListFocusedWidget(v71.requestId, v71.id, v71.template))
		end

		return function() -- line: 155
			-- upvalues: v71 (copy), v53 (copy), ClearResultsListFocusedWidget (copy), v55 (copy), FullView (copy)
			if v71 then
				v53(ClearResultsListFocusedWidget(v71.requestId))
			end

			v55(FullView.None)
		end
	end, {})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		ref = v66,
		Size = UDim2.fromScale(1, 1)
	}, React.createElement(Focusable.Frame, {
		BackgroundTransparency = 1,
		restorePreviousChildFocus = false,
		Size = UDim2.new(1, 0, 1, 0),
		ref = v67[AvatarScreen.SearchLandingFocusedWidgetPage],
		focusController = if not FFlagAXMigrateAXToGlobalAutofocus then v49 else nil,
		defaultChild = v64
	}, {
		BoundInputsUpdater = if not FFlagAXMigrateAXToGlobalAutofocus then React.createElement(BoundInputsUpdater) else nil,
		NavigationEventsLogger = React.createElement(NavigationEventsLogger, {
			pageName = AvatarScreen.SearchLandingFocusedWidgetPage
		}),
		SearchLandingFocusedWidgetPageAvatarExperienceView = React.createElement(AvatarExperienceView, {
			allowAdaptiveScrolling = true,
			bottomBarEnabled = false,
			changeViewFunction = v72,
			isSceneFullView = v56,
			isUIFullView = v57,
			topBar = React.createElement(Foundation.View, {
				ZIndex = 2,
				tag = "padding-x-large auto-xy col align-y-bottom",
				Size = UDim2.new(1, 0, 0, v58),
				backgroundStyle = {
					Color3 = v47.Color.Surface.Surface_0.Color3,
					Transparency = if not v59 then v47.Color.Surface.Surface_0.Transparency else 1
				}
			}, {
				SearchBar = React.createElement(SearchBar, {
					showCancelButton = true,
					autofocus = false,
					onFocus = v74,
					onCancel = v75
				})
			}),
			refinementButtonsRef = v62,
			quickButtonsRef = v63,
			ref = v61,
			NextSelectionDown = v64,
			NextSelectionLeft = v60,
			defaultChildRef = v64,
			multiTryOnBottomBarRef = v50,
			itemDetailsPeekViewRefs = v68,
			adaptiveScrollingProps = {
				fullHeightOptions = {
					opaqueBackground = true,
					draggerToDivider = true
				}
			}
		}, {
			GamepadFocusHandlerForPage = if not FFlagAXMigrateAXToGlobalAutofocus then React.createElement(GamepadFocusHandlerForPage, {
				captureFocusOnMount = true,
				focusController = v49
			}) else nil,
			FocusedWidgetItemsView = if not v71 then nil else React.createElement(SearchLandingFocusedWidgetPageItemsView, {
				defaultChildRef = v64,
				NextSelectionUp = v60,
				NextSelectionRight = v63,
				multiTryOnBottomBarRef = v50,
				itemDetailsPeekViewRefs = v68,
				onCloseFocusedWidget = v73,
				searchUuid = v71.requestId
			})
		})
	}))
end

return (withStackVisibilityWrapper(SearchLandingFocusedWidgetPage))
