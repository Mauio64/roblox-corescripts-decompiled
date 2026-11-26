local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Foundation")
local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local useAnimateScrollViewToSelection = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/AppBlox").useAnimateScrollViewToSelection
local AppNavBar = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/AppNavBar")
local useNavBarPlacement = AppNavBar.useNavBarPlacement
local useLastInputMode = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/FocusNavigationUtils").useLastInputMode
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Responsive")
local usePreferredInput = Responsive.usePreferredInput
local AppCommonLib = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/AppCommonLib")
local scrollMovementDirection = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/RobloxAppEnums").ScrollMovementDirection
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCompat")
local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCoreSystem")
local DiscoveryTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/DiscoveryTypes")

local CollectionViews = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/CollectionViews")
local collectionLayoutStoreProvider = CollectionViews.CollectionLayoutStoreProvider
local collectionLayoutStoreContext = CollectionViews.CollectionLayoutStoreContext

local sduiPoolStore = SduiCoreSystem.SduiPoolStore

local SduiFeedContext = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/SduiFeedContext")
local SduiStickyHeader = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/SduiStickyHeader")
local pullToRefreshSpinner = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/AppPageShell").PullToRefreshSpinner
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SignalsReact")
local tutils = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/tutils")
local useVerticalScrolledToEndThreshold = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/useVerticalScrolledToEndThreshold")
local useProgressiveRowCap = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/useProgressiveRowCap")
local useProgressiveItemCapOnScroll = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/useProgressiveItemCapOnScroll")
local buildSduiFeedChildren = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/buildSduiFeedChildren")
local SduiFeedImpressionsDetector = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/SduiFeedImpressionsDetector")
local BackToTopButton = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/BackToTopButton")
local scrollDetector = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/ScrollTelemetry").ScrollDetector

local createScrollIntervalPerformanceTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/IntervalPerformanceTracker").createScrollIntervalPerformanceTracker
local viewportVideoAutoplaySync = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/VideoUtils").ViewportVideoAutoplaySync

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags")
local fFlagLuaAppSduiHomeFriendCarousel = SharedFlags.FFlagLuaAppSduiHomeFriendCarousel
local defineFastInt = game:DefineFastInt("SduiVerticalFeedScrollInitialNumRows", 4)
local defineFastInt2 = game:DefineFastInt("SduiVerticalFeedScrollLoadNumRows", 3)
local defineFastInt3 = game:DefineFastInt("SduiVerticalFeedScrollPreloadDistancePx", 2000)

local defineFastInt4 = game:DefineFastInt("SduiVerticalFeedScrollUnderfillDebounceMs", 50)
local defineFastFlag = game:DefineFastFlag("SduiEnableBackToTop", false)
local fFlagSduiPageCanvasCollectionLayout = SharedFlags.FFlagSduiPageCanvasCollectionLayout
local fFlagLuaAppSduiVideoThumbnail = SharedFlags.FFlagLuaAppSduiVideoThumbnail
local fFlagLuaAppMediaGalleryGamepadSupport = SharedFlags.FFlagLuaAppMediaGalleryGamepadSupport
local fFlagLuaAppOneByTwoHoverIdleAutoplay = SharedFlags.FFlagLuaAppOneByTwoHoverIdleAutoplay
local fFlagLuaAppSduiSuppressVideoDetectorDuringScroll = SharedFlags.FFlagLuaAppSduiSuppressVideoDetectorDuringScroll
local fFlagAppPageShellScrollToTopFocus = SharedFlags.FFlagAppPageShellScrollToTopFocus
local fFlagSduiVerticalFeedScrollTelemetry = SharedFlags.FFlagSduiVerticalFeedScrollTelemetry
local fFlagSduiIndividualFeedItemSpacing = SharedFlags.FFlagSduiIndividualFeedItemSpacing
local fFlagSduiSamePoolFeedItemSpacing = SharedFlags.FFlagSduiSamePoolFeedItemSpacing

local signal = Signals.createSignal(nil)

local frozen = table.freeze({})

local function PoolStoreLayoutStoreWiring(p2): nil
	local v5 = React.useContext(collectionLayoutStoreContext)
	React.useEffect(function()
		if v5 == nil then
			return
		end

		local sduiPoolStore2 = sduiPoolStore.getSduiPoolStore(p2.configKey)
		sduiPoolStore2.setLayoutStore(v5)
		return function()
			sduiPoolStore2.setLayoutStore(nil)
		end
	end, { p2.configKey, v5 })
	return nil
