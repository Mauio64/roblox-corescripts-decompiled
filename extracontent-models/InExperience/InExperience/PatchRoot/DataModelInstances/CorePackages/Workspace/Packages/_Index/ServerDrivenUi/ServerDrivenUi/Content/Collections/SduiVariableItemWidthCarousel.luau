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
local FFlagLuaAppUseFrameBoundsImpressions = SharedFlags.FFlagLuaAppUseFrameBoundsImpressions
local t1 = {}

local function SduiVariableItemWidthCarousel(t2: {[any]: any}) -- line: 95
	-- upvalues: FFlagLuaAppCompositionAlways (copy), t1 (copy), useTokens (copy), React (copy), FFlagLuaAppLayoutParamsInContext (copy), SignalsReact (copy), useCollectionLayoutParams (copy), findAnalyticsField (copy), SduiBuilder (copy), SduiComponentType (copy), useCollectionAnalyticsContext (copy), useCollectionImpressionsSignal (copy), getImpressionsTag (copy), SduiParseHelpers (copy), SduiErrors (copy), reportUnifiedLoggingImpressions (copy), useScrollTelemetryCallback (copy), SduiCollectionAnalyticsBuilder (copy), getSduiComponentWrapper (copy), SduiCollectionItem (copy), VariableItemWidthCarousel (copy), WaitForPropWrapper (copy), FFlagLuaAppUseFrameBoundsImpressions (copy), FrameBoundsImpressionsTracker (copy), ScreenSizeImpressionsTracker (copy), ScrollDetector (copy)
	local sduiContext = t2.sduiContext
	local v36 = FFlagLuaAppCompositionAlways or (t2.appCompositionEnabled or sduiContext.appCompositionEnabled)
	local v37 = t2.items or t1
	local v38 = #v37
	local v39 = useTokens()
	local v40 = t2.itemHeight or v39.Size.Size_800
	local v41 = t2.itemPadding or v39.Padding.XSmall
	local v42, v43 = React.useState(nil)
	local t3 = {
		sideMargin = t2.pageSideMargin
	}
	local v45 = nil

	if not FFlagLuaAppCompositionAlways then
		if FFlagLuaAppLayoutParamsInContext then
			local v46 = React.useCallback(function(p1) -- line: 121
				-- upvalues: sduiContext (copy)
				return sduiContext.getPageLayoutConfig("Small")(p1)
			end, { sduiContext.getPageLayoutConfig })

			v45 = SignalsReact.useSignalState(v46)
		else
			v45 = useCollectionLayoutParams("Small", v42, false, t3)
		end
	end

	local v47 = if t2.sideMargin == nil then if not v36 then v45.sideMargin else 0 else t2.sideMargin
	local v48 = findAnalyticsField("componentType", t2.analyticsContext.analyticsData or t1) or (SduiBuilder.getComponentType(t2.componentConfig, sduiContext) or SduiComponentType.VariableItemWidthCarousel)
	local v49, v50 = useCollectionAnalyticsContext(t2.analyticsContext, v48, v38, v38, sduiContext, t2.startRow, t2.componentConfig.__isClientBinding)
	local v51 = React.useRef({})
	local v52, v53 = React.useState({})
	local v54 = React.useRef(nil)
	local v55, v56 = useCollectionImpressionsSignal(t2.scrollViewPositionChangedSignal)
	local v57 = getImpressionsTag(t2.index, v50.current, sduiContext, t2.debugName)
	local v58 = React.useCallback(function(n1: number, p2) -- line: 161
		-- upvalues: v53 (copy)
		local AbsoluteSizeX = p2.AbsoluteSize.X

		if AbsoluteSizeX <= 0 then
			return
		end

		v53(function(p3) -- line: 168
			-- upvalues: n1 (copy), AbsoluteSizeX (copy)
			if p3[n1] == AbsoluteSizeX then
				return p3
			end

			local v77 = table.clone(p3)

			v77[n1] = AbsoluteSizeX

			return v77
		end)
	end, {})
	local v59 = React.useCallback(function(n2: number) -- line: 179
		-- upvalues: v52 (copy)
		return v52[n2] or 0
	end, { v52 })
	local v60 = React.useCallback(function(t4: {[any]: any}) -- line: 184
		-- upvalues: v38 (copy), v49 (copy), SduiParseHelpers (copy), sduiContext (copy), SduiErrors (copy), v57 (copy), reportUnifiedLoggingImpressions (copy), v51 (copy), v50 (copy), t2 (copy)
		if v38 == 0 then
			if t4 and #t4 > 0 then
				local v69 = if not v49 then nil else SduiParseHelpers.stringifyValue(v49.analyticsData)

				sduiContext.dependencies.logger.reportError(SduiErrors.SduiErrorType.FailedToLogImpressions, {
					componentType = "VariableItemWidthCarousel",
					name = v57,
					message = `Failed to log impressions. No configs. indexes: { table.concat(t4, ",") } analytics: { v69 }`
				}, sduiContext.appPage)
			end

			return
		end

		reportUnifiedLoggingImpressions(sduiContext, t4, v51.current, v50.current, t2.startRow, t2.impressionEventName, t2.skipItemImpressionsLog)
	end, {
		v38,
		sduiContext,
		v51,
		v50,
		t2.startRow,
		t2.impressionEventName,
		t2.skipItemImpressionsLog,
		v49,
		v57
	})
	local v61 = useScrollTelemetryCallback(v54, v50, sduiContext)
	local v62 = React.useCallback(function(p4, n3: number) -- line: 225
		-- upvalues: sduiContext (copy), SduiErrors (copy), v57 (copy), React (copy), findAnalyticsField (copy), t1 (copy), SduiBuilder (copy), v51 (copy), SduiCollectionAnalyticsBuilder (copy), getSduiComponentWrapper (copy), v49 (copy), t2 (copy), SduiCollectionItem (copy), v40 (copy), v58 (copy)
		if not p4 then
			sduiContext.dependencies.logger.reportError(SduiErrors.SduiErrorType.NilItem, {
				componentType = "VariableItemWidthCarousel",
				name = v57,
				message = `Nil item in VariableItemWidthCarousel.renderItem at index { n3 }`
			}, sduiContext.appPage)

			return React.createElement(React.Fragment)
		end

		local v72 = findAnalyticsField("componentType", p4.analyticsData or t1) or SduiBuilder.getComponentType(p4, sduiContext)

		if not v72 then
			sduiContext.dependencies.logger.reportError(SduiErrors.SduiErrorType.NilComponentType, {
				componentType = "VariableItemWidthCarousel",
				name = v57,
				message = `Nil componentType in VariableItemWidthCarousel.renderItem at index { n3 }`
			}, sduiContext.appPage)

			return React.createElement(React.Fragment)
		end

		local t5 = {
			itemPosition = n3,
			itemComponentType = v72,
			componentType = v72
		}

		v51.current[n3] = SduiCollectionAnalyticsBuilder.buildAndValidateItemAnalyticsData(sduiContext, p4.analyticsData, nil, t5, v72)

		local v74 = getSduiComponentWrapper(p4)
		local v75 = React.createElement(v74, {
			componentConfig = p4,
			sduiContext = sduiContext,
			parentAnalyticsContext = if not p4.__isClientBinding then v49 else nil,
			extraLocalProps = {
				index = n3,
				scrollViewPositionChangedSignal = t2.scrollViewPositionChangedSignal,
				verticalScrollingFrameRef = t2.verticalScrollingFrameRef,
				selectionOrder = if not t2.selectionOrderBase then nil else t2.selectionOrderBase + n3
			},
			debugName = `{ v72 }_{ n3 }`,
			localAnalyticsData = t5
		})

		return React.createElement(SduiCollectionItem, {
			index = n3,
			impressionsTag = v57,
			automaticSize = Enum.AutomaticSize.X,
			size = UDim2.new(0, 0, 0, v40),
			onItemSizeChanged = v58
		}, {
			Item = v75
		})
	end, {
		sduiContext,
		v49,
		v57,
		v40,
		v58,
		t2.scrollViewPositionChangedSignal,
		t2.verticalScrollingFrameRef,
		t2.selectionOrderBase
	})

	return React.createElement(React.Fragment, nil, {
		Carousel = React.createElement(VariableItemWidthCarousel, {
			ref = v43,
			LayoutOrder = t2.layoutOrder,
			Position = t2.position,
			title = t2.title or "",
			subtitle = t2.subtitle,
			calculateItemWidth = v59,
			scrollButtonsEnabled = t2.scrollButtonsEnabled,
			scrollSpeed = t2.scrollSpeed,
			items = v37,
			itemHeight = v40,
			itemPadding = v41,
			onCanvasPositionChanged = v56,
			renderItem = v62,
			scrollingFrameRef = v54,
			sideMargin = v47
		}),
		ImpressionDetector = React.createElement(WaitForPropWrapper, {
			waitForProp = t2.startRow,
			maxUpdatesToDelay = t2.numUpdatesToDelayImpressions,
			wrappedComponent = React.createElement(if not FFlagLuaAppUseFrameBoundsImpressions and not t2.shouldUseFrameBoundsForImpressions then ScreenSizeImpressionsTracker else FrameBoundsImpressionsTracker, {
				parentRef = v54,
				pageContext = sduiContext.routeName or sduiContext.appPage,
				impressionsTag = v57,
				scrollViewPositionChangedSignal = v55,
				sendImpressions = v60,
				dataUpdatedTimestamp = t2.sduiContext.dataUpdatedTimestamp
			})
		}),
		ScrollDetector = React.createElement(ScrollDetector, {
			scrollingFrameRef = v54,
			sendScrollEvent = v61
		})
	})
end

return React.memo(SduiVariableItemWidthCarousel)
