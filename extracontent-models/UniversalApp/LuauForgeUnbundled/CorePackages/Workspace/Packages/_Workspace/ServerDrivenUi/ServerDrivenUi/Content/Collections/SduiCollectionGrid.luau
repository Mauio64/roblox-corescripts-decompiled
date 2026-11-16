local fFlagSduiErrorPaths = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSduiErrorPaths

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/AppCommonLib")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Cryo")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SignalsReact")
local CollectionViews = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/CollectionViews")
local collectionGrid = CollectionViews.CollectionGrid
local collectionItemSize = CollectionViews.CollectionViewTypes.CollectionItemSize
local useCollectionImpressionsSignal = CollectionViews.useCollectionImpressionsSignal
local useCollectionLayout = CollectionViews.useCollectionLayout
local useCollectionLayoutParams = CollectionViews.useCollectionLayoutParams
local waitForPropWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/GameCollections").WaitForPropWrapper
local Impressions = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Impressions")
local frameBoundsImpressionsTracker = Impressions.FrameBoundsImpressionsTracker
local screenSizeImpressionsTracker = Impressions.ScreenSizeImpressionsTracker
local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Foundation").Hooks.useTokens
local usePreferredTextSizeLineBudget = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiSharedUtilities").usePreferredTextSizeLineBudget

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local findAnalyticsField = SduiCoreSystem.findAnalyticsField
local getImpressionsTag = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Analytics/getImpressionsTag")
local sendLegacyGameImpressionsForSdui = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Analytics/sendLegacyGameImpressionsForSdui")
local reportUnifiedLoggingImpressions = SduiCoreSystem.reportUnifiedLoggingImpressions
local sduiBuilder = SduiCoreSystem.SduiBuilder
local sduiCollectionAnalyticsBuilder = SduiCoreSystem.SduiCollectionAnalyticsBuilder
local sduiErrors = SduiCoreSystem.SduiErrors
local sduiParseHelpers = SduiCoreSystem.SduiParseHelpers
local getSduiComponentWrapper = SduiCoreSystem.getSduiComponentWrapper

local SduiCollectionItem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/Collections/SduiCollectionItem")
local SduiCollectionGridRevealRows = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/Collections/SduiCollectionGridRevealRows")
local useCollectionAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiSharedContent").useCollectionAnalyticsContext

local fFlagLuaAppLayoutParamsInContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppLayoutParamsInContext
local fFlagLuaAppCompositionAlways = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppCompositionAlways
local fFlagSduiFixSearchTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSduiFixSearchTelemetry
local fFlagSduiPreferredTextSizeLineBudgets = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSduiPreferredTextSizeLineBudgets
local fFlagSduiCollectionGridRevealRows = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSduiCollectionGridRevealRows

local function cellSizeFromSpan(p2, p3, p4)
	local colSpan = p2.colSpan or 1
	local rowSpan = p2.rowSpan or 1
	return UDim2.new(colSpan, p3 * (colSpan - 1), rowSpan, p4 * (rowSpan - 1))
end

local v5 = {}

