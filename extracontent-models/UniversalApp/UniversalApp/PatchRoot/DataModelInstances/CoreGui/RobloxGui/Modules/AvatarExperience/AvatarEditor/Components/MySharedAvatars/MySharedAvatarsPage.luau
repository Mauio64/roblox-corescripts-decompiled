local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local AvatarExperienceCatalog = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)
local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local Focusable = RoactGamepad.Focusable
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local RetrievalStatus = require(Modules.LuaApp.Enum.RetrievalStatus)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local Common = Modules.AvatarExperience.Common
local Utils = require(Modules.AvatarExperience.Common.Utils)
local NamedRefsContext = require(Common.Context.NamedRefsContext)
local Constants = require(Common.Constants)
local sendAXCounterV2 = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).sendAXCounterV2
local useOverlayClosedCallback = require(Common.Hooks.useOverlayClosedCallback)
local useAvatarExperienceFocusNavigationBindings = require(Common.Hooks.useAvatarExperienceFocusNavigationBindings)
local useFullView = require(Common.Hooks.useFullView)
local ItemsView = require(Modules.AvatarExperience.AvatarEditor.Components.MySharedAvatars.ItemsView)
local AvatarEditorTopBar = require(Modules.AvatarExperience.AvatarEditor.Components.AvatarEditorTopBar)
local BoundInputsUpdater = require(Common.Components.BoundInputsUpdater)
local NavigationEventsLogger = require(Common.Components.RoactNavigation.Debug.NavigationEventsLogger)
local AvatarExperienceView = require(Common.Components.AvatarExperienceView)
local GamepadFocusHandlerForPage = require(Common.Components.GamepadFocusHandlerForPage)
local withStackVisibilityWrapper = require(Common.Components.RoactNavigation.withStackVisibilityWrapper)
local WidgetConstants = AvatarExperienceCatalog.WidgetConstants
local Constants2 = require(Modules.AvatarExperience.AvatarEditor.Constants)
local FullView = AvatarExperienceCommon.Enums.FullView
local ClearResultsListFocusedWidget = require(Modules.AvatarExperience.Catalog.Actions.ClearResultsListFocusedWidget)
local SetResultsListFocusedWidget = require(Modules.AvatarExperience.Catalog.Actions.SetResultsListFocusedWidget)
local FetchMySharedAvatars = require(Modules.AvatarExperience.AvatarEditor.Thunks.FetchMySharedAvatars)
local MySharedAvatars = WidgetConstants.ContextWidgets.MySharedAvatars
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus

local function selectMySharedAvatarsApiFetchStatus(p1) -- line: 67
	-- upvalues: PerformFetch (copy), Constants2 (copy)
	return PerformFetch.GetStatus(p1, Constants2.GetMySharedAvatarsKey)
