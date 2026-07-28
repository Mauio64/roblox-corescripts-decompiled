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
local ScrollMovementDirection = require(SduiSharedContentParent.RobloxAppEnums).ScrollMovementDirection

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
local SharedFlags = require(SduiSharedContentParent.SharedFlags)
local FFlagSduiPoolBackedFeed = SharedFlags.FFlagSduiPoolBackedFeed
local FFlagSduiSrpScrollAway = SharedFlags.FFlagSduiSrpScrollAway

local function PoolStoreLayoutStoreWiring(t1: {[any]: any}) -- line: 104
	-- upvalues: React (copy), CollectionLayoutStoreContext (copy), SduiPoolStore (copy)
	local v33 = React.useContext(CollectionLayoutStoreContext)

	React.useEffect(function() -- line: 106
		-- upvalues: v33 (copy), SduiPoolStore (copy), t1 (copy)
		if v33 == nil then
			return
		end

		local v77 = SduiPoolStore.getSduiPoolStore(t1.configKey)

		v77.setLayoutStore(v33)

		return function() -- line: 112
			-- upvalues: v77 (copy)
			v77.setLayoutStore(nil)
		end
	end, {
		t1.configKey,
		v33
	})

	return nil
end
local function SduiVerticalFeed(t2: {[any]: any}) -- line: 119
	-- upvalues: useTokens (copy), useNavBarPlacement (copy), AppNavBar (copy), usePreferredInput (copy), Responsive (copy), React (copy), AppCommonLib (copy), FFlagSduiSrpScrollAway (copy), ScrollMovementDirection (copy), useAnimateScrollViewToSelection (copy), useLastInputMode (copy), useProgressiveRowCap (copy), useVerticalScrolledToEndThreshold (copy), FFlagSduiPoolBackedFeed (copy), PoolStoreLayoutStoreWiring (copy), SduiFeedImpressionsDetector (copy), buildSduiFeedChildren (copy), SduiFeedContext (copy), CollectionLayoutStoreProvider (copy), View (copy), SduiStickyHeader (copy), PullToRefreshSpinner (copy)
	local analyticsContext = t2.analyticsContext
	local sduiContext = t2.sduiContext
	local feedItems = t2.feedItems
	local debugName = t2.debugName
	local v39 = t2.contentTag or t2.defaultContentTag
	local v40 = v39 ~= nil and v39 ~= ""
	local v41 = useTokens()
	local v42 = t2.stickyItems ~= nil
	local v43 = t2.onRefresh ~= nil
	local v44 = t2.stickyContentTag or t2.defaultStickyContentTag
	local v45 = t2.stickyBackgroundStyle or v41.Color.Surface.Surface_0
	local stickyPaddingTop = t2.stickyPaddingTop
	local stickyPaddingBottom = t2.stickyPaddingBottom
	local v48 = t2.gapBetweenStickyItems or v41.Gap.Medium
	local v49 = t2.gapAfterStickyItems or v41.Gap.Medium
	local v50 = useNavBarPlacement()
	local v51 = t2.impressionsTag or (sduiContext.routeName or sduiContext.appPage)
	local v52 = t2.selectionBehaviorLeft or if v50 ~= AppNavBar.Placement.Left then Enum.SelectionBehavior.Stop else Enum.SelectionBehavior.Escape
	local v53 = t2.selectionBehaviorRight or Enum.SelectionBehavior.Stop
	local v54 = usePreferredInput()
	local v55 = t2.scrollBarThickness or (v54 ~= Responsive.Input.Pointer and 0 or 4)
	local v56, v57 = React.useState(nil)
	local v58 = React.useRef(nil)
	local v59 = React.useRef(nil)

	if v59.current == nil then
		v59.current = AppCommonLib.Signal.new()
	end

	local v60 = React.useCallback(function() -- line: 158
		-- upvalues: v59 (copy)
		v59.current:fire()
	end, {})
	local v61 = if not FFlagSduiSrpScrollAway then nil else React.useRef(0)
	local v62 = if not FFlagSduiSrpScrollAway then nil else React.useRef(ScrollMovementDirection.Backward)
	local v63 = if not FFlagSduiSrpScrollAway then nil else React.useCallback(function(p1) -- line: 166
		-- upvalues: v60 (copy), t2 (copy), v61 (copy), ScrollMovementDirection (copy), v62 (copy)
		v60()

		local onScrollDirectionChanged = t2.onScrollDirectionChanged

		if not onScrollDirectionChanged then
			return
		end

		local CanvasPositionY = p1.CanvasPosition.Y

		if CanvasPositionY < 0 then
			return
		end

		if CanvasPositionY == v61.current then
			return
		end

		local v81 = if not (CanvasPositionY > v61.current) then ScrollMovementDirection.Backward else ScrollMovementDirection.Forward

		if v81 ~= v62.current then
			onScrollDirectionChanged(v81)
			v62.current = v81
		end

		v61.current = CanvasPositionY
	end, {
		v60,
		t2.onScrollDirectionChanged
	})
	local v64 = React.useMemo(function() -- line: 194
		-- upvalues: v59 (copy), v58 (copy)
		return {
			scrollViewPositionChangedSignal = v59.current,
			verticalScrollingFrameRef = v58
		}
	end, {
		v59,
		v58
	})
	local v65 = t2.gapBetweenFeedItems or v41.Gap.Large
	local v66 = React.useMemo(function() -- line: 203
		-- upvalues: v59 (copy), v58 (copy)
		return {
			scrollViewPositionChangedSignal = v59.current,
			verticalScrollingFrameRef = v58
		}
	end, {
		v59,
		v58
	})
	local v67 = t2.scrollingFrameRef or v58

	React.useEffect(function() -- line: 217
		-- upvalues: t2 (copy), FFlagSduiSrpScrollAway (copy), v61 (copy), v63 (copy), v60 (copy)
		if not t2.scrollingFrameRef or not t2.scrollingFrameRef.current then
			return nil
		end

		local current = t2.scrollingFrameRef.current

		if FFlagSduiSrpScrollAway then
			v61.current = current.CanvasPosition.Y
		end

		local v83 = if not FFlagSduiSrpScrollAway then {
			current:GetPropertyChangedSignal("CanvasPosition"):Connect(v60),
			current:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(v60)
		} else {
			current:GetPropertyChangedSignal("CanvasPosition"):Connect(function() -- line: 230
				-- upvalues: v63 (copy), current (copy)
				v63(current)
			end),
			current:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(v60)
		}

		return function() -- line: 240
			-- upvalues: v83 (copy)
			for _, v89 in v83 do
				v89:Disconnect()
			end
		end
	end, {
		t2.scrollingFrameRef,
		v60,
		if not FFlagSduiSrpScrollAway then nil else v63
	})
	useAnimateScrollViewToSelection(v67, 0.4)

	local v68 = useLastInputMode() ~= "Cursor"
	local v69 = t2.thresholdFromEnd or 600
	local v70, v71 = useProgressiveRowCap(not feedItems and 0 or #feedItems, t2.initialNumToRender, t2.progressiveFillRate, t2.progressiveFillIntervalMs)

	useVerticalScrolledToEndThreshold(v67, v69, if not v71 then t2.onScrollToEnd else nil)

	local v72 = React.useMemo(function() -- line: 275
		-- upvalues: feedItems (copy), t2 (copy), React (copy), v65 (copy), v42 (copy), v49 (copy), FFlagSduiPoolBackedFeed (copy), sduiContext (copy), PoolStoreLayoutStoreWiring (copy), v51 (copy), SduiFeedImpressionsDetector (copy), v67 (copy), v59 (copy), buildSduiFeedChildren (copy), debugName (copy), v52 (copy), v53 (copy), v66 (copy), v70 (copy)
		if feedItems == nil then
			return nil
		end

		local v84 = t2.pageBottomPadding or 80
		local t3 = {
			BottomSpacer = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 1e999,
				Size = UDim2.new(1, 0, 0, v84)
			}),
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, v65)
			}),
			StickyGap = if not v42 or (not v49 or not (v49 > 0)) then nil else React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 0,
				Size = UDim2.new(1, 0, 0, (math.max(0, v49 - v65)))
			}),
			PoolStoreLayoutStoreWiring = if not FFlagSduiPoolBackedFeed or sduiContext.configKey == nil then nil else React.createElement(PoolStoreLayoutStoreWiring, {
				configKey = sduiContext.configKey
			}),
			FeedImpressionsDetector = if not v51 or not feedItems then nil else React.createElement(SduiFeedImpressionsDetector, {
				sduiContext = sduiContext,
				feedItems = feedItems,
				parentRef = v67,
				impressionsTag = v51,
				scrollViewPositionChangedSignal = v59.current
			})
		}

		for v86, v87 in (buildSduiFeedChildren({
			componentType = "VerticalFeed",
			configs = feedItems,
			sduiContext = sduiContext,
			debugName = debugName,
			impressionsTag = v51,
			selectionBehaviorLeft = v52,
			selectionBehaviorRight = v53,
			extraLocalProps = v66,
			maxConfigs = v70
		})) do
			t3[v86] = v87
		end

		return t3
	end, {
		feedItems,
		debugName,
		v58,
		v59,
		sduiContext,
		analyticsContext,
		v65,
		v51,
		v52,
		v53,
		v42,
		v49,
		v66,
		v40,
		t2.pageBottomPadding,
		v67,
		v70
	})

	if v64 then
		v72 = React.createElement(SduiFeedContext.Provider, {
			value = v64
		}, v72)
	end

	local v73 = React.createElement(CollectionLayoutStoreProvider, {
		container = v56
	}, v72)
	local t4 = {
		["size-full-0 auto-y"] = true
	}

	if v40 then
		t4[v39] = true
	end

	local v75 = React.createElement(View, {
		tag = t4,
		LayoutOrder = t2.layoutOrder,
		ref = v57
	}, v73)

	if t2.scrollingFrameRef ~= nil then
		return v75
	end

	local v76 = React.createElement("ScrollingFrame", {
		LayoutOrder = 3,
		ref = v58,
		[React.Change.CanvasPosition] = if not FFlagSduiSrpScrollAway then v60 else v63,
		[React.Change.CanvasSize] = v60,
		BackgroundColor3 = if not t2.backgroundStyle then v41.Color.Surface.Surface_0.Color3 else t2.backgroundStyle.Color3,
		BackgroundTransparency = if not t2.backgroundStyle then nil else t2.backgroundStyle.Transparency,
		Size = UDim2.fromScale(1, 0),
		CanvasSize = UDim2.new(1, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		BorderSizePixel = 0,
		ScrollBarThickness = v55,
		ElasticBehavior = Enum.ElasticBehavior.Always,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		Selectable = false,
		ScrollingEnabled = not v68,
		ClipsDescendants = false
	}, {
		FlexFill = React.createElement("UIFlexItem", {
			FlexMode = Enum.UIFlexMode.Fill
		}),
		Content = v75
	})

	return React.createElement(View, {
		tag = "size-full",
		LayoutOrder = t2.layoutOrder,
		layout = {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder
		}
	}, {
		Sticky = if not v42 then nil else React.createElement(SduiStickyHeader, {
			zIndex = 2,
			stickyItems = t2.stickyItems,
			sduiContext = sduiContext,
			debugName = `{ debugName }.StickyHeader`,
			contentTag = v44,
			backgroundStyle = v45,
			paddingTop = stickyPaddingTop,
			paddingBottom = stickyPaddingBottom,
			gapBetweenItems = v48,
			extraLocalProps = v66,
			impressionsTag = v51,
			selectionBehaviorLeft = v52,
			selectionBehaviorRight = v53
		}),
		RefreshSpinner = if not v43 then nil else React.createElement(PullToRefreshSpinner, {
			LayoutOrder = 2,
			onRefresh = t2.onRefresh,
			scrollingFrameRef = v58,
			appEventName = sduiContext.appPage
		}),
		Scroll = v76
	})
end

return React.memo(SduiVerticalFeed)
