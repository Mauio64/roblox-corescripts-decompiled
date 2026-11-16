local fFlagSduiErrorPaths = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSduiErrorPaths

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/AppCommonLib")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Cryo")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SignalsReact")
local usePreferredTextSizeLineBudget = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiSharedUtilities").usePreferredTextSizeLineBudget
local CollectionViews = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/CollectionViews")
local collectionCarousel = CollectionViews.CollectionCarousel
local collectionItemSize = CollectionViews.CollectionViewTypes.CollectionItemSize
local useCollectionImpressionsSignal = CollectionViews.useCollectionImpressionsSignal
local useCollectionLayoutParams = CollectionViews.useCollectionLayoutParams
local waitForPropWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/GameCollections").WaitForPropWrapper
local Impressions = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Impressions")
local frameBoundsImpressionsTracker = Impressions.FrameBoundsImpressionsTracker
local screenSizeImpressionsTracker = Impressions.ScreenSizeImpressionsTracker
local hoverTileCoordinator = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/GameTile").HoverTileCoordinator
local scrollDetector = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ScrollTelemetry").ScrollDetector
local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Foundation").Hooks.useTokens
require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/VideoUtils")

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local findAnalyticsField = SduiCoreSystem.findAnalyticsField
local getImpressionsTag = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Analytics/getImpressionsTag")
local sendLegacyGameImpressionsForSdui = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Analytics/sendLegacyGameImpressionsForSdui")
local reportUnifiedLoggingImpressions = SduiCoreSystem.reportUnifiedLoggingImpressions
local sduiBuilder = SduiCoreSystem.SduiBuilder
local sduiCollectionAnalyticsBuilder = SduiCoreSystem.SduiCollectionAnalyticsBuilder
local sduiErrors = SduiCoreSystem.SduiErrors
local addSduiErrorContextFields = SduiCoreSystem.addSduiErrorContextFields
local SduiCollectionItem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/Collections/SduiCollectionItem")
local sduiParseHelpers = SduiCoreSystem.SduiParseHelpers
local getSduiComponentWrapper = SduiCoreSystem.getSduiComponentWrapper

local useCollectionAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiSharedContent").useCollectionAnalyticsContext
local sduiFeedContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiSharedContent").SduiFeedContext
local useScrollTelemetryCallback = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Analytics/useScrollTelemetryCallback")
local useUniformItemHeight = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/Collections/useUniformItemHeight")
local ItemHeightMode = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/Collections/ItemHeightMode")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags")
local fFlagLuaAppLayoutParamsInContext = SharedFlags.FFlagLuaAppLayoutParamsInContext
local fFlagLuaAppRespectClipAncestorImpressions = SharedFlags.FFlagLuaAppRespectClipAncestorImpressions
local fFlagLuaAppCompositionAlways = SharedFlags.FFlagLuaAppCompositionAlways
local fFlagLuaAppUseFrameBoundsImpressions = SharedFlags.FFlagLuaAppUseFrameBoundsImpressions
local fFlagSduiCarouselUseNestedImpressionsFeedContext = SharedFlags.FFlagSduiCarouselUseNestedImpressionsFeedContext
local fFlagLuaAppSduiVideoThumbnail = SharedFlags.FFlagLuaAppSduiVideoThumbnail
local fFlagSduiPreferredTextSizeLineBudgets = SharedFlags.FFlagSduiPreferredTextSizeLineBudgets

local v5 = {}

