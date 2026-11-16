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
local fFlagSduiSrpScrollAway = SharedFlags.FFlagSduiSrpScrollAway
local fFlagSduiVerticalFeedProgressiveFillOnScroll = SharedFlags.FFlagSduiVerticalFeedProgressiveFillOnScroll
local defineFastInt = game:DefineFastInt("SduiVerticalFeedScrollInitialNumRows", 4)
local defineFastInt2 = game:DefineFastInt("SduiVerticalFeedScrollLoadNumRows", 3)
local defineFastInt3 = game:DefineFastInt("SduiVerticalFeedScrollPreloadDistancePx", 2000)

local defineFastInt4 = game:DefineFastInt("SduiVerticalFeedScrollUnderfillDebounceMs", 50)
local defineFastFlag = game:DefineFastFlag("SduiEnableBackToTop", false)
local fFlagSduiVerticalFeedPageShellSupport = SharedFlags.FFlagSduiVerticalFeedPageShellSupport
local fFlagSduiPageCanvasCollectionLayout = SharedFlags.FFlagSduiPageCanvasCollectionLayout
local fFlagLuaAppSduiVideoThumbnail = SharedFlags.FFlagLuaAppSduiVideoThumbnail
local fFlagLuaAppMediaGalleryGamepadSupport = SharedFlags.FFlagLuaAppMediaGalleryGamepadSupport
local fFlagLuaAppOneByTwoHoverIdleAutoplay = SharedFlags.FFlagLuaAppOneByTwoHoverIdleAutoplay
local fFlagLuaAppSduiSuppressVideoDetectorDuringScroll = SharedFlags.FFlagLuaAppSduiSuppressVideoDetectorDuringScroll
local fFlagAppPageShellScrollToTopFocus = SharedFlags.FFlagAppPageShellScrollToTopFocus
local fFlagSduiVerticalFeedScrollTelemetry = SharedFlags.FFlagSduiVerticalFeedScrollTelemetry
local fFlagSduiIndividualFeedItemSpacing = SharedFlags.FFlagSduiIndividualFeedItemSpacing
local fFlagSduiSamePoolFeedItemSpacing = SharedFlags.FFlagSduiSamePoolFeedItemSpacing

local v5 = if fFlagSduiVerticalFeedProgressiveFillOnScroll then Signals.createSignal(nil) else nil

local frozen = if fFlagSduiVerticalFeedProgressiveFillOnScroll then table.freeze({}) else nil

local function PoolStoreLayoutStoreWiring(p2): nil
	local v6 = React.useContext(collectionLayoutStoreContext)
	React.useEffect(function()
		if v6 == nil then
			return
		end

		local sduiPoolStore2 = sduiPoolStore.getSduiPoolStore(p2.configKey)
		sduiPoolStore2.setLayoutStore(v6)
		return function()
			sduiPoolStore2.setLayoutStore(nil)
		end
	end, { p2.configKey, v6 })
	return nil
end

local function getFeedItemRowCount(p2, p3)
	local numberOfRowsGetter = p2.numberOfRowsGetter

	if numberOfRowsGetter ~= nil then
		local v6 = numberOfRowsGetter(p3)

		if v6 > 0 then
			return v6
		end
	end

	return 1
end

