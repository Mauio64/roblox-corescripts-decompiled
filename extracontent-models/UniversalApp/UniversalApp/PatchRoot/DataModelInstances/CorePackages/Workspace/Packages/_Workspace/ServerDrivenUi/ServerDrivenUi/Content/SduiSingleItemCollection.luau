local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local ServerDrivenUiParent = ServerDrivenUi.Parent

require(ServerDrivenUiParent.AppCommonLib)

local Cryo = require(ServerDrivenUiParent.Cryo)
local React = require(ServerDrivenUiParent.React)

require(ServerDrivenUiParent.UnifiedLogging)

local SendGameImpressions = require(ServerDrivenUiParent.GameCollections).SendGameImpressions
local WaitForPropWrapper = require(ServerDrivenUiParent.GameCollections).WaitForPropWrapper
local Impressions = require(ServerDrivenUiParent.Impressions)
local ImpressionsTagUtility = Impressions.ImpressionsTagUtility
local ScreenSizeImpressionsTracker = Impressions.ScreenSizeImpressionsTracker
local SduiCoreSystem = require(ServerDrivenUiParent.SduiCoreSystem)
local getImpressionsTag = require(ServerDrivenUi.Analytics.getImpressionsTag)
local reportUnifiedLoggingImpressions = SduiCoreSystem.reportUnifiedLoggingImpressions
local SduiCollectionAnalyticsBuilder = SduiCoreSystem.SduiCollectionAnalyticsBuilder
local findAnalyticsField = SduiCoreSystem.findAnalyticsField
local SduiBuilder = SduiCoreSystem.SduiBuilder
local SduiParsers = SduiCoreSystem.SduiParsers
local getSduiComponentWrapper = SduiCoreSystem.getSduiComponentWrapper
local FFlagSduiEdpStoreImpressionsLogging = require(ServerDrivenUiParent.SharedFlags).FFlagSduiEdpStoreImpressionsLogging
local t1 = {}