local function SduiCollectionGrid(props)
	local v6 = fFlagLuaAppCompositionAlways
		or props.appCompositionEnabled
		or props.sduiContext.appCompositionEnabled

	local layoutOrder = props.layoutOrder
	local sduiContext = props.sduiContext

	local v7 = React.useMemo(function()
		if props.items == nil then
			return v5
		end

		for k, item in props.items do
			if props.itemTemplateKey and item.templateKey == nil then
				item.templateKey = props.itemTemplateKey
			end
		end

		return props.items
	end, { props.items, props.itemTemplateKey })

	local state, setState = React.useState(nil)
	local ref = React.useRef(nil)
	ref.current = state
	local v8

	if not fFlagLuaAppCompositionAlways then
		if fFlagLuaAppLayoutParamsInContext then
			local v9 = React.useCallback(function(p2)
				return sduiContext.getPageLayoutConfig(props.collectionItemSize)(p2)
			end, { props.collectionItemSize, sduiContext.getPageLayoutConfig })
			v8 = SignalsReact.useSignalState(v9)
		else
			local collectionItemSize2 = props.collectionItemSize or collectionItemSize.Small
			local v11

			if props.layoutOverrides then
				v11 = Cryo.Dictionary.join(props.layoutOverrides, {
					overrideLoadMoreThreshold = 1e999,
					sideMargin = props.pageSideMargin
				})
			else
				v11 = {
					overrideLoadMoreThreshold = 1e999,
					sideMargin = props.pageSideMargin
				}
			end

			v8 = useCollectionLayoutParams(collectionItemSize2, state, false, v11)
		end
	end

	local count = 0

	if v7 then
		for k, v9 in v7 do
			if not v9.isBlank then
				count += 1
			end
		end
	end

	local v9 = useCollectionLayout(props.collectionItemSize)
	local v10 = v9.itemsPerRow

	if not v6 then
		v10 = v8.numColumns
	end

	local v11 = if v6 then v9.gutter else v8 and v8.columnGap or 0

	local v12 = if v6 then v9.verticalGap else v8 and v8.verticalPadding or 0

	local v13 = findAnalyticsField("componentType", props.analyticsContext.analyticsData or v5)
		or sduiBuilder.getComponentType(props.componentConfig, sduiContext)

	local v14, v15 = useCollectionAnalyticsContext(
		props.analyticsContext,
		v13,
		v10,
		count,
		sduiContext,
		props.startRow,
		props.componentConfig.__isClientBinding
	)

	local ref2 = React.useRef({})

	local v16, v17 = useCollectionImpressionsSignal(props.scrollViewPositionChangedSignal)

	local v18 = React.useCallback(function(p2, p3)
		if props.onCollectionViewabilityChanged then
			props.onCollectionViewabilityChanged()
		end

		if v17 then
			v17()
		end
	end, { v17, props.onCollectionViewabilityChanged })

	local impressionsTag = props.impressionsTag
		or getImpressionsTag(props.index, v15.current, sduiContext, props.debugName)

	local v19 = React.useCallback(function(list)
		if v7 == nil or #v7 == 0 then
			if list and #list > 0 then
				local v20 = if v14 then sduiParseHelpers.stringifyValue(v14.analyticsData) else nil

				sduiContext.dependencies.logger.reportError(
					sduiErrors.SduiErrorType.FailedToLogImpressions,
					{
						componentType = "CollectionGrid",
						name = impressionsTag,
						message = `Failed to log impressions. No configs. indexes: {table.concat(list, ",")} analytics: {v20}`
					},
					sduiContext.appPage
				)
			end
		else
			assert(v7, "itemConfigs must exist")

			if
				(props.impressionEventName or not v15.current or v15.current.contentType ~= "Game")
				and not props.sendGameImpressions
			then
				reportUnifiedLoggingImpressions(
					sduiContext,
					list,
					ref2.current,
					v15.current,
					props.startRow,
					props.impressionEventName,
					props.skipItemImpressionsLog,
					impressionsTag
				)
				return
			end

			if v15.current and v15.current.contentType == "Game" then
				sendLegacyGameImpressionsForSdui(
					list,
					ref2.current,
					v7,
					v14,
					v15.current,
					props.startRow,
					sduiContext,
					props.sendGameImpressions,
					v15.current.itemsPerRow,
					impressionsTag
				)
			end

			reportUnifiedLoggingImpressions(sduiContext, list, ref2.current, v15.current)
		end
	end, {
		v7,
		props.startRow,
		sduiContext,
		v15,
		ref2,
		v14,
		props.sendGameImpressions,
		impressionsTag,
		props.impressionEventName,
		props.skipItemImpressionsLog
	})

	React.useLayoutEffect(function()
		if props.setLogImpressions then
			props.setLogImpressions(v19)
		end
	end, { v19, props.setLogImpressions })

	local scale = useTokens().Config.UI.Scale
	local v20

	if fFlagSduiPreferredTextSizeLineBudgets then
		v20 = usePreferredTextSizeLineBudget(props.preferredTextSizeLineCount)
	else
		v20 = nil
	end

	local function fn(p2)
		return p2 * props.itemHeightFromWidth.Scale + props.itemHeightFromWidth.Offset * scale + (v20 or 0)
	end

	local v23 = React.useCallback(fn, {
		props.itemHeightFromWidth,
		scale,
		if fFlagSduiPreferredTextSizeLineBudgets then v20 else nil
	})

	local v24 = React.useCallback(function(props2, p2, p3, p4)
		if props2 and props2.isBlank then
			return React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = p2
			}), "blank"
		end

		if not props2 then
			sduiContext.dependencies.logger.reportError(
				sduiErrors.SduiErrorType.NilItem,
				{
					componentType = "CollectionGrid",
					name = impressionsTag,
					message = `Nil item in SduiCollectionGrid.renderItem at index {p2}`
				},
				sduiContext.appPage
			)
			return React.createElement(React.Fragment), "nil"
		end

		local v25 = findAnalyticsField("componentType", props2.analyticsData or v5)
			or sduiBuilder.getComponentType(props2, sduiContext)

		if not v25 then
			sduiContext.dependencies.logger.reportError(
				sduiErrors.SduiErrorType.NilComponentType,
				{
					componentType = "CollectionGrid",
					name = impressionsTag,
					message = `Nil componentType in CollectionGrid.renderItem at index {p2}`
				},
				sduiContext.appPage
			)
			return React.createElement(React.Fragment), "nil"
		end

		local v26 = {
			itemPosition = p2,
			itemComponentType = v25,
			componentType = v25,
			topicContentsIndex = props2.realIndex,
			topicDataPosition = 0
		}
		local v27 = if fFlagSduiFixSearchTelemetry then props2.realIndex else nil
		v26.topicDataPosition = v27

		local current = ref2.current
		local buildAndValidateItemAnalyticsData = sduiCollectionAnalyticsBuilder.buildAndValidateItemAnalyticsData

		local analyticsData = props2.analyticsData

		local v31 = if fFlagSduiErrorPaths then props2.errorContext else nil
		current[p2] = buildAndValidateItemAnalyticsData(sduiContext, analyticsData, nil, v26, v25, nil, v31)

		local sduiComponentWrapper = getSduiComponentWrapper(props2)
		local createElement = React.createElement
		local v32 = {
			componentConfig = props2,
			sduiContext = sduiContext,
			parentAnalyticsContext = 0,
			extraLocalProps = 0,
			debugName = 0,
			localAnalyticsData = 0
		}

		local v33 = if not props2.__isClientBinding then v14 else nil
		v32.parentAnalyticsContext = v33
		local v34 = {
			scrollViewPositionChangedSignal = props.scrollViewPositionChangedSignal,
			verticalScrollingFrameRef = props.verticalScrollingFrameRef,
			index = p2,
			selectionOrder = 0,
			alignmentType = 0,
			cellVerticalPadding = 0
		}

		local v35 = if not (props.disableSelectionOrder or not props.selectionOrderBase) then props.selectionOrderBase + p2 else nil
		v34.selectionOrder = v35

		local v36 = if props2.spanOverride ~= nil then props2.spanOverride.alignmentType else nil
		v34.alignmentType = v36
		local v37 = if props2.spanOverride ~= nil then v12 else nil
		v34.cellVerticalPadding = v37
		v32.extraLocalProps = v34

		v32.debugName = `{v25}_{p2}`
		v32.localAnalyticsData = v26
		local element = createElement(sduiComponentWrapper, v32)

		local createElement2 = React.createElement
		local v39 = {
			index = p2,
			impressionsTag = impressionsTag,
			size = p3,
			zIndex = -p2,
			innerWrapperSize = 0
		}
		local udim

		if props2.spanOverride ~= nil then
			local spanOverride = props2.spanOverride
			local colSpan = spanOverride.colSpan or 1
			local rowSpan = spanOverride.rowSpan or 1
			udim = UDim2.new(colSpan, v11 * (colSpan - 1), rowSpan, v12 * (rowSpan - 1))
		end

		v39.innerWrapperSize = udim
		return createElement2(SduiCollectionItem, v39, { Item = element }), v25 or "unknown"
	end, {
		sduiContext,
		props.analyticsContext,
		props.scrollViewPositionChangedSignal,
		props.verticalScrollingFrameRef,
		v14,
		impressionsTag,
		props.index,
		props.disableSelectionOrder,
		props.selectionOrderBase,
		v11,
		v12
	})

	local v25 = React.useMemo(function()
		local result

		if props.children then
			result = {}

			for k, child in props.children do
				result[k] = React.cloneElement(child, { parentAnalyticsContext = v14 })
			end
		end

		return result
	end, { v14, props.children })

	local v26 = React.useMemo(function()
		if props.headerComponent then
			return React.cloneElement(props.headerComponent, {
				parentAnalyticsContext = v14
			})
		end

		return nil
	end, { v14, props.headerComponent })

	local v27 = React.useMemo(function()
		if props.focusNavActionsComponent then
			return React.cloneElement(props.focusNavActionsComponent, {
				parentAnalyticsContext = v14,
				extraLocalProps = { guiObject = state }
			})
		end

		return nil
	end, { v14, props.focusNavActionsComponent, state })

	local v29 = if v6 then props.collectionItemSize else nil
	local v28 = {
		collectionItemSize = v29,
		verticalScrollingFrameRef = props.verticalScrollingFrameRef,
		containerRef = setState,
		getItemHeight = v23,
		items = v7,
		renderItem = v24,
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

	local v30 = if not v6 then v8.numColumns else nil
	v28.numColumns = v30
	local v31 = if not v6 then v8.columnGap else nil
	v28.columnGap = v31
	local v32 = if not v6 then v8.sideMargin else nil
	v28.sideMargin = v32
	v28.onViewableItemsChanged = v18
	v28.LayoutOrder = layoutOrder
	local v33 = if not v6 then v8.verticalPadding else nil
	v28.verticalPadding = v33

	v28.headerComponent = v26
	v28.testId = not props.testId and "--sdui-collection-grid" or props.testId
	v28.onReachedThresholdFromEnd = props.onReachedThresholdFromEnd
	v28.thresholdRowsFromBottom = props.thresholdRowsFromBottom
	v28.maxNumRows = props.maxNumRows

	local createElement = React.createElement
	local fragment = React.Fragment

	local join = Cryo.Dictionary.join
	local v37

	if
		fFlagSduiCollectionGridRevealRows
		and (props.initialFeedVisibleRows ~= nil or props.visibleRowsPerReveal ~= nil)
		and props.setDisplayedRowCount ~= nil
		and props.revealRowsComponent ~= nil
	then
		v37 = React.createElement(SduiCollectionGridRevealRows, {
			gridProps = v28,
			sduiContext = props.sduiContext,
			analyticsContext = props.analyticsContext,
			itemCount = #v7,
			itemsPerRow = v10,
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
		v37 = React.createElement(collectionGrid, v28)
	end

	local v38

	if not props.disableImpressionsDetector then
		local createElement2 = React.createElement
		local v40 = {
			waitForProp = props.startRow,
			maxUpdatesToDelay = props.numUpdatesToDelayImpressions,
			wrappedComponent = 0
		}
		local v41 = if props.shouldUseFrameBoundsForImpressions then React.createElement(frameBoundsImpressionsTracker, {
			parentRef = ref,
			pageContext = sduiContext.routeName or sduiContext.appPage,
			impressionsTag = impressionsTag,
			scrollViewPositionChangedSignal = v16,
			sendImpressions = v19,
			dataUpdatedTimestamp = props.sduiContext.dataUpdatedTimestamp
		}) else React.createElement(screenSizeImpressionsTracker, {
			parentRef = ref,
			pageContext = sduiContext.routeName or sduiContext.appPage,
			impressionsTag = impressionsTag,
			scrollViewPositionChangedSignal = v16,
			sendImpressions = v19,
			dataUpdatedTimestamp = props.sduiContext.dataUpdatedTimestamp
		})
		v40.wrappedComponent = v41
		v38 = createElement2(waitForPropWrapper, v40)
	end

	return createElement(
		fragment,
		nil,
		join(v25 or v5, {
			CollectionGrid = v37,
			ImpressionDetector = v38,
			FocusNavActions = v27
		})
	)
end

return React.memo(SduiCollectionGrid)
