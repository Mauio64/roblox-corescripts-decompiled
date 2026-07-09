local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local FlatList = require(CorePackages.Packages.VirtualizedList).FlatList

require(CorePackages.Workspace.Packages.AppCommonLib)

local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset
local GridMetrics = UIBlox.App.Grid.GridMetrics
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local EndOfScroll = require(Modules.LuaApp.Components.EndOfScroll)
local LoadingBarWithTheme = require(Modules.LuaApp.Components.LoadingBarWithTheme)
local Constants = require(Modules.AvatarExperience.Common.Constants)

require(CorePackages.Packages.LuauPolyfill)
require(Modules.AvatarExperience.Common.Components.WidgetList.Types)

local getItemSize = require(Modules.AvatarExperience.Common.Components.WidgetList.Utils.getItemSize)
local useRestoreYPositionOnDefocusEffect = require(Modules.AvatarExperience.Common.Components.WidgetList.Hooks.useRestoreYPositionOnDefocusEffect)
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local useRenderInfo = require(Modules.AvatarExperience.Common.Components.WidgetList.Hooks.useRenderInfo)
local useTallTileV2 = require(Modules.AvatarExperience.Common.Components.WidgetList.Hooks.useTallTileV2)
local useTallTileV3 = require(Modules.AvatarExperience.Common.Components.WidgetList.Hooks.useTallTileV3)
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local AvatarExperienceCatalog = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)
local WidgetConstants = AvatarExperienceCatalog.WidgetConstants
local Utils = require(Modules.AvatarExperience.Common.Utils)
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useFocusGuiObject = require(CorePackages.Packages.ReactFocusNavigation).useFocusGuiObject
local useTokens = require(CorePackages.Packages.Foundation).Hooks.useTokens
local Display = require(CorePackages.Workspace.Packages.Display)
local useAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).useAppPolicy
local GetFStringAXTallTilesThumbnailSize = require(Modules.AvatarExperience.Flags.GetFStringAXTallTilesThumbnailSize)
local AXHighResolutionTallTilesIXP = require(Modules.AvatarExperience.Experiments.AXHighResolutionTallTilesIXP)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local getAXMarketplaceWidgetStore = AvatarExperienceCatalog.Stores.getAXMarketplaceWidgetStore
local getUIScaleFromTokens = AvatarExperienceCatalog.Utils.getUIScaleFromTokens
local getBreakpointFromRowWidth = AvatarExperienceCatalog.Utils.getBreakpointFromRowWidth
local FFlagAXPassScreenSizeToWidgetApi = AvatarExperienceFlags.FFlagAXPassScreenSizeToWidgetApi
local FFlagAXUseVirtualizedFeedInWidgetList = AvatarExperienceFlags.FFlagAXUseVirtualizedFeedInWidgetList
local AvatarExperienceUIKit = require(CorePackages.Workspace.Packages.AvatarExperienceUIKit)
local VirtualizedFeed = AvatarExperienceUIKit.FeedComponents.VirtualizedFeed
local getItemCountForRow = AvatarExperienceUIKit.Utils.getItemCountForRow
local FFlagAXScrollingFramesShouldAnimateOnFocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXScrollingFramesShouldAnimateOnFocus
local FFlagAXLegacyIXPExposureLogging = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXLegacyIXPExposureLogging
local v46 = game:DefineFastInt("AXSearchPayloadExperimentPortraitModeMobileThreshold", 210) / 100
local v47 = game:DefineFastInt("AXSearchPayloadExperimentPortraitModeTabletThreshold", 0) / 100
local FFlagAXMISEnableMultiShopping = AvatarExperienceFlags.FFlagAXMISEnableMultiShopping
local FFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI
local FFlagAXMigrateAllTabToSduiDev = AvatarExperienceFlags.FFlagAXMigrateAllTabToSduiDev
local GetCatalogCategoriesStore = require(Modules.AvatarExperience.Catalog.Stores.GetCatalogCategoriesStore)
local v52 = game:DefineFastFlag("AXFixRowShiftInResultsList", false)
local v53 = game:DefineFastFlag("AXUseFIntForWidgetListInitialNumToRender", false)
local FFlagEnableLeftNavOnConsole = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableLeftNavOnConsole
local WidgetListHorizontalMargin = Constants.WidgetListHorizontalMargin
local v56 = game:DefineFastInt("AXWidgetListScrollThrottleIntervalMs", 400) / 1000
local t1 = {
	MAX_TO_RENDER_PER_BATCH = 1,
	UPDATE_CELLS_BATCHING_PERIOD = 30,
	SCROLL_EVENT_THROTTLE = 0,
	WINDOW_SIZE = game:DefineFastInt("WidgetListWindowSize", 21),
	INITIAL_NUM_TO_RENDER = not v53 and 8 or game:DefineFastInt("WidgetListInitialNumToRender", 8)
}
local t2 = {
	BackgroundTransparency = 1,
	BorderSizePixel = 0
}
local t3 = {
	Selectable = false,
	BackgroundTransparency = 1,
	ScrollBarThickness = 0,
	LayoutOrder = 2,
	ClipsDescendants = false,
	BorderSizePixel = if not v52 then nil else 0,
	ElasticBehavior = Enum.ElasticBehavior.Always,
	AutomaticCanvasSize = Enum.AutomaticSize.Y
}
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals
local useAXAnimateScrollFrame = AvatarExperienceCommon.Components.AnimatedScrollingFrame.useAXAnimateScrollFrame
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState

