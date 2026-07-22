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
local FFlagLuaAppRespectClipAncestorImpressions = SharedFlags.FFlagLuaAppRespectClipAncestorImpressions
local FFlagLuaAppCompositionAlways = SharedFlags.FFlagLuaAppCompositionAlways
local FFlagLuaAppUseFrameBoundsImpressions = SharedFlags.FFlagLuaAppUseFrameBoundsImpressions
local FFlagSduiCollectionCarouselOverrides = SharedFlags.FFlagSduiCollectionCarouselOverrides
local FFlagSduiEdpStoreImpressionsLogging = SharedFlags.FFlagSduiEdpStoreImpressionsLogging
local FFlagSduiGenreSelector = SharedFlags.FFlagSduiGenreSelector
local t1 = {}

local function SduiCollectionCarousel(t2: {[any]: any}) -- line: 134
	-- upvalues: FFlagLuaAppCompositionAlways (copy), React (copy), Cryo (copy), FFlagLuaAppLayoutParamsInContext (copy), SignalsReact (copy), useCollectionLayoutParams (copy), CollectionItemSize (copy), findAnalyticsField (copy), t1 (copy), SduiBuilder (copy), useCollectionAnalyticsContext (copy), useCollectionImpressionsSignal (copy), getImpressionsTag (copy), SduiParseHelpers (copy), SduiErrors (copy), reportUnifiedLoggingImpressions (copy), FFlagSduiEdpStoreImpressionsLogging (copy), sendLegacyGameImpressionsForSdui (copy), useTokens (copy), ItemHeightMode (copy), useUniformItemHeight (copy), SduiCollectionAnalyticsBuilder (copy), getSduiComponentWrapper (copy), SduiCollectionItem (copy), HoverTileCoordinator (copy), useScrollTelemetryCallback (copy), FFlagSduiGenreSelector (copy), CollectionCarousel (copy), FFlagSduiCollectionCarouselOverrides (copy), WaitForPropWrapper (copy), FFlagLuaAppUseFrameBoundsImpressions (copy), FrameBoundsImpressionsTracker (copy), FFlagLuaAppRespectClipAncestorImpressions (copy), ScreenSizeImpressionsTracker (copy), ScrollDetector (copy)
	local v44 = FFlagLuaAppCompositionAlways or (t2.appCompositionEnabled or t2.sduiContext.appCompositionEnabled)
	local layoutOrder = t2.layoutOrder
	local sduiContext = t2.sduiContext
	local v47 = React.useMemo(function() -- line: 143
		-- upvalues: t2 (copy)
		if not t2.items then
			return {}
		end

		for _, v79 in t2.items do
			if t2.itemTemplateKey and v79.templateKey == nil then
				v79.templateKey = t2.itemTemplateKey
			end
		end

		if t2.maxItemsToShow and #t2.items > t2.maxItemsToShow then
			local t3 = {}

			for v81, v82 in t2.items do
				if v81 == t2.maxItemsToShow + 1 then
					if not t2.overflowItem then
						return t3
					end

					table.insert(t3, t2.overflowItem)

					return t3
				end

				table.insert(t3, v82)
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
	local v48, v49 = React.useState(nil)
	local v50 = React.useRef(nil)
	local v51 = if not t2.layoutOverrides then {
		sideMargin = t2.pageSideMargin
	} else Cryo.Dictionary.join(t2.layoutOverrides, {
		sideMargin = t2.pageSideMargin
	})
	local v52 = nil

	if not FFlagLuaAppCompositionAlways then
		if FFlagLuaAppLayoutParamsInContext then
			local v53 = React.useCallback(function(p1) -- line: 184
				-- upvalues: sduiContext (copy), t2 (copy)
				return sduiContext.getPageLayoutConfig(t2.collectionItemSize)(p1)
			end, {
				t2.collectionItemSize,
				sduiContext.getPageLayoutConfig
			})

			v52 = SignalsReact.useSignalState(v53)
		else
			v52 = useCollectionLayoutParams(t2.collectionItemSize or CollectionItemSize.Small, v48, false, v51)
		end
	end

	local v54 = not v47 and 0 or #v47
	local v55 = findAnalyticsField("componentType", t2.analyticsContext.analyticsData or t1) or SduiBuilder.getComponentType(t2.componentConfig, sduiContext)
	local v56, v57 = useCollectionAnalyticsContext(t2.analyticsContext, v55, v54, v54, sduiContext, t2.startRow, t2.componentConfig.__isClientBinding)
	local v58 = React.useRef({})
	local v59, v60 = useCollectionImpressionsSignal(t2.scrollViewPositionChangedSignal)
	local v61 = getImpressionsTag(t2.index, v57.current, sduiContext, t2.debugName)
	local v62 = React.useCallback(function(t4: {[any]: any}) -- line: 230
		-- upvalues: v47 (copy), v56 (copy), SduiParseHelpers (copy), sduiContext (copy), SduiErrors (copy), v61 (copy), t2 (copy), v57 (copy), reportUnifiedLoggingImpressions (copy), v58 (copy), FFlagSduiEdpStoreImpressionsLogging (copy), sendLegacyGameImpressionsForSdui (copy)
		if v47 == nil or #v47 == 0 then
			if t4 and #t4 > 0 then
				local v85 = if not v56 then nil else SduiParseHelpers.stringifyValue(v56.analyticsData)

				sduiContext.dependencies.logger.reportError(SduiErrors.SduiErrorType.FailedToLogImpressions, {
					componentType = "CollectionCarousel",
					name = v61,
					message = `Failed to log impressions. No configs. indexes: { table.concat(t4, ",") } analytics: { v85 }`
				}, sduiContext.appPage)
			end

			return
		end

		assert(v47, "itemConfigs must exist")

		if t2.impressionEventName or not v57.current or v57.current.contentType ~= "Game" then
			reportUnifiedLoggingImpressions(sduiContext, t4, v58.current, v57.current, t2.startRow, t2.impressionEventName, t2.skipItemImpressionsLog, if not FFlagSduiEdpStoreImpressionsLogging then nil else v61)

			return
		end

		if v57.current and v57.current.contentType == "Game" then
			sendLegacyGameImpressionsForSdui(t4, v58.current, v47, v56, v57.current, t2.startRow, sduiContext, nil, nil, v61)
		end

		reportUnifiedLoggingImpressions(sduiContext, t4, v58.current, v57.current, t2.startRow)
	end, {
		v47,
		t2.startRow,
		sduiContext,
		v57,
		v58,
		v56,
		v61,
		t2.impressionEventName,
		t2.skipItemImpressionsLog
	})
	local UIScale = useTokens().Config.UI.Scale
	local v64 = t2.itemHeightMode == ItemHeightMode.Uniform
	local v65 = useUniformItemHeight(v64)
	local onItemSizeChanged = v65.onItemSizeChanged
	local v67 = not not v65 and v65.measuredMaxHeight ~= nil
	local uDim = nil

	if v64 then
		local measuredMaxHeight = v65.measuredMaxHeight

		if measuredMaxHeight and measuredMaxHeight > 0 then
			uDim = UDim.new(0, measuredMaxHeight / UIScale)
		end
	elseif t2.itemHeightMode ~= ItemHeightMode.Auto then
		uDim = t2.itemHeightFromWidth
	end

	local v70 = uDim == nil and #v47 > 0
	local v71 = React.useCallback(function(n1: number) -- line: 324
		-- upvalues: v64 (copy), v65 (copy), uDim (ref), UIScale (copy)
		if v64 then
			local measuredMaxHeight = v65.measuredMaxHeight

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
		v64,
		uDim,
		v65.measuredMaxHeight,
		UIScale
	})
	local v72 = React.useCallback(function(p2, n2: number, p3, _) -- line: 347
		-- upvalues: sduiContext (copy), SduiErrors (copy), v61 (copy), React (copy), findAnalyticsField (copy), t1 (copy), SduiBuilder (copy), v58 (copy), SduiCollectionAnalyticsBuilder (copy), getSduiComponentWrapper (copy), v56 (copy), t2 (copy), v64 (copy), v67 (copy), SduiCollectionItem (copy), v70 (copy), onItemSizeChanged (copy), v65 (copy)
		if not p2 then
			sduiContext.dependencies.logger.reportError(SduiErrors.SduiErrorType.NilItem, {
				componentType = "CollectionCarousel",
				name = v61,
				message = `Nil item in CollectionCarousel.renderItem at index { n2 }`
			}, sduiContext.appPage)

			return React.createElement(React.Fragment), "nil"
		end

		local v92 = findAnalyticsField("componentType", p2.analyticsData or t1) or SduiBuilder.getComponentType(p2, sduiContext)

		if not v92 then
			sduiContext.dependencies.logger.reportError(SduiErrors.SduiErrorType.NilComponentType, {
				componentType = "CollectionCarousel",
				name = v61,
				message = `Nil componentType in CollectionCarousel.renderItem at index { n2 }`
			}, sduiContext.appPage)

			return React.createElement(React.Fragment), "nil"
		end

		local t5 = {
			itemPosition = n2,
			itemComponentType = v92,
			componentType = v92
		}

		v58.current[n2] = SduiCollectionAnalyticsBuilder.buildAndValidateItemAnalyticsData(sduiContext, p2.analyticsData, nil, t5, v92)

		local v94 = getSduiComponentWrapper(p2)
		local v95 = React.createElement(v94, {
			componentConfig = p2,
			sduiContext = sduiContext,
			parentAnalyticsContext = if not p2.__isClientBinding then v56 else nil,
			extraLocalProps = {
				scrollViewPositionChangedSignal = t2.scrollViewPositionChangedSignal,
				verticalScrollingFrameRef = t2.verticalScrollingFrameRef,
				index = n2,
				selectionOrder = if t2.disableSelectionOrder or not t2.selectionOrderBase then nil else t2.selectionOrderBase + n2,
				size = if not v64 or not v67 then nil else UDim2.new(1, 0, 1, 0)
			},
			debugName = `{ v92 }_{ n2 }`,
			localAnalyticsData = t5
		})

		return React.createElement(SduiCollectionItem, {
			index = n2,
			impressionsTag = v61,
			automaticSize = if not v70 and not v64 then nil else Enum.AutomaticSize.Y,
			size = p3,
			onItemSizeChanged = if not v64 then nil else onItemSizeChanged,
			minHeightBinding = if not v64 then nil else v65.measuredMaxHeightBinding
		}, {
			Item = v95
		}), v92 or "unknown"
	end, {
		sduiContext,
		t2.analyticsContext,
		t2.scrollViewPositionChangedSignal,
		t2.verticalScrollingFrameRef,
		v56,
		v70,
		v61,
		t2.index,
		t2.disableSelectionOrder,
		t2.selectionOrderBase,
		v64,
		onItemSizeChanged,
		v67,
		v65.measuredMaxHeightBinding
	})
	local v73 = React.useMemo(function() -- line: 439
		-- upvalues: t2 (copy), React (copy), v56 (copy)
		local t6 = nil

		if t2.children then
			t6 = {}

			for v97, v98 in t2.children do
				t6[v97] = React.cloneElement(v98, {
					parentAnalyticsContext = v56
				})
			end
		end

		return t6
	end, {
		v56,
		t2.children
	})
	local v74 = React.useCallback(function() -- line: 455
		-- upvalues: HoverTileCoordinator (copy)
		HoverTileCoordinator.default:reset()
	end, {})
	local v75 = useScrollTelemetryCallback(v50, v57, sduiContext)
	local v76 = React.useMemo(function() -- line: 462
		-- upvalues: t2 (copy), React (copy), v56 (copy), FFlagSduiGenreSelector (copy), v44 (copy)
		if t2.headerComponent then
			return React.cloneElement(t2.headerComponent, {
				parentAnalyticsContext = v56,
				extraLocalProps = if not FFlagSduiGenreSelector then nil else {
					sideMargin = 0,
					appCompositionEnabled = v44,
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
		v56,
		t2.headerComponent,
		if not FFlagSduiGenreSelector then nil else v44,
		if not FFlagSduiGenreSelector then nil else t2.scrollViewPositionChangedSignal,
		if not FFlagSduiGenreSelector then nil else t2.verticalScrollingFrameRef,
		if not FFlagSduiGenreSelector then nil else t2.startRow,
		if not FFlagSduiGenreSelector then nil else t2.numUpdatesToDelayImpressions,
		if not FFlagSduiGenreSelector then nil else t2.index
	})
	local v77 = React.useMemo(function() -- line: 495
		-- upvalues: t2 (copy), React (copy), v56 (copy), v48 (copy)
		if t2.focusNavActionsComponent then
			return React.cloneElement(t2.focusNavActionsComponent, {
				parentAnalyticsContext = v56,
				extraLocalProps = {
					guiObject = v48
				}
			})
		end

		return nil
	end, {
		v56,
		t2.focusNavActionsComponent,
		v48
	})

	return React.createElement(React.Fragment, nil, Cryo.Dictionary.join(v73 or t1, {
		CollectionCarousel = React.createElement(CollectionCarousel, {
			collectionItemSize = if not v44 then nil else t2.collectionItemSize,
			onReachedThresholdFromEnd = t2.onScrollToEnd,
			thresholdFromEnd = t2.scrollThresholdFromEnd,
			containerRef = v49,
			scrollingFrameRef = v50,
			getItemHeight = v71,
			items = v47,
			renderItem = v72,
			numColumns = if not v44 then v52.numColumns else if not FFlagSduiCollectionCarouselOverrides then nil else t2.numColumnsOverride,
			fractionalItemAmount = if not v44 then v52.fractionalItemAmount else nil,
			columnGap = if not v44 then v52.columnGap else nil,
			sideMargin = if not v44 then v52.sideMargin else nil,
			onViewableItemsChanged = v60,
			onChangeCanvasPosition = v60,
			LayoutOrder = layoutOrder,
			scrollingEnabledOverride = t2.scrollingEnabledOverride,
			AutomaticSize = if not v70 and not v64 then nil else Enum.AutomaticSize.Y,
			headerComponent = v76,
			backgroundMuralUrl = t2.backgroundMuralUrl,
			onScrollButtonEnter = v74,
			numItemsToRenderOffScreen = t2.numItemsToRenderOffScreen,
			enableHoverOverflow = t2.enableHoverOverflow,
			testId = not t2.testId and "--sdui-collection-carousel" or t2.testId
		}),
		ImpressionDetector = React.createElement(WaitForPropWrapper, {
			waitForProp = t2.startRow,
			maxUpdatesToDelay = t2.numUpdatesToDelayImpressions,
			wrappedComponent = if not FFlagLuaAppUseFrameBoundsImpressions and not t2.shouldUseFrameBoundsForImpressions then React.createElement(ScreenSizeImpressionsTracker, {
				parentRef = v50,
				pageContext = sduiContext.routeName or sduiContext.appPage,
				impressionsTag = v61,
				scrollViewPositionChangedSignal = v59,
				sendImpressions = v62,
				dataUpdatedTimestamp = t2.sduiContext.dataUpdatedTimestamp
			}) else React.createElement(FrameBoundsImpressionsTracker, {
				parentRef = v50,
				pageContext = sduiContext.routeName or sduiContext.appPage,
				impressionsTag = v61,
				scrollViewPositionChangedSignal = v59,
				sendImpressions = v62,
				dataUpdatedTimestamp = t2.sduiContext.dataUpdatedTimestamp,
				respectClipAncestors = if not FFlagLuaAppRespectClipAncestorImpressions then nil else t2.respectClipAncestors
			})
		}),
		ScrollDetector = React.createElement(ScrollDetector, {
			scrollingFrameRef = v50,
			sendScrollEvent = v75
		}),
		FocusNavActions = v77
	}))
end

return React.memo(SduiCollectionCarousel)
