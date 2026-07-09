local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local ServerDrivenUiParent = ServerDrivenUi.Parent
local React = require(ServerDrivenUiParent.React)

require(ServerDrivenUiParent.AppCommonLib)

local Cryo = require(ServerDrivenUiParent.Cryo)
local SignalsReact = require(ServerDrivenUiParent.SignalsReact)
local CollectionViews = require(ServerDrivenUiParent.CollectionViews)
local CollectionGrid = CollectionViews.CollectionGrid
local CollectionItemSize = CollectionViews.CollectionViewTypes.CollectionItemSize
local useCollectionImpressionsSignal = CollectionViews.useCollectionImpressionsSignal
local useCollectionLayout = CollectionViews.useCollectionLayout
local useCollectionLayoutParams = CollectionViews.useCollectionLayoutParams
local WaitForPropWrapper = require(ServerDrivenUiParent.GameCollections).WaitForPropWrapper
local Impressions = require(ServerDrivenUiParent.Impressions)
local FrameBoundsImpressionsTracker = Impressions.FrameBoundsImpressionsTracker
local ScreenSizeImpressionsTracker = Impressions.ScreenSizeImpressionsTracker
local useTokens = require(ServerDrivenUiParent.Foundation).Hooks.useTokens
local SduiCoreSystem = require(ServerDrivenUiParent.SduiCoreSystem)
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
local useCollectionAnalyticsContext = require(ServerDrivenUiParent.SduiSharedContent).useCollectionAnalyticsContext
local FFlagLuaAppLayoutParamsInContext = require(ServerDrivenUiParent.SharedFlags).FFlagLuaAppLayoutParamsInContext
local FFlagSduiCollectionGridMaxNumRows = require(ServerDrivenUiParent.SharedFlags).FFlagSduiCollectionGridMaxNumRows
local FFlagLuaAppCompositionAlways = require(ServerDrivenUiParent.SharedFlags).FFlagLuaAppCompositionAlways
local FFlagSduiEdpStoreImpressionsLogging = require(ServerDrivenUiParent.SharedFlags).FFlagSduiEdpStoreImpressionsLogging
local FFlagSduiPoolBackedFeed = require(ServerDrivenUiParent.SharedFlags).FFlagSduiPoolBackedFeed

local function cellSizeFromSpan(p1, n1: number, n2: number) -- line: 55
	local v40 = p1.colSpan or 1
	local v41 = p1.rowSpan or 1

	return UDim2.new(v40, n1 * (v40 - 1), v41, n2 * (v41 - 1))
end

local t1 = {}