end
local function MySharedAvatarsPage(_: {[any]: any}) -- line: 73
	-- upvalues: useNavigation (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), React (copy), RoactGamepad (copy), useOverlayClosedCallback (copy), useAvatarRoute (copy), useDispatch (copy), useRoactService (copy), RoactNetworking (copy), useSelector (copy), selectMySharedAvatarsApiFetchStatus (copy), useFullView (copy), FullView (copy), useAvatarExperienceFocusNavigationBindings (copy), NamedRefsContext (copy), Utils (copy), RetrievalStatus (copy), sendAXCounterV2 (copy), Constants (copy), FetchMySharedAvatars (copy), useLocalization (copy), MySharedAvatars (copy), SetResultsListFocusedWidget (copy), ClearResultsListFocusedWidget (copy), Focusable (copy), AvatarScreen (copy), BoundInputsUpdater (copy), NavigationEventsLogger (copy), AvatarExperienceView (copy), AvatarEditorTopBar (copy), GamepadFocusHandlerForPage (copy), ItemsView (copy)
	local v46 = useNavigation()
	local v47 = if not FFlagAXMigrateAXToGlobalAutofocus then React.useRef(RoactGamepad.createFocusController()).current else nil
	local v48 = React.useRef(nil)
	local v49 = useOverlayClosedCallback(if not FFlagAXMigrateAXToGlobalAutofocus then v47 else nil)
	local v50 = useAvatarRoute()
	local v51 = useDispatch()
	local v52 = useRoactService(RoactNetworking)
	local v53 = useSelector(selectMySharedAvatarsApiFetchStatus)
	local v54, v55 = useFullView()
	local v56 = v54 == FullView.SceneFullView
	local v57 = v54 == FullView.UIFullView
	local v58 = React.useRef(nil)
	local v59 = React.useRef(nil)
	local v60 = React.useRef(nil)
	local v61 = React.useRef(nil)
	local v62 = React.useRef(nil)
	local v63 = useAvatarExperienceFocusNavigationBindings({
		overlayClosedCallback = v49
	})
	local v64 = React.useContext(NamedRefsContext)
	local v65 = RoactGamepad.useRefCache()
	local v66 = React.useCallback(function() -- line: 105
		-- upvalues: Utils (copy), v54 (copy), v55 (copy)
		local v68 = Utils.getNewFullViewEnum(v54)

		v55(v68)
	end, {
		v54,
		v55
	})

	React.useEffect(function() -- line: 110
		-- upvalues: v53 (copy), RetrievalStatus (copy), sendAXCounterV2 (copy), Constants (copy), v51 (copy), FetchMySharedAvatars (copy), v52 (copy)
		if v53 == RetrievalStatus.NotStarted then
			sendAXCounterV2(Constants.Counter.MySharedAvatars.ReloadTriggedInPage)
			v51(FetchMySharedAvatars(v52))
		end
	end, {
		v53,
		v51,
		v52
	})

	local v67 = useLocalization({
		mySharedAvatarsTooltip = "Feature.Avatar.Label.MyPostedAvatars.Tooltip"
	})

	React.useEffect(function() -- line: 123
		-- upvalues: MySharedAvatars (copy), v67 (copy), v51 (copy), SetResultsListFocusedWidget (copy), ClearResultsListFocusedWidget (copy)
		local t2 = {
			title = MySharedAvatars.Title,
			localizedTooltip = v67.mySharedAvatarsTooltip
		}

		v51(SetResultsListFocusedWidget(MySharedAvatars.RequestId, MySharedAvatars.WidgetId, t2))

		return function() -- line: 142
			-- upvalues: v51 (copy), ClearResultsListFocusedWidget (copy), MySharedAvatars (copy)
			v51(ClearResultsListFocusedWidget(MySharedAvatars.RequestId))
		end
	end, { v51 })

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		ref = v63,
		Size = UDim2.fromScale(1, 1)
	}, React.createElement(Focusable.Frame, {
		BackgroundTransparency = 1,
		restorePreviousChildFocus = false,
		Size = UDim2.new(1, 0, 1, 0),
		ref = v64[AvatarScreen.MySharedAvatars],
		focusController = if not FFlagAXMigrateAXToGlobalAutofocus then v47 else nil,
		defaultChild = v62
	}, {
		BoundInputsUpdater = if not FFlagAXMigrateAXToGlobalAutofocus then React.createElement(BoundInputsUpdater) else nil,
		NavigationEventsLogger = React.createElement(NavigationEventsLogger, {
			pageName = AvatarScreen.MySharedAvatars
		}),
		AvatarExperienceView = React.createElement(AvatarExperienceView, {
			allowAdaptiveScrolling = true,
			bottomBarEnabled = false,
			changeViewFunction = v66,
			isSceneFullView = v56,
			isUIFullView = v57,
			topBar = React.createElement(AvatarEditorTopBar, {
				showManageOutfitButton = true,
				navigation = v46,
				avatarRoute = v50,
				overlayClosedCallback = v49,
				topBarRef = v58,
				defaultChildRef = v62,
				sceneUIContainerRef = v59
			}),
			refinementButtonsRef = v60,
			quickButtonsRef = v61,
			ref = v59,
			NextSelectionDown = v62,
			NextSelectionLeft = v58,
			defaultChildRef = v62,
			multiTryOnBottomBarRef = v48,
			itemDetailsPeekViewRefs = v65
		}, {
			GamepadFocusHandlerForPage = if not FFlagAXMigrateAXToGlobalAutofocus then React.createElement(GamepadFocusHandlerForPage, {
				captureFocusOnMount = true,
				focusController = v47
			}) else nil,
			MySharedAvatarsItemsView = React.createElement(ItemsView, {
				defaultChildRef = v62,
				NextSelectionUp = v58,
				NextSelectionRight = v61,
				multiTryOnBottomBarRef = v48,
				itemDetailsPeekViewRefs = v65
			})
		})
	}))
end

return (withStackVisibilityWrapper(MySharedAvatarsPage))