local function SduiSingleItemCollection(t2: {[any]: any}) -- line: 74
	-- upvalues: React (copy), Cryo (copy), t1 (copy), findAnalyticsField (copy), SduiBuilder (copy), SduiCollectionAnalyticsBuilder (copy), getImpressionsTag (copy), ImpressionsTagUtility (copy), reportUnifiedLoggingImpressions (copy), FFlagSduiEdpStoreImpressionsLogging (copy), SduiParsers (copy), SendGameImpressions (copy), getSduiComponentWrapper (copy), ScreenSizeImpressionsTracker (copy), WaitForPropWrapper (copy)
	local layoutOrder = t2.layoutOrder
	local anchorPoint = t2.anchorPoint
	local automaticSize = t2.automaticSize
	local size = t2.size
	local position = t2.position
	local sduiContext = t2.sduiContext
	local children = t2.children
	local v29 = React.useRef(nil)
	local v30 = React.useRef({})
	local v31 = React.useCallback(function() -- line: 91
		-- upvalues: v29 (copy)
		return v29.current
	end, { v29 })
	local v32 = React.useMemo(function() -- line: 97
		-- upvalues: t2 (copy), v31 (copy), Cryo (copy), t1 (copy)
		if t2.componentConfig.__isClientBinding then
			t2.analyticsContext.getCollectionData = v31
		end

		return Cryo.Dictionary.join(t2.analyticsContext or t1, {
			getCollectionData = v31
		})
	end, {
		v31,
		t2.analyticsContext,
		t2.componentConfig.__isClientBinding
	})

	v29.current = React.useMemo(function() -- line: 117
		-- upvalues: findAnalyticsField (copy), t2 (copy), t1 (copy), SduiBuilder (copy), sduiContext (copy), SduiCollectionAnalyticsBuilder (copy)
		local v38 = findAnalyticsField("componentType", t2.analyticsContext.analyticsData or t1) or SduiBuilder.getComponentType(t2.componentConfig, sduiContext)

		return SduiCollectionAnalyticsBuilder.buildAndValidateCollectionAnalyticsData(sduiContext, t2.analyticsContext.ancestorAnalyticsData, t2.analyticsContext.analyticsData, v38, 1, 1, nil, `SingleItemCollection_{ t2.index }`, t2.startRow)
	end, {
		sduiContext,
		t2.analyticsContext,
		t2.componentConfig,
		t2.index,
		t2.startRow
	})

	local v33 = getImpressionsTag(t2.index, v29.current, sduiContext, t2.debugName)
	local v34 = React.useRef(nil)

	React.useEffect(function() -- line: 149
		-- upvalues: ImpressionsTagUtility (copy), v34 (copy), v33 (copy)
		ImpressionsTagUtility.AddTag(v34, v33, 1)

		return function() -- line: 152
			-- upvalues: ImpressionsTagUtility (copy), v34 (copy), v33 (copy)
			ImpressionsTagUtility.RemoveTag(v34, v33, 1)
		end
	end, {
		v34,
		v33
	})

	local v35 = React.useCallback(function(t3: {[any]: any}) -- line: 159
		-- upvalues: t2 (copy), v29 (copy), reportUnifiedLoggingImpressions (copy), sduiContext (copy), v30 (copy), FFlagSduiEdpStoreImpressionsLogging (copy), v33 (copy), t1 (copy), Cryo (copy), SduiParsers (copy), v32 (copy), SendGameImpressions (copy)
		if t2.item == nil then
			return
		end

		assert(t2.item, "props.item must exist")

		if t2.impressionEventName or not v29.current or v29.current.contentType ~= "Game" then
			reportUnifiedLoggingImpressions(sduiContext, t3, v30.current, v29.current, t2.startRow, t2.impressionEventName, t2.skipItemImpressionsLog, if not FFlagSduiEdpStoreImpressionsLogging then nil else v33)

			return
		end

		if v29.current and ((v29.current.contentType == "HeroUnit" or v29.current.contentType == "Game") and (t2.item.analyticsData and t2.item.analyticsData.universeId ~= nil)) then
			local t4 = {}

			for _, v42 in v30.current or t1 do
				table.insert(t4, (Cryo.Dictionary.join(v42, {
					isSponsored = SduiParsers.safeParseBoolean(v42.adFlag, sduiContext, v32)
				})))
			end

			SendGameImpressions.sendFromTopicContents(sduiContext.dependencies.eventIngest, sduiContext.dependencies.appAnalytics, t3, t4, sduiContext.appPage, tostring(v29.current.collectionId), t2.index, t2.startRow, nil, nil, 1, false, "HeroUnit", nil)
		end

		reportUnifiedLoggingImpressions(sduiContext, t3, v30.current, v29.current)
	end, {
		t2.item,
		t2.index,
		t2.startRow,
		sduiContext,
		v29,
		v30,
		v32,
		t2.impressionEventName,
		t2.skipItemImpressionsLog,
		if not FFlagSduiEdpStoreImpressionsLogging then nil else v33
	})
	local v36 = React.useMemo(function() -- line: 248
		-- upvalues: t2 (copy), React (copy), v32 (copy), findAnalyticsField (copy), t1 (copy), SduiBuilder (copy), sduiContext (copy), v30 (copy), SduiCollectionAnalyticsBuilder (copy), getSduiComponentWrapper (copy)
		local t5 = {}

		if t2.children then
			for v44, v45 in t2.children do
				t5[v44] = React.cloneElement(v45, {
					parentAnalyticsContext = v32
				})
			end
		end

		assert(t5, "result must exist")

		if t2.item then
			local v46 = findAnalyticsField("componentType", t2.item.analyticsData or t1) or SduiBuilder.getComponentType(t2.componentConfig, sduiContext)
			local v47 = `SingleItemCollection_{ v46 }`
			local t6 = {
				itemPosition = 1,
				itemComponentType = v46
			}

			v30.current[1] = SduiCollectionAnalyticsBuilder.buildAndValidateItemAnalyticsData(sduiContext, t2.item.analyticsData, nil, t6, v46)

			local v49 = getSduiComponentWrapper(t2.item)

			t5[v47] = React.createElement(v49, {
				componentConfig = t2.item,
				sduiContext = sduiContext,
				parentAnalyticsContext = if not t2.item.__isClientBinding then v32 else nil,
				extraLocalProps = {
					index = 1,
					scrollViewPositionChangedSignal = t2.scrollViewPositionChangedSignal,
					verticalScrollingFrameRef = t2.verticalScrollingFrameRef,
					pageSideMargin = t2.pageSideMargin,
					selectionOrder = if t2.disableSelectionOrder then nil else t2.selectionOrderBase
				},
				debugName = v47,
				localAnalyticsData = t6
			})
		end

		return t5
	end, {
		t2.item,
		t2.scrollViewPositionChangedSignal,
		t2.verticalScrollingFrameRef,
		v29,
		children,
		sduiContext,
		t2.pageSideMargin,
		t2.disableSelectionOrder,
		t2.selectionOrderBase
	})
	local v37 = React.createElement(ScreenSizeImpressionsTracker, {
		parentRef = t2.verticalScrollingFrameRef,
		pageContext = sduiContext.routeName or sduiContext.appPage,
		impressionsTag = v33,
		scrollViewPositionChangedSignal = t2.scrollViewPositionChangedSignal,
		sendImpressions = v35,
		dataUpdatedTimestamp = t2.sduiContext.dataUpdatedTimestamp
	})

	return React.createElement(React.Fragment, nil, {
		Content = React.createElement("Frame", {
			ref = v34,
			Position = position,
			Size = size or UDim2.new(1, 0, 0, 0),
			AutomaticSize = automaticSize or Enum.AutomaticSize.Y,
			LayoutOrder = layoutOrder,
			AnchorPoint = anchorPoint,
			BackgroundTransparency = 1,
			[React.Tag] = "data-testid=--sdui-single-item-collection"
		}, v36),
		ImpressionDetector = React.createElement(WaitForPropWrapper, {
			waitForProp = t2.startRow,
			maxUpdatesToDelay = t2.numUpdatesToDelayImpressions,
			wrappedComponent = v37
		})
	})
end

return React.memo(SduiSingleItemCollection)
