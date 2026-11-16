local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local VirtualizedList = require(CorePackages.Packages.VirtualizedList)
local flatList = VirtualizedList.FlatList
require("@game/CorePackages/Workspace/Packages/AppCommonLib")

local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset
local gridMetrics = UIBlox.App.Grid.GridMetrics

local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local module2 = require("@luauforge/bundled/edz")
local module3 = require("@luauforge/bundled/edh")
local module4 = require("@luauforge/bundled/dMx")
require(CorePackages.Packages.LuauPolyfill)
require("@luauforge/deferred/gTG")
local module5 = require("@luauforge/deferred/gTH")

local module6 = require("@luauforge/deferred/gTI")
local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")
local module8 = require("@luauforge/deferred/gTJ")
local module9 = require("@luauforge/deferred/gUg")
local module10 = require("@luauforge/deferred/gUh")
local module11 = require("@luauforge/bundled/dRQ")
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local AvatarExperienceCatalog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
local widgetConstants = AvatarExperienceCatalog.WidgetConstants
local module14 = require("@luauforge/bundled/fuD")
local module15 = require("@luauforge/bundled/dMB")
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local module16 = require("@luauforge/bundled/dUd")

local useAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").useAppPolicy

local module17 = require("@luauforge/deferred/gPL")
local module18 = require("@luauforge/deferred/gUi")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local getAXMarketplaceWidgetStore = AvatarExperienceCatalog.Stores.getAXMarketplaceWidgetStore
local getUIScaleFromTokens = AvatarExperienceCatalog.Utils.getUIScaleFromTokens
local getBreakpointFromRowWidth = AvatarExperienceCatalog.Utils.getBreakpointFromRowWidth

local fFlagAXPassScreenSizeToWidgetApi = AvatarExperienceFlags.FFlagAXPassScreenSizeToWidgetApi
local fFlagAXUseVirtualizedFeedInWidgetList = AvatarExperienceFlags.FFlagAXUseVirtualizedFeedInWidgetList
local fFlagAXFixWidgetListSeeAllListReuse = AvatarExperienceFlags.FFlagAXFixWidgetListSeeAllListReuse
local fFlagAXMarketplaceBreakpointMismatchCounter = AvatarExperienceFlags.FFlagAXMarketplaceBreakpointMismatchCounter

local module20 = require("@luauforge/deferred/gkN")
local virtualizedFeed = module20.FeedComponents.VirtualizedFeed
local getItemCountForRow = module20.Utils.getItemCountForRow
local useFlatListScrollPerformanceTracker = module20.Hooks.useFlatListScrollPerformanceTracker

local fFlagAXLegacyIXPExposureLogging = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXLegacyIXPExposureLogging

local fFlagAXScrollTelemetryIntegration2 = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXScrollTelemetryIntegration2
local v5 = game:DefineFastInt("AXSearchPayloadExperimentPortraitModeMobileThreshold", 210) / 100

local v6 = game:DefineFastInt("AXSearchPayloadExperimentPortraitModeTabletThreshold", 0) / 100

local fFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI
local fFlagAXMigrateAllTabToSduiDev = AvatarExperienceFlags.FFlagAXMigrateAllTabToSduiDev

local module21 = require("@luauforge/bundled/dPG")

local defineFastFlag = game:DefineFastFlag("AXFixRowShiftInResultsList", false)

local widgetListHorizontalMargin = module4.WidgetListHorizontalMargin

local v7 = game:DefineFastInt("AXWidgetListScrollThrottleIntervalMs", 400) / 1000

local FLATLIST_CONFIGS = AvatarExperienceCatalog.Constants.FLATLIST_CONFIGS

local v8 = { BackgroundTransparency = 1, BorderSizePixel = 0 }

local v9 = {
	Selectable = false,
	BackgroundTransparency = 1,
	ScrollBarThickness = 0,
	BorderSizePixel = defineFastFlag and 0 or nil,
	LayoutOrder = 2,
	ElasticBehavior = Enum.ElasticBehavior.Always,
	ClipsDescendants = false,
	AutomaticCanvasSize = Enum.AutomaticSize.Y
}

