local fFlagSduiErrorPaths = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSduiErrorPaths

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/AppCommonLib")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SignalsReact")
local CollectionViews = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/CollectionViews")
local useCollectionImpressionsSignal = CollectionViews.useCollectionImpressionsSignal
local useCollectionLayoutParams = CollectionViews.useCollectionLayoutParams
local variableItemWidthCarousel = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/VariableItemWidthCarousel").VariableItemWidthCarousel
local waitForPropWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/GameCollections").WaitForPropWrapper
local Impressions = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Impressions")
local frameBoundsImpressionsTracker = Impressions.FrameBoundsImpressionsTracker
local screenSizeImpressionsTracker = Impressions.ScreenSizeImpressionsTracker
local scrollDetector = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ScrollTelemetry").ScrollDetector
local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Foundation").Hooks.useTokens

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local findAnalyticsField = SduiCoreSystem.findAnalyticsField
local getSduiComponentWrapper = SduiCoreSystem.getSduiComponentWrapper
local reportUnifiedLoggingImpressions = SduiCoreSystem.reportUnifiedLoggingImpressions
local sduiBuilder = SduiCoreSystem.SduiBuilder
local sduiCollectionAnalyticsBuilder = SduiCoreSystem.SduiCollectionAnalyticsBuilder
local sduiComponentType = SduiCoreSystem.SduiComponentType
local sduiErrors = SduiCoreSystem.SduiErrors
local sduiParseHelpers = SduiCoreSystem.SduiParseHelpers

local SduiCollectionItem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/Collections/SduiCollectionItem")
local getImpressionsTag = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Analytics/getImpressionsTag")
local useCollectionAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiSharedContent").useCollectionAnalyticsContext
local useScrollTelemetryCallback = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Analytics/useScrollTelemetryCallback")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags")
local fFlagLuaAppCompositionAlways = SharedFlags.FFlagLuaAppCompositionAlways
local fFlagLuaAppLayoutParamsInContext = SharedFlags.FFlagLuaAppLayoutParamsInContext
local fFlagLuaAppRespectClipAncestorImpressions = SharedFlags.FFlagLuaAppRespectClipAncestorImpressions
local fFlagLuaAppUseFrameBoundsImpressions = SharedFlags.FFlagLuaAppUseFrameBoundsImpressions
local fFlagSduiOptionSelectorHeaderComponent = SharedFlags.FFlagSduiOptionSelectorHeaderComponent
local fFlagSduiOptionSelectorAnchorTag = SharedFlags.FFlagSduiOptionSelectorAnchorTag

local v5 = {}