local function SduiCollectionCarousel(props)
	local v6 = fFlagLuaAppCompositionAlways
		or props.appCompositionEnabled
		or props.sduiContext.appCompositionEnabled
	local layoutOrder = props.layoutOrder
	local sduiContext = props.sduiContext

	local videoPlaybackContext = if fFlagLuaAppSduiVideoThumbnail then sduiContext.videoPlaybackContext else nil

	local v7 = React.useMemo(function()
		if not props.items then
			return {}
		end

		for k, item in props.items do
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
	end, {
		props.items,
		props.itemTemplateKey,
		props.maxItemsToShow,
		props.overflowItem
	})

	local state, setState = React.useState(nil)

	local ref = React.useRef(nil)
	local v8, v9

	if fFlagLuaAppSduiVideoThumbnail then
		local viewportVideoAutoplayController = if videoPlaybackContext then videoPlaybackContext.viewportVideoAutoplayController else nil

		v8 = React.useCallback(function()
			if viewportVideoAutoplayController then
				viewportVideoAutoplayController:onScrollStart()
			end
		end, { viewportVideoAutoplayController })
		v9 = React.useCallback(function(p2)
			if viewportVideoAutoplayController then
				viewportVideoAutoplayController:onScrollSettled("X", p2, {
					current = ref.current
				})
			end
		end, { viewportVideoAutoplayController, ref })
	end

	local v10

	if props.layoutOverrides then
		v10 = Cryo.Dictionary.join(props.layoutOverrides, {
			sideMargin = props.pageSideMargin
		})
	else
		v10 = { sideMargin = props.pageSideMargin }
	end

	local v11

	if not fFlagLuaAppCompositionAlways then
		if fFlagLuaAppLayoutParamsInContext then
			local v12 = React.useCallback(function(p2)
				return sduiContext.getPageLayoutConfig(props.collectionItemSize)(p2)
			end, { props.collectionItemSize, sduiContext.getPageLayoutConfig })
			v11 = SignalsReact.useSignalState(v12)
		else
			v11 = useCollectionLayoutParams(
				props.collectionItemSize or collectionItemSize.Small,
				state,
				false,
				v10
			)
		end
	end

	local v12 = v7 and #v7 or 0

	local v13 = findAnalyticsField("componentType", props.analyticsContext.analyticsData or v5)
		or sduiBuilder.getComponentType(props.componentConfig, sduiContext)

	local v14, v15 = useCollectionAnalyticsContext(
		props.analyticsContext,
		v13,
		v12,
		v12,
		sduiContext,
		props.startRow,
		props.componentConfig.__isClientBinding
	)

	local ref2 = React.useRef({})

	local v16, v17 = useCollectionImpressionsSignal(props.scrollViewPositionChangedSignal)
	local v18

	if fFlagSduiCarouselUseNestedImpressionsFeedContext then
		v18 = React.useMemo(function()
			return {
				scrollViewPositionChangedSignal = v16,
				verticalScrollingFrameRef = props.verticalScrollingFrameRef,
				impressionsParentScrollingFrameRef = ref
			}
		end, { v16, props.verticalScrollingFrameRef, ref })
	end

	local v19 = getImpressionsTag(props.index, v15.current, sduiContext, props.debugName)

	local v20 = React.useCallback(function(list)
		if v7 == nil or #v7 == 0 then
			if list and #list > 0 then
				local v21 = if v14 then sduiParseHelpers.stringifyValue(v14.analyticsData) else nil

				sduiContext.dependencies.logger.reportError(
					sduiErrors.SduiErrorType.FailedToLogImpressions,
					{
						componentType = "CollectionCarousel",
						name = v19,
						message = `Failed to log impressions. No configs. indexes: {table.concat(list, ",")} analytics: {v21}`
					},
					sduiContext.appPage
				)
			end
		else
			assert(v7, "itemConfigs must exist")

			if props.impressionEventName or not v15.current or v15.current.contentType ~= "Game" then
				reportUnifiedLoggingImpressions(
					sduiContext,
					list,
					ref2.current,
					v15.current,
					props.startRow,
					props.impressionEventName,
					props.skipItemImpressionsLog,
					v19
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
					nil,
					nil,
					v19
				)
			end

			reportUnifiedLoggingImpressions(sduiContext, list, ref2.current, v15.current, props.startRow)
		end
	end, {
		v7,
		props.startRow,
		sduiContext,
		v15,
		ref2,
		v14,
		v19,
		props.impressionEventName,
		props.skipItemImpressionsLog
	})

	local scale = useTokens().Config.UI.Scale
	local v21

	if fFlagSduiPreferredTextSizeLineBudgets then
		v21 = usePreferredTextSizeLineBudget(props.preferredTextSizeLineCount)
	else
		v21 = nil
	end

	local v22 = props.itemHeightMode == ItemHeightMode.Uniform
	local v23 = useUniformItemHeight(v22)
	local onItemSizeChanged = v23.onItemSizeChanged

	local v24 = if v23 then v23.measuredMaxHeight ~= nil else false

	local v25 = nil

	if v22 then
		local measuredMaxHeight = v23.measuredMaxHeight

		if measuredMaxHeight and measuredMaxHeight > 0 then
			v25 = UDim.new(0, measuredMaxHeight / scale)
		end
	elseif props.itemHeightMode ~= ItemHeightMode.Auto then
		v25 = props.itemHeightFromWidth
	end

	local v26 = v25 == nil and #v7 > 0

	local function fn(p2)
		if v22 then
			local measuredMaxHeight = v23.measuredMaxHeight

			if measuredMaxHeight and measuredMaxHeight > 0 then
				return measuredMaxHeight
			end

			return 0
		elseif v25 then
			return p2 * v25.Scale + v25.Offset * scale + (v21 or 0)
		else
			return 0
		end
	end

	local v30 = React.useCallback(fn, {
		v22,
		v25,
		v23.measuredMaxHeight,
		scale,
		if fFlagSduiPreferredTextSizeLineBudgets then v21 else nil
	})

	local v31 = React.useCallback(function(props2, p2, size, p3)
		if not props2 then
			sduiContext.dependencies.logger.reportError(
				sduiErrors.SduiErrorType.NilItem,
				{
					componentType = "CollectionCarousel",
					name = v19,
					message = `Nil item in CollectionCarousel.renderItem at index {p2}`
				},
				sduiContext.appPage
			)
			return React.createElement(React.Fragment), "nil"
		end

		local v32 = findAnalyticsField("componentType", props2.analyticsData or v5)
			or sduiBuilder.getComponentType(props2, sduiContext)

		if v32 then
			local v33 = {
				itemPosition = p2,
				itemComponentType = v32,
				componentType = v32
			}

			local current = ref2.current
			local buildAndValidateItemAnalyticsData = sduiCollectionAnalyticsBuilder.buildAndValidateItemAnalyticsData

			local analyticsData = props2.analyticsData

			local v37 = if fFlagSduiErrorPaths then props2.errorContext else nil
			current[p2] = buildAndValidateItemAnalyticsData(
				sduiContext,
				analyticsData,
				nil,
				v33,
				v32,
				nil,
				v37
			)

			local sduiComponentWrapper = getSduiComponentWrapper(props2)
			local createElement = React.createElement
			local v38 = {
				componentConfig = props2,
				sduiContext = sduiContext,
				parentAnalyticsContext = 0,
				extraLocalProps = 0,
				debugName = 0,
				localAnalyticsData = 0
			}

			local v39 = if not props2.__isClientBinding then v14 else nil
			v38.parentAnalyticsContext = v39
			local v40 = {
				scrollViewPositionChangedSignal = props.scrollViewPositionChangedSignal,
				verticalScrollingFrameRef = props.verticalScrollingFrameRef,
				index = p2,
				selectionOrder = 0,
				size = 0
			}

			local v41 = if not (props.disableSelectionOrder or not props.selectionOrderBase) then props.selectionOrderBase + p2 else nil
			v40.selectionOrder = v41

			local v42 = if v22 and v24 then UDim2.new(1, 0, 1, 0) else nil
			v40.size = v42
			v38.extraLocalProps = v40

			v38.debugName = `{v32}_{p2}`
			v38.localAnalyticsData = v33
			local element = createElement(sduiComponentWrapper, v38)

			local createElement2 = React.createElement
			local v44 = {
				index = p2,
				impressionsTag = v19,
				automaticSize = 0,
				size = 0,
				onItemSizeChanged = 0,
				minHeightBinding = 0
			}

			local v45 = if v26 or v22 then Enum.AutomaticSize.Y else nil
			v44.automaticSize = v45
			v44.size = size
			v44.onItemSizeChanged = if v22 then onItemSizeChanged else nil
			local v47 = if v22 then v23.measuredMaxHeightBinding else nil
			v44.minHeightBinding = v47
			return createElement2(SduiCollectionItem, v44, { Item = element }), v32 or "unknown"
		else
			local v33 = {
				componentType = "CollectionCarousel",
				name = v19,
				message = `Nil componentType in CollectionCarousel.renderItem at index {p2}`
			}

			if fFlagSduiErrorPaths then
				addSduiErrorContextFields(v33, props2.errorContext)
			end

			sduiContext.dependencies.logger.reportError(
				sduiErrors.SduiErrorType.NilComponentType,
				v33,
				sduiContext.appPage
			)

			return React.createElement(React.Fragment), "nil"
		end
	end, {
		sduiContext,
		props.analyticsContext,
		props.scrollViewPositionChangedSignal,
		props.verticalScrollingFrameRef,
		v14,
		v26,
		v19,
		props.index,
		props.disableSelectionOrder,
		props.selectionOrderBase,
		v22,
		onItemSizeChanged,
		v24,
		v23.measuredMaxHeightBinding
	})

	local v32 = React.useMemo(function()
		local result

		if props.children then
			result = {}

			for k, child in props.children do
				result[k] = React.cloneElement(child, { parentAnalyticsContext = v14 })
			end
		end

		return result
	end, { v14, props.children })

	local v33 = React.useCallback(function()
		hoverTileCoordinator.default:reset()
	end, {})

	local v34 = useScrollTelemetryCallback(ref, v15, sduiContext)

	local v35 = React.useMemo(function()
		if props.headerComponent then
			return React.cloneElement(props.headerComponent, {
				parentAnalyticsContext = v14,
				extraLocalProps = {
					sideMargin = 0,
					appCompositionEnabled = v6,
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
		v14,
		props.headerComponent,
		v6,
		props.scrollViewPositionChangedSignal,
		props.verticalScrollingFrameRef,
		props.startRow,
		props.numUpdatesToDelayImpressions,
		props.index
	})

	local v36 = React.useMemo(function()
		if props.focusNavActionsComponent then
			return React.cloneElement(props.focusNavActionsComponent, {
				parentAnalyticsContext = v14,
				extraLocalProps = { guiObject = state }
			})
		end

		return nil
	end, { v14, props.focusNavActionsComponent, state })

	local createElement = React.createElement
	local v39 = if v6 then props.collectionItemSize else nil
	local v38 = {
		collectionItemSize = v39,
		onReachedThresholdFromEnd = props.onScrollToEnd,
		thresholdFromEnd = props.scrollThresholdFromEnd,
		containerRef = setState,
		scrollingFrameRef = ref,
		getItemHeight = v30,
		items = v7,
		renderItem = v31,
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

	local v40 = if v6 then props.numColumnsOverride else v11.numColumns
	v38.numColumns = v40
	local v41 = if not v6 then v11.fractionalItemAmount else nil
	v38.fractionalItemAmount = v41
	local v42 = if not v6 then v11.columnGap else nil
	v38.columnGap = v42
	local v43 = if not v6 then v11.sideMargin else nil
	v38.sideMargin = v43
	v38.onViewableItemsChanged = v17
	v38.onChangeCanvasPosition = v17
	v38.LayoutOrder = layoutOrder
	v38.scrollingEnabledOverride = props.scrollingEnabledOverride
	local v44 = if v26 or v22 then Enum.AutomaticSize.Y else nil
	v38.AutomaticSize = v44
	v38.headerComponent = v35
	v38.backgroundMuralUrl = props.backgroundMuralUrl
	v38.onScrollButtonEnter = v33
	v38.numItemsToRenderOffScreen = props.numItemsToRenderOffScreen
	v38.enableHoverOverflow = props.enableHoverOverflow
	v38.testId = not props.testId and "--sdui-collection-carousel" or props.testId
	local element = createElement(collectionCarousel, v38)

	local createElement2 = React.createElement
	local fragment = React.Fragment

	local join = Cryo.Dictionary.join

	if fFlagSduiCarouselUseNestedImpressionsFeedContext and v18 then
		element = React.createElement(sduiFeedContext.Provider, { value = v18 }, element)
	end

	local createElement3 = React.createElement
	local v48 = {
		waitForProp = props.startRow,
		maxUpdatesToDelay = props.numUpdatesToDelayImpressions,
		wrappedComponent = 0
	}
	local v49

	if fFlagLuaAppUseFrameBoundsImpressions or props.shouldUseFrameBoundsForImpressions then
		local createElement4 = React.createElement
		local v51 = {
			parentRef = ref,
			pageContext = sduiContext.routeName or sduiContext.appPage,
			impressionsTag = v19,
			scrollViewPositionChangedSignal = v16,
			sendImpressions = v20,
			dataUpdatedTimestamp = props.sduiContext.dataUpdatedTimestamp,
			respectClipAncestors = 0
		}

		local v52 = if fFlagLuaAppRespectClipAncestorImpressions then props.respectClipAncestors else nil
		v51.respectClipAncestors = v52
		v49 = createElement4(frameBoundsImpressionsTracker, v51)
	else
		v49 = React.createElement(screenSizeImpressionsTracker, {
			parentRef = ref,
			pageContext = sduiContext.routeName or sduiContext.appPage,
			impressionsTag = v19,
			scrollViewPositionChangedSignal = v16,
			sendImpressions = v20,
			dataUpdatedTimestamp = props.sduiContext.dataUpdatedTimestamp
		})
	end

	v48.wrappedComponent = v49
	local children = {
		CollectionCarousel = element,
		ImpressionDetector = createElement3(waitForPropWrapper, v48),
		ScrollDetector = 0,
		FocusNavActions = 0
	}

	local createElement4 = React.createElement
	local v51 = {
		scrollingFrameRef = ref,
		sendScrollEvent = v34,
		onScrollStart = nil,
		onScrollSettled = nil
	}

	if not fFlagLuaAppSduiVideoThumbnail then
		v8 = nil
	end

	v51.onScrollStart = v8

	if not fFlagLuaAppSduiVideoThumbnail then
		v9 = nil
	end

	v51.onScrollSettled = v9
	children.ScrollDetector = createElement4(scrollDetector, v51)

	children.FocusNavActions = v36
	return createElement2(fragment, nil, join(v32 or v5, children))
end

return React.memo(SduiCollectionCarousel)
