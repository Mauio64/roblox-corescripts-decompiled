local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local ServerDrivenUiParent = ServerDrivenUi.Parent
local React = require(ServerDrivenUiParent.React)

require(ServerDrivenUiParent.AppCommonLib)

local SignalsReact = require(ServerDrivenUiParent.SignalsReact)
local CollectionViews = require(ServerDrivenUiParent.CollectionViews)
local useCollectionImpressionsSignal = CollectionViews.useCollectionImpressionsSignal
local useCollectionLayoutParams = CollectionViews.useCollectionLayoutParams
local VariableItemWidthCarousel = require(ServerDrivenUiParent.VariableItemWidthCarousel).VariableItemWidthCarousel
local WaitForPropWrapper = require(ServerDrivenUiParent.GameCollections).WaitForPropWrapper
local Impressions = require(ServerDrivenUiParent.Impressions)
local FrameBoundsImpressionsTracker = Impressions.FrameBoundsImpressionsTracker
local ScreenSizeImpressionsTracker = Impressions.ScreenSizeImpressionsTracker
local ScrollDetector = require(ServerDrivenUiParent.ScrollTelemetry).ScrollDetector
local useTokens = require(ServerDrivenUiParent.Foundation).Hooks.useTokens
local SduiCoreSystem = require(ServerDrivenUiParent.SduiCoreSystem)
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
local useCollectionAnalyticsContext = require(ServerDrivenUiParent.SduiSharedContent).useCollectionAnalyticsContext
local useScrollTelemetryCallback = require(ServerDrivenUi.Analytics.useScrollTelemetryCallback)
local SharedFlags = require(ServerDrivenUiParent.SharedFlags)
local FFlagLuaAppCompositionAlways = SharedFlags.FFlagLuaAppCompositionAlways
local FFlagLuaAppLayoutParamsInContext = SharedFlags.FFlagLuaAppLayoutParamsInContext
local FFlagLuaAppRespectClipAncestorImpressions = SharedFlags.FFlagLuaAppRespectClipAncestorImpressions
local FFlagLuaAppUseFrameBoundsImpressions = SharedFlags.FFlagLuaAppUseFrameBoundsImpressions
local t1 = {}

