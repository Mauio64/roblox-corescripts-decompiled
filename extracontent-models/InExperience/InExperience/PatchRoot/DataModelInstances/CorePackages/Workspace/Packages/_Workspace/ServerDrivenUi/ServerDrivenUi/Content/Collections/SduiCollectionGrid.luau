local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local parent = ServerDrivenUi.Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiErrorPaths = SharedFlags.FFlagSduiErrorPaths

local React = require(parent.React)
require(parent.AppCommonLib)
local Cryo = require(parent.Cryo)
local SignalsReact = require(parent.SignalsReact)
local CollectionViews = require(parent.CollectionViews)
local CollectionGrid = CollectionViews.CollectionGrid
local CollectionItemSize = CollectionViews.CollectionViewTypes.CollectionItemSize
local useCollectionImpressionsSignal = CollectionViews.useCollectionImpressionsSignal
local useCollectionLayout = CollectionViews.useCollectionLayout
local useCollectionLayoutParams = CollectionViews.useCollectionLayoutParams
local GameCollections = require(parent.GameCollections)
local WaitForPropWrapper = GameCollections.WaitForPropWrapper
local Impressions = require(parent.Impressions)
local FrameBoundsImpressionsTracker = Impressions.FrameBoundsImpressionsTracker
local ScreenSizeImpressionsTracker = Impressions.ScreenSizeImpressionsTracker
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local usePreferredTextSizeLineBudget = SduiSharedUtilities.usePreferredTextSizeLineBudget

local SduiCoreSystem = require(parent.SduiCoreSystem)
local findAnalyticsField = SduiCoreSystem.findAnalyticsField
local getImpressionsTag = require(ServerDrivenUi.Analytics.getImpressionsTag)
local sendLegacyGameImpressionsForSdui = require(ServerDrivenUi.Analytics.sendLegacyGameImpressionsForSdui)
local reportUnifiedLoggingImpressions = SduiCoreSystem.reportUnifiedLoggingImpressions
local SduiBuilder = SduiCoreSystem.SduiBuilder
local SduiCollectionAnalyticsBuilder = SduiCoreSystem.SduiCollectionAnalyticsBuilder
local SduiErrors = SduiCoreSystem.SduiErrors
local SduiParseHelpers = SduiCoreSystem.SduiParseHelpers
local getSduiComponentWrapper = SduiCoreSystem.getSduiComponentWrapper

local SduiCollectionItem = require(ServerDrivenUi.Content.Collections.SduiCollectionItem)
local SduiCollectionGridRevealRows = require(ServerDrivenUi.Content.Collections.SduiCollectionGridRevealRows)
local SduiSharedContent = require(parent.SduiSharedContent)
local useCollectionAnalyticsContext = SduiSharedContent.useCollectionAnalyticsContext

local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppLayoutParamsInContext = SharedFlags2.FFlagLuaAppLayoutParamsInContext
local SharedFlags3 = require(parent.SharedFlags)
local FFlagLuaAppCompositionAlways = SharedFlags3.FFlagLuaAppCompositionAlways
local SharedFlags4 = require(parent.SharedFlags)
local FFlagSduiFixSearchTelemetry = SharedFlags4.FFlagSduiFixSearchTelemetry
local SharedFlags5 = require(parent.SharedFlags)
local FFlagSduiPreferredTextSizeLineBudgets = SharedFlags5.FFlagSduiPreferredTextSizeLineBudgets
local SharedFlags6 = require(parent.SharedFlags)
local FFlagSduiCollectionGridRevealRows = SharedFlags6.FFlagSduiCollectionGridRevealRows

local function cellSizeFromSpan(spanOverride, p: number, p2: number) -- 1 equivalent call inferred from this helper
	local colSpan = spanOverride.colSpan or 1
	local rowSpan = spanOverride.rowSpan or 1
	return UDim2.new(colSpan, p * (colSpan - 1), rowSpan, p2 * (rowSpan - 1))
end

