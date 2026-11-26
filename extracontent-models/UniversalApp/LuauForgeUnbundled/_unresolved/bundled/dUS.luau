local module = require("@luauforge/bundled/dTk")
local module2 = require("@luauforge/bundled/dTi")
local module3 = require("@luauforge/bundled/dUT")
local useNavBarPlacement = module3.useNavBarPlacement
local useNavBarSize = module3.useNavBarSize
local placement = module3.Placement
local module4 = require("@luauforge/bundled/dUL")
local module5 = require("@luauforge/bundled/dTq")
local findAnalyticsField = module5.findAnalyticsField
local getSduiComponentWrapper = module5.getSduiComponentWrapper
local sduiBuilder = module5.SduiBuilder
local sduiErrors = module5.SduiErrors

local virtualizedFeed = require("@luauforge/bundled/dUK").FeedComponents.VirtualizedFeed

local module6 = require("@luauforge/bundled/dUU")
local CATALOG_RESULTS_HORIZONTAL_MARGIN = module6.Constants.CATALOG_RESULTS_HORIZONTAL_MARGIN
local FLATLIST_CONFIGS = module6.Constants.FLATLIST_CONFIGS

local useAXAnimateScrollFrame = require("@luauforge/bundled/dUj").Components.AnimatedScrollingFrame.useAXAnimateScrollFrame

local module7 = require("@luauforge/bundled/dTo")
local fFlagSduiCatalogVirtualizedFeed = module7.FFlagSduiCatalogVirtualizedFeed
local fFlagAXScrollTelemetryIntegration2 = module7.FFlagAXScrollTelemetryIntegration2

local module8 = require("@luauforge/bundled/dTp")
local fFlagAXFixSduiCatalogRowJump = module8.FFlagAXFixSduiCatalogRowJump
local fFlagAXSharedImpressionRescan = module8.FFlagAXSharedImpressionRescan
local fFlagAXSduiFeedBackToTopAndNavClearance = module8.FFlagAXSduiFeedBackToTopAndNavClearance
local fFlagAXCategoryMenuVisualFixes = module8.FFlagAXCategoryMenuVisualFixes
local fFlagAXSduiFeedMaintainScrollOnSeeAll = module8.FFlagAXSduiFeedMaintainScrollOnSeeAll
local fFlagAXSduiFeedSkipScrollWithoutContent = module8.FFlagAXSduiFeedSkipScrollWithoutContent

local catalogSduiPageContext = module6.Sdui.CatalogSduiPageContext
local module9 = require("@luauforge/bundled/dUV")

local v5 = {}