local function useCreatorNameTileFooterEnabledV2(s1: string) -- line: 148
	-- upvalues: GetCatalogCategoriesStore (copy), useSignalState (copy), useAvatarRoute (copy), React (copy), AvatarScreen (copy), WidgetConstants (copy), CatalogUtils (copy), Utils (copy), useSelector (copy), getUseSelectorDeepEquals (copy)
	local v69 = GetCatalogCategoriesStore.getCatalogSelectionStore()
	local v70 = useSignalState(v69.selectedCategoryId)
	local v71 = useSignalState(v69.selectedSubcategoryId)
	local v72 = useAvatarRoute()
	local v73 = v72 and (v72.opaque and v72.opaque.name)
	local v74 = React.useCallback(function(p1) -- line: 156
		-- upvalues: v73 (copy), AvatarScreen (copy), WidgetConstants (copy), v70 (copy), CatalogUtils (copy), v71 (copy), s1 (copy), Utils (copy)
		local v128 = if v73 ~= AvatarScreen.MySharedAvatars then if not v70 then nil else CatalogUtils.getContextForWidgetsById(v73, v70, v71) else WidgetConstants.ContextWidgets.MySharedAvatars.Context
		local v129 = p1.SearchesParameters[s1]
		local v130 = v129 and v129.searchKeyword ~= nil
		local v131 = CatalogUtils.getQueryStringForSearchWidgets(v129)
		local v132 = if not v130 then if not v128 then p1.AvatarExperience.Common.Widgets.WidgetInfo else p1.AvatarExperience.Common.Widgets.ContextWidgetInfo[v128] else p1.AvatarExperience.Common.Widgets.SearchPageWidgetInfo[v131]

		if v132 then
			return (Utils.getCreatorNameTileFooterEnabled(v132.Configuration))
		end

		return false
	end, {
		s1,
		v73,
		v70,
		v71
	})

	return useSelector(v74, getUseSelectorDeepEquals())
end
local function renderItem(p2) -- line: 184
	return p2.item.render(p2)
end
local function v65(p3) -- line: 233
	return p3.GlobalGuiInset and p3.GlobalGuiInset.bottom or 0
end
local function selectDeviceOrientation(p4) -- line: 237
	return p4.DeviceOrientation
