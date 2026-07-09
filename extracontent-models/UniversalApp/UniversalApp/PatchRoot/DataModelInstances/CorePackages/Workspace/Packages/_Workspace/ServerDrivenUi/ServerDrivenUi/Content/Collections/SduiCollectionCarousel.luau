local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local ServerDrivenUiParent = ServerDrivenUi.Parent
local React = require(ServerDrivenUiParent.React)

require(ServerDrivenUiParent.AppCommonLib)

local Cryo = require(ServerDrivenUiParent.Cryo)
local SignalsReact = require(ServerDrivenUiParent.SignalsReact)
local CollectionViews = require(ServerDrivenUiParent.CollectionViews)
local CollectionCarousel = CollectionViews.CollectionCarousel
local CollectionItemSize = CollectionViews.CollectionViewTypes.CollectionItemSize
local useCollectionImpressionsSignal = CollectionViews.useCollectionImpressionsSignal
local useCollectionLayoutParams = CollectionViews.useCollectionLayoutParams
local WaitForPropWrapper = require(ServerDrivenUiParent.GameCollections).WaitForPropWrapper
local Impressions = require(ServerDrivenUiParent.Impressions)
local FrameBoundsImpressionsTracker = Impressions.FrameBoundsImpressionsTracker
local ScreenSizeImpressionsTracker = Impressions.ScreenSizeImpressionsTracker
local HoverTileCoordinator = require(ServerDrivenUiParent.GameTile).HoverTileCoordinator
local ScrollDetector = require(ServerDrivenUiParent.ScrollTelemetry).ScrollDetector
local useTokens = require(ServerDrivenUiParent.Foundation).Hooks.useTokens
local SduiCoreSystem = require(ServerDrivenUiParent.SduiCoreSystem)
local findAnalyticsField = SduiCoreSystem.findAnalyticsField
local getImpressionsTag = require(ServerDrivenUi.Analytics.getImpressionsTag)
local sendLegacyGameImpressionsForSdui = require(ServerDrivenUi.Analytics.sendLegacyGameImpressionsForSdui)
local reportUnifiedLoggingImpressions = SduiCoreSystem.reportUnifiedLoggingImpressions
local SduiBuilder = SduiCoreSystem.SduiBuilder
local SduiCollectionAnalyticsBuilder = SduiCoreSystem.SduiCollectionAnalyticsBuilder
local SduiErrors = SduiCoreSystem.SduiErrors
local SduiCollectionItem = require(ServerDrivenUi.Content.Collections.SduiCollectionItem)
local SduiParseHelpers = SduiCoreSystem.SduiParseHelpers
local getSduiComponentWrapper = SduiCoreSystem.getSduiComponentWrapper
local useCollectionAnalyticsContext = require(ServerDrivenUiParent.SduiSharedContent).useCollectionAnalyticsContext
local useScrollTelemetryCallback = require(ServerDrivenUi.Analytics.useScrollTelemetryCallback)
local useUniformItemHeight = require(ServerDrivenUi.Content.Collections.useUniformItemHeight)
local ItemHeightMode = require(ServerDrivenUi.Content.Collections.ItemHeightMode)
local SharedFlags = require(ServerDrivenUiParent.SharedFlags)
local FFlagLuaAppLayoutParamsInContext = SharedFlags.FFlagLuaAppLayoutParamsInContext
local FFlagLuaAppCompositionAlways = SharedFlags.FFlagLuaAppCompositionAlways
local FFlagLuaAppUseFrameBoundsImpressions = SharedFlags.FFlagLuaAppUseFrameBoundsImpressions
local FFlagSduiCollectionCarouselOverrides = SharedFlags.FFlagSduiCollectionCarouselOverrides
local FFlagSduiEdpStoreImpressionsLogging = SharedFlags.FFlagSduiEdpStoreImpressionsLogging
local FFlagSduiGenreSelector = SharedFlags.FFlagSduiGenreSelector
local t1 = {}

