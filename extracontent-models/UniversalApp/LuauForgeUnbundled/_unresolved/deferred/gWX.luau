local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local module = require("@luauforge/bundled/fpM")
local Foundation = require(CorePackages.Packages.Foundation)
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local module3 = require("@luauforge/bundled/dMB")

local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useTokens = Foundation.Hooks.useTokens
local module4 = require("@luauforge/bundled/eeH")

local module5 = require("@luauforge/bundled/fuD")
local module6 = require("@luauforge/deferred/ggG")
local module7 = require("@luauforge/bundled/dTM")
local module8 = require("@luauforge/bundled/fvF")
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals

local module9 = require("@luauforge/deferred/gml")
local module10 = require("@luauforge/deferred/gmi")
local module11 = require("@luauforge/deferred/gpj")
local module12 = require("@luauforge/bundled/gfm")

local module13 = require("@luauforge/deferred/gWY")
local module14 = require("@luauforge/deferred/gfe")
local module15 = require("@luauforge/deferred/goQ")
local module16 = require("@luauforge/deferred/gmV")
local searchBar = module.Components.SearchBar
local module17 = require("@luauforge/bundled/fox")

local fullView = AvatarExperienceCommon.Enums.FullView
local counter = module.Enums.Counter
local searchLandingPageWidgetEnum = module.Enums.SearchLandingPageWidgetEnum

local module18 = require("@luauforge/bundled/dST")
local module19 = require("@luauforge/bundled/dSS")

local axRecentlyViewedSearchItemsIXPTest = AvatarExperienceCommon.Experiments.AXRecentlyViewedSearchItemsIXPTest

function LUAUFORGE_MODULE_GLOBALS_gWX_selectTopBarHeight(p2)
	return module17.selectTopBarHeight(p2)
end

function LUAUFORGE_MODULE_GLOBALS_gWX_selectWidgetState(p2)
	return p2.AvatarExperience.Common.Widgets.ContextWidgetInfo
end

function LUAUFORGE_MODULE_GLOBALS_gWX_selectWidgetInfo(p2, p3)
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

	local v14 = useSelector(LUAUFORGE_MODULE_GLOBALS_gWX_selectTopBarHeight, getUseSelectorDeepEquals())
	local v15 = useSelector(module12, getUseSelectorDeepEquals())

	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)
	local ref4 = React.useRef(nil)
	local ref5 = React.useRef(nil)
	local ref6 = React.useRef(nil)
	local v16 = module10((React.useMemo(function()
		return { overlayClosedCallback = v7 }
	end, { v7 })))
	local v17 = React.useContext(module6)
	local v18 = RoactGamepad.useRefCache()

	local param = v6.getParam("widgetType")
	local v19 = useSelector(LUAUFORGE_MODULE_GLOBALS_gWX_selectWidgetState, getUseSelectorDeepEquals())

	local v20 = React.useMemo(function()
		return LUAUFORGE_MODULE_GLOBALS_gWX_selectWidgetInfo(v19, param)
	end, { v19, param })

	local v21 = React.useCallback(function()
		v11((module5.getNewFullViewEnum(v10)))
	end, { v10, v11 })

	local v22 = React.useCallback(function()
		module7.closeSearchLandingPageFocusedWidget(v6)
		v6.navigate(avatarScreen.CatalogSearchLanding)
	end, { v6 })

	local v23 = React.useCallback(function(object)
		object:ReleaseFocus()
		v22()
	end, { v22 })

	local v24 = React.useCallback(function()
		module7.closeSearchLandingPageFocusedWidget(v6)
		v6.navigate(avatarScreen.Catalog)
	end, { v9, v6 })

	React.useEffect(function()
		if v20 then
			if v8 and param == searchLandingPageWidgetEnum.RecentlyViewedItems then
				local v25 = module3.readTestVariable(axRecentlyViewedSearchItemsIXPTest.EnabledTopVariant)
					or false

				local v26 = module3.readTestVariable(axRecentlyViewedSearchItemsIXPTest.EnabledSaveInCatalog)
					or false

				v8.sendAXCounterV2(counter.RecentlyViewedFocusedWidgetEntered, {
					isPositionTopVariant = tostring(v25),
					isGlobalSaveVariant = tostring(v26)
				})
			end

			v9(module19(v20.requestId, v20.id, v20.template))
		end

		return function()
			if v20 then
				v9(module18(v20.requestId))
			end

			v11(fullView.None)
		end
	end, {})

	local createElement = React.createElement

	local v26 = { ref = v16, BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) }

	local createElement2 = React.createElement
	local frame = focusable.Frame
	local v27 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		ref = v17[avatarScreen.SearchLandingFocusedWidgetPage],
		defaultChild = ref6,
		restorePreviousChildFocus = false
	}

	local v28 = {
		NavigationEventsLogger = React.createElement(module14, {
			pageName = avatarScreen.SearchLandingFocusedWidgetPage
		}),
		SearchLandingFocusedWidgetPageAvatarExperienceView = 0
	}

	local createElement3 = React.createElement
	local v30 = {
		allowAdaptiveScrolling = true,
		bottomBarEnabled = false,
		changeViewFunction = v21,
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
				onFocus = v23,
				onCancel = v24
			})
		}),
		refinementButtonsRef = ref4,
		quickButtonsRef = ref5,
		ref = ref3,
		NextSelectionDown = ref6,
		NextSelectionLeft = ref2,
		defaultChildRef = ref6,
		multiTryOnBottomBarRef = ref,
		itemDetailsPeekViewRefs = v18,
		adaptiveScrollingProps = {
			fullHeightOptions = { opaqueBackground = true, draggerToDivider = true }
		}
	}

	local v32 = if v20 then React.createElement(module13, {
		defaultChildRef = ref6,
		NextSelectionUp = ref2,
		NextSelectionRight = ref5,
		multiTryOnBottomBarRef = ref,
		itemDetailsPeekViewRefs = v18,
		onCloseFocusedWidget = v22,
		searchUuid = v20.requestId
	}) else nil
	v28.SearchLandingFocusedWidgetPageAvatarExperienceView = createElement3(module15, v30, {
		FocusedWidgetItemsView = v32
	})
	return createElement("Frame", v26, createElement2(frame, v27, v28))
end

return (module16(SearchLandingFocusedWidgetPage))
