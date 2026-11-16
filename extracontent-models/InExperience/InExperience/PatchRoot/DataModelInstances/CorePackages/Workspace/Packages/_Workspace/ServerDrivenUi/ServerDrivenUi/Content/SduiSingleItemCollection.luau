local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local parent = ServerDrivenUi.Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiErrorPaths = SharedFlags.FFlagSduiErrorPaths
require(parent.AppCommonLib)
local Cryo = require(parent.Cryo)
local React = require(parent.React)
require(parent.UnifiedLogging)

local GameCollections = require(parent.GameCollections)
local SendGameImpressions = GameCollections.SendGameImpressions
local GameCollections2 = require(parent.GameCollections)
local WaitForPropWrapper = GameCollections2.WaitForPropWrapper

local Impressions = require(parent.Impressions)
local ImpressionsTagUtility = Impressions.ImpressionsTagUtility
local ScreenSizeImpressionsTracker = Impressions.ScreenSizeImpressionsTracker

local SduiCoreSystem = require(parent.SduiCoreSystem)
local getImpressionsTag = require(ServerDrivenUi.Analytics.getImpressionsTag)
local reportUnifiedLoggingImpressions = SduiCoreSystem.reportUnifiedLoggingImpressions
local SduiCollectionAnalyticsBuilder = SduiCoreSystem.SduiCollectionAnalyticsBuilder

local findAnalyticsField = SduiCoreSystem.findAnalyticsField
local SduiBuilder = SduiCoreSystem.SduiBuilder
local SduiParsers = SduiCoreSystem.SduiParsers
local getSduiComponentWrapper = SduiCoreSystem.getSduiComponentWrapper

local v = {}

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

	local getCollectionData = React.useCallback(function()
		return ref.current
	end, { ref })

	local parentAnalyticsContext = React.useMemo(function()
		if props.componentConfig.__isClientBinding then
			props.analyticsContext.getCollectionData = getCollectionData
		end

		return Cryo.Dictionary.join(props.analyticsContext or v, {
			getCollectionData = getCollectionData
		})
	end, { getCollectionData, props.analyticsContext, props.componentConfig.__isClientBinding })

	ref.current = React.useMemo(function()
		local v2 = findAnalyticsField("componentType", props.analyticsContext.analyticsData or v)
			or SduiBuilder.getComponentType(props.componentConfig, sduiContext)

		return SduiCollectionAnalyticsBuilder.buildAndValidateCollectionAnalyticsData(
			sduiContext,
			props.analyticsContext.ancestorAnalyticsData,
			props.analyticsContext.analyticsData,
			v2,
			1,
			1,
			nil,
			`SingleItemCollection_{props.index}`,
			props.startRow
		)
	end, { sduiContext, props.analyticsContext, props.componentConfig, props.index, props.startRow })

	local impressionsTag = getImpressionsTag(props.index, ref.current, sduiContext, props.debugName)

	local ref3 = React.useRef(nil)
	React.useEffect(function()
		ImpressionsTagUtility.AddTag(ref3, impressionsTag, 1)
		return function()
			ImpressionsTagUtility.RemoveTag(ref3, impressionsTag, 1)
		end
	end, { ref3, impressionsTag })

	local sendImpressions = React.useCallback(function(p)
		if props.item == nil then
			return
		end

		assert(props.item, "props.item must exist")

		if props.impressionEventName or not ref.current or ref.current.contentType ~= "Game" then
			reportUnifiedLoggingImpressions(
				sduiContext,
				p,
				ref2.current,
				ref.current,
				props.startRow,
				props.impressionEventName,
				props.skipItemImpressionsLog,
				impressionsTag
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

			for _, v2 in ref2.current or v do
				table.insert(
					values,
					(Cryo.Dictionary.join(v2, {
						isSponsored = SduiParsers.safeParseBoolean(v2.adFlag, sduiContext, parentAnalyticsContext)
					}))
				)
			end

			SendGameImpressions.sendFromTopicContents(
				sduiContext.dependencies.eventIngest,
				sduiContext.dependencies.appAnalytics,
				p,
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

		reportUnifiedLoggingImpressions(sduiContext, p, ref2.current, ref.current)
	end, {
		props.item,
		props.index,
		props.startRow,
		sduiContext,
		ref,
		ref2,
		parentAnalyticsContext,
		props.impressionEventName,
		props.skipItemImpressionsLog,
		impressionsTag
	})

	local v2 = React.useMemo(function()
		local result = {}

		if props.children then
			for k, child in props.children do
				result[k] = React.cloneElement(child, {
					parentAnalyticsContext = parentAnalyticsContext
				})
			end
		end

		assert(result, "result must exist")

		if not props.item then
			return result
		end

		local itemComponentType = findAnalyticsField("componentType", props.item.analyticsData or v)
			or SduiBuilder.getComponentType(props.componentConfig, sduiContext)

		local formatted = `SingleItemCollection_{itemComponentType}`

		local localAnalyticsData = { itemPosition = 1, itemComponentType = itemComponentType }

		local current = ref2.current
		local buildAndValidateItemAnalyticsData = SduiCollectionAnalyticsBuilder.buildAndValidateItemAnalyticsData

		local analyticsData = props.item.analyticsData
		local v2

		if FFlagSduiErrorPaths then
			v2 = props.item.errorContext
		end

		current[1] = buildAndValidateItemAnalyticsData(
			sduiContext,
			analyticsData,
			nil,
			localAnalyticsData,
			itemComponentType,
			nil,
			v2
		)

		local sduiComponentWrapper = getSduiComponentWrapper(props.item)

		local createElement = React.createElement
		local v3 = {
			componentConfig = props.item,
			sduiContext = sduiContext,
			parentAnalyticsContext = 0,
			extraLocalProps = 0,
			debugName = 0,
			localAnalyticsData = 0
		}
		local parentAnalyticsContext2

		if not props.item.__isClientBinding then
			parentAnalyticsContext2 = parentAnalyticsContext
		end

		v3.parentAnalyticsContext = parentAnalyticsContext2
		local extraLocalProps = {
			scrollViewPositionChangedSignal = props.scrollViewPositionChangedSignal,
			verticalScrollingFrameRef = props.verticalScrollingFrameRef,
			index = 1,
			pageSideMargin = props.pageSideMargin,
			selectionOrder = 0
		}
		local selectionOrder

		if not props.disableSelectionOrder then
			selectionOrder = props.selectionOrderBase
		end

		extraLocalProps.selectionOrder = selectionOrder
		v3.extraLocalProps = extraLocalProps

		v3.debugName = formatted
		v3.localAnalyticsData = localAnalyticsData
		result[formatted] = createElement(sduiComponentWrapper, v3)

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

	local element = React.createElement(ScreenSizeImpressionsTracker, {
		parentRef = props.verticalScrollingFrameRef,
		pageContext = sduiContext.routeName or sduiContext.appPage,
		impressionsTag = impressionsTag,
		scrollViewPositionChangedSignal = props.scrollViewPositionChangedSignal,
		sendImpressions = sendImpressions,
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
		}, v2),
		ImpressionDetector = React.createElement(WaitForPropWrapper, {
			waitForProp = props.startRow,
			maxUpdatesToDelay = props.numUpdatesToDelayImpressions,
			wrappedComponent = element
		})
	})
end

return React.memo(SduiSingleItemCollection)