local function useProgressiveRowCapWithScroll(feedItems, initialNumToRender, progressiveFillRate, progressiveFillIntervalMs, progressiveFillOnScroll, scrollingFrameRef, ref, defineFastInt5)
	local v7, v8 = useProgressiveRowCap(
		feedItems and #feedItems or 0,
		initialNumToRender,
		progressiveFillRate,
		progressiveFillIntervalMs
	)

	local v9 = React.useMemo(function()
		return Signals.createComputed(function(p2)
			v5(p2)

			if not progressiveFillOnScroll then
				return frozen
			end

			local result = table.create(feedItems and #feedItems or 0)

			if not feedItems then
				return result
			end

			for k, item in feedItems do
				local numberOfRowsGetter = item.numberOfRowsGetter
				local v10

				if numberOfRowsGetter == nil then
					v10 = 1
				else
					local v11 = numberOfRowsGetter(p2)
					v10 = not (v11 > 0) and 1 or v11
				end

				result[k] = v10
			end

			return result
		end, tutils.shallowEqual)
	end, { feedItems, progressiveFillOnScroll })

	local v10 = SignalsReact.useSignalState(v9)

	if not progressiveFillOnScroll then
		scrollingFrameRef = nil
	end

	if not progressiveFillOnScroll then
		ref = nil
	end

	local v14, v15 = useProgressiveItemCapOnScroll(
		v10,
		defineFastInt,
		defineFastInt2,
		scrollingFrameRef,
		ref,
		defineFastInt3,
		defineFastInt5
	)

	if progressiveFillOnScroll then
		return math.min(v7, v14), v8 or v15
	end

	return v7, v8
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
	local v6 = not (contentTag == nil) and contentTag ~= ""

	local v7 = useTokens()

	local v8 = not (props.stickyItems == nil) and #props.stickyItems > 0
	local v9 = props.onRefresh ~= nil
	local stickyContentTag = props.stickyContentTag or props.defaultStickyContentTag
	local stickyBackgroundStyle = props.stickyBackgroundStyle or v7.Color.Surface.Surface_0

	local stickyPaddingTop = props.stickyPaddingTop or v7.Gap.Medium
	local stickyPaddingBottom = props.stickyPaddingBottom or v7.Gap.Medium
	local gapBetweenStickyItems = props.gapBetweenStickyItems or v7.Gap.Medium
	local gapAfterStickyItems = props.gapAfterStickyItems or v7.Gap.Medium
	local v10 = useNavBarPlacement()
	local impressionsTag = props.impressionsTag or sduiContext.routeName or sduiContext.appPage
	local v11 = props.selectionBehaviorLeft

	if not v11 then
		if v10 == AppNavBar.Placement.Left then
			v11 = Enum.SelectionBehavior.Escape
		else
			v11 = Enum.SelectionBehavior.Stop
		end
	end

	local selectionBehaviorRight = props.selectionBehaviorRight or Enum.SelectionBehavior.Stop
	local v12 = usePreferredInput()
	local scrollBarThickness = props.scrollBarThickness or v12 == Responsive.Input.Pointer and 4 or 0

	local state, setState = React.useState(nil)

	local ref = React.useRef(nil)

	local scrollingFrameRef = if fFlagSduiVerticalFeedPageShellSupport then props.scrollingFrameRef or ref else nil

	local ref2 = if fFlagSduiVerticalFeedProgressiveFillOnScroll then React.useRef(nil) else nil

	local ref3 = React.useRef(nil)

	if ref3.current == nil then
		ref3.current = AppCommonLib.Signal.new()
	end

	local v13 = React.useCallback(function()
		ref3.current:fire()
	end, {})
	local ref4, v14

	if fFlagLuaAppSduiHomeFriendCarousel then
		ref4 = React.useRef(nil)

		if ref4.current == nil then
			local v15 = if fFlagSduiVerticalFeedPageShellSupport and props.refreshSignal then props.refreshSignal else AppCommonLib.Signal.new()
			ref4.current = v15
		end

		v14 = React.useCallback(function()
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

	local ref5 = if fFlagSduiSrpScrollAway then React.useRef(0) else nil

	local ref6 = if fFlagSduiSrpScrollAway then React.useRef(scrollMovementDirection.Backward) else nil
	local v15

	if fFlagSduiSrpScrollAway then
		v15 = React.useCallback(function(p2)
			v13()
			local onScrollDirectionChanged = props.onScrollDirectionChanged

			if not onScrollDirectionChanged then
				return
			end

			local y = p2.CanvasPosition.Y

			if y < 0 or y == ref5.current then
				return
			end

			local v16

			if ref5.current < y then
				v16 = scrollMovementDirection.Forward
			else
				v16 = scrollMovementDirection.Backward
			end

			if v16 ~= ref6.current then
				onScrollDirectionChanged(v16)
				ref6.current = v16
			end

			ref5.current = y
		end, { v13, props.onScrollDirectionChanged })
	else
		v15 = nil
	end

	local useMemo = React.useMemo
	local function fn()
		return {
			scrollViewPositionChangedSignal = ref3.current,
			verticalScrollingFrameRef = if fFlagSduiVerticalFeedPageShellSupport then scrollingFrameRef else ref
		}
	end

	local v18 = useMemo(fn, {
		ref3,
		ref,
		if fFlagSduiVerticalFeedPageShellSupport then scrollingFrameRef else nil
	})

	local gapBetweenFeedItems = props.gapBetweenFeedItems or v7.Gap.Large
	local samePoolFeedItemGap

	if fFlagSduiSamePoolFeedItemSpacing then
		samePoolFeedItemGap = props.samePoolFeedItemGap or v7.Gap.Large
	else
		samePoolFeedItemGap = nil
	end

	local useMemo2 = React.useMemo
	local function fn2()
		local v19 = {
			scrollViewPositionChangedSignal = ref3.current,
			verticalScrollingFrameRef = if fFlagSduiVerticalFeedPageShellSupport then scrollingFrameRef else ref,
			refreshSignal = 0
		}

		local v21 = if fFlagLuaAppSduiHomeFriendCarousel then ref4.current else nil
		v19.refreshSignal = v21
		return v19
	end

	local v21 = useMemo2(fn2, {
		ref3,
		if fFlagSduiVerticalFeedPageShellSupport then scrollingFrameRef else ref
	})

	if not fFlagSduiVerticalFeedPageShellSupport then
		scrollingFrameRef = props.scrollingFrameRef or ref
	end

	local state2 = nil
	local v22 = nil

	if defineFastFlag then
		local setState2
		state2, setState2 = React.useState(false)
		v22 = setState2
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

				v22(y < y2)
			end

			local v23 = {
				current:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(updateIsScrollable),
				current:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(updateIsScrollable)
			}
			local y = current.AbsoluteWindowSize.Y
			local y2 = current.AbsoluteCanvasSize.Y

			if not (y < 0 or y2 < 0) then
				v22(y < y2)
			end

			return function()
				for k, connection in v23 do
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

	local function fn3()
		if not (props.scrollingFrameRef and props.scrollingFrameRef.current) then
			return nil
		end

		local current = props.scrollingFrameRef.current

		if fFlagSduiSrpScrollAway then
			ref5.current = current.CanvasPosition.Y
		end

		local v23

		if fFlagSduiSrpScrollAway then
			v23 = {
				current:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
					v15(current)
				end),
				current:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(v13)
			}
		else
			v23 = {
				current:GetPropertyChangedSignal("CanvasPosition"):Connect(v13),
				current:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(v13)
			}
		end

		return function()
			for k, connection in v23 do
				connection:Disconnect()
			end
		end
	end

	React.useEffect(fn3, { props.scrollingFrameRef, v13, if fFlagSduiSrpScrollAway then v15 else nil })
	local v26

	if not (fFlagSduiVerticalFeedPageShellSupport and props.scrollToSelectionAnimationManagedByParent) then
		v26 = scrollingFrameRef
	end

	local v28 = if fFlagLuaAppMediaGalleryGamepadSupport then props.scrollToSelectionRevealOnly else nil
	useAnimateScrollViewToSelection(v26, 0.4, v28)

	local v29 = useLastInputMode() ~= "Cursor"

	local thresholdFromEnd = props.thresholdFromEnd or 600
	local viewportVideoAutoplayController, v30, v31

	if fFlagLuaAppSduiVideoThumbnail or fFlagLuaAppOneByTwoHoverIdleAutoplay then
		viewportVideoAutoplayController = if videoPlaybackContext then videoPlaybackContext.viewportVideoAutoplayController else nil

		v30 = React.useCallback(function()
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
		v31 = React.useCallback(function(p2)
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

	local v32, v33

	if fFlagSduiVerticalFeedProgressiveFillOnScroll then
		v32, v33 = useProgressiveRowCapWithScroll(
			feedItems,
			props.initialNumToRender,
			props.progressiveFillRate,
			props.progressiveFillIntervalMs,
			props.progressiveFillOnScroll,
			scrollingFrameRef,
			ref2,
			defineFastInt4
		)
	else
		v32, v33 = useProgressiveRowCap(
			feedItems and #feedItems or 0,
			props.initialNumToRender,
			props.progressiveFillRate,
			props.progressiveFillIntervalMs
		)
	end

	local v35 = scrollingFrameRef

	local v36 = if not v33 then props.onScrollToEnd else nil
	useVerticalScrolledToEndThreshold(v35, thresholdFromEnd, v36)

	local useMemo3 = React.useMemo
	local function fn4()
		if feedItems == nil then
			return nil
		end

		local pageBottomPadding = props.pageBottomPadding or 80
		local v37

		if defineFastFlag and props.enableBackToTop and state2 then
			v37 = React.createElement(
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
			v37 = React.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, pageBottomPadding),
				BackgroundTransparency = 1,
				LayoutOrder = 1000000
			})
		end

		local result = {
			BottomSpacer = v37,
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, fFlagSduiIndividualFeedItemSpacing and 0 or gapBetweenFeedItems),
				ref = if fFlagSduiVerticalFeedProgressiveFillOnScroll then ref2 else nil
			}),
			StickyGap = 0,
			NoStickyTopMargin = 0,
			PoolStoreLayoutStoreWiring = 0,
			FeedImpressionsDetector = 0
		}
		local v41

		if v8 and gapAfterStickyItems and gapAfterStickyItems > 0 then
			local createElement2 = React.createElement
			local newUDim2 = UDim2.new
			local v47

			if fFlagSduiIndividualFeedItemSpacing then
				v47 = math.max(gapAfterStickyItems, gapBetweenFeedItems)
			else
				v47 = math.max(0, gapAfterStickyItems - gapBetweenFeedItems)
			end

			v41 = createElement2("Frame", {
				Size = newUDim2(1, 0, 0, v47),
				BackgroundTransparency = 1,
				LayoutOrder = 0
			})
		end

		result.StickyGap = v41
		local v42

		if not (v8 or not (props.feedTopMargin and props.feedTopMargin > 0)) then
			local createElement2 = React.createElement
			local newUDim2 = UDim2.new
			local v48

			if fFlagSduiIndividualFeedItemSpacing then
				v48 = math.max(props.feedTopMargin, gapBetweenFeedItems)
			else
				v48 = math.max(0, props.feedTopMargin - gapBetweenFeedItems)
			end

			v42 = createElement2("Frame", {
				Size = newUDim2(1, 0, 0, v48),
				BackgroundTransparency = 1,
				LayoutOrder = 0
			})
		end

		result.NoStickyTopMargin = v42

		local v43 = if sduiContext.configKey ~= nil then React.createElement(PoolStoreLayoutStoreWiring, {
			configKey = sduiContext.configKey
		}) else nil
		result.PoolStoreLayoutStoreWiring = v43

		local v44 = if impressionsTag and feedItems then React.createElement(SduiFeedImpressionsDetector, {
			sduiContext = sduiContext,
			feedItems = feedItems,
			parentRef = scrollingFrameRef,
			impressionsTag = impressionsTag,
			scrollViewPositionChangedSignal = ref3.current
		}) else nil
		result.FeedImpressionsDetector = v44

		local v46 = {
			configs = feedItems,
			sduiContext = sduiContext,
			debugName = debugName,
			componentType = "VerticalFeed",
			impressionsTag = impressionsTag,
			selectionBehaviorLeft = v11,
			selectionBehaviorRight = selectionBehaviorRight,
			extraLocalProps = v21,
			selectionOrderBase = 0,
			defaultFocusRef = 0,
			maxConfigs = 0,
			gapBetweenFeedItems = 0,
			gapAfterFirstFeedItem = 0,
			samePoolFeedItemGap = 0
		}

		local v47 = if fFlagAppPageShellScrollToTopFocus then DiscoveryTypes.Constants.SORT_SELECTION_ORDER_BASE else nil
		v46.selectionOrderBase = v47

		local v48 = if fFlagAppPageShellScrollToTopFocus then props.defaultFocusRef else nil
		v46.defaultFocusRef = v48
		v46.maxConfigs = v32
		v46.gapBetweenFeedItems = if fFlagSduiIndividualFeedItemSpacing then gapBetweenFeedItems else nil
		local v50 = if fFlagSduiIndividualFeedItemSpacing then props.gapAfterFirstFeedItem else nil
		v46.gapAfterFirstFeedItem = v50
		v46.samePoolFeedItemGap = if fFlagSduiSamePoolFeedItemSpacing then samePoolFeedItemGap else nil
		local v52 = buildSduiFeedChildren(v46)

		for k, v53 in v52 do
			result[k] = v53
		end

		return result
	end

	local gapAfterFirstFeedItem = if fFlagSduiIndividualFeedItemSpacing then props.gapAfterFirstFeedItem else nil
	local v37 = {
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
		v11,
		selectionBehaviorRight,
		v8,
		gapAfterStickyItems,
		props.feedTopMargin,
		v21,
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
	local v39 = if defineFastFlag then state2 else nil
	local v40 = scrollingFrameRef

	local v42 = if fFlagAppPageShellScrollToTopFocus then props.defaultFocusRef else nil
	v37[17], v37[18], v37[19], v37[20], v37[21], v37[22], v37[23] = v6, pageBottomPadding, enableBackToTop, v39, v40, v32, v42
	local v43 = useMemo3(fn4, v37)

	if v18 then
		v43 = React.createElement(SduiFeedContext.Provider, { value = v18 }, v43)
	end

	if not (fFlagSduiPageCanvasCollectionLayout and props.disableCollectionLayoutStoreProvider) then
		v43 = React.createElement(collectionLayoutStoreProvider, { container = state }, v43)
	end

	local v44 = { ["size-full-0 auto-y"] = true }

	if v6 then
		v44[contentTag] = true
	end

	local v45 = React.createElement(
		view,
		{ tag = v44, LayoutOrder = props.layoutOrder, ref = setState },
		v43
	)

	if fFlagLuaAppSduiVideoThumbnail or fFlagLuaAppOneByTwoHoverIdleAutoplay then
		local createElement = React.createElement
		local fragment = React.Fragment

		local v48 = if viewportVideoAutoplayController then React.createElement(viewportVideoAutoplaySync, {
			viewportAutoplayController = viewportVideoAutoplayController,
			scrollingFrameRef = scrollingFrameRef
		}) else nil

		local v49 = if viewportVideoAutoplayController then React.createElement(scrollDetector, {
			scrollingFrameRef = scrollingFrameRef,
			onScrollStart = v30,
			onScrollSettled = v31
		}) else nil
		v45 = createElement(fragment, nil, {
			Content = v45,
			ViewportVideoAutoplaySync = v48,
			ScrollDetector = v49
		})
	end

	if props.scrollingFrameRef ~= nil then
		return v45
	end

	local createElement = React.createElement
	local v47 = {}
	v47.LayoutOrder = 3
	v47.ref = ref
	local canvasPosition = React.Change.CanvasPosition
	v47[canvasPosition] = if fFlagSduiSrpScrollAway then v15 else v13
	v47[React.Change.CanvasSize] = v13
	local v49 = if props.backgroundStyle then props.backgroundStyle.Color3 else v7.Color.Surface.Surface_0.Color3
	v47.BackgroundColor3 = v49

	local v50 = if props.backgroundStyle then props.backgroundStyle.Transparency else nil
	v47.BackgroundTransparency = v50
	v47.Size = UDim2.fromScale(1, 0)
	v47.CanvasSize = UDim2.new(1, 0, 0, 0)
	v47.AutomaticCanvasSize = Enum.AutomaticSize.Y
	v47.BorderSizePixel = 0
	v47.ScrollBarThickness = scrollBarThickness
	v47.ElasticBehavior = Enum.ElasticBehavior.Always
	v47.ScrollingDirection = Enum.ScrollingDirection.Y
	v47.Selectable = false
	v47.ScrollingEnabled = not v29
	v47.ClipsDescendants = false
	local element = createElement("ScrollingFrame", v47, {
		FlexFill = React.createElement("UIFlexItem", {
			FlexMode = Enum.UIFlexMode.Fill
		}),
		Content = v45
	})

	local createElement2 = React.createElement
	local v52 = {
		tag = "size-full",
		LayoutOrder = props.layoutOrder,
		layout = {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder
		}
	}

	local v54 = if v8 then React.createElement(SduiStickyHeader, {
		stickyItems = props.stickyItems,
		sduiContext = sduiContext,
		debugName = `{debugName}.StickyHeader`,
		contentTag = stickyContentTag,
		backgroundStyle = stickyBackgroundStyle,
		paddingTop = stickyPaddingTop,
		paddingBottom = stickyPaddingBottom,
		gapBetweenItems = gapBetweenStickyItems,
		zIndex = 2,
		extraLocalProps = v21,
		impressionsTag = impressionsTag,
		selectionBehaviorLeft = v11,
		selectionBehaviorRight = selectionBehaviorRight
	}) else nil
	local v55

	if v9 then
		local createElement3 = React.createElement

		if not fFlagLuaAppSduiHomeFriendCarousel then
			v14 = props.onRefresh
		end

		v55 = createElement3(pullToRefreshSpinner, {
			LayoutOrder = 2,
			onRefresh = v14,
			scrollingFrameRef = ref,
			appEventName = sduiContext.appPage
		})
	end

	return createElement2(view, v52, {
		Sticky = v54,
		RefreshSpinner = v55,
		Scroll = element
	})
end

return React.memo(SduiVerticalFeed)
