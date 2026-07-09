local SduiSharedContent = script:FindFirstAncestor("SduiSharedContent")
local SduiSharedContentParent = SduiSharedContent.Parent
local React = require(SduiSharedContentParent.React)
local Foundation = require(SduiSharedContentParent.Foundation)
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local useAnimateScrollViewToSelection = require(SduiSharedContentParent.AppBlox).useAnimateScrollViewToSelection
local AppNavBar = require(SduiSharedContentParent.AppNavBar)
local useNavBarPlacement = AppNavBar.useNavBarPlacement
local useLastInputMode = require(SduiSharedContentParent.FocusNavigationUtils).useLastInputMode
local Responsive = require(SduiSharedContentParent.Responsive)
local usePreferredInput = Responsive.usePreferredInput
local AppCommonLib = require(SduiSharedContentParent.AppCommonLib)

require(SduiSharedContentParent.SduiCompat)

local SduiCoreSystem = require(SduiSharedContentParent.SduiCoreSystem)
local CollectionViews = require(SduiSharedContentParent.CollectionViews)
local CollectionLayoutStoreProvider = CollectionViews.CollectionLayoutStoreProvider
local CollectionLayoutStoreContext = CollectionViews.CollectionLayoutStoreContext
local SduiPoolStore = SduiCoreSystem.SduiPoolStore
local SduiFeedContext = require(SduiSharedContent.Components.SduiFeedContext)
local SduiStickyHeader = require(SduiSharedContent.Components.SduiStickyHeader)
local PullToRefreshSpinner = require(SduiSharedContent.Components.PullToRefreshSpinner)
local useVerticalScrolledToEndThreshold = require(SduiSharedContent.Components.useVerticalScrolledToEndThreshold)
local useProgressiveRowCap = require(SduiSharedContent.Components.useProgressiveRowCap)
local buildSduiFeedChildren = require(SduiSharedContent.Components.buildSduiFeedChildren)
local SduiFeedImpressionsDetector = require(SduiSharedContent.Components.SduiFeedImpressionsDetector)
local FFlagSduiPoolBackedFeed = require(SduiSharedContentParent.SharedFlags).FFlagSduiPoolBackedFeed

local function PoolStoreLayoutStoreWiring(t1: {[any]: any}) -- line: 100
	-- upvalues: React (copy), CollectionLayoutStoreContext (copy), SduiPoolStore (copy)
	local v30 = React.useContext(CollectionLayoutStoreContext)

	React.useEffect(function() -- line: 102
		-- upvalues: v30 (copy), SduiPoolStore (copy), t1 (copy)
		if v30 == nil then
			return
		end

		local v71 = SduiPoolStore.getSduiPoolStore(t1.configKey)

		v71.setLayoutStore(v30)

		return function() -- line: 108
			-- upvalues: v71 (copy)
			v71.setLayoutStore(nil)
		end
	end, {
		t1.configKey,
		v30
	})

	return nil