local function SduiCollectionCarousel(t2: {[any]: any}) -- line: 132
	-- upvalues: FFlagLuaAppCompositionAlways (copy), React (copy), Cryo (copy), FFlagLuaAppLayoutParamsInContext (copy), SignalsReact (copy), useCollectionLayoutParams (copy), CollectionItemSize (copy), findAnalyticsField (copy), t1 (copy), SduiBuilder (copy), useCollectionAnalyticsContext (copy), useCollectionImpressionsSignal (copy), getImpressionsTag (copy), SduiParseHelpers (copy), SduiErrors (copy), reportUnifiedLoggingImpressions (copy), FFlagSduiEdpStoreImpressionsLogging (copy), sendLegacyGameImpressionsForSdui (copy), useTokens (copy), ItemHeightMode (copy), useUniformItemHeight (copy), SduiCollectionAnalyticsBuilder (copy), getSduiComponentWrapper (copy), SduiCollectionItem (copy), HoverTileCoordinator (copy), useScrollTelemetryCallback (copy), FFlagSduiGenreSelector (copy), CollectionCarousel (copy), FFlagSduiCollectionCarouselOverrides (copy), WaitForPropWrapper (copy), FFlagLuaAppUseFrameBoundsImpressions (copy), FrameBoundsImpressionsTracker (copy), ScreenSizeImpressionsTracker (copy), ScrollDetector (copy)
	local v43 = FFlagLuaAppCompositionAlways or (t2.appCompositionEnabled or t2.sduiContext.appCompositionEnabled)
	local layoutOrder = t2.layoutOrder
	local sduiContext = t2.sduiContext
	local v46 = React.useMemo(function() -- line: 141
		-- upvalues: t2 (copy)
		if not t2.items then
			return {}
		end

		for _, v78 in t2.items do
			if t2.itemTemplateKey and v78.templateKey == nil then
				v78.templateKey = t2.itemTemplateKey
			end
		end

		if t2.maxItemsToShow and #t2.items > t2.maxItemsToShow then
			local t3 = {}

			for v80, v81 in t2.items do
				if v80 == t2.maxItemsToShow + 1 then
					if not t2.overflowItem then
						return t3
					end

					table.insert(t3, t2.overflowItem)

					return t3
				end

				table.insert(t3, v81)
			end

			return t3
		end

		return t2.items
	end, {
		t2.items,
		t2.itemTemplateKey,
		t2.maxItemsToShow,
		t2.overflowItem
	})
	local v47, v48 = React.useState(nil)
	local v49 = React.useRef(nil)
	local v50 = if not t2.layoutOverrides then {
		sideMargin = t2.pageSideMargin
	} else Cryo.Dictionary.join(t2.layoutOverrides, {
		sideMargin = t2.pageSideMargin
	})
	local v51 = nil

	if not FFlagLuaAppCompositionAlways then
		if FFlagLuaAppLayoutParamsInContext then
			local v52 = React.useCallback(function(p1) -- line: 182
				-- upvalues: sduiContext (copy), t2 (copy)
				return sduiContext.getPageLayoutConfig(t2.collectionItemSize)(p1)
			end, {
				t2.collectionItemSize,
				sduiContext.getPageLayoutConfig
			})

			v51 = SignalsReact.useSignalState(v52)
		else
			v51 = useCollectionLayoutParams(t2.collectionItemSize or CollectionItemSize.Small, v47, false, v50)
		end
	end

	local v53 = not v46 and 0 or #v46
	local v54 = findAnalyticsField("componentType", t2.analyticsContext.analyticsData or t1) or SduiBuilder.getComponentType(t2.componentConfig, sduiContext)
	local v55, v56 = useCollectionAnalyticsContext(t2.analyticsContext, v54, v53, v53, sduiContext, t2.startRow, t2.componentConfig.__isClientBinding)
	local v57 = React.useRef({})
	local v58, v59 = useCollectionImpressionsSignal(t2.scrollViewPositionChangedSignal)
	local v60 = getImpressionsTag(t2.index, v56.current, sduiContext, t2.debugName)
	local v61 = React.useCallback(function(t4: {[any]: any}) -- line: 228
		-- upvalues: v46 (copy), v55 (copy), SduiParseHelpers (copy), sduiContext (copy), SduiErrors (copy), v60 (copy), t2 (copy), v56 (copy), reportUnifiedLoggingImpressions (copy), v57 (copy), FFlagSduiEdpStoreImpressionsLogging (copy), sendLegacyGameImpressionsForSdui (copy)
		if v46 == nil or #v46 == 0 then
			if t4 and #t4 > 0 then
				local v84 = if not v55 then nil else SduiParseHelpers.stringifyValue(v55.analyticsData)

				sduiContext.dependencies.logger.reportError(SduiErrors.SduiErrorType.FailedToLogImpressions, {
					componentType = "CollectionCarousel",
					name = v60,
					message = `Failed to log impressions. No configs. indexes: { table.concat(t4, ",") } analytics: { v84 }`
				}, sduiContext.appPage)
			end

			return
		end

		assert(v46, "itemConfigs must exist")

		if t2.impressionEventName or not v56.current or v56.current.contentType ~= "Game" then
			reportUnifiedLoggingImpressions(sduiContext, t4, v57.current, v56.current, t2.startRow, t2.impressionEventName, t2.skipItemImpressionsLog, if not FFlagSduiEdpStoreImpressionsLogging then nil else v60)

			return
		end

		if v56.current and v56.current.contentType == "Game" then
			sendLegacyGameImpressionsForSdui(t4, v57.current, v46, v55, v56.current, t2.startRow, sduiContext, nil, nil, v60)
		end

		reportUnifiedLoggingImpressions(sduiContext, t4, v57.current, v56.current, t2.startRow)
	end, {
		v46,
		t2.startRow,
		sduiContext,
		v56,
		v57,
		v55,
		v60,
		t2.impressionEventName,
		t2.skipItemImpressionsLog
	})
	local UIScale = useTokens().Config.UI.Scale
	local v63 = t2.itemHeightMode == ItemHeightMode.Uniform
	local v64 = useUniformItemHeight(v63)
	local onItemSizeChanged = v64.onItemSizeChanged
	local v66 = not not v64 and v64.measuredMaxHeight ~= nil
	local uDim = nil

	if v63 then
		local measuredMaxHeight = v64.measuredMaxHeight

		if measuredMaxHeight and measuredMaxHeight > 0 then
			uDim = UDim.new(0, measuredMaxHeight / UIScale)
		end
	elseif t2.itemHeightMode ~= ItemHeightMode.Auto then
		uDim = t2.itemHeightFromWidth
	end

	local v69 = uDim == nil and #v46 > 0
	local v70 = React.useCallback(function(n1: number) -- line: 322
		-- upvalues: v63 (copy), v64 (copy), uDim (ref), UIScale (copy)
		if v63 then
			local measuredMaxHeight = v64.measuredMaxHeight

			if measuredMaxHeight and measuredMaxHeight > 0 then
				return measuredMaxHeight
			end

			return 0
		end

		if uDim then
			return n1 * uDim.Scale + uDim.Offset * UIScale
		end

		return 0
	end, {
		v63,
		uDim,
		v64.measuredMaxHeight,
		UIScale
	})
	local v71 = React.useCallback(function(p2, n2: number, p3, _) -- line: 345
		-- upvalues: sduiContext (copy), SduiErrors (copy), v60 (copy), React (copy), findAnalyticsField (copy), t1 (copy), SduiBuilder (copy), v57 (copy), SduiCollectionAnalyticsBuilder (copy), getSduiComponentWrapper (copy), v55 (copy), t2 (copy), v63 (copy), v66 (copy), SduiCollectionItem (copy), v69 (copy), onItemSizeChanged (copy), v64 (copy)
		if not p2 then
			sduiContext.dependencies.logger.reportError(SduiErrors.SduiErrorType.NilItem, {
				componentType = "CollectionCarousel",
				name = v60,
				message = `Nil item in CollectionCarousel.renderItem at index { n2 }`
			}, sduiContext.appPage)

			return React.createElement(React.Fragment), "nil"
		end

		local v91 = findAnalyticsField("componentType", p2.analyticsData or t1) or SduiBuilder.getComponentType(p2, sduiContext)

		if not v91 then
			sduiContext.dependencies.logger.reportError(SduiErrors.SduiErrorType.NilComponentType, {
				componentType = "CollectionCarousel",
				name = v60,
				message = `Nil componentType in CollectionCarousel.renderItem at index { n2 }`
			}, sduiContext.appPage)

			return React.createElement(React.Fragment), "nil"
		end

		local t5 = {
			itemPosition = n2,
			itemComponentType = v91,
			componentType = v91
		}

		v57.current[n2] = SduiCollectionAnalyticsBuilder.buildAndValidateItemAnalyticsData(sduiContext, p2.analyticsData, nil, t5, v91)

		local v93 = getSduiComponentWrapper(p2)
		local v94 = React.createElement(v93, {
			componentConfig = p2,
			sduiContext = sduiContext,
			parentAnalyticsContext = if not p2.__isClientBinding then v55 else nil,
			extraLocalProps = {
				scrollViewPositionChangedSignal = t2.scrollViewPositionChangedSignal,
				verticalScrollingFrameRef = t2.verticalScrollingFrameRef,
				index = n2,
				selectionOrder = if t2.disableSelectionOrder or not t2.selectionOrderBase then nil else t2.selectionOrderBase + n2,
				size = if not v63 or not v66 then nil else UDim2.new(1, 0, 1, 0)
			},
			debugName = `{ v91 }_{ n2 }`,
			localAnalyticsData = t5
		})

		return React.createElement(SduiCollectionItem, {
			index = n2,
			impressionsTag = v60,
			automaticSize = if not v69 and not v63 then nil else Enum.AutomaticSize.Y,
			size = p3,
			onItemSizeChanged = if not v63 then nil else onItemSizeChanged,
			minHeightBinding = if not v63 then nil else v64.measuredMaxHeightBinding
		}, {
			Item = v94
		}), v91 or "unknown"
	end, {
		sduiContext,
		t2.analyticsContext,
		t2.scrollViewPositionChangedSignal,
		t2.verticalScrollingFrameRef,
		v55,
		v69,
		v60,
		t2.index,
		t2.disableSelectionOrder,
		t2.selectionOrderBase,
		v63,
		onItemSizeChanged,
		v66,
		v64.measuredMaxHeightBinding
	})
	local v72 = React.useMemo(function() -- line: 437
		-- upvalues: t2 (copy), React (copy), v55 (copy)
		local t6 = nil

		if t2.children then
			t6 = {}

			for v96, v97 in t2.children do
				t6[v96] = React.cloneElement(v97, {
					parentAnalyticsContext = v55
				})
			end
		end

		return t6
	end, {
		v55,
		t2.children
	})
	local v73 = React.useCallback(function() -- line: 453
		-- upvalues: HoverTileCoordinator (copy)
		HoverTileCoordinator.default:reset()
	end, {})
	local v74 = useScrollTelemetryCallback(v49, v56, sduiContext)
	local v75 = React.useMemo(function() -- line: 460
		-- upvalues: t2 (copy), React (copy), v55 (copy), FFlagSduiGenreSelector (copy), v43 (copy)
		if t2.headerComponent then
			return React.cloneElement(t2.headerComponent, {
				parentAnalyticsContext = v55,
				extraLocalProps = if not FFlagSduiGenreSelector then nil else {
					sideMargin = 0,
					appCompositionEnabled = v43,
					scrollViewPositionChangedSignal = t2.scrollViewPositionChangedSignal,
					verticalScrollingFrameRef = t2.verticalScrollingFrameRef,
					startRow = t2.startRow,
					numUpdatesToDelayImpressions = t2.numUpdatesToDelayImpressions,
					index = t2.index
				}
			})
		end

		return nil
	end, {
		v55,
		t2.headerComponent,
		if not FFlagSduiGenreSelector then nil else v43,
		if not FFlagSduiGenreSelector then nil else t2.scrollViewPositionChangedSignal,
		if not FFlagSduiGenreSelector then nil else t2.verticalScrollingFrameRef,
		if not FFlagSduiGenreSelector then nil else t2.startRow,
		if not FFlagSduiGenreSelector then nil else t2.numUpdatesToDelayImpressions,
		if not FFlagSduiGenreSelector then nil else t2.index
	})
	local v76 = React.useMemo(function() -- line: 493
		-- upvalues: t2 (copy), React (copy), v55 (copy), v47 (copy)
		if t2.focusNavActionsComponent then
			return React.cloneElement(t2.focusNavActionsComponent, {
				parentAnalyticsContext = v55,
				extraLocalProps = {
					guiObject = v47
				}
			})
		end

		return nil
	end, {
		v55,
		t2.focusNavActionsComponent,
		v47
	})

	return React.createElement(React.Fragment, nil, Cryo.Dictionary.join(v72 or t1, {
		CollectionCarousel = React.createElement(CollectionCarousel, {
			collectionItemSize = if not v43 then nil else t2.collectionItemSize,
			onReachedThresholdFromEnd = t2.onScrollToEnd,
			thresholdFromEnd = t2.scrollThresholdFromEnd,
			containerRef = v48,
			scrollingFrameRef = v49,
			getItemHeight = v70,
			items = v46,
			renderItem = v71,
			numColumns = if not v43 then v51.numColumns else if not FFlagSduiCollectionCarouselOverrides then nil else t2.numColumnsOverride,
			fractionalItemAmount = if not v43 then v51.fractionalItemAmount else nil,
			columnGap = if not v43 then v51.columnGap else nil,
			sideMargin = if not v43 then v51.sideMargin else nil,
			onViewableItemsChanged = v59,
			onChangeCanvasPosition = v59,
			LayoutOrder = layoutOrder,
			scrollingEnabledOverride = t2.scrollingEnabledOverride,
			AutomaticSize = if not v69 and not v63 then nil else Enum.AutomaticSize.Y,
			headerComponent = v75,
			backgroundMuralUrl = t2.backgroundMuralUrl,
			onScrollButtonEnter = v73,
			numItemsToRenderOffScreen = t2.numItemsToRenderOffScreen,
			enableHoverOverflow = t2.enableHoverOverflow,
			testId = not t2.testId and "--sdui-collection-carousel" or t2.testId
		}),
		ImpressionDetector = React.createElement(WaitForPropWrapper, {
			waitForProp = t2.startRow,
			maxUpdatesToDelay = t2.numUpdatesToDelayImpressions,
			wrappedComponent = if not FFlagLuaAppUseFrameBoundsImpressions and not t2.shouldUseFrameBoundsForImpressions then React.createElement(ScreenSizeImpressionsTracker, {
				parentRef = v49,
				pageContext = sduiContext.routeName or sduiContext.appPage,
				impressionsTag = v60,
				scrollViewPositionChangedSignal = v58,
				sendImpressions = v61,
				dataUpdatedTimestamp = t2.sduiContext.dataUpdatedTimestamp
			}) else React.createElement(FrameBoundsImpressionsTracker, {
				parentRef = v49,
				pageContext = sduiContext.routeName or sduiContext.appPage,
				impressionsTag = v60,
				scrollViewPositionChangedSignal = v58,
				sendImpressions = v61,
				dataUpdatedTimestamp = t2.sduiContext.dataUpdatedTimestamp
			})
		}),
		ScrollDetector = React.createElement(ScrollDetector, {
			scrollingFrameRef = v49,
			sendScrollEvent = v74
		}),
		FocusNavActions = v76
	}))
end

return React.memo(SduiCollectionCarousel)
