local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local parent = ServerDrivenUi.Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiErrorPaths = SharedFlags.FFlagSduiErrorPaths

local React = require(parent.React)
require(parent.AppCommonLib)
local SignalsReact = require(parent.SignalsReact)
local CollectionViews = require(parent.CollectionViews)
local useCollectionImpressionsSignal = CollectionViews.useCollectionImpressionsSignal
local useCollectionLayoutParams = CollectionViews.useCollectionLayoutParams
local VariableItemWidthCarousel = require(parent.VariableItemWidthCarousel)
local variableItemWidthCarousel = VariableItemWidthCarousel.VariableItemWidthCarousel
local GameCollections = require(parent.GameCollections)
local WaitForPropWrapper = GameCollections.WaitForPropWrapper
local Impressions = require(parent.Impressions)
local FrameBoundsImpressionsTracker = Impressions.FrameBoundsImpressionsTracker
local ScreenSizeImpressionsTracker = Impressions.ScreenSizeImpressionsTracker
local ScrollTelemetry = require(parent.ScrollTelemetry)
local ScrollDetector = ScrollTelemetry.ScrollDetector
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens

local SduiCoreSystem = require(parent.SduiCoreSystem)
local findAnalyticsField = SduiCoreSystem.findAnalyticsField
local getSduiComponentWrapper = SduiCoreSystem.getSduiComponentWrapper
local reportUnifiedLoggingImpressions = SduiCoreSystem.reportUnifiedLoggingImpressions
local SduiBuilder = SduiCoreSystem.SduiBuilder
local SduiCollectionAnalyticsBuilder = SduiCoreSystem.SduiCollectionAnalyticsBuilder
local SduiComponentType = SduiCoreSystem.SduiComponentType
local SduiErrors = SduiCoreSystem.SduiErrors
local SduiParseHelpers = SduiCoreSystem.SduiParseHelpers

local SduiCollectionItem = require(ServerDrivenUi.Content.Collections.SduiCollectionItem)
local getImpressionsTag = require(ServerDrivenUi.Analytics.getImpressionsTag)
local SduiSharedContent = require(parent.SduiSharedContent)
local useCollectionAnalyticsContext = SduiSharedContent.useCollectionAnalyticsContext
local useScrollTelemetryCallback = require(ServerDrivenUi.Analytics.useScrollTelemetryCallback)

local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppCompositionAlways = SharedFlags2.FFlagLuaAppCompositionAlways
local FFlagLuaAppLayoutParamsInContext = SharedFlags2.FFlagLuaAppLayoutParamsInContext
local FFlagLuaAppRespectClipAncestorImpressions = SharedFlags2.FFlagLuaAppRespectClipAncestorImpressions
local FFlagLuaAppUseFrameBoundsImpressions = SharedFlags2.FFlagLuaAppUseFrameBoundsImpressions
local FFlagSduiOptionSelectorHeaderComponent = SharedFlags2.FFlagSduiOptionSelectorHeaderComponent
local FFlagSduiOptionSelectorAnchorTag = SharedFlags2.FFlagSduiOptionSelectorAnchorTag

local v = {}