end
local function WidgetList(t4: {[any]: any}) -- line: 241
	-- upvalues: FFlagAXScrollingFramesShouldAnimateOnFocus (copy), useFocusGuiObject (copy), React (copy), RoactGamepad (copy), Responsive (copy), v47 (copy), v46 (copy), FFlagAXMISEnableMultiShopping (copy), useSelector (copy), selectDeviceOrientation (copy), v65 (copy), FFlagAXPassScreenSizeToWidgetApi (copy), getAXMarketplaceWidgetStore (copy), useTokens (copy), getUIScaleFromTokens (copy), useStyle (copy), useTextSizeOffset (copy), FFlagAXCatalogCategoriesSDUI (copy), useTallTileV3 (copy), useTallTileV2 (copy), useAppPolicy (copy), Constants (copy), GetFStringAXTallTilesThumbnailSize (copy), AXHighResolutionTallTilesIXP (copy), IxpUtils (copy), FFlagAXLegacyIXPExposureLogging (copy), GridMetrics (copy), WidgetListHorizontalMargin (copy), getItemCountForRow (copy), useCreatorNameTileFooterEnabledV2 (copy), getItemSize (copy), v56 (copy), useRestoreYPositionOnDefocusEffect (copy), EndOfScroll (copy), LoadingBarWithTheme (copy), useRenderInfo (copy), useAXAnimateScrollFrame (copy), getBreakpointFromRowWidth (copy), FFlagAXUseVirtualizedFeedInWidgetList (copy), FFlagEnableLeftNavOnConsole (copy), useSignalState (copy), Display (copy), VirtualizedFeed (copy), renderItem (copy), FFlagAXMigrateAllTabToSduiDev (copy), FlatList (copy), t1 (copy), t2 (copy), t3 (copy)
	local u79 = nil

	if FFlagAXScrollingFramesShouldAnimateOnFocus then
		u79 = useFocusGuiObject()
	end

	local v80 = t4.gridRef or React.useRef(nil)
	local v81 = t4.flatListRef or React.useRef(nil)
	local v82 = RoactGamepad.useRefCache()
	local v83 = Responsive.useResponsive()
	local v84 = Responsive.useOrientation()
	local v85 = if not (v83 == Responsive.BreakpointConfig.Enum.Medium and v84 == Responsive.BreakpointConfig.Enum.Portrait) then v46 else v47
	local v86 = nil

	if FFlagAXMISEnableMultiShopping then
		local v87 = useSelector(selectDeviceOrientation)
		local v88 = useSelector(v65)

		if v87 == Responsive.BreakpointConfig.Enum.Portrait then
			v86 = v88 * 1.5
		end
	end

	local v89, v90 = React.useState(0)
	local setScreenSize = nil
	local u92 = nil

	if FFlagAXPassScreenSizeToWidgetApi then
		setScreenSize = getAXMarketplaceWidgetStore(false).setScreenSize

		local v93 = useTokens()

		u92 = getUIScaleFromTokens(v93)
	end

	local v94 = useStyle()
	local Theme = v94.Theme
	local v96 = useTextSizeOffset()
	local u97 = if not FFlagAXCatalogCategoriesSDUI then useTallTileV2(t4.fromSearch, t4.searchUuid) else useTallTileV3(t4.fromSearch)
	local v98 = useAppPolicy(function(p5) -- line: 297
		return p5.getEnableContinuousLoad()
	end)
	local v99 = if not u97 then nil else Constants.ItemTileTallAspectRatio
	local v100 = if not u97 then nil else Enum.ScaleType.Crop
	local v101 = if not u97 then nil else GetFStringAXTallTilesThumbnailSize()

	if AXHighResolutionTallTilesIXP.isEnabled() and u97 then
		v101 = if not IxpUtils.readTestVariable(AXHighResolutionTallTilesIXP.EnableHighResolutionTallTiles) then Constants.CatalogThumbnailTypeToSize.BundleThumbnail._150x150 else Constants.CatalogThumbnailTypeToSize.BundleThumbnail._420x420
	end

	if AXHighResolutionTallTilesIXP.isEnabled() then
		React.useEffect(function() -- line: 314
			-- upvalues: u97 (ref), FFlagAXLegacyIXPExposureLogging (copy), AXHighResolutionTallTilesIXP (copy), IxpUtils (copy)
			if u97 then
				if FFlagAXLegacyIXPExposureLogging then
					if AXHighResolutionTallTilesIXP.logExposureEnabled and AXHighResolutionTallTilesIXP.logExposureEnabled() then
						IxpUtils.logExperimentExposure(AXHighResolutionTallTilesIXP)

						return
					end
				else
					IxpUtils.logExperimentExposure(AXHighResolutionTallTilesIXP)
				end
			end
		end, { u97 })
	end

	local v102 = GridMetrics.getSmallMetrics(math.max(v89 - WidgetListHorizontalMargin * 2, 0), 10)
	local u103 = math.max(getItemCountForRow(v89 - WidgetListHorizontalMargin * 2 + 10, v102.itemWidth + 10), 1)
	local v104 = if not u97 then Constants.ItemTileType.CatalogItemTile else Constants.ItemTileType.TallCatalogItemTile
	local v105 = useCreatorNameTileFooterEnabledV2(t4.searchUuid)
	local v106 = if not u97 then getItemSize(v94, v102.itemWidth, nil, v105, v96) else getItemSize(v94, v102.itemWidth, v104, v105, v96)
	local v107 = u103
	local v108, v109 = React.useState(false)
	local v110 = React.useRef(0)
	local v111 = React.useCallback(function() -- line: 363
		-- upvalues: v110 (copy), v56 (copy), t4 (copy), v109 (copy)
		local elapsed = os.clock()

		if elapsed - v110.current < v56 then
			return
		end

		v110.current = elapsed

		if not t4.focusedWidget and t4.loadMore then
			v109(true)
			t4.loadMore():andThen(function() -- line: 374
				-- upvalues: v109 (copy)
				v109(false)
			end, function() -- line: 376
				-- upvalues: v109 (copy)
				v109(false)
			end)
		end
	end, {
		t4.loadMore,
		t4.focusedWidget
	})
	local v112 = if v98 or not t4.hasMoreRows then nil else v111
	local v113 = React.useCallback(function() -- line: 386
		-- upvalues: v81 (copy)
		if v81.current ~= nil then
			local v135 = v81.current:getNativeScrollRef()

			if v135 ~= nil then
				return v135._nativeRef
			end
		end

		return nil
	end, {})
	local v114 = React.useCallback(function() -- line: 400
		-- upvalues: v81 (copy), FFlagAXScrollingFramesShouldAnimateOnFocus (copy), t4 (copy), u79 (ref)
		if v81.current then
			v81.current:scrollToOffset({
				offset = 0,
				animated = true
			})

			if FFlagAXScrollingFramesShouldAnimateOnFocus and t4.NextSelectionUp then
				u79(t4.NextSelectionUp.current)
			end
		end
	end, if not FFlagAXScrollingFramesShouldAnimateOnFocus then {} else {
		t4.NextSelectionUp,
		u79
	})
	local v115 = React.useRef(0)
	local v116 = React.useCallback(function(...) -- line: 417
		-- upvalues: v113 (copy), v115 (copy), t4 (copy)
		local v136 = v113()

		if v136 and v136.current then
			v115.current = v136.current.CanvasPosition.Y
		end

		if t4.onWidgetFocusAcquired then
			t4.onWidgetFocusAcquired(...)
		end
	end, {
		t4.onWidgetFocusAcquired,
		v113
	})

	useRestoreYPositionOnDefocusEffect(t4.searchUuid, t4.focusedWidget, v113, v115)

	local v117, v118 = React.useState(false)
	local v119 = v113()

	React.useEffect(function() -- line: 439
		-- upvalues: v119 (copy), v118 (copy)
		local connection = nil

		if v119 and v119.current then
			connection = v119.current:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(function() -- line: 442
				-- upvalues: v119 (copy), v118 (copy)
				if v119 == nil or v119.current == nil then
					return
				end

				v118(v119.current.AbsoluteCanvasSize.Y > v119.current.AbsoluteWindowSize.Y)
			end)
		end

		return function() -- line: 456
			-- upvalues: connection (ref)
			if connection then
				connection:Disconnect()
			end
		end
	end, { v119 })

	local v120 = if not t4.shouldCreateEndOfScrollElement then if not v108 then nil else React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 56)
	}, {
		LoadingBar = React.createElement(LoadingBarWithTheme)
	}) else if not v117 then nil else React.createElement(EndOfScroll, {
		backToTopCallback = v114,
		bottomPadding = v86
	})
	local v121 = React.useCallback(function(p6) -- line: 482
		-- upvalues: t4 (copy)
		if t4.onScroll then
			t4.onScroll(p6.CanvasPosition.Y)
		end
	end, { t4.onScroll })
	local v122 = v89 - WidgetListHorizontalMargin * 2
	local v123 = useRenderInfo(v106, u103, v107, t4.searchUuid, t4.entries, t4.showingEntries, t4.numItemsExpected, t4.fromSearch, t4.topPanelHeight, t4.bottomBarHeight, t4.focusedWidget, v116, t4.onWidgetFocusReleased, t4.hasMoreRows, t4.itemDetailsPeekViewRefs, v82, v80, t4.onFocusGained, t4.requestImpressionsSignal, v113, v99, v100, v101, v112, v122, t4.pillBarVisible)

	if FFlagAXScrollingFramesShouldAnimateOnFocus then
		useAXAnimateScrollFrame((v113()))
	end

	local v124 = React.useCallback(function(p7) -- line: 527
		-- upvalues: v90 (copy), FFlagAXPassScreenSizeToWidgetApi (copy), WidgetListHorizontalMargin (copy), getBreakpointFromRowWidth (copy), u92 (ref), setScreenSize (ref)
		local AbsoluteSizeX = p7.AbsoluteSize.X

		v90(AbsoluteSizeX)

		if FFlagAXPassScreenSizeToWidgetApi then
			local v141 = math.max(AbsoluteSizeX - WidgetListHorizontalMargin * 2, 0)
			local v142 = getBreakpointFromRowWidth(v141, u92)

			setScreenSize(v142)
		end
	end, {
		if not FFlagAXPassScreenSizeToWidgetApi then nil else setScreenSize,
		if not FFlagAXPassScreenSizeToWidgetApi then nil else v90,
		if not FFlagAXPassScreenSizeToWidgetApi then nil else u92
	})
	local v125 = nil

	if FFlagAXUseVirtualizedFeedInWidgetList then
		v125 = React.useCallback(function(n1: number) -- line: 547
			-- upvalues: v90 (copy), FFlagAXPassScreenSizeToWidgetApi (copy), WidgetListHorizontalMargin (copy), getBreakpointFromRowWidth (copy), u92 (ref), setScreenSize (ref)
			v90(n1)

			if FFlagAXPassScreenSizeToWidgetApi then
				local v144 = math.max(n1 - WidgetListHorizontalMargin * 2, 0)
				local v145 = getBreakpointFromRowWidth(v144, u92)

				setScreenSize(v145)
			end
		end, {
			if not FFlagAXPassScreenSizeToWidgetApi then nil else setScreenSize,
			if not FFlagAXPassScreenSizeToWidgetApi then nil else v90,
			if not FFlagAXPassScreenSizeToWidgetApi then nil else u92
		})
	end

	React.useEffect(function() -- line: 563
		-- upvalues: t4 (copy), u103 (ref)
		if t4.onNumItemsPerRowChanged then
			t4.onNumItemsPerRowChanged(u103)
		end
	end, {
		t4.onNumItemsPerRowChanged,
		u103
	})

	local v126 = if not FFlagEnableLeftNavOnConsole then nil else useSignalState(Display.GetDisplayStore().getDeviceSafePadding)

	if FFlagAXUseVirtualizedFeedInWidgetList then
		return React.createElement(VirtualizedFeed, {
			clipsDescendants = true,
			data = v123,
			renderItem = renderItem,
			horizontalPadding = WidgetListHorizontalMargin,
			verticalPadding = if not FFlagAXMigrateAllTabToSduiDev then nil else 8,
			onScroll = t4.onScroll,
			scrollEnabled = t4.scrollingEnabled,
			onEndReached = if not v98 then nil else v111,
			onEndReachedThreshold = v85,
			ListHeaderComponent = t4.listHeaderComponent,
			ListFooterComponent = v120,
			isLoading = v108,
			isEndOfList = t4.shouldCreateEndOfScrollElement,
			onContainerWidthChanged = v125,
			backgroundColor = Theme.BackgroundDefault.Color,
			backgroundTransparency = Theme.BackgroundDefault.Transparency,
			flatListRef = v81,
			ref = v80
		})
	end

	return React.createElement(RoactGamepad.Focusable.Frame, {
		BackgroundColor3 = Theme.BackgroundDefault.Color,
		BackgroundTransparency = Theme.BackgroundDefault.Transparency,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		ClipsDescendants = true,
		[React.Change.AbsoluteSize] = v124,
		ref = v80,
		defaultChild = if not t4.showingEntries then nil else v82[1],
		restorePreviousChildFocus = t4.restorePreviousChildFocus,
		NextSelectionRight = t4.NextSelectionRight,
		NextSelectionUp = t4.NextSelectionUp
	}, {
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, WidgetListHorizontalMargin),
			PaddingRight = UDim.new(0, WidgetListHorizontalMargin),
			PaddingBottom = UDim.new(0, not FFlagEnableLeftNavOnConsole and 0 or v126.bottom)
		}),
		WidgetFlatList = React.createElement(FlatList, {
			UNSTABLE_forceSiblingLayoutUpdate = true,
			showDefaultLoadingIndicators = true,
			data = v123,
			renderItem = renderItem,
			windowSize = t1.WINDOW_SIZE,
			initialNumToRender = t1.INITIAL_NUM_TO_RENDER,
			maxToRenderPerBatch = t1.MAX_TO_RENDER_PER_BATCH,
			updateCellsBatchingPeriod = t1.UPDATE_CELLS_BATCHING_PERIOD,
			scrollEventThrottle = t1.SCROLL_EVENT_THROTTLE,
			ref = v81,
			contentContainerStyle = t2,
			style = t3,
			onScroll = v121,
			onEndReachedThreshold = v85,
			onEndReached = if not v98 then nil else v111,
			ListHeaderComponent = t4.listHeaderComponent,
			ListFooterComponent = v120,
			scrollEnabled = t4.scrollingEnabled
		})
	})
end

return WidgetList