local function SduiVariableItemWidthCarousel(t2: {[any]: any}) -- line: 97
	-- upvalues: FFlagLuaAppCompositionAlways (copy), t1 (copy), useTokens (copy), React (copy), FFlagLuaAppLayoutParamsInContext (copy), SignalsReact (copy), useCollectionLayoutParams (copy), findAnalyticsField (copy), SduiBuilder (copy), SduiComponentType (copy), useCollectionAnalyticsContext (copy), useCollectionImpressionsSignal (copy), getImpressionsTag (copy), SduiParseHelpers (copy), SduiErrors (copy), reportUnifiedLoggingImpressions (copy), useScrollTelemetryCallback (copy), SduiCollectionAnalyticsBuilder (copy), getSduiComponentWrapper (copy), SduiCollectionItem (copy), VariableItemWidthCarousel (copy), WaitForPropWrapper (copy), FFlagLuaAppUseFrameBoundsImpressions (copy), FrameBoundsImpressionsTracker (copy), ScreenSizeImpressionsTracker (copy), FFlagLuaAppRespectClipAncestorImpressions (copy), ScrollDetector (copy)
	local sduiContext = t2.sduiContext
	local v37 = FFlagLuaAppCompositionAlways or (t2.appCompositionEnabled or sduiContext.appCompositionEnabled)
	local v38 = t2.items or t1
	local v39 = #v38
	local v40 = useTokens()
	local v41 = t2.itemHeight or v40.Size.Size_800
	local v42 = t2.itemPadding or v40.Padding.XSmall
	local v43, v44 = React.useState(nil)
	local t3 = {
		sideMargin = t2.pageSideMargin
	}
	local v46 = nil

	if not FFlagLuaAppCompositionAlways then
		if FFlagLuaAppLayoutParamsInContext then
			local v47 = React.useCallback(function(p1) -- line: 123
				-- upvalues: sduiContext (copy)
				return sduiContext.getPageLayoutConfig("Small")(p1)
			end, { sduiContext.getPageLayoutConfig })

			v46 = SignalsReact.useSignalState(v47)
		else
			v46 = useCollectionLayoutParams("Small", v43, false, t3)
		end
	end

	local v48 = if t2.sideMargin == nil then if not v37 then v46.sideMargin else 0 else t2.sideMargin
	local v49 = findAnalyticsField("componentType", t2.analyticsContext.analyticsData or t1) or (SduiBuilder.getComponentType(t2.componentConfig, sduiContext) or SduiComponentType.VariableItemWidthCarousel)
	local v50, v51 = useCollectionAnalyticsContext(t2.analyticsContext, v49, v39, v39, sduiContext, t2.startRow, t2.componentConfig.__isClientBinding)
	local v52 = React.useRef({})
	local v53, v54 = React.useState({})
	local v55 = React.useRef(nil)
	local v56, v57 = useCollectionImpressionsSignal(t2.scrollViewPositionChangedSignal)
	local v58 = getImpressionsTag(t2.index, v51.current, sduiContext, t2.debugName)
	local v59 = React.useCallback(function(n1: number, p2) -- line: 163
		-- upvalues: v54 (copy)
		local AbsoluteSizeX = p2.AbsoluteSize.X

		if AbsoluteSizeX <= 0 then
			return
		end

		v54(function(p3) -- line: 170
			-- upvalues: n1 (copy), AbsoluteSizeX (copy)
			if p3[n1] == AbsoluteSizeX then
				return p3
			end

			local v78 = table.clone(p3)

			v78[n1] = AbsoluteSizeX

			return v78
		end)
	end, {})
	local v60 = React.useCallback(function(n2: number) -- line: 181
		-- upvalues: v53 (copy)
		return v53[n2] or 0
	end, { v53 })
	local v61 = React.useCallback(function(t4: {[any]: any}) -- line: 186
		-- upvalues: v39 (copy), v50 (copy), SduiParseHelpers (copy), sduiContext (copy), SduiErrors (copy), v58 (copy), reportUnifiedLoggingImpressions (copy), v52 (copy), v51 (copy), t2 (copy)
		if v39 == 0 then
			if t4 and #t4 > 0 then
				local v70 = if not v50 then nil else SduiParseHelpers.stringifyValue(v50.analyticsData)

				sduiContext.dependencies.logger.reportError(SduiErrors.SduiErrorType.FailedToLogImpressions, {
					componentType = "VariableItemWidthCarousel",
					name = v58,
					message = `Failed to log impressions. No configs. indexes: { table.concat(t4, ",") } analytics: { v70 }`
				}, sduiContext.appPage)
			end

			return
		end

		reportUnifiedLoggingImpressions(sduiContext, t4, v52.current, v51.current, t2.startRow, t2.impressionEventName, t2.skipItemImpressionsLog)
	end, {
		v39,
		sduiContext,
		v52,
		v51,
		t2.startRow,
		t2.impressionEventName,
		t2.skipItemImpressionsLog,
		v50,
		v58
	})
	local v62 = useScrollTelemetryCallback(v55, v51, sduiContext)
	local v63 = React.useCallback(function(p4, n3: number) -- line: 227
		-- upvalues: sduiContext (copy), SduiErrors (copy), v58 (copy), React (copy), findAnalyticsField (copy), t1 (copy), SduiBuilder (copy), v52 (copy), SduiCollectionAnalyticsBuilder (copy), getSduiComponentWrapper (copy), v50 (copy), t2 (copy), SduiCollectionItem (copy), v41 (copy), v59 (copy)
		if not p4 then
			sduiContext.dependencies.logger.reportError(SduiErrors.SduiErrorType.NilItem, {
				componentType = "VariableItemWidthCarousel",
				name = v58,
				message = `Nil item in VariableItemWidthCarousel.renderItem at index { n3 }`
			}, sduiContext.appPage)

			return React.createElement(React.Fragment)
		end

		local v73 = findAnalyticsField("componentType", p4.analyticsData or t1) or SduiBuilder.getComponentType(p4, sduiContext)

		if not v73 then
			sduiContext.dependencies.logger.reportError(SduiErrors.SduiErrorType.NilComponentType, {
				componentType = "VariableItemWidthCarousel",
				name = v58,
				message = `Nil componentType in VariableItemWidthCarousel.renderItem at index { n3 }`
			}, sduiContext.appPage)

			return React.createElement(React.Fragment)
		end

		local t5 = {
			itemPosition = n3,
			itemComponentType = v73,
			componentType = v73
		}

		v52.current[n3] = SduiCollectionAnalyticsBuilder.buildAndValidateItemAnalyticsData(sduiContext, p4.analyticsData, nil, t5, v73)

		local v75 = getSduiComponentWrapper(p4)
		local v76 = React.createElement(v75, {
			componentConfig = p4,
			sduiContext = sduiContext,
			parentAnalyticsContext = if not p4.__isClientBinding then v50 else nil,
			extraLocalProps = {
				index = n3,
				scrollViewPositionChangedSignal = t2.scrollViewPositionChangedSignal,
				verticalScrollingFrameRef = t2.verticalScrollingFrameRef,
				selectionOrder = if not t2.selectionOrderBase then nil else t2.selectionOrderBase + n3
			},
			debugName = `{ v73 }_{ n3 }`,
			localAnalyticsData = t5
		})

		return React.createElement(SduiCollectionItem, {
			index = n3,
			impressionsTag = v58,
			automaticSize = Enum.AutomaticSize.X,
			size = UDim2.new(0, 0, 0, v41),
			onItemSizeChanged = v59
		}, {
			Item = v76
		})
	end, {
		sduiContext,
		v50,
		v58,
		v41,
		v59,
		t2.scrollViewPositionChangedSignal,
		t2.verticalScrollingFrameRef,
		t2.selectionOrderBase
	})

	return React.createElement(React.Fragment, nil, {
		Carousel = React.createElement(VariableItemWidthCarousel, {
			ref = v44,
			LayoutOrder = t2.layoutOrder,
			Position = t2.position,
			title = t2.title or "",
			subtitle = t2.subtitle,
			calculateItemWidth = v60,
			scrollButtonsEnabled = t2.scrollButtonsEnabled,
			scrollSpeed = t2.scrollSpeed,
			items = v38,
			itemHeight = v41,
			itemPadding = v42,
			onCanvasPositionChanged = v57,
			renderItem = v63,
			scrollingFrameRef = v55,
			sideMargin = v48
		}),
		ImpressionDetector = React.createElement(WaitForPropWrapper, {
			waitForProp = t2.startRow,
			maxUpdatesToDelay = t2.numUpdatesToDelayImpressions,
			wrappedComponent = React.createElement(if not FFlagLuaAppUseFrameBoundsImpressions and not t2.shouldUseFrameBoundsForImpressions then ScreenSizeImpressionsTracker else FrameBoundsImpressionsTracker, {
				parentRef = v55,
				pageContext = sduiContext.routeName or sduiContext.appPage,
				impressionsTag = v58,
				scrollViewPositionChangedSignal = v56,
				sendImpressions = v61,
				dataUpdatedTimestamp = t2.sduiContext.dataUpdatedTimestamp,
				respectClipAncestors = if not FFlagLuaAppRespectClipAncestorImpressions then nil else t2.respectClipAncestors
			})
		}),
		ScrollDetector = React.createElement(ScrollDetector, {
			scrollingFrameRef = v55,
			sendScrollEvent = v62
		})
	})
end

return React.memo(SduiVariableItemWidthCarousel)