local function SduiVariableItemWidthCarousel(props)
	local sduiContext = props.sduiContext

	local v2 = FFlagLuaAppCompositionAlways or props.appCompositionEnabled or sduiContext.appCompositionEnabled

	local items = props.items or v
	local count = #items

	local v3 = useTokens()
	local itemHeight = props.itemHeight or v3.Size.Size_800
	local itemPadding = props.itemPadding or v3.Padding.XSmall

	local state, setState = React.useState(nil)

	local v4 = { sideMargin = props.pageSideMargin }
	local v5

	if not FFlagLuaAppCompositionAlways then
		if FFlagLuaAppLayoutParamsInContext then
			local v6 = React.useCallback(function(p)
				return sduiContext.getPageLayoutConfig("Small")(p)
			end, { sduiContext.getPageLayoutConfig })
			v5 = SignalsReact.useSignalState(v6)
		else
			v5 = useCollectionLayoutParams("Small", state, false, v4)
		end
	end

	local sideMargin

	if props.sideMargin == nil then
		sideMargin = v2 and 0 or v5.sideMargin
	else
		sideMargin = props.sideMargin
	end

	local v6 = findAnalyticsField("componentType", props.analyticsContext.analyticsData or v)
		or SduiBuilder.getComponentType(props.componentConfig, sduiContext)
		or SduiComponentType.VariableItemWidthCarousel

	local v7, v8 = useCollectionAnalyticsContext(
		props.analyticsContext,
		v6,
		count,
		count,
		sduiContext,
		props.startRow,
		props.componentConfig.__isClientBinding
	)

	local ref = React.useRef({})
	local state2, setState2 = React.useState({})
	local ref2 = React.useRef(nil)

	local scrollViewPositionChangedSignal2, onCanvasPositionChanged = useCollectionImpressionsSignal(props.scrollViewPositionChangedSignal)

	local impressionsTag = getImpressionsTag(props.index, v8.current, sduiContext, props.debugName)

	local onItemSizeChanged = React.useCallback(function(p: number, p2)
		local x = p2.AbsoluteSize.X

		if x <= 0 then
			return
		end

		setState2(function(p3)
			if p3[p] == x then
				return p3
			end

			local clone = table.clone(p3)
			clone[p] = x
			return clone
		end)
	end, {})

	local calculateItemWidth = React.useCallback(function(p: number)
		return state2[p] or 0
	end, { state2 })

	local sendImpressions = React.useCallback(function(list)
		if count ~= 0 then
			reportUnifiedLoggingImpressions(
				sduiContext,
				list,
				ref.current,
				v8.current,
				props.startRow,
				props.impressionEventName,
				props.skipItemImpressionsLog
			)
		elseif list and #list > 0 then
			local v9

			if v7 then
				v9 = SduiParseHelpers.stringifyValue(v7.analyticsData)
			end

			sduiContext.dependencies.logger.reportError(
				SduiErrors.SduiErrorType.FailedToLogImpressions,
				{
					componentType = "VariableItemWidthCarousel",
					name = impressionsTag,
					message = `Failed to log impressions. No configs. indexes: {table.concat(list, ",")} analytics: {v9}`
				},
				sduiContext.appPage
			)
		end
	end, {
		count,
		sduiContext,
		ref,
		v8,
		props.startRow,
		props.impressionEventName,
		props.skipItemImpressionsLog,
		v7,
		impressionsTag
	})

	local sendScrollEvent = useScrollTelemetryCallback(ref2, v8, sduiContext)

	local useCallback = React.useCallback
	local function fn(props2, itemPosition: number)
		if not props2 then
			sduiContext.dependencies.logger.reportError(
				SduiErrors.SduiErrorType.NilItem,
				{
					componentType = "VariableItemWidthCarousel",
					name = impressionsTag,
					message = `Nil item in VariableItemWidthCarousel.renderItem at index {itemPosition}`
				},
				sduiContext.appPage
			)
			return React.createElement(React.Fragment)
		end

		local v9 = findAnalyticsField("componentType", props2.analyticsData or v)
			or SduiBuilder.getComponentType(props2, sduiContext)

		if not v9 then
			sduiContext.dependencies.logger.reportError(
				SduiErrors.SduiErrorType.NilComponentType,
				{
					componentType = "VariableItemWidthCarousel",
					name = impressionsTag,
					message = `Nil componentType in VariableItemWidthCarousel.renderItem at index {itemPosition}`
				},
				sduiContext.appPage
			)
			return React.createElement(React.Fragment)
		end

		local localAnalyticsData = {
			itemPosition = itemPosition,
			itemComponentType = v9,
			componentType = v9
		}

		local current = ref.current
		local buildAndValidateItemAnalyticsData = SduiCollectionAnalyticsBuilder.buildAndValidateItemAnalyticsData

		local analyticsData = props2.analyticsData
		local v10

		if FFlagSduiErrorPaths then
			v10 = props2.errorContext
		end

		current[itemPosition] = buildAndValidateItemAnalyticsData(
			sduiContext,
			analyticsData,
			nil,
			localAnalyticsData,
			v9,
			nil,
			v10
		)

		local sduiComponentWrapper = getSduiComponentWrapper(props2)
		local createElement = React.createElement
		local v11 = {
			componentConfig = props2,
			sduiContext = sduiContext,
			parentAnalyticsContext = 0,
			extraLocalProps = 0,
			debugName = 0,
			localAnalyticsData = 0
		}
		local parentAnalyticsContext

		if not props2.__isClientBinding then
			parentAnalyticsContext = v7
		end

		v11.parentAnalyticsContext = parentAnalyticsContext
		local extraLocalProps = {
			index = itemPosition,
			scrollViewPositionChangedSignal = props.scrollViewPositionChangedSignal,
			verticalScrollingFrameRef = props.verticalScrollingFrameRef,
			selectionOrder = 0
		}
		local selectionOrder

		if props.selectionOrderBase then
			selectionOrder = props.selectionOrderBase + itemPosition
		end

		extraLocalProps.selectionOrder = selectionOrder
		v11.extraLocalProps = extraLocalProps

		v11.debugName = `{v9}_{itemPosition}`
		v11.localAnalyticsData = localAnalyticsData
		local element = createElement(sduiComponentWrapper, v11)

		local createElement2 = React.createElement
		local v12 = {
			index = itemPosition,
			impressionsTag = impressionsTag,
			automaticSize = Enum.AutomaticSize.X,
			size = UDim2.new(0, 0, 0, itemHeight),
			onItemSizeChanged = onItemSizeChanged,
			tag = 0
		}
		local tag

		if FFlagSduiOptionSelectorAnchorTag and props.itemTags then
			tag = props.itemTags[itemPosition]
		end

		v12.tag = tag
		return createElement2(SduiCollectionItem, v12, { Item = element })
	end

	local scrollViewPositionChangedSignal = props.scrollViewPositionChangedSignal
	local verticalScrollingFrameRef = props.verticalScrollingFrameRef
	local selectionOrderBase = props.selectionOrderBase
	local v9

	if FFlagSduiOptionSelectorAnchorTag then
		v9 = props.itemTags
	end

	local renderItem = useCallback(fn, {
		sduiContext,
		v7,
		impressionsTag,
		itemHeight,
		onItemSizeChanged,
		scrollViewPositionChangedSignal,
		verticalScrollingFrameRef,
		selectionOrderBase,
		v9
	})

	local createElement = React.createElement
	local fragment = React.Fragment
	local createElement2 = React.createElement
	local v10 = {
		ref = setState,
		LayoutOrder = props.layoutOrder,
		Position = props.position,
		title = props.title or "",
		subtitle = props.subtitle,
		headerComponent = 0,
		calculateItemWidth = 0,
		scrollButtonsEnabled = 0,
		scrollSpeed = 0,
		items = 0,
		itemHeight = 0,
		itemPadding = 0,
		onCanvasPositionChanged = 0,
		renderItem = 0,
		scrollingFrameRef = 0,
		sideMargin = 0
	}
	local headerComponent

	if FFlagSduiOptionSelectorHeaderComponent then
		headerComponent = props.headerComponent
	end

	v10.headerComponent = headerComponent
	v10.calculateItemWidth = calculateItemWidth
	v10.scrollButtonsEnabled = props.scrollButtonsEnabled
	v10.scrollSpeed = props.scrollSpeed
	v10.items = items
	v10.itemHeight = itemHeight
	v10.itemPadding = itemPadding
	v10.onCanvasPositionChanged = onCanvasPositionChanged
	v10.renderItem = renderItem
	v10.scrollingFrameRef = ref2
	v10.sideMargin = sideMargin
	local children = {
		Carousel = createElement2(variableItemWidthCarousel, v10),
		ImpressionDetector = 0,
		ScrollDetector = 0
	}

	local createElement3 = React.createElement
	local v11 = {
		waitForProp = props.startRow,
		maxUpdatesToDelay = props.numUpdatesToDelayImpressions,
		wrappedComponent = 0
	}
	local createElement4 = React.createElement
	local v12

	if FFlagLuaAppUseFrameBoundsImpressions or props.shouldUseFrameBoundsForImpressions then
		v12 = FrameBoundsImpressionsTracker
	else
		v12 = ScreenSizeImpressionsTracker
	end

	local v13 = {
		parentRef = ref2,
		pageContext = sduiContext.routeName or sduiContext.appPage,
		impressionsTag = impressionsTag,
		scrollViewPositionChangedSignal = scrollViewPositionChangedSignal2,
		sendImpressions = sendImpressions,
		dataUpdatedTimestamp = props.sduiContext.dataUpdatedTimestamp,
		respectClipAncestors = 0
	}
	local respectClipAncestors

	if FFlagLuaAppRespectClipAncestorImpressions then
		respectClipAncestors = props.respectClipAncestors
	end

	v13.respectClipAncestors = respectClipAncestors
	v11.wrappedComponent = createElement4(v12, v13)
	children.ImpressionDetector = createElement3(WaitForPropWrapper, v11)

	children.ScrollDetector = React.createElement(ScrollDetector, {
		scrollingFrameRef = ref2,
		sendScrollEvent = sendScrollEvent
	})
	return createElement(fragment, nil, children)
end

return React.memo(SduiVariableItemWidthCarousel)