local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals
local useAXAnimateScrollFrame = AvatarExperienceCommon.Components.AnimatedScrollingFrame.useAXAnimateScrollFrame

local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local function useCreatorNameTileFooterEnabledV2(searchUuid)
	local catalogSelectionStore = module21.getCatalogSelectionStore()
	local v10 = useSignalState(catalogSelectionStore.selectedCategoryId)
	local v11 = useSignalState(catalogSelectionStore.selectedSubcategoryId)

	local v12 = useAvatarRoute()
	local name = v12 and v12.opaque and v12.opaque.name

	return useSelector(React.useCallback(function(p2)
		local v13

		if name == avatarScreen.MySharedAvatars then
			v13 = widgetConstants.ContextWidgets.MySharedAvatars.Context
		elseif v10 then
			v13 = module11.getContextForWidgetsById(name, v10, v11)
		end

		local searchesParameter = p2.SearchesParameters[searchUuid]
		local v14 = searchesParameter and searchesParameter.searchKeyword ~= nil
		local queryStringForSearchWidgets = module11.getQueryStringForSearchWidgets(searchesParameter)
		local v15

		if v14 then
			v15 = p2.AvatarExperience.Common.Widgets.SearchPageWidgetInfo[queryStringForSearchWidgets]
		elseif v13 then
			v15 = p2.AvatarExperience.Common.Widgets.ContextWidgetInfo[v13]
		else
			v15 = p2.AvatarExperience.Common.Widgets.WidgetInfo
		end

		if v15 then
			return (module14.getCreatorNameTileFooterEnabled(v15.Configuration))
		end

		return false
	end, { searchUuid, name, v10, v11 }), getUseSelectorDeepEquals())
end

local function renderItem(p2)
	return p2.item.render(p2)
end

local function fn(p2)
	return p2.GlobalGuiInset and p2.GlobalGuiInset.bottom or 0
end

local function selectDeviceOrientation(p2)
	return p2.DeviceOrientation
end

