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
local defineFastInt = game:DefineFastInt("SduiVerticalFeedScrollInitialNumRows", 4)
local defineFastInt2 = game:DefineFastInt("SduiVerticalFeedScrollLoadNumRows", 3)
local defineFastInt3 = game:DefineFastInt("SduiVerticalFeedScrollPreloadDistancePx", 2000)

local defineFastInt4 = game:DefineFastInt("SduiVerticalFeedScrollUnderfillDebounceMs", 50)
local defineFastFlag = game:DefineFastFlag("SduiEnableBackToTop", false)
local FFlagSduiPageCanvasCollectionLayout = SharedFlags.FFlagSduiPageCanvasCollectionLayout
local FFlagLuaAppSduiVideoThumbnail = SharedFlags.FFlagLuaAppSduiVideoThumbnail
local FFlagLuaAppMediaGalleryGamepadSupport = SharedFlags.FFlagLuaAppMediaGalleryGamepadSupport
local FFlagLuaAppOneByTwoHoverIdleAutoplay = SharedFlags.FFlagLuaAppOneByTwoHoverIdleAutoplay
local FFlagLuaAppSduiSuppressVideoDetectorDuringScroll = SharedFlags.FFlagLuaAppSduiSuppressVideoDetectorDuringScroll
local FFlagAppPageShellScrollToTopFocus = SharedFlags.FFlagAppPageShellScrollToTopFocus
local FFlagSduiVerticalFeedScrollTelemetry = SharedFlags.FFlagSduiVerticalFeedScrollTelemetry
local FFlagSduiIndividualFeedItemSpacing = SharedFlags.FFlagSduiIndividualFeedItemSpacing
local FFlagSduiSamePoolFeedItemSpacing = SharedFlags.FFlagSduiSamePoolFeedItemSpacing

local signal = Signals.createSignal(nil)

local frozen = table.freeze({})

local function PoolStoreLayoutStoreWiring(p): nil
	local v = React.useContext(CollectionLayoutStoreContext)
	React.useEffect(function()
		if v == nil then
			return
		end

		local sduiPoolStore = SduiPoolStore.getSduiPoolStore(p.configKey)
		sduiPoolStore.setLayoutStore(v)
		return function()
			sduiPoolStore.setLayoutStore(nil)
		end
	end, { p.configKey, v })
	return nil
end

local function getFeedItemRowCount(item, p) -- 1 equivalent call inferred from this helper
	local numberOfRowsGetter = item.numberOfRowsGetter

	if numberOfRowsGetter ~= nil then
		local v = numberOfRowsGetter(p)

		if v > 0 then
			return v
		end
	end

	return 1
end

