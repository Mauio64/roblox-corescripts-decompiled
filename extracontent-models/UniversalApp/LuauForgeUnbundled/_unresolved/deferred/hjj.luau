local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local module = require("@luauforge/bundled/fxg")
local Foundation = require(CorePackages.Packages.Foundation)
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local module3 = require("@luauforge/bundled/dPR")

local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useTokens = Foundation.Hooks.useTokens
local module4 = require("@luauforge/bundled/eie")

local module5 = require("@luauforge/bundled/fCe")
local module6 = require("@luauforge/deferred/gLm")
local module7 = require("@luauforge/bundled/dXh")
local module8 = require("@luauforge/bundled/fDf")
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals

local module9 = require("@luauforge/deferred/gQQ")
local module10 = require("@luauforge/deferred/gQN")
local module11 = require("@luauforge/deferred/gTM")
local module12 = require("@luauforge/bundled/gJS")

local module13 = require("@luauforge/deferred/hjk")
local module14 = require("@luauforge/deferred/gJK")
local module15 = require("@luauforge/deferred/gTt")
local module16 = require("@luauforge/deferred/gRz")
local searchBar = module.Components.SearchBar
local module17 = require("@luauforge/bundled/fvR")

local fullView = AvatarExperienceCommon.Enums.FullView
local counter = module.Enums.Counter
local searchLandingPageWidgetEnum = module.Enums.SearchLandingPageWidgetEnum

local module18 = require("@luauforge/bundled/dWo")
local module19 = require("@luauforge/bundled/dWn")

local axRecentlyViewedSearchItemsIXPTest = AvatarExperienceCommon.Experiments.AXRecentlyViewedSearchItemsIXPTest

function LUAUFORGE_MODULE_GLOBALS_hjj_selectTopBarHeight(p2)
	return module17.selectTopBarHeight(p2)
end

function LUAUFORGE_MODULE_GLOBALS_hjj_selectWidgetState(p2)
	return p2.AvatarExperience.Common.Widgets.ContextWidgetInfo
end

function LUAUFORGE_MODULE_GLOBALS_hjj_selectWidgetInfo(p2, p3)
	local v5 = if p2 then p2[p3] else nil

	if v5 and v5.Details then
		return v5.Details[p3]
	end

	return nil
end

local function SearchLandingFocusedWidgetPage()
	local v5 = useTokens()
	local v6 = useNavigation()
	local ref = React.useRef(nil)

	local v7 = module9()

	local v8 = module4(module8)
	local v9 = useDispatch()
	local v10, v11 = module11()
	local v12 = v10 == fullView.SceneFullView
	local v13 = v10 == fullView.UIFullView

	local v14 = useSelector(LUAUFORGE_MODULE_GLOBALS_hjj_selectTopBarHeight, getUseSelectorDeepEquals())
	local v15 = useSelector(module12, getUseSelectorDeepEquals())

	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)
	local ref4 = React.useRef(nil)
	local ref5 = React.useRef(nil)
	local ref6 = React.useRef(nil)
	local v17 = module10((React.useMemo(function()
		return { overlayClosedCallback = v7 }
	end, { v7 })))
	local v18 = React.useContext(module6)
	local v19 = RoactGamepad.useRefCache()

	local param = v6.getParam("widgetType")
	local v20 = useSelector(LUAUFORGE_MODULE_GLOBALS_hjj_selectWidgetState, getUseSelectorDeepEquals())

	local v21 = React.useMemo(function()
		return LUAUFORGE_MODULE_GLOBALS_hjj_selectWidgetInfo(v20, param)
	end, { v20, param })

	local v22 = React.useCallback(function()
		v11((module5.getNewFullViewEnum(v10)))
	end, { v10, v11 })

	local v23 = React.useCallback(function()
		module7.closeSearchLandingPageFocusedWidget(v6)
		v6.navigate(avatarScreen.CatalogSearchLanding)
	end, { v6 })

	local v24 = React.useCallback(function(object)
		object:ReleaseFocus()
		v23()
	end, { v23 })

	local v25 = React.useCallback(function()
		module7.closeSearchLandingPageFocusedWidget(v6)
		v6.navigate(avatarScreen.Catalog)
	end, { v9, v6 })

	React.useEffect(function()
		if v21 then
			if v8 and param == searchLandingPageWidgetEnum.RecentlyViewedItems then
				local v26 = module3.readTestVariable(axRecentlyViewedSearchItemsIXPTest.EnabledTopVariant)
					or false

				local v27 = module3.readTestVariable(axRecentlyViewedSearchItemsIXPTest.EnabledSaveInCatalog)
					or false

				v8.sendAXCounterV2(counter.RecentlyViewedFocusedWidgetEntered, {
					isPositionTopVariant = tostring(v26),
					isGlobalSaveVariant = tostring(v27)
				})
			end

			v9(module19(v21.requestId, v21.id, v21.template))
		end

		return function()
			if v21 then
				v9(module18(v21.requestId))
			end

			v11(fullView.None)
		end
	end, {})

	local createElement = React.createElement

	local v27 = { ref = v17, BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) }

	local createElement2 = React.createElement
	local frame = focusable.Frame
	local v28 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		ref = v18[avatarScreen.SearchLandingFocusedWidgetPage],
		defaultChild = ref6,
		restorePreviousChildFocus = false
	}

	local v29 = {
		NavigationEventsLogger = React.createElement(module14, {
			pageName = avatarScreen.SearchLandingFocusedWidgetPage
		}),
		SearchLandingFocusedWidgetPageAvatarExperienceView = 0
	}

	local createElement3 = React.createElement
	local v31 = {
		allowAdaptiveScrolling = true,
		bottomBarEnabled = false,
		changeViewFunction = v22,
		isSceneFullView = v12,
		isUIFullView = v13,
		topBar = React.createElement(Foundation.View, {
			ZIndex = 2,
			Size = UDim2.new(1, 0, 0, v14),
			backgroundStyle = {
				Color3 = v5.Color.Surface.Surface_0.Color3,
				Transparency = v15 and 1 or v5.Color.Surface.Surface_0.Transparency
			},
			tag = "padding-x-large auto-xy col align-y-bottom"
		}, {
			SearchBar = React.createElement(searchBar, {
				showCancelButton = true,
				autofocus = false,
				onFocus = v24,
				onCancel = v25
			})
		}),
		refinementButtonsRef = ref4,
		quickButtonsRef = ref5,
		ref = ref3,
		NextSelectionDown = ref6,
		NextSelectionLeft = ref2,
		defaultChildRef = ref6,
		multiTryOnBottomBarRef = ref,
		itemDetailsPeekViewRefs = v19,
		adaptiveScrollingProps = {
			fullHeightOptions = { opaqueBackground = true, draggerToDivider = true }
		}
	}

	local v33 = if v21 then React.createElement(module13, {
		defaultChildRef = ref6,
		NextSelectionUp = ref2,
		NextSelectionRight = ref5,
		multiTryOnBottomBarRef = ref,
		itemDetailsPeekViewRefs = v19,
		onCloseFocusedWidget = v23,
		searchUuid = v21.requestId
	}) else nil
	v29.SearchLandingFocusedWidgetPageAvatarExperienceView = createElement3(module15, v31, {
		FocusedWidgetItemsView = v33
	})
	return createElement("Frame", v27, createElement2(frame, v28, v29))
end

return (module16(SearchLandingFocusedWidgetPage))
