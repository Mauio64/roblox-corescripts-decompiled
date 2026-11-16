local fFlagSduiErrorPaths = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSduiErrorPaths
require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/AppCommonLib")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/UnifiedLogging")

local sendGameImpressions = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/GameCollections").SendGameImpressions
local waitForPropWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/GameCollections").WaitForPropWrapper

local Impressions = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Impressions")
local impressionsTagUtility = Impressions.ImpressionsTagUtility
local screenSizeImpressionsTracker = Impressions.ScreenSizeImpressionsTracker

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local getImpressionsTag = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Analytics/getImpressionsTag")
local reportUnifiedLoggingImpressions = SduiCoreSystem.reportUnifiedLoggingImpressions
local sduiCollectionAnalyticsBuilder = SduiCoreSystem.SduiCollectionAnalyticsBuilder

local findAnalyticsField = SduiCoreSystem.findAnalyticsField
local sduiBuilder = SduiCoreSystem.SduiBuilder
local sduiParsers = SduiCoreSystem.SduiParsers
local getSduiComponentWrapper = SduiCoreSystem.getSduiComponentWrapper

local v5 = {}

local function SduiSingleItemCollection(props)
	local layoutOrder = props.layoutOrder
	local anchorPoint = props.anchorPoint
	local automaticSize = props.automaticSize
	local size = props.size
	local position = props.position

	local sduiContext = props.sduiContext
	local children = props.children

	local ref = React.useRef(nil)

	local ref2 = React.useRef({})

	local v6 = React.useCallback(function()
		return ref.current
	end, { ref })

	local v7 = React.useMemo(function()
		if props.componentConfig.__isClientBinding then
			props.analyticsContext.getCollectionData = v6
		end

		return Cryo.Dictionary.join(props.analyticsContext or v5, {
			getCollectionData = v6
		})
	end, { v6, props.analyticsContext, props.componentConfig.__isClientBinding })

	ref.current = React.useMemo(function()
		local v8 = findAnalyticsField("componentType", props.analyticsContext.analyticsData or v5)
			or sduiBuilder.getComponentType(props.componentConfig, sduiContext)

		return sduiCollectionAnalyticsBuilder.buildAndValidateCollectionAnalyticsData(
			sduiContext,
			props.analyticsContext.ancestorAnalyticsData,
			props.analyticsContext.analyticsData,
			v8,
			1,
			1,
			nil,
			`SingleItemCollection_{props.index}`,
			props.startRow
		)
	end, {
		sduiContext,
		props.analyticsContext,
		props.componentConfig,
		props.index,
		props.startRow
	})

	local v8 = getImpressionsTag(props.index, ref.current, sduiContext, props.debugName)

	local ref3 = React.useRef(nil)
	React.useEffect(function()
		impressionsTagUtility.AddTag(ref3, v8, 1)
		return function()
			impressionsTagUtility.RemoveTag(ref3, v8, 1)
		end
	end, { ref3, v8 })

	local v9 = React.useCallback(function(p2)
		if props.item == nil then
			return
		end

		assert(props.item, "props.item must exist")

		if props.impressionEventName or not ref.current or ref.current.contentType ~= "Game" then
			reportUnifiedLoggingImpressions(
				sduiContext,
				p2,
				ref2.current,
				ref.current,
				props.startRow,
				props.impressionEventName,
				props.skipItemImpressionsLog,
				v8
			)
			return
		end

		if
			ref.current
			and (ref.current.contentType == "HeroUnit" or ref.current.contentType == "Game")
			and props.item.analyticsData
			and props.item.analyticsData.universeId ~= nil
		then
			local values = {}

			for k, v10 in ref2.current or v5 do
				table.insert(
					values,
					(Cryo.Dictionary.join(v10, {
						isSponsored = sduiParsers.safeParseBoolean(v10.adFlag, sduiContext, v7)
					}))
				)
			end

			sendGameImpressions.sendFromTopicContents(
				sduiContext.dependencies.eventIngest,
				sduiContext.dependencies.appAnalytics,
				p2,
				values,
				sduiContext.appPage,
				tostring(ref.current.collectionId),
				props.index,
				props.startRow,
				nil,
				nil,
				1,
				false,
				"HeroUnit",
				nil
			)
		end

		reportUnifiedLoggingImpressions(sduiContext, p2, ref2.current, ref.current)
	end, {
		props.item,
		props.index,
		props.startRow,
		sduiContext,
		ref,
		ref2,
		v7,
		props.impressionEventName,
		props.skipItemImpressionsLog,
		v8
	})

	local v10 = React.useMemo(function()
		local result = {}

		if props.children then
			for k, child in props.children do
				result[k] = React.cloneElement(child, { parentAnalyticsContext = v7 })
			end
		end

		assert(result, "result must exist")

		if not props.item then
			return result
		end

		local v11 = findAnalyticsField("componentType", props.item.analyticsData or v5)
			or sduiBuilder.getComponentType(props.componentConfig, sduiContext)

		local formatted = `SingleItemCollection_{v11}`

		local v12 = { itemPosition = 1, itemComponentType = v11 }

		local current = ref2.current
		local buildAndValidateItemAnalyticsData = sduiCollectionAnalyticsBuilder.buildAndValidateItemAnalyticsData

		local analyticsData = props.item.analyticsData

		local v16 = if fFlagSduiErrorPaths then props.item.errorContext else nil
		current[1] = buildAndValidateItemAnalyticsData(sduiContext, analyticsData, nil, v12, v11, nil, v16)

		local sduiComponentWrapper = getSduiComponentWrapper(props.item)

		local createElement = React.createElement
		local v17 = {
			componentConfig = props.item,
			sduiContext = sduiContext,
			parentAnalyticsContext = 0,
			extraLocalProps = 0,
			debugName = 0,
			localAnalyticsData = 0
		}

		local v18 = if not props.item.__isClientBinding then v7 else nil
		v17.parentAnalyticsContext = v18
		local v19 = {
			scrollViewPositionChangedSignal = props.scrollViewPositionChangedSignal,
			verticalScrollingFrameRef = props.verticalScrollingFrameRef,
			index = 1,
			pageSideMargin = props.pageSideMargin,
			selectionOrder = 0
		}
		local v20 = if not props.disableSelectionOrder then props.selectionOrderBase else nil
		v19.selectionOrder = v20
		v17.extraLocalProps = v19

		v17.debugName = formatted
		v17.localAnalyticsData = v12
		result[formatted] = createElement(sduiComponentWrapper, v17)

		return result
	end, {
		props.item,
		props.scrollViewPositionChangedSignal,
		props.verticalScrollingFrameRef,
		ref,
		children,
		sduiContext,
		props.pageSideMargin,
		props.disableSelectionOrder,
		props.selectionOrderBase
	})

	local element = React.createElement(screenSizeImpressionsTracker, {
		parentRef = props.verticalScrollingFrameRef,
		pageContext = sduiContext.routeName or sduiContext.appPage,
		impressionsTag = v8,
		scrollViewPositionChangedSignal = props.scrollViewPositionChangedSignal,
		sendImpressions = v9,
		dataUpdatedTimestamp = props.sduiContext.dataUpdatedTimestamp
	})

	return React.createElement(React.Fragment, nil, {
		Content = React.createElement("Frame", {
			ref = ref3,
			Position = position,
			Size = size or UDim2.new(1, 0, 0, 0),
			AutomaticSize = automaticSize or Enum.AutomaticSize.Y,
			LayoutOrder = layoutOrder,
			AnchorPoint = anchorPoint,
			BackgroundTransparency = 1,
			[React.Tag] = "data-testid=--sdui-single-item-collection"
		}, v10),
		ImpressionDetector = React.createElement(waitForPropWrapper, {
			waitForProp = props.startRow,
			maxUpdatesToDelay = props.numUpdatesToDelayImpressions,
			wrappedComponent = element
		})
	})
end

return React.memo(SduiSingleItemCollection)