local function WidgetList(props)
	local v10 = useFocusGuiObject()

	local gridRef = props.gridRef or React.useRef(nil)
	local flatListRef = props.flatListRef or React.useRef(nil)
	local v11 = RoactGamepad.useRefCache()

	local v12 = Responsive.useResponsive()
	local v13 = Responsive.useOrientation()
	local v14

	if v12 == Responsive.BreakpointConfig.Enum.Medium then
		v14 = v13 == Responsive.BreakpointConfig.Enum.Portrait
	else
		v14 = false
	end

	local v15 = if v14 then v6 else v5
	local v16 = useSelector(selectDeviceOrientation)
	local v17 = useSelector(fn)
	local v18 = if v16 == Responsive.BreakpointConfig.Enum.Portrait then v17 * 1.5 else nil

	local state, setState = React.useState(0)
	local setScreenSize, v19

	if fFlagAXPassScreenSizeToWidgetApi then
		setScreenSize = getAXMarketplaceWidgetStore(false).setScreenSize

		v19 = getUIScaleFromTokens((useTokens()))
	else
		v19 = nil
		setScreenSize = nil
	end

	local ref

	if fFlagAXPassScreenSizeToWidgetApi and fFlagAXMarketplaceBreakpointMismatchCounter then
		ref = React.useRef(false)
	else
		ref = nil
	end

	local v20 = useStyle()
	local theme = v20.Theme
	local v21 = useTextSizeOffset()
	local v22

	if fFlagAXCatalogCategoriesSDUI or fFlagAXMigrateAllTabToSduiDev then
		v22 = module10(props.fromSearch)
	else
		v22 = module9(props.fromSearch, props.searchUuid)
	end

	local v23 = useAppPolicy(function(p2)
		return p2.getEnableContinuousLoad()
	end)

	local itemTileTallAspectRatio = if v22 then module4.ItemTileTallAspectRatio else nil
	local crop = if v22 then Enum.ScaleType.Crop else nil
	local v24 = if v22 then module17() else nil

	if module18.isEnabled() and v22 then
		if module15.readTestVariable(module18.EnableHighResolutionTallTiles) then
			v24 = module4.CatalogThumbnailTypeToSize.BundleThumbnail._420x420
		else
			v24 = module4.CatalogThumbnailTypeToSize.BundleThumbnail._150x150
		end
	end

	if module18.isEnabled() then
		React.useEffect(function()
			if v22 then
				if fFlagAXLegacyIXPExposureLogging then
					if module18.logExposureEnabled and module18.logExposureEnabled() then
						module15.logExperimentExposure(module18)
					end
				else
					module15.logExperimentExposure(module18)
				end
			end
		end, { v22 })
	end

	local smallMetrics = gridMetrics.getSmallMetrics(
		math.max(state - widgetListHorizontalMargin * 2, 0),
		10
	)
	local v25 = math.max(
		getItemCountForRow(state - widgetListHorizontalMargin * 2 + 10, smallMetrics.itemWidth + 10),
		1
	)
	local v26

	if v22 then
		v26 = module4.ItemTileType.TallCatalogItemTile
	else
		v26 = module4.ItemTileType.CatalogItemTile
	end

	local v27 = useCreatorNameTileFooterEnabledV2(props.searchUuid)
	local v28

	if v22 then
		v28 = module5(v20, smallMetrics.itemWidth, v26, v27, v21)
	else
		v28 = module5(v20, smallMetrics.itemWidth, nil, v27, v21)
	end

	local state2, setState2 = React.useState(false)
	local ref2 = React.useRef(0)
	local v29 = React.useCallback(function()
		local now = os.clock()

		if now - ref2.current < v7 then
			return
		end

		ref2.current = now

		if not props.focusedWidget and props.loadMore then
			setState2(true)
			props.loadMore():andThen(function()
				setState2(false)
			end, function()
				setState2(false)
			end)
		end
	end, { props.loadMore, props.focusedWidget })
	local v30 = if not (v23 or not props.hasMoreRows) then v29 else nil

	local v31 = React.useCallback(function()
		if flatListRef.current ~= nil then
			local nativeScrollRef = flatListRef.current:getNativeScrollRef()

			if nativeScrollRef ~= nil then
				return nativeScrollRef._nativeRef
			end
		end

		return nil
	end, {})

	local v32 = React.useCallback(function()
		if flatListRef.current then
			flatListRef.current:scrollToOffset({ offset = 0, animated = true })

			if props.NextSelectionUp then
				v10(props.NextSelectionUp.current)
			end
		end
	end, { props.NextSelectionUp, v10 })

	local ref3 = React.useRef(0)
	local v33 = React.useCallback(function(...)
		local v34 = v31()

		if v34 and v34.current then
			ref3.current = v34.current.CanvasPosition.Y
		end

		if props.onWidgetFocusAcquired then
			props.onWidgetFocusAcquired(...)
		end
	end, { props.onWidgetFocusAcquired, v31 })

	module6(props.searchUuid, props.focusedWidget, v31, ref3)

	local state3, setState3 = React.useState(false)
	local v34 = v31()

	React.useEffect(function()
		local absoluteCanvasSizeChangedConnection

		if v34 and v34.current then
			absoluteCanvasSizeChangedConnection = v34.current:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(function()
				if v34 == nil or v34.current == nil then
					return
				end

				setState3(v34.current.AbsoluteCanvasSize.Y > v34.current.AbsoluteWindowSize.Y)
			end)
		else
			absoluteCanvasSizeChangedConnection = nil
		end

		return function()
			if absoluteCanvasSizeChangedConnection then
				absoluteCanvasSizeChangedConnection:Disconnect()
			end
		end
	end, { v34 })
	local v35

	if props.shouldCreateEndOfScrollElement then
		if state3 then
			v35 = React.createElement(module2, {
				backToTopCallback = v32,
				bottomPadding = v18
			})
		end
	elseif state2 then
		v35 = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 56)
		}, {
			LoadingBar = React.createElement(module3)
		})
	end

	local v36 = React.useCallback(function(p2)
		if props.onScroll then
			props.onScroll(p2.CanvasPosition.Y)
		end
	end, { props.onScroll })

	local v37 = state - widgetListHorizontalMargin * 2

	local v38 = module8(
		v28,
		v25,
		v25,
		props.searchUuid,
		props.entries,
		props.showingEntries,
		props.numItemsExpected,
		props.fromSearch,
		props.topPanelHeight,
		props.bottomBarHeight,
		props.focusedWidget,
		v33,
		props.onWidgetFocusReleased,
		props.hasMoreRows,
		props.itemDetailsPeekViewRefs,
		v11,
		gridRef,
		props.onFocusGained,
		props.requestImpressionsSignal,
		v31,
		itemTileTallAspectRatio,
		crop,
		v24,
		v30,
		v37,
		props.pillBarVisible
	)

	useAXAnimateScrollFrame(v31())

	local v39 = fFlagAXFixWidgetListSeeAllListReuse and props.focusedWidget and "WidgetListFocused" or nil

	if fFlagAXScrollTelemetryIntegration2 and not fFlagAXUseVirtualizedFeedInWidgetList then
		useFlatListScrollPerformanceTracker(props.scrollPerformanceIntervalName, flatListRef, v39)
	end

	local useCallback = React.useCallback
	local function fn2(p2)
		local x = p2.AbsoluteSize.X
		setState(x)

		if fFlagAXPassScreenSizeToWidgetApi then
			local breakpointFromRowWidth = getBreakpointFromRowWidth(
				math.max(x - widgetListHorizontalMargin * 2, 0),
				v19
			)

			if fFlagAXMarketplaceBreakpointMismatchCounter and ref and not ref.current then
				ref.current = true
				getAXMarketplaceWidgetStore(false).reportMeasuredBreakpoint(
					breakpointFromRowWidth,
					"WidgetList"
				)
			end

			setScreenSize(breakpointFromRowWidth)
		end
	end

	local v41 = if fFlagAXPassScreenSizeToWidgetApi then setScreenSize else nil
	local v42 = if fFlagAXPassScreenSizeToWidgetApi then setState else nil
	local v44 = useCallback(fn2, { v41, v42, if fFlagAXPassScreenSizeToWidgetApi then v19 else nil })
	local v45

	if fFlagAXUseVirtualizedFeedInWidgetList then
		local useCallback2 = React.useCallback
		local function fn3(p2)
			setState(p2)

			if fFlagAXPassScreenSizeToWidgetApi then
				local breakpointFromRowWidth = getBreakpointFromRowWidth(
					math.max(p2 - widgetListHorizontalMargin * 2, 0),
					v19
				)

				if fFlagAXMarketplaceBreakpointMismatchCounter and ref and not ref.current then
					ref.current = true
					getAXMarketplaceWidgetStore(false).reportMeasuredBreakpoint(
						breakpointFromRowWidth,
						"WidgetList"
					)
				end

				setScreenSize(breakpointFromRowWidth)
			end
		end

		local v47 = if fFlagAXPassScreenSizeToWidgetApi then setScreenSize else nil
		local v48 = if fFlagAXPassScreenSizeToWidgetApi then setState else nil
		v45 = useCallback2(fn3, { v47, v48, if fFlagAXPassScreenSizeToWidgetApi then v19 else nil })
	end

	React.useEffect(function()
		if props.onNumItemsPerRowChanged then
			props.onNumItemsPerRowChanged(v25)
		end
	end, { props.onNumItemsPerRowChanged, v25 })

	local v46 = useSignalState(module16.GetDisplayStore().getDeviceSafePadding)

	if fFlagAXUseVirtualizedFeedInWidgetList then
		local createElement = React.createElement
		local v48 = {
			key = v39,
			data = v38,
			renderItem = renderItem,
			horizontalPadding = widgetListHorizontalMargin,
			verticalPadding = fFlagAXMigrateAllTabToSduiDev and 8 or nil,
			windowSize = FLATLIST_CONFIGS.WINDOW_SIZE,
			initialNumToRender = FLATLIST_CONFIGS.INITIAL_NUM_TO_RENDER,
			maxToRenderPerBatch = FLATLIST_CONFIGS.MAX_TO_RENDER_PER_BATCH,
			updateCellsBatchingPeriod = FLATLIST_CONFIGS.UPDATE_CELLS_BATCHING_PERIOD,
			scrollEventThrottle = FLATLIST_CONFIGS.SCROLL_EVENT_THROTTLE,
			onScroll = props.onScroll,
			scrollEnabled = props.scrollingEnabled,
			onEndReached = 0,
			onEndReachedThreshold = 0,
			ListHeaderComponent = 0,
			ListFooterComponent = 0,
			isLoading = 0,
			isEndOfList = 0,
			onContainerWidthChanged = 0,
			backgroundColor = 0,
			backgroundTransparency = 0,
			clipsDescendants = true,
			flatListRef = 0,
			scrollPerformanceIntervalName = 0,
			ref = 0
		}

		if not v23 then
			v29 = nil
		end

		v48.onEndReached = v29
		v48.onEndReachedThreshold = v15
		v48.ListHeaderComponent = props.listHeaderComponent
		v48.ListFooterComponent = v35
		v48.isLoading = state2
		v48.isEndOfList = props.shouldCreateEndOfScrollElement
		v48.onContainerWidthChanged = v45
		v48.backgroundColor = theme.BackgroundDefault.Color
		v48.backgroundTransparency = theme.BackgroundDefault.Transparency

		v48.flatListRef = flatListRef
		v48.scrollPerformanceIntervalName = props.scrollPerformanceIntervalName
		v48.ref = gridRef
		return createElement(virtualizedFeed, v48)
	else
		local createElement = React.createElement
		local frame = RoactGamepad.Focusable.Frame
		local v47 = {
			["BackgroundColor3"] = nil,
			["BackgroundColor3"] = nil,
			BackgroundColor3 = theme.BackgroundDefault.Color,
			BackgroundTransparency = theme.BackgroundDefault.Transparency,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			ClipsDescendants = true,
			[React.Change.AbsoluteSize] = v44,
			ref = gridRef
		}

		local v48 = if props.showingEntries then v11[1] else nil
		v47.defaultChild = v48
		v47.restorePreviousChildFocus = props.restorePreviousChildFocus
		v47.NextSelectionRight = props.NextSelectionRight
		v47.NextSelectionUp = props.NextSelectionUp
		local v49 = {
			UIPadding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, widgetListHorizontalMargin),
				PaddingRight = UDim.new(0, widgetListHorizontalMargin),
				PaddingBottom = UDim.new(0, v46.bottom)
			}),
			WidgetFlatList = 0
		}

		local createElement2 = React.createElement
		local v51 = {
			key = v39,
			data = v38,
			renderItem = renderItem,
			windowSize = FLATLIST_CONFIGS.WINDOW_SIZE,
			initialNumToRender = FLATLIST_CONFIGS.INITIAL_NUM_TO_RENDER,
			maxToRenderPerBatch = FLATLIST_CONFIGS.MAX_TO_RENDER_PER_BATCH,
			updateCellsBatchingPeriod = FLATLIST_CONFIGS.UPDATE_CELLS_BATCHING_PERIOD,
			scrollEventThrottle = FLATLIST_CONFIGS.SCROLL_EVENT_THROTTLE,
			UNSTABLE_forceSiblingLayoutUpdate = true,
			ref = flatListRef,
			contentContainerStyle = v8,
			style = v9,
			onScroll = v36,
			onEndReachedThreshold = v15,
			onEndReached = 0,
			showDefaultLoadingIndicators = true,
			ListHeaderComponent = 0,
			ListFooterComponent = 0,
			scrollEnabled = 0
		}

		if not v23 then
			v29 = nil
		end

		v51.onEndReached = v29

		v51.ListHeaderComponent = props.listHeaderComponent
		v51.ListFooterComponent = v35
		v51.scrollEnabled = props.scrollingEnabled
		v49.WidgetFlatList = createElement2(flatList, v51)
		return createElement(frame, v47, v49)
	end
end

return WidgetList
