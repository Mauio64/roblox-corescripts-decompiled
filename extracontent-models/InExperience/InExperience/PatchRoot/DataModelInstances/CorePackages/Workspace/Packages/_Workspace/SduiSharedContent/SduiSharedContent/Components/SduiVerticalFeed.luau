local SduiSharedContent = script:FindFirstAncestor("SduiSharedContent")
local parent = SduiSharedContent.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local AppBlox = require(parent.AppBlox)
local useAnimateScrollViewToSelection = AppBlox.useAnimateScrollViewToSelection
local AppNavBar = require(parent.AppNavBar)
local useNavBarPlacement = AppNavBar.useNavBarPlacement
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local useLastInputMode = FocusNavigationUtils.useLastInputMode
local Responsive = require(parent.Responsive)
local usePreferredInput = Responsive.usePreferredInput
local AppCommonLib = require(parent.AppCommonLib)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local ScrollMovementDirection = RobloxAppEnums.ScrollMovementDirection
require(parent.SduiCompat)
local SduiCoreSystem = require(parent.SduiCoreSystem)
local DiscoveryTypes = require(parent.DiscoveryTypes)

local CollectionViews = require(parent.CollectionViews)
local CollectionLayoutStoreProvider = CollectionViews.CollectionLayoutStoreProvider
local CollectionLayoutStoreContext = CollectionViews.CollectionLayoutStoreContext

local SduiPoolStore = SduiCoreSystem.SduiPoolStore

local SduiFeedContext = require(SduiSharedContent.Components.SduiFeedContext)
local SduiStickyHeader = require(SduiSharedContent.Components.SduiStickyHeader)
local AppPageShell = require(parent.AppPageShell)
local PullToRefreshSpinner = AppPageShell.PullToRefreshSpinner
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local tutils = require(parent.tutils)
local useVerticalScrolledToEndThreshold = require(SduiSharedContent.Components.useVerticalScrolledToEndThreshold)
local useProgressiveRowCap = require(SduiSharedContent.Components.useProgressiveRowCap)
local useProgressiveItemCapOnScroll = require(SduiSharedContent.Components.useProgressiveItemCapOnScroll)
local buildSduiFeedChildren = require(SduiSharedContent.Components.buildSduiFeedChildren)
local SduiFeedImpressionsDetector = require(SduiSharedContent.Components.SduiFeedImpressionsDetector)
local BackToTopButton = require(SduiSharedContent.Components.BackToTopButton)
local ScrollTelemetry = require(parent.ScrollTelemetry)
local ScrollDetector = ScrollTelemetry.ScrollDetector

local IntervalPerformanceTracker = require(parent.IntervalPerformanceTracker)
local createScrollIntervalPerformanceTracker = IntervalPerformanceTracker.createScrollIntervalPerformanceTracker
local VideoUtils = require(parent.VideoUtils)
local ViewportVideoAutoplaySync = VideoUtils.ViewportVideoAutoplaySync

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppSduiHomeFriendCarousel = SharedFlags.FFlagLuaAppSduiHomeFriendCarousel
local FFlagSduiSrpScrollAway = SharedFlags.FFlagSduiSrpScrollAway
local FFlagSduiVerticalFeedProgressiveFillOnScroll = SharedFlags.FFlagSduiVerticalFeedProgressiveFillOnScroll
local defineFastInt = game:DefineFastInt("SduiVerticalFeedScrollInitialNumRows", 4)
local defineFastInt2 = game:DefineFastInt("SduiVerticalFeedScrollLoadNumRows", 3)
local defineFastInt3 = game:DefineFastInt("SduiVerticalFeedScrollPreloadDistancePx", 2000)