local function useProgressiveRowCapWithScroll(feedItems, initialNumToRender: number?, progressiveFillRate: number?, progressiveFillIntervalMs: number?, progressiveFillOnScroll: boolean?, scrollingFrameRef, ref, defineFastInt5: number)
	local v, v2 = useProgressiveRowCap(
		feedItems and #feedItems or 0,
		initialNumToRender,
		progressiveFillRate,
		progressiveFillIntervalMs
	)

	local v3 = React.useMemo(function()
		return Signals.createComputed(function(p)
			signal(p)

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

	local v4 = SignalsReact.useSignalState(v3)

	if not progressiveFillOnScroll then
		scrollingFrameRef = nil
	end

	if not progressiveFillOnScroll then
		ref = nil
	end

	local v5, v6 = useProgressiveItemCapOnScroll(
		v4,
		defineFastInt,
		defineFastInt2,
		scrollingFrameRef,
		ref,
		defineFastInt3,
		defineFastInt5
	)

	if progressiveFillOnScroll then
		return math.min(v, v5), v2 or v6
	end

	return v, v2
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
	local v

	if contentTag == nil then
		v = false
	else
		v = contentTag ~= ""
	end

	local v2 = useTokens()
	local v3

	if props.stickyItems == nil then
		v3 = false
	else
		v3 = #props.stickyItems > 0
	end

	local v4 = props.onRefresh ~= nil
	local stickyContentTag = props.stickyContentTag or props.defaultStickyContentTag
	local stickyBackgroundStyle = props.stickyBackgroundStyle or v2.Color.Surface.Surface_0

	local stickyPaddingTop = props.stickyPaddingTop or v2.Gap.Medium
	local stickyPaddingBottom = props.stickyPaddingBottom or v2.Gap.Medium
	local gapBetweenStickyItems = props.gapBetweenStickyItems or v2.Gap.Medium
	local gapAfterStickyItems = props.gapAfterStickyItems or v2.Gap.Medium
	local v5 = useNavBarPlacement()
	local impressionsTag = props.impressionsTag or sduiContext.routeName or sduiContext.appPage
	local selectionBehaviorLeft = props.selectionBehaviorLeft

	if not selectionBehaviorLeft then
		if v5 == AppNavBar.Placement.Left then
			selectionBehaviorLeft = Enum.SelectionBehavior.Escape
		else
			selectionBehaviorLeft = Enum.SelectionBehavior.Stop
		end
	end

	local selectionBehaviorRight = props.selectionBehaviorRight or Enum.SelectionBehavior.Stop
	local v6 = usePreferredInput()
	local scrollBarThickness = props.scrollBarThickness or v6 == Responsive.Input.Pointer and 4 or 0

	local state, setState = React.useState(nil)

	local ref = React.useRef(nil)
	local scrollingFrameRef = props.scrollingFrameRef or ref

	local ref2 = React.useRef(nil)

	local ref3 = React.useRef(nil)

	if ref3.current == nil then
		ref3.current = AppCommonLib.Signal.new()
	end

	local v7 = React.useCallback(function()
		ref3.current:fire()
	end, {})
	local ref4, onRefresh

	if FFlagLuaAppSduiHomeFriendCarousel then
		ref4 = React.useRef(nil)

		if ref4.current == nil then
			local current

			if props.refreshSignal then
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

	local ref5 = React.useRef(0)
	local ref6 = React.useRef(ScrollMovementDirection.Backward)
	local v8 = React.useCallback(function(p)
		v7()
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
	end, { v7, props.onScrollDirectionChanged })

	local v9 = React.useMemo(function()
		return {
			scrollViewPositionChangedSignal = ref3.current,
			verticalScrollingFrameRef = scrollingFrameRef
		}
	end, { ref3, ref, scrollingFrameRef })

	local gapBetweenFeedItems = props.gapBetweenFeedItems or v2.Gap.Large
	local samePoolFeedItemGap

	if FFlagSduiSamePoolFeedItemSpacing then
		samePoolFeedItemGap = props.samePoolFeedItemGap or v2.Gap.Large
	else
		samePoolFeedItemGap = nil
	end

	local extraLocalProps = React.useMemo(function()
		local v10 = {
			scrollViewPositionChangedSignal = ref3.current,
			verticalScrollingFrameRef = scrollingFrameRef,
			refreshSignal = 0
		}
		local refreshSignal

		if FFlagLuaAppSduiHomeFriendCarousel then
			refreshSignal = ref4.current
		end

		v10.refreshSignal = refreshSignal
		return v10
	end, { ref3, scrollingFrameRef })

	local state2 = nil
	local v10 = nil

	if defineFastFlag then
		local setState2
		state2, setState2 = React.useState(false)
		v10 = setState2
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

				v10(y < y2)
			end

			local v11 = {
				current:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(updateIsScrollable),
				current:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(updateIsScrollable)
			}
			updateIsScrollable() -- inferred equivalent call
			return function()
				for _, connection in v11 do
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

	React.useEffect(function()
		if not (props.scrollingFrameRef and props.scrollingFrameRef.current) then
			return nil
		end

		local current = props.scrollingFrameRef.current
		ref5.current = current.CanvasPosition.Y

		local v11 = {
			current:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
				v8(current)
			end),
			current:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(v7)
		}

		return function()
			for _, connection in v11 do
				connection:Disconnect()
			end
		end
	end, { props.scrollingFrameRef, v7, v8 })
	local v11

	if not props.scrollToSelectionAnimationManagedByParent then
		v11 = scrollingFrameRef
	end

	local v12

	if FFlagLuaAppMediaGalleryGamepadSupport then
		v12 = props.scrollToSelectionRevealOnly
	end

	useAnimateScrollViewToSelection(v11, 0.4, v12)

	local v13 = useLastInputMode() ~= "Cursor"

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

	local maxConfigs, v14 = useProgressiveRowCapWithScroll(
		feedItems,
		props.initialNumToRender,
		props.progressiveFillRate,
		props.progressiveFillIntervalMs,
		props.progressiveFillOnScroll,
		scrollingFrameRef,
		ref2,
		defineFastInt4
	)
	local v15

	if not v14 then
		v15 = props.onScrollToEnd
	end

	useVerticalScrolledToEndThreshold(scrollingFrameRef, thresholdFromEnd, v15)

	local useMemo = React.useMemo
	local function fn()
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

		local result = {
			BottomSpacer = bottomSpacer,
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, FFlagSduiIndividualFeedItemSpacing and 0 or gapBetweenFeedItems),
				ref = ref2
			}),
			StickyGap = 0,
			NoStickyTopMargin = 0,
			PoolStoreLayoutStoreWiring = 0,
			FeedImpressionsDetector = 0
		}
		local stickyGap

		if v3 and gapAfterStickyItems and gapAfterStickyItems > 0 then
			local createElement = React.createElement
			local v16

			if FFlagSduiIndividualFeedItemSpacing then
				v16 = math.max(gapAfterStickyItems, gapBetweenFeedItems)
			else
				v16 = math.max(0, gapAfterStickyItems - gapBetweenFeedItems)
			end

			stickyGap = createElement("Frame", {
				Size = UDim2.new(1, 0, 0, v16),
				BackgroundTransparency = 1,
				LayoutOrder = 0
			})
		end

		result.StickyGap = stickyGap
		local noStickyTopMargin

		if not (v3 or not (props.feedTopMargin and props.feedTopMargin > 0)) then
			local createElement = React.createElement
			local v16

			if FFlagSduiIndividualFeedItemSpacing then
				v16 = math.max(props.feedTopMargin, gapBetweenFeedItems)
			else
				v16 = math.max(0, props.feedTopMargin - gapBetweenFeedItems)
			end

			noStickyTopMargin = createElement("Frame", {
				Size = UDim2.new(1, 0, 0, v16),
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

		local v16 = {
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

		v16.selectionOrderBase = selectionOrderBase
		local defaultFocusRef

		if FFlagAppPageShellScrollToTopFocus then
			defaultFocusRef = props.defaultFocusRef
		end

		v16.defaultFocusRef = defaultFocusRef
		v16.maxConfigs = maxConfigs
		local gapBetweenFeedItems2

		if FFlagSduiIndividualFeedItemSpacing then
			gapBetweenFeedItems2 = gapBetweenFeedItems
		end

		v16.gapBetweenFeedItems = gapBetweenFeedItems2
		local gapAfterFirstFeedItem

		if FFlagSduiIndividualFeedItemSpacing then
			gapAfterFirstFeedItem = props.gapAfterFirstFeedItem
		end

		v16.gapAfterFirstFeedItem = gapAfterFirstFeedItem
		local samePoolFeedItemGap2

		if FFlagSduiSamePoolFeedItemSpacing then
			samePoolFeedItemGap2 = samePoolFeedItemGap
		end

		v16.samePoolFeedItemGap = samePoolFeedItemGap2
		local sduiFeedChildren = buildSduiFeedChildren(v16)

		for k, v17 in sduiFeedChildren do
			result[k] = v17
		end

		return result
	end

	local gapAfterFirstFeedItem

	if FFlagSduiIndividualFeedItemSpacing then
		gapAfterFirstFeedItem = props.gapAfterFirstFeedItem
	end

	local v16

	if FFlagSduiSamePoolFeedItemSpacing then
		v16 = samePoolFeedItemGap
	end

	local v17 = {
		feedItems,
		debugName,
		ref,
		ref3,
		sduiContext,
		analyticsContext,
		gapBetweenFeedItems,
		gapAfterFirstFeedItem,
		v16,
		impressionsTag,
		selectionBehaviorLeft,
		selectionBehaviorRight,
		v3,
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

	local v18

	if defineFastFlag then
		v18 = state2
	end

	local v19

	if FFlagAppPageShellScrollToTopFocus then
		v19 = props.defaultFocusRef
	end

	v17[17], v17[18], v17[19], v17[20], v17[21], v17[22], v17[23] = v, pageBottomPadding, enableBackToTop, v18, scrollingFrameRef, maxConfigs, v19
	local v20 = useMemo(fn, v17)

	if v9 then
		v20 = React.createElement(SduiFeedContext.Provider, { value = v9 }, v20)
	end

	if not (FFlagSduiPageCanvasCollectionLayout and props.disableCollectionLayoutStoreProvider) then
		v20 = React.createElement(CollectionLayoutStoreProvider, { container = state }, v20)
	end

	local tag = { ["size-full-0 auto-y"] = true }

	if v then
		tag[contentTag] = true
	end

	local content = React.createElement(View, {
		tag = tag,
		LayoutOrder = props.layoutOrder,
		ref = setState
	}, v20)

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
	local v21 = {
		["LayoutOrder"] = nil,
		["LayoutOrder"] = nil,
		["LayoutOrder"] = nil,
		["LayoutOrder"] = nil,
		["LayoutOrder"] = nil,
		LayoutOrder = 3,
		ref = ref,
		[React.Change.CanvasPosition] = v8,
		[React.Change.CanvasSize] = v7
	}
	local backgroundColor

	if props.backgroundStyle then
		backgroundColor = props.backgroundStyle.Color3
	else
		backgroundColor = v2.Color.Surface.Surface_0.Color3
	end

	v21.BackgroundColor3 = backgroundColor
	local backgroundTransparency

	if props.backgroundStyle then
		backgroundTransparency = props.backgroundStyle.Transparency
	end

	v21.BackgroundTransparency = backgroundTransparency
	v21.Size = UDim2.fromScale(1, 0)
	v21.CanvasSize = UDim2.new(1, 0, 0, 0)
	v21.AutomaticCanvasSize = Enum.AutomaticSize.Y
	v21.BorderSizePixel = 0
	v21.ScrollBarThickness = scrollBarThickness
	v21.ElasticBehavior = Enum.ElasticBehavior.Always
	v21.ScrollingDirection = Enum.ScrollingDirection.Y
	v21.Selectable = false
	v21.ScrollingEnabled = not v13
	v21.ClipsDescendants = false
	local element = createElement("ScrollingFrame", v21, {
		FlexFill = React.createElement("UIFlexItem", { FlexMode = Enum.UIFlexMode.Fill }),
		Content = content
	})

	local createElement2 = React.createElement
	local v22 = {
		tag = "size-full",
		LayoutOrder = props.layoutOrder,
		layout = {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder
		}
	}
	local sticky

	if v3 then
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

	if v4 then
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

	return createElement2(View, v22, {
		Sticky = sticky,
		RefreshSpinner = refreshSpinner,
		Scroll = element
	})
end

return React.memo(SduiVerticalFeed)