local function SduiCatalogVirtualizedFeed(props)
	local analyticsContext = props.analyticsContext
	local sduiContext = props.sduiContext
	local feedItems = props.feedItems
	local debugName = props.debugName
	local v6

	if props.horizontalPadding then
		v6 = props.horizontalPadding
	else
		v6 = CATALOG_RESULTS_HORIZONTAL_MARGIN
	end

	local v7

	if fFlagAXSduiFeedBackToTopAndNavClearance then
		local v8 = useNavBarPlacement()
		local v9 = useNavBarSize()
		v7 = v8 ~= placement.Bottom and 0 or v9
	else
		v7 = 0
	end

	local v8 = module.useMemo(function()
		return module2.Signal.new()
	end, {})

	local ref = module.useRef(nil)
	local scrollPerformanceIntervalName

	if fFlagAXScrollTelemetryIntegration2 then
		local v9 = module.useContext(catalogSduiPageContext)

		if v9 then
			scrollPerformanceIntervalName = v9.scrollPerformanceIntervalName
		end
	end

	if fFlagAXSduiFeedMaintainScrollOnSeeAll then
		local v9 = module.useContext(catalogSduiPageContext)

		local scrollPositionRef = if v9 then v9.scrollPositionRef else nil
		local v11 = if v9 then v9.scrollRestoreRef else nil
		module9(ref, scrollPositionRef, v11)
	end

	if fFlagAXCategoryMenuVisualFixes then
		local state, setState = module.useState(nil)
		module.useLayoutEffect(function()
			local current = ref.current

			if current == nil then
				return
			end

			local nativeScrollRef = current:getNativeScrollRef()

			if nativeScrollRef ~= nil then
				setState(nativeScrollRef._nativeRef)
			end
		end, {})

		useAXAnimateScrollFrame(state)
	end

	local v9 = fFlagAXCategoryMenuVisualFixes and 0 or module4.Hooks.useTokens().Padding.Small

	local v10 = module.useContext(catalogSduiPageContext)
	local onScroll = if v10 then v10.onScroll else nil
	local requestImpressionsSignal = if v10 then v10.requestImpressionsSignal else nil

	local v11 = module.useCallback(function(p2)
		v8:fire()

		if onScroll then
			onScroll(p2)
			task.defer(function()
				if requestImpressionsSignal then
					requestImpressionsSignal:fire()
				end
			end)
		end
	end, { onScroll, requestImpressionsSignal })

	module.useEffect(function()
		if not requestImpressionsSignal then
			return
		end

		requestImpressionsSignal:fire()

		if fFlagAXSharedImpressionRescan then
			return
		end

		local flag = false
		local thread = nil
		local function scheduleNext()
			if flag then
				return
			end

			thread = task.delay(1, function()
				if flag then
					return
				end

				requestImpressionsSignal:fire()
				scheduleNext()
			end)
		end

		if not flag then
			thread = task.delay(1, function()
				if flag then
					return
				end

				requestImpressionsSignal:fire()
				scheduleNext()
			end)
		end

		return function()
			flag = true

			if thread then
				task.cancel(thread)
				thread = nil
			end
		end
	end, { requestImpressionsSignal })

	local v12 = nil
	local v13

	if fFlagAXFixSduiCatalogRowJump then
		local state, setState = module.useState(0)
		local ref2 = module.useRef(0)
		v13 = module.useCallback(function(current)
			if ref2.current == current then
				return
			end

			ref2.current = current
			setState(current)
		end, {})

		if state > 0 then
			v12 = math.max(0, state - v6 * 2)
		end
	end

	local function fn(p2)
		local item = p2.item
		local index = p2.index

		local v14 = findAnalyticsField("componentType", item.analyticsData or v5)
			or sduiBuilder.getComponentType(item, sduiContext)

		if not v14 then
			sduiContext.dependencies.logger.reportError(
				sduiErrors.SduiErrorType.NilComponentType,
				{
					componentType = "CatalogVirtualizedFeed",
					name = debugName,
					message = `Nil componentType in CatalogVirtualizedFeed at feedItem index {index}`
				},
				sduiContext.appPage
			)
			return nil
		end

		local sduiComponentWrapper = getSduiComponentWrapper(item)

		local v16 = if item.props and item.props.layoutOrder ~= nil then item.props.layoutOrder else index

		local createElement = module.createElement
		local v19 = {
			debugName = `catalogVirtualizedFeedItem{index}`,
			componentConfig = item,
			sduiContext = sduiContext,
			localAnalyticsData = {
				feedItemPosition = index,
				itemComponentType = v14,
				componentType = v14
			},
			extraLocalProps = {
				scrollViewPositionChangedSignal = v8,
				startRow = 1,
				layoutOrder = v16,
				feedRowWidth = if fFlagAXFixSduiCatalogRowJump then v12 else nil
			},
			parentAnalyticsContext = 0
		}

		local v20 = if not item.__isClientBinding then analyticsContext else nil
		v19.parentAnalyticsContext = v20
		return createElement(sduiComponentWrapper, v19)
	end

	local v16 = module.useCallback(fn, {
		feedItems,
		debugName,
		v8,
		sduiContext,
		analyticsContext,
		if fFlagAXFixSduiCatalogRowJump then v12 else nil
	})

	if feedItems == nil then
		return nil
	end

	local v17

	if fFlagAXSduiFeedBackToTopAndNavClearance then
		v17 = #feedItems > 0 and not props.isLoading
	else
		v17 = props.isEndOfList
	end

	local v18 = props.windowSize
	local v19 = props.initialNumToRender
	local v20 = props.maxToRenderPerBatch
	local v21 = props.updateCellsBatchingPeriod
	local v22 = props.scrollEventThrottle

	if fFlagSduiCatalogVirtualizedFeed then
		if v18 == nil then
			v18 = FLATLIST_CONFIGS.WINDOW_SIZE
		end

		if v19 == nil then
			v19 = FLATLIST_CONFIGS.INITIAL_NUM_TO_RENDER
		end

		if v20 == nil then
			v20 = FLATLIST_CONFIGS.MAX_TO_RENDER_PER_BATCH
		end

		if v21 == nil then
			v21 = FLATLIST_CONFIGS.UPDATE_CELLS_BATCHING_PERIOD
		end

		if v22 == nil then
			v22 = FLATLIST_CONFIGS.SCROLL_EVENT_THROTTLE
		end
	end

	local createElement = module.createElement
	local v24 = {
		data = feedItems,
		renderItem = v16,
		flatListRef = ref,
		skipScrollWithoutContent = fFlagAXSduiFeedSkipScrollWithoutContent and true or nil,
		scrollPerformanceIntervalName = nil,
		horizontalPadding = nil,
		verticalPadding = 0,
		windowSize = 0,
		initialNumToRender = 0,
		maxToRenderPerBatch = 0,
		updateCellsBatchingPeriod = 0,
		scrollEventThrottle = 0,
		onScroll = 0,
		onContainerWidthChanged = 0,
		onEndReached = 0,
		onEndReachedThreshold = 0,
		isLoading = 0,
		isEndOfList = 0,
		scrollToTopLabel = 0,
		endOfListBottomPadding = 0,
		LayoutOrder = 0,
		Size = 0,
		backgroundColor = 0,
		backgroundTransparency = 0
	}

	if not fFlagAXScrollTelemetryIntegration2 then
		scrollPerformanceIntervalName = nil
	end

	v24.scrollPerformanceIntervalName = scrollPerformanceIntervalName

	v24.horizontalPadding = v6

	if props.verticalPadding ~= nil then
		v9 = props.verticalPadding
	end

	v24.verticalPadding = v9
	v24.windowSize = v18
	v24.initialNumToRender = v19
	v24.maxToRenderPerBatch = v20
	v24.updateCellsBatchingPeriod = v21
	v24.scrollEventThrottle = v22

	v24.onScroll = v11
	v24.onContainerWidthChanged = v13
	v24.onEndReached = props.onScrollToEnd
	v24.onEndReachedThreshold = props.onEndReachedThreshold

	v24.isLoading = props.isLoading
	v24.isEndOfList = v17
	v24.scrollToTopLabel = props.scrollToTopLabel

	local v25 = if fFlagAXSduiFeedBackToTopAndNavClearance then math.max(props.endOfListBottomPadding or 0, v7) else props.endOfListBottomPadding
	v24.endOfListBottomPadding = v25

	v24.LayoutOrder = props.layoutOrder
	v24.Size = props.Size
	v24.backgroundColor = props.backgroundColor
	v24.backgroundTransparency = props.backgroundTransparency
	return createElement(virtualizedFeed, v24)
end

return module.memo(SduiCatalogVirtualizedFeed)