end

local function getFeedItemRowCount(p2, p3)
	local numberOfRowsGetter = p2.numberOfRowsGetter

	if numberOfRowsGetter ~= nil then
		local v5 = numberOfRowsGetter(p3)

		if v5 > 0 then
			return v5
		end
	end

	return 1
end

local function useProgressiveRowCapWithScroll(feedItems, initialNumToRender, progressiveFillRate, progressiveFillIntervalMs, progressiveFillOnScroll, scrollingFrameRef, ref, defineFastInt5)
	local v6, v7 = useProgressiveRowCap(
		feedItems and #feedItems or 0,
		initialNumToRender,
		progressiveFillRate,
		progressiveFillIntervalMs
	)

	local v8 = React.useMemo(function()
		return Signals.createComputed(function(p2)
			signal(p2)

			if not progressiveFillOnScroll then
				return frozen
			end

			local result = table.create(feedItems and #feedItems or 0)

			if not feedItems then
				return result
			end

			for k, item in feedItems do
				local numberOfRowsGetter = item.numberOfRowsGetter
				local v9

				if numberOfRowsGetter == nil then
					v9 = 1
				else
					local v10 = numberOfRowsGetter(p2)
					v9 = not (v10 > 0) and 1 or v10
				end

				result[k] = v9
			end

			return result
		end, tutils.shallowEqual)
	end, { feedItems, progressiveFillOnScroll })

	local v9 = SignalsReact.useSignalState(v8)

	if not progressiveFillOnScroll then
		scrollingFrameRef = nil
	end

	if not progressiveFillOnScroll then
		ref = nil
	end

	local v13, v14 = useProgressiveItemCapOnScroll(
		v9,
		defineFastInt,
		defineFastInt2,
		scrollingFrameRef,
		ref,
		defineFastInt3,
		defineFastInt5
	)

	if progressiveFillOnScroll then
		return math.min(v6, v13), v7 or v14
	end

	return v6, v7
end

local function SduiVerticalFeed(props)
	local analyticsContext = props.analyticsContext
	local sduiContext = props.sduiContext
	local videoPlaybackContext

	if fFlagLuaAppSduiVideoThumbnail or fFlagLuaAppOneByTwoHoverIdleAutoplay then
		videoPlaybackContext = sduiContext.videoPlaybackContext
	end

	local feedItems = props.feedItems
	local debugName = props.debugName
	local contentTag = props.contentTag or props.defaultContentTag
	local v5 = not (contentTag == nil) and contentTag ~= ""

	local v6 = useTokens()

	local v7 = not (props.stickyItems == nil) and #props.stickyItems > 0
	local v8 = props.onRefresh ~= nil
	local stickyContentTag = props.stickyContentTag or props.defaultStickyContentTag
	local stickyBackgroundStyle = props.stickyBackgroundStyle or v6.Color.Surface.Surface_0

	local stickyPaddingTop = props.stickyPaddingTop or v6.Gap.Medium
	local stickyPaddingBottom = props.stickyPaddingBottom or v6.Gap.Medium
	local gapBetweenStickyItems = props.gapBetweenStickyItems or v6.Gap.Medium
	local gapAfterStickyItems = props.gapAfterStickyItems or v6.Gap.Medium
	local v9 = useNavBarPlacement()
	local impressionsTag = props.impressionsTag or sduiContext.routeName or sduiContext.appPage
	local v10 = props.selectionBehaviorLeft

	if not v10 then
		if v9 == AppNavBar.Placement.Left then
			v10 = Enum.SelectionBehavior.Escape
		else
			v10 = Enum.SelectionBehavior.Stop
		end
	end

	local selectionBehaviorRight = props.selectionBehaviorRight or Enum.SelectionBehavior.Stop
	local v11 = usePreferredInput()
	local scrollBarThickness = props.scrollBarThickness or v11 == Responsive.Input.Pointer and 4 or 0

	local state, setState = React.useState(nil)

	local ref = React.useRef(nil)
	local scrollingFrameRef = props.scrollingFrameRef or ref

	local ref2 = React.useRef(nil)

	local ref3 = React.useRef(nil)

	if ref3.current == nil then
		ref3.current = AppCommonLib.Signal.new()
	end

	local v12 = React.useCallback(function()
		ref3.current:fire()
	end, {})
	local ref4, v13

	if fFlagLuaAppSduiHomeFriendCarousel then
		ref4 = React.useRef(nil)

		if ref4.current == nil then
			local v14 = if props.refreshSignal then props.refreshSignal else AppCommonLib.Signal.new()
			ref4.current = v14
		end

		v13 = React.useCallback(function()
			if ref4.current then
				ref4.current:fire()
			end

			if props.onRefresh then
				return props.onRefresh()
			end

			return nil
		end, { props.onRefresh, ref4 })
	else
		ref4 = nil
	end

	local ref5 = React.useRef(0)
	local ref6 = React.useRef(scrollMovementDirection.Backward)
	local v14 = React.useCallback(function(p2)
		v12()
		local onScrollDirectionChanged = props.onScrollDirectionChanged

		if not onScrollDirectionChanged then
			return
		end

		local y = p2.CanvasPosition.Y

		if y < 0 or y == ref5.current then
			return
		end

		local v15

		if ref5.current < y then
			v15 = scrollMovementDirection.Forward
		else
			v15 = scrollMovementDirection.Backward
		end

		if v15 ~= ref6.current then
			onScrollDirectionChanged(v15)
			ref6.current = v15
		end

		ref5.current = y
	end, { v12, props.onScrollDirectionChanged })

	local v15 = React.useMemo(function()
		return {
			scrollViewPositionChangedSignal = ref3.current,
			verticalScrollingFrameRef = scrollingFrameRef
		}
	end, { ref3, ref, scrollingFrameRef })

	local gapBetweenFeedItems = props.gapBetweenFeedItems or v6.Gap.Large
	local samePoolFeedItemGap

	if fFlagSduiSamePoolFeedItemSpacing then
		samePoolFeedItemGap = props.samePoolFeedItemGap or v6.Gap.Large
	else
		samePoolFeedItemGap = nil
	end

	local v16 = React.useMemo(function()
		local v17 = {
			scrollViewPositionChangedSignal = ref3.current,
			verticalScrollingFrameRef = scrollingFrameRef,
			refreshSignal = 0
		}

		local v18 = if fFlagLuaAppSduiHomeFriendCarousel then ref4.current else nil
		v17.refreshSignal = v18
		return v17
	end, { ref3, scrollingFrameRef })

	local state2 = nil
	local v17 = nil

	if defineFastFlag then
		local setState2
		state2, setState2 = React.useState(false)
		v17 = setState2
		React.useEffect(function()
			if not props.enableBackToTop then
				return
			end

			local current = scrollingFrameRef.current

			if not current then
				return
			end

			local function updateIsScrollable()
				local y = current.AbsoluteWindowSize.Y
				local y2 = current.AbsoluteCanvasSize.Y

				if y < 0 or y2 < 0 then
					return
				end

				v17(y < y2)
			end

			local v18 = {
				current:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(updateIsScrollable),
				current:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(updateIsScrollable)
			}
			local y = current.AbsoluteWindowSize.Y
			local y2 = current.AbsoluteCanvasSize.Y

			if not (y < 0 or y2 < 0) then
				v17(y < y2)
			end

			return function()
				for k, connection in v18 do
					connection:Disconnect()
				end
			end
		end, { scrollingFrameRef, props.enableBackToTop })
	end

	if fFlagSduiVerticalFeedScrollTelemetry then
		React.useEffect(function()
			local scrollPerformanceIntervalName = props.scrollPerformanceIntervalName
			local current = scrollingFrameRef.current

			if scrollPerformanceIntervalName == nil or current == nil then
				return
			end

			local scrollIntervalPerformanceTracker = createScrollIntervalPerformanceTracker(
				scrollPerformanceIntervalName,
				current
			)
			local canvasPositionChangedConnection = current:GetPropertyChangedSignal("CanvasPosition"):Connect(scrollIntervalPerformanceTracker.onScrollTick)
			return function()
				canvasPositionChangedConnection:Disconnect()
				scrollIntervalPerformanceTracker.cleanup()
			end
		end, { scrollingFrameRef, props.scrollPerformanceIntervalName })
	end

	React.useEffect(function()
		if not (props.scrollingFrameRef and props.scrollingFrameRef.current) then
			return nil
		end

		local current = props.scrollingFrameRef.current
		ref5.current = current.CanvasPosition.Y

		local v18 = {
			current:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
				v14(current)
			end),
			current:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(v12)
		}

		return function()
			for k, connection in v18 do
				connection:Disconnect()
			end
		end
	end, { props.scrollingFrameRef, v12, v14 })

	local v19 = if not props.scrollToSelectionAnimationManagedByParent then scrollingFrameRef else nil

	local v21 = if fFlagLuaAppMediaGalleryGamepadSupport then props.scrollToSelectionRevealOnly else nil
	useAnimateScrollViewToSelection(v19, 0.4, v21)

	local v22 = useLastInputMode() ~= "Cursor"

	local thresholdFromEnd = props.thresholdFromEnd or 600
	local viewportVideoAutoplayController, v23, v24

	if fFlagLuaAppSduiVideoThumbnail or fFlagLuaAppOneByTwoHoverIdleAutoplay then
		viewportVideoAutoplayController = if videoPlaybackContext then videoPlaybackContext.viewportVideoAutoplayController else nil

		v23 = React.useCallback(function()
			if viewportVideoAutoplayController then
				viewportVideoAutoplayController:onScrollStart()

				if
					fFlagLuaAppSduiSuppressVideoDetectorDuringScroll
					and viewportVideoAutoplayController.suppressDetectorsDuringScroll
				then
					viewportVideoAutoplayController.setDetectorsUnmounted(true)
				end
			end
		end, { viewportVideoAutoplayController })
		v24 = React.useCallback(function(p2)
			if viewportVideoAutoplayController then
				if
					fFlagLuaAppSduiSuppressVideoDetectorDuringScroll
					and viewportVideoAutoplayController.suppressDetectorsDuringScroll
				then
					viewportVideoAutoplayController.setDetectorsUnmounted(false)
				end

				viewportVideoAutoplayController:onScrollSettled("Y", p2)
			end
		end, { viewportVideoAutoplayController })
	else
		viewportVideoAutoplayController = nil
	end

	local v25, v26 = useProgressiveRowCapWithScroll(
		feedItems,
		props.initialNumToRender,
		props.progressiveFillRate,
		props.progressiveFillIntervalMs,
		props.progressiveFillOnScroll,
		scrollingFrameRef,
		ref2,
		defineFastInt4
	)

	local v28 = if not v26 then props.onScrollToEnd else nil
	useVerticalScrolledToEndThreshold(scrollingFrameRef, thresholdFromEnd, v28)

	local useMemo = React.useMemo
	local function fn()
		if feedItems == nil then
			return nil
		end

		local pageBottomPadding = props.pageBottomPadding or 80
		local v29

		if defineFastFlag and props.enableBackToTop and state2 then
			v29 = React.createElement(
				"Frame",
				{
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					LayoutOrder = 1000000
				},
				{
					Layout = React.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 0)
					}),
					Spacer = React.createElement("Frame", {
						Size = UDim2.new(1, 0, 0, pageBottomPadding),
						BackgroundTransparency = 1,
						LayoutOrder = 1
					}),
					BackToTop = React.createElement(BackToTopButton, {
						scrollingFrameRef = scrollingFrameRef,
						pageContext = sduiContext.appPage,
						layoutOrder = 2
					})
				}
			)
		else
			v29 = React.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, pageBottomPadding),
				BackgroundTransparency = 1,
				LayoutOrder = 1000000
			})
		end

		local result = {
			BottomSpacer = v29,
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, fFlagSduiIndividualFeedItemSpacing and 0 or gapBetweenFeedItems),
				ref = ref2
			}),
			StickyGap = 0,
			NoStickyTopMargin = 0,
			PoolStoreLayoutStoreWiring = 0,
			FeedImpressionsDetector = 0
		}
		local v30

		if v7 and gapAfterStickyItems and gapAfterStickyItems > 0 then
			local createElement = React.createElement
			local newUDim2 = UDim2.new
			local v36

			if fFlagSduiIndividualFeedItemSpacing then
				v36 = math.max(gapAfterStickyItems, gapBetweenFeedItems)
			else
				v36 = math.max(0, gapAfterStickyItems - gapBetweenFeedItems)
			end

			v30 = createElement("Frame", {
				Size = newUDim2(1, 0, 0, v36),
				BackgroundTransparency = 1,
				LayoutOrder = 0
			})
		end

		result.StickyGap = v30
		local v31

		if not (v7 or not (props.feedTopMargin and props.feedTopMargin > 0)) then
			local createElement = React.createElement
			local newUDim2 = UDim2.new
			local v37

			if fFlagSduiIndividualFeedItemSpacing then
				v37 = math.max(props.feedTopMargin, gapBetweenFeedItems)
			else
				v37 = math.max(0, props.feedTopMargin - gapBetweenFeedItems)
			end

			v31 = createElement("Frame", {
				Size = newUDim2(1, 0, 0, v37),
				BackgroundTransparency = 1,
				LayoutOrder = 0
			})
		end

		result.NoStickyTopMargin = v31

		local v32 = if sduiContext.configKey ~= nil then React.createElement(PoolStoreLayoutStoreWiring, {
			configKey = sduiContext.configKey
		}) else nil
		result.PoolStoreLayoutStoreWiring = v32

		local v33 = if impressionsTag and feedItems then React.createElement(SduiFeedImpressionsDetector, {
			sduiContext = sduiContext,
			feedItems = feedItems,
			parentRef = scrollingFrameRef,
			impressionsTag = impressionsTag,
			scrollViewPositionChangedSignal = ref3.current
		}) else nil
		result.FeedImpressionsDetector = v33

		local v35 = {
			configs = feedItems,
			sduiContext = sduiContext,
			debugName = debugName,
			componentType = "VerticalFeed",
			impressionsTag = impressionsTag,
			selectionBehaviorLeft = v10,
			selectionBehaviorRight = selectionBehaviorRight,
			extraLocalProps = v16,
			selectionOrderBase = 0,
			defaultFocusRef = 0,
			maxConfigs = 0,
			gapBetweenFeedItems = 0,
			gapAfterFirstFeedItem = 0,
			samePoolFeedItemGap = 0
		}

		local v36 = if fFlagAppPageShellScrollToTopFocus then DiscoveryTypes.Constants.SORT_SELECTION_ORDER_BASE else nil
		v35.selectionOrderBase = v36

		local v37 = if fFlagAppPageShellScrollToTopFocus then props.defaultFocusRef else nil
		v35.defaultFocusRef = v37
		v35.maxConfigs = v25
		v35.gapBetweenFeedItems = if fFlagSduiIndividualFeedItemSpacing then gapBetweenFeedItems else nil
		local v39 = if fFlagSduiIndividualFeedItemSpacing then props.gapAfterFirstFeedItem else nil
		v35.gapAfterFirstFeedItem = v39
		v35.samePoolFeedItemGap = if fFlagSduiSamePoolFeedItemSpacing then samePoolFeedItemGap else nil
		local v41 = buildSduiFeedChildren(v35)

		for k, v42 in v41 do
			result[k] = v42
		end

		return result
	end

	local gapAfterFirstFeedItem = if fFlagSduiIndividualFeedItemSpacing then props.gapAfterFirstFeedItem else nil
	local v29 = {
		feedItems,
		debugName,
		ref,
		ref3,
		sduiContext,
		analyticsContext,
		gapBetweenFeedItems,
		gapAfterFirstFeedItem,
		if fFlagSduiSamePoolFeedItemSpacing then samePoolFeedItemGap else nil,
		impressionsTag,
		v10,
		selectionBehaviorRight,
		v7,
		gapAfterStickyItems,
		props.feedTopMargin,
		v16,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil
	}

	local pageBottomPadding = props.pageBottomPadding
	local enableBackToTop = if defineFastFlag then props.enableBackToTop else nil
	local v31 = if defineFastFlag then state2 else nil
	local v32 = if fFlagAppPageShellScrollToTopFocus then props.defaultFocusRef else nil
	v29[17], v29[18], v29[19], v29[20], v29[21], v29[22], v29[23] = v5, pageBottomPadding, enableBackToTop, v31, scrollingFrameRef, v25, v32
	local v33 = useMemo(fn, v29)

	if v15 then
		v33 = React.createElement(SduiFeedContext.Provider, { value = v15 }, v33)
	end

	if not (fFlagSduiPageCanvasCollectionLayout and props.disableCollectionLayoutStoreProvider) then
		v33 = React.createElement(collectionLayoutStoreProvider, { container = state }, v33)
	end

	local v34 = { ["size-full-0 auto-y"] = true }

	if v5 then
		v34[contentTag] = true
	end

	local v35 = React.createElement(
		view,
		{ tag = v34, LayoutOrder = props.layoutOrder, ref = setState },
		v33
	)

	if fFlagLuaAppSduiVideoThumbnail or fFlagLuaAppOneByTwoHoverIdleAutoplay then
		local createElement = React.createElement
		local fragment = React.Fragment

		local v38 = if viewportVideoAutoplayController then React.createElement(viewportVideoAutoplaySync, {
			viewportAutoplayController = viewportVideoAutoplayController,
			scrollingFrameRef = scrollingFrameRef
		}) else nil

		local v39 = if viewportVideoAutoplayController then React.createElement(scrollDetector, {
			scrollingFrameRef = scrollingFrameRef,
			onScrollStart = v23,
			onScrollSettled = v24
		}) else nil
		v35 = createElement(fragment, nil, {
			Content = v35,
			ViewportVideoAutoplaySync = v38,
			ScrollDetector = v39
		})
	end

	if props.scrollingFrameRef ~= nil then
		return v35
	end

	local createElement = React.createElement
	local v37 = {
		["LayoutOrder"] = nil,
		["LayoutOrder"] = nil,
		["LayoutOrder"] = nil,
		["LayoutOrder"] = nil,
		["LayoutOrder"] = nil,
		LayoutOrder = 3,
		ref = ref,
		[React.Change.CanvasPosition] = v14,
		[React.Change.CanvasSize] = v12
	}
	local v38 = if props.backgroundStyle then props.backgroundStyle.Color3 else v6.Color.Surface.Surface_0.Color3
	v37.BackgroundColor3 = v38

	local v39 = if props.backgroundStyle then props.backgroundStyle.Transparency else nil
	v37.BackgroundTransparency = v39
	v37.Size = UDim2.fromScale(1, 0)
	v37.CanvasSize = UDim2.new(1, 0, 0, 0)
	v37.AutomaticCanvasSize = Enum.AutomaticSize.Y
	v37.BorderSizePixel = 0
	v37.ScrollBarThickness = scrollBarThickness
	v37.ElasticBehavior = Enum.ElasticBehavior.Always
	v37.ScrollingDirection = Enum.ScrollingDirection.Y
	v37.Selectable = false
	v37.ScrollingEnabled = not v22
	v37.ClipsDescendants = false
	local element = createElement("ScrollingFrame", v37, {
		FlexFill = React.createElement("UIFlexItem", {
			FlexMode = Enum.UIFlexMode.Fill
		}),
		Content = v35
	})

	local createElement2 = React.createElement
	local v41 = {
		tag = "size-full",
		LayoutOrder = props.layoutOrder,
		layout = {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder
		}
	}

	local v43 = if v7 then React.createElement(SduiStickyHeader, {
		stickyItems = props.stickyItems,
		sduiContext = sduiContext,
		debugName = `{debugName}.StickyHeader`,
		contentTag = stickyContentTag,
		backgroundStyle = stickyBackgroundStyle,
		paddingTop = stickyPaddingTop,
		paddingBottom = stickyPaddingBottom,
		gapBetweenItems = gapBetweenStickyItems,
		zIndex = 2,
		extraLocalProps = v16,
		impressionsTag = impressionsTag,
		selectionBehaviorLeft = v10,
		selectionBehaviorRight = selectionBehaviorRight
	}) else nil
	local v44

	if v8 then
		local createElement3 = React.createElement

		if not fFlagLuaAppSduiHomeFriendCarousel then
			v13 = props.onRefresh
		end

		v44 = createElement3(pullToRefreshSpinner, {
			LayoutOrder = 2,
			onRefresh = v13,
			scrollingFrameRef = ref,
			appEventName = sduiContext.appPage
		})
	end

	return createElement2(view, v41, {
		Sticky = v43,
		RefreshSpinner = v44,
		Scroll = element
	})
end

return React.memo(SduiVerticalFeed)
