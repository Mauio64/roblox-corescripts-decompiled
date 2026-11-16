local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local parent = ServerDrivenUi.Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiErrorPaths = SharedFlags.FFlagSduiErrorPaths

local React = require(parent.React)
require(parent.AppCommonLib)
local Cryo = require(parent.Cryo)
local SignalsReact = require(parent.SignalsReact)
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local usePreferredTextSizeLineBudget = SduiSharedUtilities.usePreferredTextSizeLineBudget
local CollectionViews = require(parent.CollectionViews)
local CollectionCarousel = CollectionViews.CollectionCarousel
local CollectionItemSize = CollectionViews.CollectionViewTypes.CollectionItemSize
local useCollectionImpressionsSignal = CollectionViews.useCollectionImpressionsSignal
local useCollectionLayoutParams = CollectionViews.useCollectionLayoutParams
local GameCollections = require(parent.GameCollections)
local WaitForPropWrapper = GameCollections.WaitForPropWrapper
local Impressions = require(parent.Impressions)
local FrameBoundsImpressionsTracker = Impressions.FrameBoundsImpressionsTracker
local ScreenSizeImpressionsTracker = Impressions.ScreenSizeImpressionsTracker
local GameTile = require(parent.GameTile)
local HoverTileCoordinator = GameTile.HoverTileCoordinator
local ScrollTelemetry = require(parent.ScrollTelemetry)
local ScrollDetector = ScrollTelemetry.ScrollDetector
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
require(parent.VideoUtils)

local SduiCoreSystem = require(parent.SduiCoreSystem)
local findAnalyticsField = SduiCoreSystem.findAnalyticsField
local getImpressionsTag = require(ServerDrivenUi.Analytics.getImpressionsTag)
local sendLegacyGameImpressionsForSdui = require(ServerDrivenUi.Analytics.sendLegacyGameImpressionsForSdui)
local reportUnifiedLoggingImpressions = SduiCoreSystem.reportUnifiedLoggingImpressions
local SduiBuilder = SduiCoreSystem.SduiBuilder
local SduiCollectionAnalyticsBuilder = SduiCoreSystem.SduiCollectionAnalyticsBuilder
local SduiErrors = SduiCoreSystem.SduiErrors
local addSduiErrorContextFields = SduiCoreSystem.addSduiErrorContextFields
local SduiCollectionItem = require(ServerDrivenUi.Content.Collections.SduiCollectionItem)
local SduiParseHelpers = SduiCoreSystem.SduiParseHelpers
local getSduiComponentWrapper = SduiCoreSystem.getSduiComponentWrapper

local SduiSharedContent = require(parent.SduiSharedContent)
local useCollectionAnalyticsContext = SduiSharedContent.useCollectionAnalyticsContext
local SduiSharedContent2 = require(parent.SduiSharedContent)
local SduiFeedContext = SduiSharedContent2.SduiFeedContext
local useScrollTelemetryCallback = require(ServerDrivenUi.Analytics.useScrollTelemetryCallback)
local useUniformItemHeight = require(ServerDrivenUi.Content.Collections.useUniformItemHeight)
local ItemHeightMode = require(ServerDrivenUi.Content.Collections.ItemHeightMode)

local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppLayoutParamsInContext = SharedFlags2.FFlagLuaAppLayoutParamsInContext
local FFlagLuaAppRespectClipAncestorImpressions = SharedFlags2.FFlagLuaAppRespectClipAncestorImpressions
local FFlagLuaAppCompositionAlways = SharedFlags2.FFlagLuaAppCompositionAlways
local FFlagLuaAppUseFrameBoundsImpressions = SharedFlags2.FFlagLuaAppUseFrameBoundsImpressions
local FFlagSduiCarouselUseNestedImpressionsFeedContext = SharedFlags2.FFlagSduiCarouselUseNestedImpressionsFeedContext
local FFlagLuaAppSduiVideoThumbnail = SharedFlags2.FFlagLuaAppSduiVideoThumbnail
local FFlagSduiPreferredTextSizeLineBudgets = SharedFlags2.FFlagSduiPreferredTextSizeLineBudgets

local v = {}