local defineFastInt4 = game:DefineFastInt("SduiVerticalFeedScrollUnderfillDebounceMs", 50)
local defineFastFlag = game:DefineFastFlag("SduiEnableBackToTop", false)
local FFlagSduiVerticalFeedPageShellSupport = SharedFlags.FFlagSduiVerticalFeedPageShellSupport
local FFlagSduiPageCanvasCollectionLayout = SharedFlags.FFlagSduiPageCanvasCollectionLayout
local FFlagLuaAppSduiVideoThumbnail = SharedFlags.FFlagLuaAppSduiVideoThumbnail
local FFlagLuaAppMediaGalleryGamepadSupport = SharedFlags.FFlagLuaAppMediaGalleryGamepadSupport
local FFlagLuaAppOneByTwoHoverIdleAutoplay = SharedFlags.FFlagLuaAppOneByTwoHoverIdleAutoplay
local FFlagLuaAppSduiSuppressVideoDetectorDuringScroll = SharedFlags.FFlagLuaAppSduiSuppressVideoDetectorDuringScroll
local FFlagAppPageShellScrollToTopFocus = SharedFlags.FFlagAppPageShellScrollToTopFocus
local FFlagSduiVerticalFeedScrollTelemetry = SharedFlags.FFlagSduiVerticalFeedScrollTelemetry
local FFlagSduiIndividualFeedItemSpacing = SharedFlags.FFlagSduiIndividualFeedItemSpacing
local FFlagSduiSamePoolFeedItemSpacing = SharedFlags.FFlagSduiSamePoolFeedItemSpacing
local v

if FFlagSduiVerticalFeedProgressiveFillOnScroll then
	v = Signals.createSignal(nil)
else
	v = nil
end

local frozen

if FFlagSduiVerticalFeedProgressiveFillOnScroll then
	frozen = table.freeze({})
else
	frozen = nil
end

local function PoolStoreLayoutStoreWiring(p): nil
	local v2 = React.useContext(CollectionLayoutStoreContext)
	React.useEffect(function()
		if v2 == nil then
			return
		end

		local sduiPoolStore = SduiPoolStore.getSduiPoolStore(p.configKey)
		sduiPoolStore.setLayoutStore(v2)
		return function()
			sduiPoolStore.setLayoutStore(nil)
		end
	end, { p.configKey, v2 })
	return nil
end

local function getFeedItemRowCount(item, p) -- 1 equivalent call inferred from this helper
	local numberOfRowsGetter = item.numberOfRowsGetter

	if numberOfRowsGetter ~= nil then
		local v2 = numberOfRowsGetter(p)

		if v2 > 0 then
			return v2
		end
	end

	return 1
end