local v = {}

local function SduiCollectionGrid(props)
	local v2 = FFlagLuaAppCompositionAlways or props.appCompositionEnabled or props.sduiContext.appCompositionEnabled

	local layoutOrder = props.layoutOrder
	local sduiContext = props.sduiContext

	local items = React.useMemo(function()
		if props.items == nil then
			return v
		end

		for _, item in props.items do
			if props.itemTemplateKey and item.templateKey == nil then
				item.templateKey = props.itemTemplateKey
			end
		end

		return props.items
	end, { props.items, props.itemTemplateKey })

	local state, setState = React.useState(nil)
	local ref = React.useRef(nil)
	ref.current = state
	local v3

	if not FFlagLuaAppCompositionAlways then
		if FFlagLuaAppLayoutParamsInContext then
			local v4 = React.useCallback(function(p)
				return sduiContext.getPageLayoutConfig(props.collectionItemSize)(p)
			end, { props.collectionItemSize, sduiContext.getPageLayoutConfig })
			v3 = SignalsReact.useSignalState(v4)
		else
			local collectionItemSize = props.collectionItemSize or CollectionItemSize.Small
			local v4

			if props.layoutOverrides then
				v4 = Cryo.Dictionary.join(props.layoutOverrides, {
					overrideLoadMoreThreshold = 1e999,
					sideMargin = props.pageSideMargin
				})
			else
				v4 = { overrideLoadMoreThreshold = 1e999, sideMargin = props.pageSideMargin }
			end

			v3 = useCollectionLayoutParams(collectionItemSize, state, false, v4)
		end
	end

	local count = 0

	if items then
		for _, v4 in items do
			if not v4.isBlank then
				count += 1
			end
		end
	end

	local v4 = useCollectionLayout(props.collectionItemSize)
	local itemsPerRow = v4.itemsPerRow

	if not v2 then
		itemsPerRow = v3.numColumns
	end

	local v5

	if v2 then
		v5 = v4.gutter
	else
		v5 = v3 and v3.columnGap or 0
	end

	local v6

	if v2 then
		v6 = v4.verticalGap
	else
		v6 = v3 and v3.verticalPadding or 0
	end

	local v7 = findAnalyticsField("componentType", props.analyticsContext.analyticsData or v)
		or SduiBuilder.getComponentType(props.componentConfig, sduiContext)

	local parentAnalyticsContext, v8 = useCollectionAnalyticsContext(
		props.analyticsContext,
		v7,
		itemsPerRow,
		count,
		sduiContext,
		props.startRow,
		props.componentConfig.__isClientBinding
	)

	local ref2 = React.useRef({})

	local scrollViewPositionChangedSignal, v9 = useCollectionImpressionsSignal(props.scrollViewPositionChangedSignal)

	local onViewableItemsChanged = React.useCallback(function(_: number, _: number)
		if props.onCollectionViewabilityChanged then
			props.onCollectionViewabilityChanged()
		end

		if v9 then
			v9()
		end
	end, { v9, props.onCollectionViewabilityChanged })

	local impressionsTag = props.impressionsTag
		or getImpressionsTag(props.index, v8.current, sduiContext, props.debugName)

	local sendImpressions = React.useCallback(function(list)
		if items == nil or #items == 0 then
			if list and #list > 0 then
				local v10

				if parentAnalyticsContext then
					v10 = SduiParseHelpers.stringifyValue(parentAnalyticsContext.analyticsData)
				end

				sduiContext.dependencies.logger.reportError(
					SduiErrors.SduiErrorType.FailedToLogImpressions,
					{
						componentType = "CollectionGrid",
						name = impressionsTag,
						message = `Failed to log impressions. No configs. indexes: {table.concat(list, ",")} analytics: {v10}`
					},
					sduiContext.appPage
				)
			end
		else
			assert(items, "itemConfigs must exist")

			if
				(props.impressionEventName or not v8.current or v8.current.contentType ~= "Game")
				and not props.sendGameImpressions
			then
				reportUnifiedLoggingImpressions(
					sduiContext,
					list,
					ref2.current,
					v8.current,
					props.startRow,
					props.impressionEventName,
					props.skipItemImpressionsLog,
					impressionsTag
				)
				return
			end

			if v8.current and v8.current.contentType == "Game" then
				sendLegacyGameImpressionsForSdui(
					list,
					ref2.current,
					items,
					parentAnalyticsContext,
					v8.current,
					props.startRow,
					sduiContext,
					props.sendGameImpressions,
					v8.current.itemsPerRow,
					impressionsTag
				)
			end

			reportUnifiedLoggingImpressions(sduiContext, list, ref2.current, v8.current)
		end
	end, {
		items,
		props.startRow,
		sduiContext,
		v8,
		ref2,
		parentAnalyticsContext,
		props.sendGameImpressions,
		impressionsTag,
		props.impressionEventName,
		props.skipItemImpressionsLog
	})

	React.useLayoutEffect(function()
		if props.setLogImpressions then
			props.setLogImpressions(sendImpressions)
		end
	end, { sendImpressions, props.setLogImpressions })

	local scale = useTokens().Config.UI.Scale
	local v10

	if FFlagSduiPreferredTextSizeLineBudgets then
		v10 = usePreferredTextSizeLineBudget(props.preferredTextSizeLineCount)
	else
		v10 = nil
	end

	local useCallback = React.useCallback
	local function fn(p: number)
		return p * props.itemHeightFromWidth.Scale + props.itemHeightFromWidth.Offset * scale + (v10 or 0)
	end

	local itemHeightFromWidth = props.itemHeightFromWidth
	local v11

	if FFlagSduiPreferredTextSizeLineBudgets then
		v11 = v10
	end

	local getItemHeight = useCallback(fn, { itemHeightFromWidth, scale, v11 })

	local renderItem = React.useCallback(function(props2, p: number, size, _: number?)
		if props2 and props2.isBlank then
			return React.createElement("Frame", { BackgroundTransparency = 1, LayoutOrder = p }), "blank"
		end

		if not props2 then
			sduiContext.dependencies.logger.reportError(
				SduiErrors.SduiErrorType.NilItem,
				{
					componentType = "CollectionGrid",
					name = impressionsTag,
					message = `Nil item in SduiCollectionGrid.renderItem at index {p}`
				},
				sduiContext.appPage
			)
			return React.createElement(React.Fragment), "nil"
		end

		local v12 = findAnalyticsField("componentType", props2.analyticsData or v)
			or SduiBuilder.getComponentType(props2, sduiContext)

		if not v12 then
			sduiContext.dependencies.logger.reportError(
				SduiErrors.SduiErrorType.NilComponentType,
				{
					componentType = "CollectionGrid",
					name = impressionsTag,
					message = `Nil componentType in CollectionGrid.renderItem at index {p}`
				},
				sduiContext.appPage
			)
			return React.createElement(React.Fragment), "nil"
		end

		local localAnalyticsData = {
			itemPosition = p,
			itemComponentType = v12,
			componentType = v12,
			topicContentsIndex = props2.realIndex,
			topicDataPosition = 0
		}
		local topicDataPosition

		if FFlagSduiFixSearchTelemetry then
			topicDataPosition = props2.realIndex
		end

		localAnalyticsData.topicDataPosition = topicDataPosition

		local current = ref2.current
		local buildAndValidateItemAnalyticsData = SduiCollectionAnalyticsBuilder.buildAndValidateItemAnalyticsData

		local analyticsData = props2.analyticsData
		local v13

		if FFlagSduiErrorPaths then
			v13 = props2.errorContext
		end

		current[p] = buildAndValidateItemAnalyticsData(
			sduiContext,
			analyticsData,
			nil,
			localAnalyticsData,
			v12,
			nil,
			v13
		)

		local sduiComponentWrapper = getSduiComponentWrapper(props2)
		local createElement = React.createElement
		local v14 = {
			componentConfig = props2,
			sduiContext = sduiContext,
			parentAnalyticsContext = 0,
			extraLocalProps = 0,
			debugName = 0,
			localAnalyticsData = 0
		}
		local parentAnalyticsContext2

		if not props2.__isClientBinding then
			parentAnalyticsContext2 = parentAnalyticsContext
		end

		v14.parentAnalyticsContext = parentAnalyticsContext2
		local extraLocalProps = {
			scrollViewPositionChangedSignal = props.scrollViewPositionChangedSignal,
			verticalScrollingFrameRef = props.verticalScrollingFrameRef,
			index = p,
			selectionOrder = 0,
			alignmentType = 0,
			cellVerticalPadding = 0
		}
		local selectionOrder

		if not (props.disableSelectionOrder or not props.selectionOrderBase) then
			selectionOrder = props.selectionOrderBase + p
		end

		extraLocalProps.selectionOrder = selectionOrder
		local alignmentType

		if props2.spanOverride ~= nil then
			alignmentType = props2.spanOverride.alignmentType
		end

		extraLocalProps.alignmentType = alignmentType
		local cellVerticalPadding

		if props2.spanOverride ~= nil then
			cellVerticalPadding = v6
		end

		extraLocalProps.cellVerticalPadding = cellVerticalPadding
		v14.extraLocalProps = extraLocalProps

		v14.debugName = `{v12}_{p}`
		v14.localAnalyticsData = localAnalyticsData
		local element = createElement(sduiComponentWrapper, v14)

		local createElement2 = React.createElement
		local v15 = {
			index = p,
			impressionsTag = impressionsTag,
			size = size,
			zIndex = -p,
			innerWrapperSize = 0
		}
		local innerWrapperSize

		if props2.spanOverride ~= nil then
			innerWrapperSize = cellSizeFromSpan(props2.spanOverride, v5, v6) -- inferred equivalent call
		end

		v15.innerWrapperSize = innerWrapperSize
		return createElement2(SduiCollectionItem, v15, { Item = element }), v12 or "unknown"
	end, {
		sduiContext,
		props.analyticsContext,
		props.scrollViewPositionChangedSignal,
		props.verticalScrollingFrameRef,
		parentAnalyticsContext,
		impressionsTag,
		props.index,
		props.disableSelectionOrder,
		props.selectionOrderBase,
		v5,
		v6
	})

	local v12 = React.useMemo(function()
		local result

		if props.children then
			result = {}

			for k, child in props.children do
				result[k] = React.cloneElement(child, {
					parentAnalyticsContext = parentAnalyticsContext
				})
			end
		end

		return result
	end, { parentAnalyticsContext, props.children })

	local headerComponent = React.useMemo(function()
		if props.headerComponent then
			return React.cloneElement(props.headerComponent, {
				parentAnalyticsContext = parentAnalyticsContext
			})
		end

		return nil
	end, { parentAnalyticsContext, props.headerComponent })

	local focusNavActions = React.useMemo(function()
		if props.focusNavActionsComponent then
			return React.cloneElement(props.focusNavActionsComponent, {
				parentAnalyticsContext = parentAnalyticsContext,
				extraLocalProps = { guiObject = state }
			})
		end

		return nil
	end, { parentAnalyticsContext, props.focusNavActionsComponent, state })
	local collectionItemSize

	if v2 then
		collectionItemSize = props.collectionItemSize
	end

	local gridProps = {
		collectionItemSize = collectionItemSize,
		verticalScrollingFrameRef = props.verticalScrollingFrameRef,
		containerRef = setState,
		getItemHeight = getItemHeight,
		items = items,
		renderItem = renderItem,
		numColumns = 0,
		columnGap = 0,
		sideMargin = 0,
		onViewableItemsChanged = 0,
		LayoutOrder = 0,
		verticalPadding = 0,
		disableRelativeGap = true,
		headerComponent = 0,
		testId = 0,
		onReachedThresholdFromEnd = 0,
		thresholdRowsFromBottom = 0,
		maxNumRows = 0
	}
	local numColumns

	if not v2 then
		numColumns = v3.numColumns
	end

	gridProps.numColumns = numColumns
	local columnGap

	if not v2 then
		columnGap = v3.columnGap
	end

	gridProps.columnGap = columnGap
	local sideMargin

	if not v2 then
		sideMargin = v3.sideMargin
	end

	gridProps.sideMargin = sideMargin
	gridProps.onViewableItemsChanged = onViewableItemsChanged
	gridProps.LayoutOrder = layoutOrder
	local verticalPadding

	if not v2 then
		verticalPadding = v3.verticalPadding
	end

	gridProps.verticalPadding = verticalPadding

	gridProps.headerComponent = headerComponent
	gridProps.testId = not props.testId and "--sdui-collection-grid" or props.testId
	gridProps.onReachedThresholdFromEnd = props.onReachedThresholdFromEnd
	gridProps.thresholdRowsFromBottom = props.thresholdRowsFromBottom
	gridProps.maxNumRows = props.maxNumRows

	local createElement = React.createElement
	local fragment = React.Fragment

	local join = Cryo.Dictionary.join
	local collectionGrid

	if
		FFlagSduiCollectionGridRevealRows
		and (props.initialFeedVisibleRows ~= nil or props.visibleRowsPerReveal ~= nil)
		and props.setDisplayedRowCount ~= nil
		and props.revealRowsComponent ~= nil
	then
		collectionGrid = React.createElement(SduiCollectionGridRevealRows, {
			gridProps = gridProps,
			sduiContext = props.sduiContext,
			analyticsContext = props.analyticsContext,
			itemCount = #items,
			itemsPerRow = itemsPerRow,
			maxNumRows = props.maxNumRows,
			initialFeedVisibleRows = props.initialFeedVisibleRows,
			visibleRowsPerReveal = props.visibleRowsPerReveal,
			startRow = props.startRow,
			setDisplayedRowCount = props.setDisplayedRowCount,
			revealRowsComponent = props.revealRowsComponent,
			containerFrame = state,
			setContainerFrame = setState
		})
	else
		collectionGrid = React.createElement(CollectionGrid, gridProps)
	end

	local impressionDetector

	if not props.disableImpressionsDetector then
		local createElement2 = React.createElement
		local v13 = {
			waitForProp = props.startRow,
			maxUpdatesToDelay = props.numUpdatesToDelayImpressions,
			wrappedComponent = 0
		}
		local wrappedComponent

		if props.shouldUseFrameBoundsForImpressions then
			wrappedComponent = React.createElement(FrameBoundsImpressionsTracker, {
				parentRef = ref,
				pageContext = sduiContext.routeName or sduiContext.appPage,
				impressionsTag = impressionsTag,
				scrollViewPositionChangedSignal = scrollViewPositionChangedSignal,
				sendImpressions = sendImpressions,
				dataUpdatedTimestamp = props.sduiContext.dataUpdatedTimestamp
			})
		else
			wrappedComponent = React.createElement(ScreenSizeImpressionsTracker, {
				parentRef = ref,
				pageContext = sduiContext.routeName or sduiContext.appPage,
				impressionsTag = impressionsTag,
				scrollViewPositionChangedSignal = scrollViewPositionChangedSignal,
				sendImpressions = sendImpressions,
				dataUpdatedTimestamp = props.sduiContext.dataUpdatedTimestamp
			})
		end

		v13.wrappedComponent = wrappedComponent
		impressionDetector = createElement2(WaitForPropWrapper, v13)
	end

	return createElement(
		fragment,
		nil,
		join(v12 or v, {
			CollectionGrid = collectionGrid,
			ImpressionDetector = impressionDetector,
			FocusNavActions = focusNavActions
		})
	)
end

return React.memo(SduiCollectionGrid)