local function SduiVariableItemWidthCarousel(props)
	local sduiContext = props.sduiContext

	local v6 = fFlagLuaAppCompositionAlways
		or props.appCompositionEnabled
		or sduiContext.appCompositionEnabled

	local items = props.items or v5
	local count = #items

	local v7 = useTokens()
	local itemHeight = props.itemHeight or v7.Size.Size_800
	local itemPadding = props.itemPadding or v7.Padding.XSmall

	local state, setState = React.useState(nil)

	local v8 = { sideMargin = props.pageSideMargin }
	local v9

	if not fFlagLuaAppCompositionAlways then
		if fFlagLuaAppLayoutParamsInContext then
			local v10 = React.useCallback(function(p2)
				return sduiContext.getPageLayoutConfig("Small")(p2)
			end, { sduiContext.getPageLayoutConfig })
			v9 = SignalsReact.useSignalState(v10)
		else
			v9 = useCollectionLayoutParams("Small", state, false, v8)
		end
	end

	local v10 = if props.sideMargin == nil then v6 and 0 or v9.sideMargin else props.sideMargin

	local v11 = findAnalyticsField("componentType", props.analyticsContext.analyticsData or v5)
		or sduiBuilder.getComponentType(props.componentConfig, sduiContext)
		or sduiComponentType.VariableItemWidthCarousel

	local v12, v13 = useCollectionAnalyticsContext(
		props.analyticsContext,
		v11,
		count,
		count,
		sduiContext,
		props.startRow,
		props.componentConfig.__isClientBinding
	)

	local ref = React.useRef({})
	local state2, setState2 = React.useState({})
	local ref2 = React.useRef(nil)

	local v14, v15 = useCollectionImpressionsSignal(props.scrollViewPositionChangedSignal)

	local v16 = getImpressionsTag(props.index, v13.current, sduiContext, props.debugName)

	local v17 = React.useCallback(function(p2, p3)
		local x = p3.AbsoluteSize.X

		if x <= 0 then
			return
		end

		setState2(function(p4)
			if p4[p2] == x then
				return p4
			end

			local clone = table.clone(p4)
			clone[p2] = x
			return clone
		end)
	end, {})

	local v18 = React.useCallback(function(p2)
		return state2[p2] or 0
	end, { state2 })

	local v19 = React.useCallback(function(list)
		if count ~= 0 then
			reportUnifiedLoggingImpressions(
				sduiContext,
				list,
				ref.current,
				v13.current,
				props.startRow,
				props.impressionEventName,
				props.skipItemImpressionsLog
			)
		elseif list and #list > 0 then
			local v20 = if v12 then sduiParseHelpers.stringifyValue(v12.analyticsData) else nil

			sduiContext.dependencies.logger.reportError(
				sduiErrors.SduiErrorType.FailedToLogImpressions,
				{
					componentType = "VariableItemWidthCarousel",
					name = v16,
					message = `Failed to log impressions. No configs. indexes: {table.concat(list, ",")} analytics: {v20}`
				},
				sduiContext.appPage
			)
		end
	end, {
		count,
		sduiContext,
		ref,
		v13,
		props.startRow,
		props.impressionEventName,
		props.skipItemImpressionsLog,
		v12,
		v16
	})

	local v20 = useScrollTelemetryCallback(ref2, v13, sduiContext)

	local useCallback = React.useCallback
	local function fn(props2, p2)
		if not props2 then
			sduiContext.dependencies.logger.reportError(
				sduiErrors.SduiErrorType.NilItem,
				{
					componentType = "VariableItemWidthCarousel",
					name = v16,
					message = `Nil item in VariableItemWidthCarousel.renderItem at index {p2}`
				},
				sduiContext.appPage
			)
			return React.createElement(React.Fragment)
		end

		local v21 = findAnalyticsField("componentType", props2.analyticsData or v5)
			or sduiBuilder.getComponentType(props2, sduiContext)

		if not v21 then
			sduiContext.dependencies.logger.reportError(
				sduiErrors.SduiErrorType.NilComponentType,
				{
					componentType = "VariableItemWidthCarousel",
					name = v16,
					message = `Nil componentType in VariableItemWidthCarousel.renderItem at index {p2}`
				},
				sduiContext.appPage
			)
			return React.createElement(React.Fragment)
		end

		local v22 = { itemPosition = p2, itemComponentType = v21, componentType = v21 }

		local current = ref.current
		local buildAndValidateItemAnalyticsData = sduiCollectionAnalyticsBuilder.buildAndValidateItemAnalyticsData

		local analyticsData = props2.analyticsData

		local v26 = if fFlagSduiErrorPaths then props2.errorContext else nil
		current[p2] = buildAndValidateItemAnalyticsData(sduiContext, analyticsData, nil, v22, v21, nil, v26)

		local sduiComponentWrapper = getSduiComponentWrapper(props2)
		local createElement = React.createElement
		local v27 = {
			componentConfig = props2,
			sduiContext = sduiContext,
			parentAnalyticsContext = 0,
			extraLocalProps = 0,
			debugName = 0,
			localAnalyticsData = 0
		}

		local v28 = if not props2.__isClientBinding then v12 else nil
		v27.parentAnalyticsContext = v28
		local v29 = {
			index = p2,
			scrollViewPositionChangedSignal = props.scrollViewPositionChangedSignal,
			verticalScrollingFrameRef = props.verticalScrollingFrameRef,
			selectionOrder = 0
		}
		local v30 = if props.selectionOrderBase then props.selectionOrderBase + p2 else nil
		v29.selectionOrder = v30
		v27.extraLocalProps = v29

		v27.debugName = `{v21}_{p2}`
		v27.localAnalyticsData = v22
		local element = createElement(sduiComponentWrapper, v27)

		local createElement2 = React.createElement
		local v32 = {
			index = p2,
			impressionsTag = v16,
			automaticSize = Enum.AutomaticSize.X,
			size = UDim2.new(0, 0, 0, itemHeight),
			onItemSizeChanged = v17,
			tag = 0
		}

		local v33 = if fFlagSduiOptionSelectorAnchorTag and props.itemTags then props.itemTags[p2] else nil
		v32.tag = v33
		return createElement2(SduiCollectionItem, v32, { Item = element })
	end

	local scrollViewPositionChangedSignal = props.scrollViewPositionChangedSignal
	local verticalScrollingFrameRef = props.verticalScrollingFrameRef
	local selectionOrderBase = props.selectionOrderBase
	local v22 = if fFlagSduiOptionSelectorAnchorTag then props.itemTags else nil
	local v23 = useCallback(fn, {
		sduiContext,
		v12,
		v16,
		itemHeight,
		v17,
		scrollViewPositionChangedSignal,
		verticalScrollingFrameRef,
		selectionOrderBase,
		v22
	})

	local createElement = React.createElement
	local fragment = React.Fragment
	local createElement2 = React.createElement
	local v26 = {
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
	local v27 = if fFlagSduiOptionSelectorHeaderComponent then props.headerComponent else nil
	v26.headerComponent = v27
	v26.calculateItemWidth = v18
	v26.scrollButtonsEnabled = props.scrollButtonsEnabled
	v26.scrollSpeed = props.scrollSpeed
	v26.items = items
	v26.itemHeight = itemHeight
	v26.itemPadding = itemPadding
	v26.onCanvasPositionChanged = v15
	v26.renderItem = v23
	v26.scrollingFrameRef = ref2
	v26.sideMargin = v10
	local children = {
		Carousel = createElement2(variableItemWidthCarousel, v26),
		ImpressionDetector = 0,
		ScrollDetector = 0
	}

	local createElement3 = React.createElement
	local v29 = {
		waitForProp = props.startRow,
		maxUpdatesToDelay = props.numUpdatesToDelayImpressions,
		wrappedComponent = 0
	}
	local createElement4 = React.createElement
	local v30

	if fFlagLuaAppUseFrameBoundsImpressions or props.shouldUseFrameBoundsForImpressions then
		v30 = frameBoundsImpressionsTracker
	else
		v30 = screenSizeImpressionsTracker
	end

	local v31 = {
		parentRef = ref2,
		pageContext = sduiContext.routeName or sduiContext.appPage,
		impressionsTag = v16,
		scrollViewPositionChangedSignal = v14,
		sendImpressions = v19,
		dataUpdatedTimestamp = props.sduiContext.dataUpdatedTimestamp,
		respectClipAncestors = 0
	}

	local v32 = if fFlagLuaAppRespectClipAncestorImpressions then props.respectClipAncestors else nil
	v31.respectClipAncestors = v32
	v29.wrappedComponent = createElement4(v30, v31)
	children.ImpressionDetector = createElement3(waitForPropWrapper, v29)

	children.ScrollDetector = React.createElement(scrollDetector, {
		scrollingFrameRef = ref2,
		sendScrollEvent = v20
	})
	return createElement(fragment, nil, children)
end

return React.memo(SduiVariableItemWidthCarousel)