local function useProgressiveRowCapWithScroll(feedItems, initialNumToRender: number?, progressiveFillRate: number?, progressiveFillIntervalMs: number?, progressiveFillOnScroll: boolean?, scrollingFrameRef, ref, defineFastInt5: number)
	local v2, v3 = useProgressiveRowCap(
		feedItems and #feedItems or 0,
		initialNumToRender,
		progressiveFillRate,
		progressiveFillIntervalMs
	)

	local v4 = React.useMemo(function()
		return Signals.createComputed(function(p)
			v(p)

			if not progressiveFillOnScroll then
				return frozen
			end

			local result = table.create(feedItems and #feedItems or 0)

			if feedItems then
				for k, item in feedItems do
					result[k] = getFeedItemRowCount(item, p) -- inferred equivalent call
				end
			end

			return result
		end, tutils.shallowEqual)
	end, { feedItems, progressiveFillOnScroll })

	local v5 = SignalsReact.useSignalState(v4)

	if not progressiveFillOnScroll then
		scrollingFrameRef = nil
	end

	if not progressiveFillOnScroll then
		ref = nil
	end

	local v6, v7 = useProgressiveItemCapOnScroll(
		v5,
		defineFastInt,
		defineFastInt2,
		scrollingFrameRef,
		ref,
		defineFastInt3,
		defineFastInt5
	)

	if progressiveFillOnScroll then
		return math.min(v2, v6), v3 or v7
	end

	return v2, v3
end

local function SduiVerticalFeed(props)
	local analyticsContext = props.analyticsContext
	local sduiContext = props.sduiContext
	local videoPlaybackContext

	if FFlagLuaAppSduiVideoThumbnail or FFlagLuaAppOneByTwoHoverIdleAutoplay then
		videoPlaybackContext = sduiContext.videoPlaybackContext
	end

	local feedItems = props.feedItems
	local debugName = props.debugName
	local contentTag = props.contentTag or props.defaultContentTag
	local v2

	if contentTag == nil then
		v2 = false
	else
		v2 = contentTag ~= ""
	end

	local v3 = useTokens()
	local v4

	if props.stickyItems == nil then
		v4 = false
	else
		v4 = #props.stickyItems > 0
	end

	local v5 = props.onRefresh ~= nil
	local stickyContentTag = props.stickyContentTag or props.defaultStickyContentTag
	local stickyBackgroundStyle = props.stickyBackgroundStyle or v3.Color.Surface.Surface_0

	local stickyPaddingTop = props.stickyPaddingTop or v3.Gap.Medium
	local stickyPaddingBottom = props.stickyPaddingBottom or v3.Gap.Medium
	local gapBetweenStickyItems = props.gapBetweenStickyItems or v3.Gap.Medium
	local gapAfterStickyItems = props.gapAfterStickyItems or v3.Gap.Medium
	local v6 = useNavBarPlacement()
	local impressionsTag = props.impressionsTag or sduiContext.routeName or sduiContext.appPage
	local selectionBehaviorLeft = props.selectionBehaviorLeft

	if not selectionBehaviorLeft then
		if v6 == AppNavBar.Placement.Left then
			selectionBehaviorLeft = Enum.SelectionBehavior.Escape
		else
			selectionBehaviorLeft = Enum.SelectionBehavior.Stop
		end
	end

	local selectionBehaviorRight = props.selectionBehaviorRight or Enum.SelectionBehavior.Stop
	local v7 = usePreferredInput()
	local scrollBarThickness = props.scrollBarThickness or v7 == Responsive.Input.Pointer and 4 or 0

	local state, setState = React.useState(nil)

	local ref = React.useRef(nil)
	local scrollingFrameRef

	if FFlagSduiVerticalFeedPageShellSupport then
		scrollingFrameRef = props.scrollingFrameRef or ref
	else
		scrollingFrameRef = nil
	end

	local ref2

	if FFlagSduiVerticalFeedProgressiveFillOnScroll then
		ref2 = React.useRef(nil)
	else
		ref2 = nil
	end

	local ref3 = React.useRef(nil)

	if ref3.current == nil then
		ref3.current = AppCommonLib.Signal.new()
	end

	local v8 = React.useCallback(function()
		ref3.current:fire()
	end, {})
	local ref4, onRefresh

	if FFlagLuaAppSduiHomeFriendCarousel then
		ref4 = React.useRef(nil)

		if ref4.current == nil then
			local current

			if FFlagSduiVerticalFeedPageShellSupport and props.refreshSignal then
				current = props.refreshSignal
			else
				current = AppCommonLib.Signal.new()
			end

			ref4.current = current
		end

		onRefresh = React.useCallback(function()
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

	local ref5

	if FFlagSduiSrpScrollAway then
		ref5 = React.useRef(0)
	else
		ref5 = nil
	end

	local ref6

	if FFlagSduiSrpScrollAway then
		ref6 = React.useRef(ScrollMovementDirection.Backward)
	else
		ref6 = nil
	end

	local v9

	if FFlagSduiSrpScrollAway then
		v9 = React.useCallback(function(p)
			v8()
			local onScrollDirectionChanged = props.onScrollDirectionChanged

			if not onScrollDirectionChanged then
				return
			end

			local y = p.CanvasPosition.Y

			if y < 0 or y == ref5.current then
				return
			end

			local current

			if ref5.current < y then
				current = ScrollMovementDirection.Forward
			else
				current = ScrollMovementDirection.Backward
			end

			if current ~= ref6.current then
				onScrollDirectionChanged(current)
				ref6.current = current
			end

			ref5.current = y
		end, { v8, props.onScrollDirectionChanged })
	else
		v9 = nil
	end

	local useMemo = React.useMemo
	local function fn()
		local v10 = {
			scrollViewPositionChangedSignal = ref3.current,
			verticalScrollingFrameRef = 0
		}
		local verticalScrollingFrameRef

		if FFlagSduiVerticalFeedPageShellSupport then
			verticalScrollingFrameRef = scrollingFrameRef
		else
			verticalScrollingFrameRef = ref
		end

		v10.verticalScrollingFrameRef = verticalScrollingFrameRef
		return v10
	end

	local v10

	if FFlagSduiVerticalFeedPageShellSupport then
		v10 = scrollingFrameRef
	end

	local v11 = useMemo(fn, { ref3, ref, v10 })

	local gapBetweenFeedItems = props.gapBetweenFeedItems or v3.Gap.Large
	local samePoolFeedItemGap

	if FFlagSduiSamePoolFeedItemSpacing then
		samePoolFeedItemGap = props.samePoolFeedItemGap or v3.Gap.Large
	else
		samePoolFeedItemGap = nil
	end

	local useMemo2 = React.useMemo
	local function fn2()
		local v12 = {
			scrollViewPositionChangedSignal = ref3.current,
			verticalScrollingFrameRef = 0,
			refreshSignal = 0
		}
		local verticalScrollingFrameRef

		if FFlagSduiVerticalFeedPageShellSupport then
			verticalScrollingFrameRef = scrollingFrameRef
		else
			verticalScrollingFrameRef = ref
		end

		v12.verticalScrollingFrameRef = verticalScrollingFrameRef
		local refreshSignal

		if FFlagLuaAppSduiHomeFriendCarousel then
			refreshSignal = ref4.current
		end

		v12.refreshSignal = refreshSignal
		return v12
	end

	local v12

	if FFlagSduiVerticalFeedPageShellSupport then
		v12 = scrollingFrameRef
	else
		v12 = ref
	end

	local extraLocalProps = useMemo2(fn2, { ref3, v12 })

	if not FFlagSduiVerticalFeedPageShellSupport then
		scrollingFrameRef = props.scrollingFrameRef or ref
	end

	local state2 = nil
	local v13 = nil

	if defineFastFlag then
		local setState2
		state2, setState2 = React.useState(false)
		v13 = setState2
		React.useEffect(function()
			if not props.enableBackToTop then
				return
			end

			local current = scrollingFrameRef.current

			if not current then
				return
			end

			local function updateIsScrollable() -- 1 equivalent call inferred from this helper
				local y = current.AbsoluteWindowSize.Y
				local y2 = current.AbsoluteCanvasSize.Y

				if y < 0 or y2 < 0 then
					return
				end

				v13(y < y2)
			end

			local v14 = {
				current:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(updateIsScrollable),
				current:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(updateIsScrollable)
			}
			updateIsScrollable() -- inferred equivalent call
			return function()
				for _, connection in v14 do
					connection:Disconnect()
				end
			end
		end, { scrollingFrameRef, props.enableBackToTop })
	end

	if FFlagSduiVerticalFeedScrollTelemetry then
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

	local useEffect = React.useEffect
	local function fn3()
		if not (props.scrollingFrameRef and props.scrollingFrameRef.current) then
			return nil
		end

		local current = props.scrollingFrameRef.current

		if FFlagSduiSrpScrollAway then
			ref5.current = current.CanvasPosition.Y
		end

		local v14

		if FFlagSduiSrpScrollAway then
			v14 = {
				current:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
					v9(current)
				end),
				current:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(v8)
			}
		else
			v14 = {
				current:GetPropertyChangedSignal("CanvasPosition"):Connect(v8),
				current:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(v8)
			}
		end

		return function()
			for _, connection in v14 do
				connection:Disconnect()
			end
		end
	end

	local scrollingFrameRef2 = props.scrollingFrameRef
	local v14

	if FFlagSduiSrpScrollAway then
		v14 = v9
	end

	useEffect(fn3, { scrollingFrameRef2, v8, v14 })
	local v15

	if not (FFlagSduiVerticalFeedPageShellSupport and props.scrollToSelectionAnimationManagedByParent) then
		v15 = scrollingFrameRef
	end

	local v16

	if FFlagLuaAppMediaGalleryGamepadSupport then
		v16 = props.scrollToSelectionRevealOnly
	end

	useAnimateScrollViewToSelection(v15, 0.4, v16)

	local v17 = useLastInputMode() ~= "Cursor"

	local thresholdFromEnd = props.thresholdFromEnd or 600
	local viewportVideoAutoplayController, onScrollStart, onScrollSettled

	if FFlagLuaAppSduiVideoThumbnail or FFlagLuaAppOneByTwoHoverIdleAutoplay then
		if videoPlaybackContext then
			viewportVideoAutoplayController = videoPlaybackContext.viewportVideoAutoplayController
		else
			viewportVideoAutoplayController = nil
		end

		onScrollStart = React.useCallback(function()
			if viewportVideoAutoplayController then
				viewportVideoAutoplayController:onScrollStart()

				if
					FFlagLuaAppSduiSuppressVideoDetectorDuringScroll
					and viewportVideoAutoplayController.suppressDetectorsDuringScroll
				then
					viewportVideoAutoplayController.setDetectorsUnmounted(true)
				end
			end
		end, { viewportVideoAutoplayController })
		onScrollSettled = React.useCallback(function(p: number)
			if viewportVideoAutoplayController then
				if
					FFlagLuaAppSduiSuppressVideoDetectorDuringScroll
					and viewportVideoAutoplayController.suppressDetectorsDuringScroll
				then
					viewportVideoAutoplayController.setDetectorsUnmounted(false)
				end

				viewportVideoAutoplayController:onScrollSettled("Y", p)
			end
		end, { viewportVideoAutoplayController })
	else
		viewportVideoAutoplayController = nil
	end

	local maxConfigs, v18

	if FFlagSduiVerticalFeedProgressiveFillOnScroll then
		maxConfigs, v18 = useProgressiveRowCapWithScroll(
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
		maxConfigs, v18 = useProgressiveRowCap(
			feedItems and #feedItems or 0,
			props.initialNumToRender,
			props.progressiveFillRate,
			props.progressiveFillIntervalMs
		)
	end

	local v19

	if not v18 then
		v19 = props.onScrollToEnd
	end

	useVerticalScrolledToEndThreshold(scrollingFrameRef, thresholdFromEnd, v19)

	local useMemo3 = React.useMemo
	local function fn4()
		if feedItems == nil then
			return nil
		end

		local pageBottomPadding = props.pageBottomPadding or 80
		local bottomSpacer

		if defineFastFlag and props.enableBackToTop and state2 then
			bottomSpacer = React.createElement(
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
			bottomSpacer = React.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, pageBottomPadding),
				BackgroundTransparency = 1,
				LayoutOrder = 1000000
			})
		end

		local createElement = React.createElement
		local v20 = {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, FFlagSduiIndividualFeedItemSpacing and 0 or gapBetweenFeedItems),
			ref = 0
		}
		local ref7

		if FFlagSduiVerticalFeedProgressiveFillOnScroll then
			ref7 = ref2
		end

		v20.ref = ref7
		local result = {
			BottomSpacer = bottomSpacer,
			UIListLayout = createElement("UIListLayout", v20),
			StickyGap = 0,
			NoStickyTopMargin = 0,
			PoolStoreLayoutStoreWiring = 0,
			FeedImpressionsDetector = 0
		}
		local stickyGap

		if v4 and gapAfterStickyItems and gapAfterStickyItems > 0 then
			local createElement2 = React.createElement
			local v21

			if FFlagSduiIndividualFeedItemSpacing then
				v21 = math.max(gapAfterStickyItems, gapBetweenFeedItems)
			else
				v21 = math.max(0, gapAfterStickyItems - gapBetweenFeedItems)
			end

			stickyGap = createElement2("Frame", {
				Size = UDim2.new(1, 0, 0, v21),
				BackgroundTransparency = 1,
				LayoutOrder = 0
			})
		end

		result.StickyGap = stickyGap
		local noStickyTopMargin

		if not (v4 or not (props.feedTopMargin and props.feedTopMargin > 0)) then
			local createElement2 = React.createElement
			local v21

			if FFlagSduiIndividualFeedItemSpacing then
				v21 = math.max(props.feedTopMargin, gapBetweenFeedItems)
			else
				v21 = math.max(0, props.feedTopMargin - gapBetweenFeedItems)
			end

			noStickyTopMargin = createElement2("Frame", {
				Size = UDim2.new(1, 0, 0, v21),
				BackgroundTransparency = 1,
				LayoutOrder = 0
			})
		end

		result.NoStickyTopMargin = noStickyTopMargin
		local poolStoreLayoutStoreWiring

		if sduiContext.configKey ~= nil then
			poolStoreLayoutStoreWiring = React.createElement(PoolStoreLayoutStoreWiring, {
				configKey = sduiContext.configKey
			})
		end

		result.PoolStoreLayoutStoreWiring = poolStoreLayoutStoreWiring
		local feedImpressionsDetector

		if impressionsTag and feedItems then
			feedImpressionsDetector = React.createElement(SduiFeedImpressionsDetector, {
				sduiContext = sduiContext,
				feedItems = feedItems,
				parentRef = scrollingFrameRef,
				impressionsTag = impressionsTag,
				scrollViewPositionChangedSignal = ref3.current
			})
		end

		result.FeedImpressionsDetector = feedImpressionsDetector

		local v21 = {
			configs = feedItems,
			sduiContext = sduiContext,
			debugName = debugName,
			componentType = "VerticalFeed",
			impressionsTag = impressionsTag,
			selectionBehaviorLeft = selectionBehaviorLeft,
			selectionBehaviorRight = selectionBehaviorRight,
			extraLocalProps = extraLocalProps,
			selectionOrderBase = 0,
			defaultFocusRef = 0,
			maxConfigs = 0,
			gapBetweenFeedItems = 0,
			gapAfterFirstFeedItem = 0,
			samePoolFeedItemGap = 0
		}
		local selectionOrderBase

		if FFlagAppPageShellScrollToTopFocus then
			selectionOrderBase = DiscoveryTypes.Constants.SORT_SELECTION_ORDER_BASE
		end

		v21.selectionOrderBase = selectionOrderBase
		local defaultFocusRef

		if FFlagAppPageShellScrollToTopFocus then
			defaultFocusRef = props.defaultFocusRef
		end

		v21.defaultFocusRef = defaultFocusRef
		v21.maxConfigs = maxConfigs
		local gapBetweenFeedItems2

		if FFlagSduiIndividualFeedItemSpacing then
			gapBetweenFeedItems2 = gapBetweenFeedItems
		end

		v21.gapBetweenFeedItems = gapBetweenFeedItems2
		local gapAfterFirstFeedItem

		if FFlagSduiIndividualFeedItemSpacing then
			gapAfterFirstFeedItem = props.gapAfterFirstFeedItem
		end

		v21.gapAfterFirstFeedItem = gapAfterFirstFeedItem
		local samePoolFeedItemGap2

		if FFlagSduiSamePoolFeedItemSpacing then
			samePoolFeedItemGap2 = samePoolFeedItemGap
		end

		v21.samePoolFeedItemGap = samePoolFeedItemGap2
		local sduiFeedChildren = buildSduiFeedChildren(v21)

		for k, v22 in sduiFeedChildren do
			result[k] = v22
		end

		return result
	end

	local gapAfterFirstFeedItem

	if FFlagSduiIndividualFeedItemSpacing then
		gapAfterFirstFeedItem = props.gapAfterFirstFeedItem
	end

	local v20

	if FFlagSduiSamePoolFeedItemSpacing then
		v20 = samePoolFeedItemGap
	end

	local v21 = {
		feedItems,
		debugName,
		ref,
		ref3,
		sduiContext,
		analyticsContext,
		gapBetweenFeedItems,
		gapAfterFirstFeedItem,
		v20,
		impressionsTag,
		selectionBehaviorLeft,
		selectionBehaviorRight,
		v4,
		gapAfterStickyItems,
		props.feedTopMargin,
		extraLocalProps,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil
	}

	local pageBottomPadding = props.pageBottomPadding
	local enableBackToTop

	if defineFastFlag then
		enableBackToTop = props.enableBackToTop
	end

	local v22

	if defineFastFlag then
		v22 = state2
	end

	local v23

	if FFlagAppPageShellScrollToTopFocus then
		v23 = props.defaultFocusRef
	end

	v21[17], v21[18], v21[19], v21[20], v21[21], v21[22], v21[23] = v2, pageBottomPadding, enableBackToTop, v22, scrollingFrameRef, maxConfigs, v23
	local v24 = useMemo3(fn4, v21)

	if v11 then
		v24 = React.createElement(SduiFeedContext.Provider, { value = v11 }, v24)
	end

	if not (FFlagSduiPageCanvasCollectionLayout and props.disableCollectionLayoutStoreProvider) then
		v24 = React.createElement(CollectionLayoutStoreProvider, { container = state }, v24)
	end

	local tag = { ["size-full-0 auto-y"] = true }

	if v2 then
		tag[contentTag] = true
	end

	local content = React.createElement(View, {
		tag = tag,
		LayoutOrder = props.layoutOrder,
		ref = setState
	}, v24)

	if FFlagLuaAppSduiVideoThumbnail or FFlagLuaAppOneByTwoHoverIdleAutoplay then
		local createElement = React.createElement
		local fragment = React.Fragment
		local viewportVideoAutoplaySync

		if viewportVideoAutoplayController then
			viewportVideoAutoplaySync = React.createElement(ViewportVideoAutoplaySync, {
				viewportAutoplayController = viewportVideoAutoplayController,
				scrollingFrameRef = scrollingFrameRef
			})
		end

		local scrollDetector

		if viewportVideoAutoplayController then
			scrollDetector = React.createElement(ScrollDetector, {
				scrollingFrameRef = scrollingFrameRef,
				onScrollStart = onScrollStart,
				onScrollSettled = onScrollSettled
			})
		end

		content = createElement(fragment, nil, {
			Content = content,
			ViewportVideoAutoplaySync = viewportVideoAutoplaySync,
			ScrollDetector = scrollDetector
		})
	end

	if props.scrollingFrameRef ~= nil then
		return content
	end

	local createElement = React.createElement
	local v25 = {}
	v25.LayoutOrder = 3
	v25.ref = ref
	local canvasPosition = React.Change.CanvasPosition
	local v26 = if FFlagSduiSrpScrollAway then v9 else v8
	v25[canvasPosition] = v26
	v25[React.Change.CanvasSize] = v8
	local backgroundColor

	if props.backgroundStyle then
		backgroundColor = props.backgroundStyle.Color3
	else
		backgroundColor = v3.Color.Surface.Surface_0.Color3
	end

	v25.BackgroundColor3 = backgroundColor
	local backgroundTransparency

	if props.backgroundStyle then
		backgroundTransparency = props.backgroundStyle.Transparency
	end

	v25.BackgroundTransparency = backgroundTransparency
	v25.Size = UDim2.fromScale(1, 0)
	v25.CanvasSize = UDim2.new(1, 0, 0, 0)
	v25.AutomaticCanvasSize = Enum.AutomaticSize.Y
	v25.BorderSizePixel = 0
	v25.ScrollBarThickness = scrollBarThickness
	v25.ElasticBehavior = Enum.ElasticBehavior.Always
	v25.ScrollingDirection = Enum.ScrollingDirection.Y
	v25.Selectable = false
	v25.ScrollingEnabled = not v17
	v25.ClipsDescendants = false
	local element = createElement("ScrollingFrame", v25, {
		FlexFill = React.createElement("UIFlexItem", { FlexMode = Enum.UIFlexMode.Fill }),
		Content = content
	})

	local createElement2 = React.createElement
	local v27 = {
		tag = "size-full",
		LayoutOrder = props.layoutOrder,
		layout = {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder
		}
	}
	local sticky

	if v4 then
		sticky = React.createElement(SduiStickyHeader, {
			stickyItems = props.stickyItems,
			sduiContext = sduiContext,
			debugName = `{debugName}.StickyHeader`,
			contentTag = stickyContentTag,
			backgroundStyle = stickyBackgroundStyle,
			paddingTop = stickyPaddingTop,
			paddingBottom = stickyPaddingBottom,
			gapBetweenItems = gapBetweenStickyItems,
			zIndex = 2,
			extraLocalProps = extraLocalProps,
			impressionsTag = impressionsTag,
			selectionBehaviorLeft = selectionBehaviorLeft,
			selectionBehaviorRight = selectionBehaviorRight
		})
	end

	local refreshSpinner

	if v5 then
		local createElement3 = React.createElement

		if not FFlagLuaAppSduiHomeFriendCarousel then
			onRefresh = props.onRefresh
		end

		refreshSpinner = createElement3(PullToRefreshSpinner, {
			LayoutOrder = 2,
			onRefresh = onRefresh,
			scrollingFrameRef = ref,
			appEventName = sduiContext.appPage
		})
	end

	return createElement2(View, v27, {
		Sticky = sticky,
		RefreshSpinner = refreshSpinner,
		Scroll = element
	})
end

return React.memo(SduiVerticalFeed)