end
local function SduiVerticalFeed(t2: {[any]: any}) -- line: 115
	-- upvalues: useTokens (copy), useNavBarPlacement (copy), AppNavBar (copy), usePreferredInput (copy), Responsive (copy), React (copy), AppCommonLib (copy), useAnimateScrollViewToSelection (copy), useLastInputMode (copy), useProgressiveRowCap (copy), useVerticalScrolledToEndThreshold (copy), FFlagSduiPoolBackedFeed (copy), PoolStoreLayoutStoreWiring (copy), SduiFeedImpressionsDetector (copy), buildSduiFeedChildren (copy), SduiFeedContext (copy), CollectionLayoutStoreProvider (copy), View (copy), SduiStickyHeader (copy), PullToRefreshSpinner (copy)
	local analyticsContext = t2.analyticsContext
	local sduiContext = t2.sduiContext
	local feedItems = t2.feedItems
	local debugName = t2.debugName
	local v36 = t2.contentTag or t2.defaultContentTag
	local v37 = v36 ~= nil and v36 ~= ""
	local v38 = useTokens()
	local v39 = t2.stickyItems ~= nil
	local v40 = t2.onRefresh ~= nil
	local v41 = t2.stickyContentTag or t2.defaultStickyContentTag
	local v42 = t2.stickyBackgroundStyle or v38.Color.Surface.Surface_0
	local stickyPaddingTop = t2.stickyPaddingTop
	local stickyPaddingBottom = t2.stickyPaddingBottom
	local v45 = t2.gapBetweenStickyItems or v38.Gap.Medium
	local v46 = t2.gapAfterStickyItems or v38.Gap.Medium
	local v47 = useNavBarPlacement()
	local v48 = t2.impressionsTag or (sduiContext.routeName or sduiContext.appPage)
	local v49 = t2.selectionBehaviorLeft or if v47 ~= AppNavBar.Placement.Left then Enum.SelectionBehavior.Stop else Enum.SelectionBehavior.Escape
	local v50 = t2.selectionBehaviorRight or Enum.SelectionBehavior.Stop
	local v51 = usePreferredInput()
	local v52 = t2.scrollBarThickness or (v51 ~= Responsive.Input.Pointer and 0 or 4)
	local v53, v54 = React.useState(nil)
	local v55 = React.useRef(nil)
	local v56 = React.useRef(nil)

	if v56.current == nil then
		v56.current = AppCommonLib.Signal.new()
	end

	local v57 = React.useCallback(function() -- line: 154
		-- upvalues: v56 (copy)
		v56.current:fire()
	end, {})
	local v58 = React.useMemo(function() -- line: 158
		-- upvalues: v56 (copy), v55 (copy)
		return {
			scrollViewPositionChangedSignal = v56.current,
			verticalScrollingFrameRef = v55
		}
	end, {
		v56,
		v55
	})
	local v59 = t2.gapBetweenFeedItems or v38.Gap.Large
	local v60 = React.useMemo(function() -- line: 167
		-- upvalues: v56 (copy), v55 (copy)
		return {
			scrollViewPositionChangedSignal = v56.current,
			verticalScrollingFrameRef = v55
		}
	end, {
		v56,
		v55
	})
	local v61 = t2.scrollingFrameRef or v55

	React.useEffect(function() -- line: 180
		-- upvalues: t2 (copy), v57 (copy)
		if not t2.scrollingFrameRef or not t2.scrollingFrameRef.current then
			return nil
		end

		local current = t2.scrollingFrameRef.current
		local t3 = {
			current:GetPropertyChangedSignal("CanvasPosition"):Connect(v57),
			current:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(v57)
		}

		return function() -- line: 191
			-- upvalues: t3 (copy)
			for _, v79 in t3 do
				v79:Disconnect()
			end
		end
	end, {
		t2.scrollingFrameRef,
		v57
	})
	useAnimateScrollViewToSelection(v61, 0.4)

	local v62 = useLastInputMode() ~= "Cursor"
	local v63 = t2.thresholdFromEnd or 600
	local v64, v65 = useProgressiveRowCap(not feedItems and 0 or #feedItems, t2.initialNumToRender, t2.progressiveFillRate, t2.progressiveFillIntervalMs)

	useVerticalScrolledToEndThreshold(v61, v63, if not v65 then t2.onScrollToEnd else nil)

	local v66 = React.useMemo(function() -- line: 220
		-- upvalues: feedItems (copy), t2 (copy), React (copy), v59 (copy), v39 (copy), v46 (copy), FFlagSduiPoolBackedFeed (copy), sduiContext (copy), PoolStoreLayoutStoreWiring (copy), v48 (copy), SduiFeedImpressionsDetector (copy), v61 (copy), v56 (copy), buildSduiFeedChildren (copy), debugName (copy), v49 (copy), v50 (copy), v60 (copy), v64 (copy)
		if feedItems == nil then
			return nil
		end

		local v74 = t2.pageBottomPadding or 80
		local t4 = {
			BottomSpacer = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 1e999,
				Size = UDim2.new(1, 0, 0, v74)
			}),
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, v59)
			}),
			StickyGap = if not v39 or (not v46 or not (v46 > 0)) then nil else React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 0,
				Size = UDim2.new(1, 0, 0, (math.max(0, v46 - v59)))
			}),
			PoolStoreLayoutStoreWiring = if not FFlagSduiPoolBackedFeed or sduiContext.configKey == nil then nil else React.createElement(PoolStoreLayoutStoreWiring, {
				configKey = sduiContext.configKey
			}),
			FeedImpressionsDetector = if not v48 or not feedItems then nil else React.createElement(SduiFeedImpressionsDetector, {
				sduiContext = sduiContext,
				feedItems = feedItems,
				parentRef = v61,
				impressionsTag = v48,
				scrollViewPositionChangedSignal = v56.current
			})
		}

		for v76, v77 in (buildSduiFeedChildren({
			componentType = "VerticalFeed",
			configs = feedItems,
			sduiContext = sduiContext,
			debugName = debugName,
			impressionsTag = v48,
			selectionBehaviorLeft = v49,
			selectionBehaviorRight = v50,
			extraLocalProps = v60,
			maxConfigs = v64
		})) do
			t4[v76] = v77
		end

		return t4
	end, {
		feedItems,
		debugName,
		v55,
		v56,
		sduiContext,
		analyticsContext,
		v59,
		v48,
		v49,
		v50,
		v39,
		v46,
		v60,
		v37,
		t2.pageBottomPadding,
		v61,
		v64
	})

	if v58 then
		v66 = React.createElement(SduiFeedContext.Provider, {
			value = v58
		}, v66)
	end

	local v67 = React.createElement(CollectionLayoutStoreProvider, {
		container = v53
	}, v66)
	local t5 = {
		["size-full-0 auto-y"] = true
	}

	if v37 then
		t5[v36] = true
	end

	local v69 = React.createElement(View, {
		tag = t5,
		LayoutOrder = t2.layoutOrder,
		ref = v54
	}, v67)

	if t2.scrollingFrameRef ~= nil then
		return v69
	end

	local v70 = React.createElement("ScrollingFrame", {
		LayoutOrder = 3,
		ref = v55,
		[React.Change.CanvasPosition] = v57,
		[React.Change.CanvasSize] = v57,
		BackgroundColor3 = if not t2.backgroundStyle then v38.Color.Surface.Surface_0.Color3 else t2.backgroundStyle.Color3,
		BackgroundTransparency = if not t2.backgroundStyle then nil else t2.backgroundStyle.Transparency,
		Size = UDim2.fromScale(1, 0),
		CanvasSize = UDim2.new(1, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		BorderSizePixel = 0,
		ScrollBarThickness = v52,
		ElasticBehavior = Enum.ElasticBehavior.Always,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		Selectable = false,
		ScrollingEnabled = not v62,
		ClipsDescendants = false
	}, {
		FlexFill = React.createElement("UIFlexItem", {
			FlexMode = Enum.UIFlexMode.Fill
		}),
		Content = v69
	})

	return React.createElement(View, {
		tag = "size-full",
		LayoutOrder = t2.layoutOrder,
		layout = {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder
		}
	}, {
		Sticky = if not v39 then nil else React.createElement(SduiStickyHeader, {
			zIndex = 2,
			stickyItems = t2.stickyItems,
			sduiContext = sduiContext,
			debugName = `{ debugName }.StickyHeader`,
			contentTag = v41,
			backgroundStyle = v42,
			paddingTop = stickyPaddingTop,
			paddingBottom = stickyPaddingBottom,
			gapBetweenItems = v45,
			extraLocalProps = v60,
			impressionsTag = v48,
			selectionBehaviorLeft = v49,
			selectionBehaviorRight = v50
		}),
		RefreshSpinner = if not v40 then nil else React.createElement(PullToRefreshSpinner, {
			LayoutOrder = 2,
			onRefresh = t2.onRefresh,
			scrollingFrameRef = v55,
			appEventName = sduiContext.appPage
		}),
		Scroll = v70
	})
end

return React.memo(SduiVerticalFeed)