local function SduiCollectionGrid(t2: {[any]: any}) -- line: 142
	-- upvalues: FFlagLuaAppCompositionAlways (copy), React (copy), t1 (copy), FFlagLuaAppLayoutParamsInContext (copy), SignalsReact (copy), useCollectionLayoutParams (copy), CollectionItemSize (copy), Cryo (copy), FFlagSduiPoolBackedFeed (copy), useCollectionLayout (copy), findAnalyticsField (copy), SduiBuilder (copy), useCollectionAnalyticsContext (copy), useCollectionImpressionsSignal (copy), getImpressionsTag (copy), SduiParseHelpers (copy), SduiErrors (copy), reportUnifiedLoggingImpressions (copy), FFlagSduiEdpStoreImpressionsLogging (copy), sendLegacyGameImpressionsForSdui (copy), useTokens (copy), SduiCollectionAnalyticsBuilder (copy), getSduiComponentWrapper (copy), SduiCollectionItem (copy), CollectionGrid (copy), FFlagSduiCollectionGridMaxNumRows (copy), WaitForPropWrapper (copy), FrameBoundsImpressionsTracker (copy), ScreenSizeImpressionsTracker (copy)
	local v43 = FFlagLuaAppCompositionAlways or (t2.appCompositionEnabled or t2.sduiContext.appCompositionEnabled)
	local layoutOrder = t2.layoutOrder
	local sduiContext = t2.sduiContext
	local v46 = React.useMemo(function() -- line: 152
		-- upvalues: t2 (copy), t1 (copy)
		if t2.items == nil then
			return t1
		end

		for _, v76 in t2.items do
			if t2.itemTemplateKey and v76.templateKey == nil then
				v76.templateKey = t2.itemTemplateKey
			end
		end

		return t2.items
	end, {
		t2.items,
		t2.itemTemplateKey
	})
	local v47, v48 = React.useState(nil)
	local v49 = React.useRef(nil)

	v49.current = v47

	local v50 = nil

	if not FFlagLuaAppCompositionAlways then
		if FFlagLuaAppLayoutParamsInContext then
			local v51 = React.useCallback(function(p2) -- line: 174
				-- upvalues: sduiContext (copy), t2 (copy)
				return sduiContext.getPageLayoutConfig(t2.collectionItemSize)(p2)
			end, {
				t2.collectionItemSize,
				sduiContext.getPageLayoutConfig
			})

			v50 = SignalsReact.useSignalState(v51)
		else
			v50 = useCollectionLayoutParams(t2.collectionItemSize or CollectionItemSize.Small, v47, false, if not t2.layoutOverrides then {
				overrideLoadMoreThreshold = 1e999,
				sideMargin = t2.pageSideMargin
			} else Cryo.Dictionary.join(t2.layoutOverrides, {
				overrideLoadMoreThreshold = 1e999,
				sideMargin = t2.pageSideMargin
			}))
		end
	end

	local n3

	if FFlagSduiPoolBackedFeed then
		n3 = 0

		if v46 then
			for _, v54 in v46 do
				if not v54.isBlank then
					n3 += 1
				end
			end
		end
	else
		n3 = not v46 and 0 or #v46
	end

	local v55 = useCollectionLayout(t2.collectionItemSize)
	local itemsPerRow = v55.itemsPerRow
	local v57 = if not v43 then v50.numColumns else itemsPerRow
	local u58 = nil
	local u59 = nil

	if FFlagSduiPoolBackedFeed then
		u58 = if not v43 then v50 and v50.columnGap or 0 else v55.gutter
		u59 = if not v43 then v50 and v50.verticalPadding or 0 else v55.verticalGap
	end

	local v60 = findAnalyticsField("componentType", t2.analyticsContext.analyticsData or t1) or SduiBuilder.getComponentType(t2.componentConfig, sduiContext)
	local v61, v62 = useCollectionAnalyticsContext(t2.analyticsContext, v60, v57, n3, sduiContext, t2.startRow, t2.componentConfig.__isClientBinding)
	local v63 = React.useRef({})
	local v64, v65 = useCollectionImpressionsSignal(t2.scrollViewPositionChangedSignal)
	local v66 = React.useCallback(function(_: number, _: number) -- line: 244
		-- upvalues: t2 (copy), v65 (copy)
		if t2.onCollectionViewabilityChanged then
			t2.onCollectionViewabilityChanged()
		end

		if v65 then
			v65()
		end
	end, {
		v65,
		t2.onCollectionViewabilityChanged
	})
	local v67 = t2.impressionsTag or getImpressionsTag(t2.index, v62.current, sduiContext, t2.debugName)
	local v68 = React.useCallback(function(t3: {[any]: any}) -- line: 260
		-- upvalues: v46 (copy), v61 (copy), SduiParseHelpers (copy), sduiContext (copy), SduiErrors (copy), v67 (copy), t2 (copy), v62 (copy), reportUnifiedLoggingImpressions (copy), v63 (copy), FFlagSduiEdpStoreImpressionsLogging (copy), sendLegacyGameImpressionsForSdui (copy)
		if v46 == nil or #v46 == 0 then
			if t3 and #t3 > 0 then
				local v81 = if not v61 then nil else SduiParseHelpers.stringifyValue(v61.analyticsData)

				sduiContext.dependencies.logger.reportError(SduiErrors.SduiErrorType.FailedToLogImpressions, {
					componentType = "CollectionGrid",
					name = v67,
					message = `Failed to log impressions. No configs. indexes: { table.concat(t3, ",") } analytics: { v81 }`
				}, sduiContext.appPage)
			end

			return
		end

		assert(v46, "itemConfigs must exist")

		if (t2.impressionEventName or not v62.current or v62.current.contentType ~= "Game") and not t2.sendGameImpressions then
			reportUnifiedLoggingImpressions(sduiContext, t3, v63.current, v62.current, t2.startRow, t2.impressionEventName, t2.skipItemImpressionsLog, if not FFlagSduiEdpStoreImpressionsLogging then nil else v67)

			return
		end

		if v62.current and v62.current.contentType == "Game" then
			sendLegacyGameImpressionsForSdui(t3, v63.current, v46, v61, v62.current, t2.startRow, sduiContext, t2.sendGameImpressions, v62.current.itemsPerRow, v67)
		end

		reportUnifiedLoggingImpressions(sduiContext, t3, v63.current, v62.current)
	end, {
		v46,
		t2.startRow,
		sduiContext,
		v62,
		v63,
		v61,
		t2.sendGameImpressions,
		v67,
		t2.impressionEventName,
		t2.skipItemImpressionsLog
	})

	React.useLayoutEffect(function() -- line: 339
		-- upvalues: t2 (copy), v68 (copy)
		if t2.setLogImpressions then
			t2.setLogImpressions(v68)
		end
	end, {
		v68,
		t2.setLogImpressions
	})

	local UIScale = useTokens().Config.UI.Scale
	local v70 = React.useCallback(function(n6: number) -- line: 348
		-- upvalues: t2 (copy), UIScale (copy)
		return n6 * t2.itemHeightFromWidth.Scale + t2.itemHeightFromWidth.Offset * UIScale
	end, {
		t2.itemHeightFromWidth,
		UIScale
	})
	local v71 = React.useCallback(function(p3, n7: number, p4, _) -- line: 354
		-- upvalues: FFlagSduiPoolBackedFeed (copy), React (copy), sduiContext (copy), SduiErrors (copy), v67 (copy), findAnalyticsField (copy), t1 (copy), SduiBuilder (copy), v63 (copy), SduiCollectionAnalyticsBuilder (copy), getSduiComponentWrapper (copy), v61 (copy), t2 (copy), SduiCollectionItem (copy), u58 (ref), u59 (ref)
		if FFlagSduiPoolBackedFeed and (p3 and p3.isBlank) then
			return React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = n7
			}), "blank"
		end

		if not p3 then
			sduiContext.dependencies.logger.reportError(SduiErrors.SduiErrorType.NilItem, {
				componentType = "CollectionGrid",
				name = v67,
				message = `Nil item in SduiCollectionGrid.renderItem at index { n7 }`
			}, sduiContext.appPage)

			return React.createElement(React.Fragment), "nil"
		end

		local v87 = findAnalyticsField("componentType", p3.analyticsData or t1) or SduiBuilder.getComponentType(p3, sduiContext)

		if not v87 then
			sduiContext.dependencies.logger.reportError(SduiErrors.SduiErrorType.NilComponentType, {
				componentType = "CollectionGrid",
				name = v67,
				message = `Nil componentType in CollectionGrid.renderItem at index { n7 }`
			}, sduiContext.appPage)

			return React.createElement(React.Fragment), "nil"
		end

		local t4 = {
			itemPosition = n7,
			itemComponentType = v87,
			componentType = v87,
			topicContentsIndex = if not FFlagSduiPoolBackedFeed then nil else p3.realIndex
		}

		v63.current[n7] = SduiCollectionAnalyticsBuilder.buildAndValidateItemAnalyticsData(sduiContext, p3.analyticsData, nil, t4, v87)

		local v89 = getSduiComponentWrapper(p3)
		local v90 = React.createElement(v89, {
			componentConfig = p3,
			sduiContext = sduiContext,
			parentAnalyticsContext = if not p3.__isClientBinding then v61 else nil,
			extraLocalProps = {
				scrollViewPositionChangedSignal = t2.scrollViewPositionChangedSignal,
				verticalScrollingFrameRef = t2.verticalScrollingFrameRef,
				index = n7,
				selectionOrder = if t2.disableSelectionOrder or not t2.selectionOrderBase then nil else t2.selectionOrderBase + n7
			},
			debugName = `{ v87 }_{ n7 }`,
			localAnalyticsData = t4
		})
		local createElement = React.createElement
		local v92 = SduiCollectionItem
		local t5 = {
			index = n7,
			impressionsTag = v67,
			size = p4,
			zIndex = -n7
		}
		local uDim2

		if FFlagSduiPoolBackedFeed and p3.spanOverride ~= nil then
			local spanOverride = p3.spanOverride
			local v95 = u58
			local v96 = u59
			local v97 = spanOverride.colSpan or 1
			local v98 = spanOverride.rowSpan or 1

			uDim2 = UDim2.new(v97, v95 * (v97 - 1), v98, v96 * (v98 - 1))
		else
			uDim2 = nil
		end

		t5.innerWrapperSize = uDim2

		return createElement(v92, t5, {
			Item = v90
		}), v87 or "unknown"
	end, {
		sduiContext,
		t2.analyticsContext,
		t2.scrollViewPositionChangedSignal,
		t2.verticalScrollingFrameRef,
		v61,
		v67,
		t2.index,
		t2.disableSelectionOrder,
		t2.selectionOrderBase,
		if not FFlagSduiPoolBackedFeed then nil else u58,
		if not FFlagSduiPoolBackedFeed then nil else u59
	})
	local v72 = React.useMemo(function() -- line: 457
		-- upvalues: t2 (copy), React (copy), v61 (copy)
		local t6 = nil

		if t2.children then
			t6 = {}

			for v101, v102 in t2.children do
				t6[v101] = React.cloneElement(v102, {
					parentAnalyticsContext = v61
				})
			end
		end

		return t6
	end, {
		v61,
		t2.children
	})
	local v73 = React.useMemo(function() -- line: 472
		-- upvalues: t2 (copy), React (copy), v61 (copy)
		if t2.headerComponent then
			return React.cloneElement(t2.headerComponent, {
				parentAnalyticsContext = v61
			})
		end

		return nil
	end, {
		v61,
		t2.headerComponent
	})
	local v74 = React.useMemo(function() -- line: 481
		-- upvalues: t2 (copy), React (copy), v61 (copy), v47 (copy)
		if t2.focusNavActionsComponent then
			return React.cloneElement(t2.focusNavActionsComponent, {
				parentAnalyticsContext = v61,
				extraLocalProps = {
					guiObject = v47
				}
			})
		end

		return nil
	end, {
		v61,
		t2.focusNavActionsComponent,
		v47
	})

	return React.createElement(React.Fragment, nil, Cryo.Dictionary.join(v72 or t1, {
		CollectionGrid = React.createElement(CollectionGrid, {
			disableRelativeGap = true,
			collectionItemSize = if not v43 then nil else t2.collectionItemSize,
			verticalScrollingFrameRef = t2.verticalScrollingFrameRef,
			containerRef = v48,
			getItemHeight = v70,
			items = v46,
			renderItem = v71,
			numColumns = if not v43 then v50.numColumns else nil,
			columnGap = if not v43 then v50.columnGap else nil,
			sideMargin = if not v43 then v50.sideMargin else nil,
			onViewableItemsChanged = v66,
			LayoutOrder = layoutOrder,
			verticalPadding = if not v43 then v50.verticalPadding else nil,
			headerComponent = v73,
			testId = not t2.testId and "--sdui-collection-grid" or t2.testId,
			onReachedThresholdFromEnd = t2.onReachedThresholdFromEnd,
			thresholdRowsFromBottom = t2.thresholdRowsFromBottom,
			maxNumRows = if not FFlagSduiCollectionGridMaxNumRows then nil else t2.maxNumRows
		}),
		ImpressionDetector = if not t2.disableImpressionsDetector then React.createElement(WaitForPropWrapper, {
			waitForProp = t2.startRow,
			maxUpdatesToDelay = t2.numUpdatesToDelayImpressions,
			wrappedComponent = if not t2.shouldUseFrameBoundsForImpressions then React.createElement(ScreenSizeImpressionsTracker, {
				parentRef = v49,
				pageContext = sduiContext.routeName or sduiContext.appPage,
				impressionsTag = v67,
				scrollViewPositionChangedSignal = v64,
				sendImpressions = v68,
				dataUpdatedTimestamp = t2.sduiContext.dataUpdatedTimestamp
			}) else React.createElement(FrameBoundsImpressionsTracker, {
				parentRef = v49,
				pageContext = sduiContext.routeName or sduiContext.appPage,
				impressionsTag = v67,
				scrollViewPositionChangedSignal = v64,
				sendImpressions = v68,
				dataUpdatedTimestamp = t2.sduiContext.dataUpdatedTimestamp
			})
		}) else nil,
		FocusNavActions = v74
	}))
end

return React.memo(SduiCollectionGrid)