local function SduiCollectionCarousel(props)
	local appCompositionEnabled = FFlagLuaAppCompositionAlways
		or props.appCompositionEnabled
		or props.sduiContext.appCompositionEnabled
	local layoutOrder = props.layoutOrder
	local sduiContext = props.sduiContext
	local videoPlaybackContext

	if FFlagLuaAppSduiVideoThumbnail then
		videoPlaybackContext = sduiContext.videoPlaybackContext
	end

	local items = React.useMemo(function()
		if not props.items then
			return {}
		end

		for _, item in props.items do
			if props.itemTemplateKey and item.templateKey == nil then
				item.templateKey = props.itemTemplateKey
			end
		end

		if not (props.maxItemsToShow and #props.items > props.maxItemsToShow) then
			return props.items
		end

		local result = {}

		for k, item in props.items do
			if k == props.maxItemsToShow + 1 then
				if not props.overflowItem then
					break
				end

				table.insert(result, props.overflowItem)

				return result
			end

			table.insert(result, item)
		end

		return result
	end, { props.items, props.itemTemplateKey, props.maxItemsToShow, props.overflowItem })

	local state, setState = React.useState(nil)

	local ref = React.useRef(nil)
	local onScrollStart, onScrollSettled

	if FFlagLuaAppSduiVideoThumbnail then
		local viewportVideoAutoplayController

		if videoPlaybackContext then
			viewportVideoAutoplayController = videoPlaybackContext.viewportVideoAutoplayController
		else
			viewportVideoAutoplayController = nil
		end

		onScrollStart = React.useCallback(function()
			if viewportVideoAutoplayController then
				viewportVideoAutoplayController:onScrollStart()
			end
		end, { viewportVideoAutoplayController })
		onScrollSettled = React.useCallback(function(p: number)
			if viewportVideoAutoplayController then
				viewportVideoAutoplayController:onScrollSettled("X", p, { current = ref.current })
			end
		end, { viewportVideoAutoplayController, ref })
	end

	local v2

	if props.layoutOverrides then
		v2 = Cryo.Dictionary.join(props.layoutOverrides, { sideMargin = props.pageSideMargin })
	else
		v2 = { sideMargin = props.pageSideMargin }
	end

	local v3

	if not FFlagLuaAppCompositionAlways then
		if FFlagLuaAppLayoutParamsInContext then
			local v4 = React.useCallback(function(p)
				return sduiContext.getPageLayoutConfig(props.collectionItemSize)(p)
			end, { props.collectionItemSize, sduiContext.getPageLayoutConfig })
			v3 = SignalsReact.useSignalState(v4)
		else
			v3 = useCollectionLayoutParams(props.collectionItemSize or CollectionItemSize.Small, state, false, v2)
		end
	end

	local v4 = items and #items or 0

	local v5 = findAnalyticsField("componentType", props.analyticsContext.analyticsData or v)
		or SduiBuilder.getComponentType(props.componentConfig, sduiContext)

	local parentAnalyticsContext, v6 = useCollectionAnalyticsContext(
		props.analyticsContext,
		v5,
		v4,
		v4,
		sduiContext,
		props.startRow,
		props.componentConfig.__isClientBinding
	)

	local ref2 = React.useRef({})

	local scrollViewPositionChangedSignal, v7 = useCollectionImpressionsSignal(props.scrollViewPositionChangedSignal)
	local v8

	if FFlagSduiCarouselUseNestedImpressionsFeedContext then
		v8 = React.useMemo(function()
			return {
				scrollViewPositionChangedSignal = scrollViewPositionChangedSignal,
				verticalScrollingFrameRef = props.verticalScrollingFrameRef,
				impressionsParentScrollingFrameRef = ref
			}
		end, { scrollViewPositionChangedSignal, props.verticalScrollingFrameRef, ref })
	end

	local impressionsTag = getImpressionsTag(props.index, v6.current, sduiContext, props.debugName)

	local sendImpressions = React.useCallback(function(list)
		if items == nil or #items == 0 then
			if list and #list > 0 then
				local v9

				if parentAnalyticsContext then
					v9 = SduiParseHelpers.stringifyValue(parentAnalyticsContext.analyticsData)
				end

				sduiContext.dependencies.logger.reportError(
					SduiErrors.SduiErrorType.FailedToLogImpressions,
					{
						componentType = "CollectionCarousel",
						name = impressionsTag,
						message = `Failed to log impressions. No configs. indexes: {table.concat(list, ",")} analytics: {v9}`
					},
					sduiContext.appPage
				)
			end
		else
			assert(items, "itemConfigs must exist")

			if props.impressionEventName or not v6.current or v6.current.contentType ~= "Game" then
				reportUnifiedLoggingImpressions(
					sduiContext,
					list,
					ref2.current,
					v6.current,
					props.startRow,
					props.impressionEventName,
					props.skipItemImpressionsLog,
					impressionsTag
				)
				return
			end

			if v6.current and v6.current.contentType == "Game" then
				sendLegacyGameImpressionsForSdui(
					list,
					ref2.current,
					items,
					parentAnalyticsContext,
					v6.current,
					props.startRow,
					sduiContext,
					nil,
					nil,
					impressionsTag
				)
			end

			reportUnifiedLoggingImpressions(sduiContext, list, ref2.current, v6.current, props.startRow)
		end
	end, {
		items,
		props.startRow,
		sduiContext,
		v6,
		ref2,
		parentAnalyticsContext,
		impressionsTag,
		props.impressionEventName,
		props.skipItemImpressionsLog
	})

	local scale = useTokens().Config.UI.Scale
	local v9

	if FFlagSduiPreferredTextSizeLineBudgets then
		v9 = usePreferredTextSizeLineBudget(props.preferredTextSizeLineCount)
	else
		v9 = nil
	end

	local v10 = props.itemHeightMode == ItemHeightMode.Uniform
	local v11 = useUniformItemHeight(v10)
	local onItemSizeChanged = v11.onItemSizeChanged
	local v12

	if v11 then
		v12 = v11.measuredMaxHeight ~= nil
	else
		v12 = false
	end

	local v13 = nil

	if v10 then
		local measuredMaxHeight = v11.measuredMaxHeight

		if measuredMaxHeight and measuredMaxHeight > 0 then
			v13 = UDim.new(0, measuredMaxHeight / scale)
		end
	elseif props.itemHeightMode ~= ItemHeightMode.Auto then
		v13 = props.itemHeightFromWidth
	end

	local v14

	if v13 == nil then
		v14 = #items > 0
	else
		v14 = false
	end

	local useCallback = React.useCallback
	local function fn(p: number)
		if v10 then
			local measuredMaxHeight = v11.measuredMaxHeight

			if measuredMaxHeight and measuredMaxHeight > 0 then
				return measuredMaxHeight
			end

			return 0
		elseif v13 then
			return p * v13.Scale + v13.Offset * scale + (v9 or 0)
		else
			return 0
		end
	end

	local measuredMaxHeight = v11.measuredMaxHeight
	local v15

	if FFlagSduiPreferredTextSizeLineBudgets then
		v15 = v9
	end

	local getItemHeight = useCallback(fn, { v10, v13, measuredMaxHeight, scale, v15 })

	local renderItem = React.useCallback(function(props2, itemPosition: number, size, _)
		if not props2 then
			sduiContext.dependencies.logger.reportError(
				SduiErrors.SduiErrorType.NilItem,
				{
					componentType = "CollectionCarousel",
					name = impressionsTag,
					message = `Nil item in CollectionCarousel.renderItem at index {itemPosition}`
				},
				sduiContext.appPage
			)
			return React.createElement(React.Fragment), "nil"
		end

		local v16 = findAnalyticsField("componentType", props2.analyticsData or v)
			or SduiBuilder.getComponentType(props2, sduiContext)

		if v16 then
			local localAnalyticsData = {
				itemPosition = itemPosition,
				itemComponentType = v16,
				componentType = v16
			}

			local current = ref2.current
			local buildAndValidateItemAnalyticsData = SduiCollectionAnalyticsBuilder.buildAndValidateItemAnalyticsData

			local analyticsData = props2.analyticsData
			local v17

			if FFlagSduiErrorPaths then
				v17 = props2.errorContext
			end

			current[itemPosition] = buildAndValidateItemAnalyticsData(
				sduiContext,
				analyticsData,
				nil,
				localAnalyticsData,
				v16,
				nil,
				v17
			)

			local sduiComponentWrapper = getSduiComponentWrapper(props2)
			local createElement = React.createElement
			local v18 = {
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

			v18.parentAnalyticsContext = parentAnalyticsContext2
			local extraLocalProps = {
				scrollViewPositionChangedSignal = props.scrollViewPositionChangedSignal,
				verticalScrollingFrameRef = props.verticalScrollingFrameRef,
				index = itemPosition,
				selectionOrder = 0,
				size = 0
			}
			local selectionOrder

			if not (props.disableSelectionOrder or not props.selectionOrderBase) then
				selectionOrder = props.selectionOrderBase + itemPosition
			end

			extraLocalProps.selectionOrder = selectionOrder
			local size2

			if v10 and v12 then
				size2 = UDim2.new(1, 0, 1, 0)
			end

			extraLocalProps.size = size2
			v18.extraLocalProps = extraLocalProps

			v18.debugName = `{v16}_{itemPosition}`
			v18.localAnalyticsData = localAnalyticsData
			local element = createElement(sduiComponentWrapper, v18)

			local createElement2 = React.createElement
			local v19 = {
				index = itemPosition,
				impressionsTag = impressionsTag,
				automaticSize = 0,
				size = 0,
				onItemSizeChanged = 0,
				minHeightBinding = 0
			}
			local automaticSize

			if v14 or v10 then
				automaticSize = Enum.AutomaticSize.Y
			end

			v19.automaticSize = automaticSize
			v19.size = size
			local onItemSizeChanged2

			if v10 then
				onItemSizeChanged2 = onItemSizeChanged
			end

			v19.onItemSizeChanged = onItemSizeChanged2
			local minHeightBinding

			if v10 then
				minHeightBinding = v11.measuredMaxHeightBinding
			end

			v19.minHeightBinding = minHeightBinding
			return createElement2(SduiCollectionItem, v19, { Item = element }), v16 or "unknown"
		else
			local v17 = {
				componentType = "CollectionCarousel",
				name = impressionsTag,
				message = `Nil componentType in CollectionCarousel.renderItem at index {itemPosition}`
			}

			if FFlagSduiErrorPaths then
				addSduiErrorContextFields(v17, props2.errorContext)
			end

			sduiContext.dependencies.logger.reportError(
				SduiErrors.SduiErrorType.NilComponentType,
				v17,
				sduiContext.appPage
			)

			return React.createElement(React.Fragment), "nil"
		end
	end, {
		sduiContext,
		props.analyticsContext,
		props.scrollViewPositionChangedSignal,
		props.verticalScrollingFrameRef,
		parentAnalyticsContext,
		v14,
		impressionsTag,
		props.index,
		props.disableSelectionOrder,
		props.selectionOrderBase,
		v10,
		onItemSizeChanged,
		v12,
		v11.measuredMaxHeightBinding
	})

	local v16 = React.useMemo(function()
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

	local onScrollButtonEnter = React.useCallback(function()
		HoverTileCoordinator.default:reset()
	end, {})

	local sendScrollEvent = useScrollTelemetryCallback(ref, v6, sduiContext)

	local headerComponent = React.useMemo(function()
		if props.headerComponent then
			return React.cloneElement(props.headerComponent, {
				parentAnalyticsContext = parentAnalyticsContext,
				extraLocalProps = {
					sideMargin = 0,
					appCompositionEnabled = appCompositionEnabled,
					scrollViewPositionChangedSignal = props.scrollViewPositionChangedSignal,
					verticalScrollingFrameRef = props.verticalScrollingFrameRef,
					startRow = props.startRow,
					numUpdatesToDelayImpressions = props.numUpdatesToDelayImpressions,
					index = props.index
				}
			})
		end

		return nil
	end, {
		parentAnalyticsContext,
		props.headerComponent,
		appCompositionEnabled,
		props.scrollViewPositionChangedSignal,
		props.verticalScrollingFrameRef,
		props.startRow,
		props.numUpdatesToDelayImpressions,
		props.index
	})

	local focusNavActions = React.useMemo(function()
		if props.focusNavActionsComponent then
			return React.cloneElement(props.focusNavActionsComponent, {
				parentAnalyticsContext = parentAnalyticsContext,
				extraLocalProps = { guiObject = state }
			})
		end

		return nil
	end, { parentAnalyticsContext, props.focusNavActionsComponent, state })

	local createElement = React.createElement
	local collectionItemSize

	if appCompositionEnabled then
		collectionItemSize = props.collectionItemSize
	end

	local v17 = {
		collectionItemSize = collectionItemSize,
		onReachedThresholdFromEnd = props.onScrollToEnd,
		thresholdFromEnd = props.scrollThresholdFromEnd,
		containerRef = setState,
		scrollingFrameRef = ref,
		getItemHeight = getItemHeight,
		items = items,
		renderItem = renderItem,
		numColumns = 0,
		fractionalItemAmount = 0,
		columnGap = 0,
		sideMargin = 0,
		onViewableItemsChanged = 0,
		onChangeCanvasPosition = 0,
		LayoutOrder = 0,
		scrollingEnabledOverride = 0,
		AutomaticSize = 0,
		headerComponent = 0,
		backgroundMuralUrl = 0,
		onScrollButtonEnter = 0,
		numItemsToRenderOffScreen = 0,
		enableHoverOverflow = 0,
		testId = 0
	}
	local numColumns

	if appCompositionEnabled then
		numColumns = props.numColumnsOverride
	else
		numColumns = v3.numColumns
	end

	v17.numColumns = numColumns
	local fractionalItemAmount

	if not appCompositionEnabled then
		fractionalItemAmount = v3.fractionalItemAmount
	end

	v17.fractionalItemAmount = fractionalItemAmount
	local columnGap

	if not appCompositionEnabled then
		columnGap = v3.columnGap
	end

	v17.columnGap = columnGap
	local sideMargin

	if not appCompositionEnabled then
		sideMargin = v3.sideMargin
	end

	v17.sideMargin = sideMargin
	v17.onViewableItemsChanged = v7
	v17.onChangeCanvasPosition = v7
	v17.LayoutOrder = layoutOrder
	v17.scrollingEnabledOverride = props.scrollingEnabledOverride
	local automaticSize

	if v14 or v10 then
		automaticSize = Enum.AutomaticSize.Y
	end

	v17.AutomaticSize = automaticSize
	v17.headerComponent = headerComponent
	v17.backgroundMuralUrl = props.backgroundMuralUrl
	v17.onScrollButtonEnter = onScrollButtonEnter
	v17.numItemsToRenderOffScreen = props.numItemsToRenderOffScreen
	v17.enableHoverOverflow = props.enableHoverOverflow
	v17.testId = not props.testId and "--sdui-collection-carousel" or props.testId
	local element = createElement(CollectionCarousel, v17)

	local createElement2 = React.createElement
	local fragment = React.Fragment

	local join = Cryo.Dictionary.join

	if FFlagSduiCarouselUseNestedImpressionsFeedContext and v8 then
		element = React.createElement(SduiFeedContext.Provider, { value = v8 }, element)
	end

	local createElement3 = React.createElement
	local v18 = {
		waitForProp = props.startRow,
		maxUpdatesToDelay = props.numUpdatesToDelayImpressions,
		wrappedComponent = 0
	}
	local wrappedComponent

	if FFlagLuaAppUseFrameBoundsImpressions or props.shouldUseFrameBoundsForImpressions then
		local createElement4 = React.createElement
		local v19 = {
			parentRef = ref,
			pageContext = sduiContext.routeName or sduiContext.appPage,
			impressionsTag = impressionsTag,
			scrollViewPositionChangedSignal = scrollViewPositionChangedSignal,
			sendImpressions = sendImpressions,
			dataUpdatedTimestamp = props.sduiContext.dataUpdatedTimestamp,
			respectClipAncestors = 0
		}
		local respectClipAncestors

		if FFlagLuaAppRespectClipAncestorImpressions then
			respectClipAncestors = props.respectClipAncestors
		end

		v19.respectClipAncestors = respectClipAncestors
		wrappedComponent = createElement4(FrameBoundsImpressionsTracker, v19)
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

	v18.wrappedComponent = wrappedComponent
	local children = {
		CollectionCarousel = element,
		ImpressionDetector = createElement3(WaitForPropWrapper, v18),
		ScrollDetector = 0,
		FocusNavActions = 0
	}

	local createElement4 = React.createElement
	local v19 = {
		scrollingFrameRef = ref,
		sendScrollEvent = sendScrollEvent,
		onScrollStart = nil,
		onScrollSettled = nil
	}

	if not FFlagLuaAppSduiVideoThumbnail then
		onScrollStart = nil
	end

	v19.onScrollStart = onScrollStart

	if not FFlagLuaAppSduiVideoThumbnail then
		onScrollSettled = nil
	end

	v19.onScrollSettled = onScrollSettled
	children.ScrollDetector = createElement4(ScrollDetector, v19)

	children.FocusNavActions = focusNavActions
	return createElement2(fragment, nil, join(v16 or v, children))
end

return React.memo(SduiCollectionCarousel)
