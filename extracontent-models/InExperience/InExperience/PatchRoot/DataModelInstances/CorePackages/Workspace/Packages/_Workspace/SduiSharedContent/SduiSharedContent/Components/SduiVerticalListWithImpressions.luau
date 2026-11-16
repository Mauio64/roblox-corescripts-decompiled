local parent = script:FindFirstAncestor("SduiSharedContent").Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiErrorPaths = SharedFlags.FFlagSduiErrorPaths

local React = require(parent.React)
require(parent.AppCommonLib)

local Impressions = require(parent.Impressions)
local FrameBoundsImpressionsTracker = Impressions.FrameBoundsImpressionsTracker
local ImpressionsTagUtility = Impressions.ImpressionsTagUtility

require(parent.UnifiedLogging)

local SduiCoreSystem = require(parent.SduiCoreSystem)
local findAnalyticsField = SduiCoreSystem.findAnalyticsField
local getSduiComponentWrapper = SduiCoreSystem.getSduiComponentWrapper
local reportUnifiedLoggingImpressions = SduiCoreSystem.reportUnifiedLoggingImpressions
local SduiBuilder = SduiCoreSystem.SduiBuilder
local SduiCollectionAnalyticsBuilder = SduiCoreSystem.SduiCollectionAnalyticsBuilder
local SduiErrors = SduiCoreSystem.SduiErrors
local addSduiErrorContextFields = SduiCoreSystem.addSduiErrorContextFields

local SduiFeedContext = require(script.Parent.SduiFeedContext)
local SduiView = require(script.Parent.SduiView)
local useCollectionAnalyticsContext = require(script.Parent.useCollectionAnalyticsContext)

local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppRespectClipAncestorImpressions = SharedFlags2.FFlagLuaAppRespectClipAncestorImpressions
local FFlagSduiCarouselUseNestedImpressionsFeedContext = SharedFlags2.FFlagSduiCarouselUseNestedImpressionsFeedContext

local SduiParseHelpers = SduiCoreSystem.SduiParseHelpers

local frozen = table.freeze({})

local function ImpressionTaggedSduiItem(props)
	local ref = React.useRef(nil)

	React.useEffect(function()
		if not props.impressionsTag then
			return
		end

		ImpressionsTagUtility.AddTag(ref, props.impressionsTag, props.index)
		return function()
			ImpressionsTagUtility.RemoveTag(ref, props.impressionsTag, props.index)
		end
	end, { props.impressionsTag, props.index })

	local ref2 = React.useCallback(function(current)
		ref.current = current

		if current and props.impressionsTag then
			ImpressionsTagUtility.AddTag(ref, props.impressionsTag, props.index)
		end
	end, { props.impressionsTag, props.index })

	local sduiComponentWrapper = getSduiComponentWrapper(props.item)

	local createElement = React.createElement
	local v = {
		ref = ref2,
		BackgroundTransparency = 1,
		LayoutOrder = props.index,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}

	local createElement2 = React.createElement
	local v2 = {
		componentConfig = props.item,
		sduiContext = props.sduiContext,
		parentAnalyticsContext = 0,
		extraLocalProps = 0,
		debugName = 0,
		localAnalyticsData = 0
	}
	local parentAnalyticsContext

	if not props.item.__isClientBinding then
		parentAnalyticsContext = props.collectionAnalyticsContext
	end

	v2.parentAnalyticsContext = parentAnalyticsContext
	v2.extraLocalProps = {
		index = props.index,
		layoutOrder = props.index,
		scrollViewPositionChangedSignal = props.scrollViewPositionChangedSignal,
		verticalScrollingFrameRef = props.verticalScrollingFrameRef
	}
	local debugName

	if props.debugName then
		debugName = `{props.debugName}.Item_{props.index}`
	else
		debugName = `Item_{props.index}`
	end

	v2.debugName = debugName
	v2.localAnalyticsData = props.localAnalyticsData
	return createElement("Frame", v, {
		Item = createElement2(sduiComponentWrapper, v2)
	})
end

local function resolveImpressionsTag(p, p2, routeName: string?, debugName: string?, index: number, sduiContext)
	local current = p.current

	if not current then
		sduiContext.dependencies.logger.reportError(
			SduiErrors.SduiErrorType.GetImpressionsTagMissingCollectionData,
			{ name = debugName },
			sduiContext.appPage
		)
		return nil
	end

	local v = current.collectionComponentType

	if not v then
		sduiContext.dependencies.logger.reportError(
			SduiErrors.SduiErrorType.GetImpressionsTagMissingCollectionComponentType,
			{ name = debugName },
			sduiContext.appPage
		)
		v = p2
	end

	local collectionId = current.collectionId

	if collectionId ~= nil and collectionId ~= -1 then
		return `{debugName}_{v}_{routeName}_{collectionId}_{index}`
	end

	sduiContext.dependencies.logger.reportError(
		SduiErrors.SduiErrorType.GetImpressionsTagMissingCollectionId,
		{ name = debugName },
		sduiContext.appPage
	)
	return nil
end

local function SduiVerticalListWithImpressions(props)
	local sduiContext = props.sduiContext
	local items = props.items or frozen
	local v = #items
	local v2 = React.useContext(SduiFeedContext)

	local scrollViewPositionChangedSignal = v2.scrollViewPositionChangedSignal or props.scrollViewPositionChangedSignal
	local verticalScrollingFrameRef = v2.verticalScrollingFrameRef or props.verticalScrollingFrameRef

	local ref = React.useRef(nil)
	local v3

	if FFlagSduiCarouselUseNestedImpressionsFeedContext then
		v3 = v2.impressionsParentScrollingFrameRef
	end

	local parentRef = v3 or ref

	local componentType = findAnalyticsField("componentType", props.analyticsContext.analyticsData or frozen)
		or SduiBuilder.getComponentType(props.componentConfig, sduiContext)

	local collectionAnalyticsContext, v4 = useCollectionAnalyticsContext(
		props.analyticsContext,
		componentType,
		1,
		v,
		sduiContext,
		props.startRow,
		props.componentConfig.__isClientBinding
	)

	local ref2 = React.useRef({})

	local routeName = sduiContext.routeName or sduiContext.appPage
	local index = props.index or 0

	local impressionsTag = resolveImpressionsTag(v4, componentType, routeName, props.debugName, index, sduiContext)

	local sendImpressions = React.useCallback(function(list)
		if #items ~= 0 then
			reportUnifiedLoggingImpressions(
				sduiContext,
				list,
				ref2.current,
				v4.current,
				props.startRow,
				props.impressionEventName,
				props.skipItemImpressionsLog,
				impressionsTag
			)
		elseif list and #list > 0 then
			local v5

			if collectionAnalyticsContext then
				v5 = SduiParseHelpers.stringifyValue(collectionAnalyticsContext.analyticsData)
			end

			sduiContext.dependencies.logger.reportError(
				SduiErrors.SduiErrorType.FailedToLogImpressions,
				{
					componentType = componentType,
					name = impressionsTag,
					message = `Failed to log impressions. No configs. indexes: {table.concat(list, ",")} analytics: {v5}`
				},
				sduiContext.appPage
			)
		end
	end, {
		items,
		sduiContext,
		ref2,
		v4,
		collectionAnalyticsContext,
		componentType,
		impressionsTag,
		props.startRow,
		props.impressionEventName,
		props.skipItemImpressionsLog
	})

	local children = React.useMemo(function()
		local current = {}
		local children = {}

		for k, item in items do
			if item then
				local v5 = findAnalyticsField("componentType", item.analyticsData or frozen)
					or SduiBuilder.getComponentType(item, sduiContext)

				if v5 then
					local localAnalyticsData = {
						itemPosition = k,
						itemComponentType = v5,
						componentType = v5
					}

					local buildAndValidateItemAnalyticsData = SduiCollectionAnalyticsBuilder.buildAndValidateItemAnalyticsData

					local analyticsData = item.analyticsData
					local v6

					if FFlagSduiErrorPaths then
						v6 = item.errorContext
					end

					current[k] = buildAndValidateItemAnalyticsData(
						sduiContext,
						analyticsData,
						nil,
						localAnalyticsData,
						v5,
						nil,
						v6
					)

					children[`Item_{k}`] = React.createElement(ImpressionTaggedSduiItem, {
						item = item,
						index = k,
						debugName = props.debugName,
						impressionsTag = impressionsTag,
						sduiContext = sduiContext,
						collectionAnalyticsContext = collectionAnalyticsContext,
						localAnalyticsData = localAnalyticsData,
						scrollViewPositionChangedSignal = scrollViewPositionChangedSignal,
						verticalScrollingFrameRef = verticalScrollingFrameRef
					})
				else
					local v6 = {
						componentType = componentType,
						name = impressionsTag,
						message = `Nil componentType in SduiVerticalListWithImpressions at index {k}`
					}

					if FFlagSduiErrorPaths then
						addSduiErrorContextFields(v6, item.errorContext)
					end

					sduiContext.dependencies.logger.reportError(
						SduiErrors.SduiErrorType.NilComponentType,
						v6,
						sduiContext.appPage
					)
				end
			else
				sduiContext.dependencies.logger.reportError(
					SduiErrors.SduiErrorType.NilItem,
					{
						componentType = componentType,
						name = impressionsTag,
						message = `Nil item in SduiVerticalListWithImpressions at index {k}`
					},
					sduiContext.appPage
				)
			end
		end

		ref2.current = current
		return children
	end, {
		items,
		sduiContext,
		collectionAnalyticsContext,
		componentType,
		scrollViewPositionChangedSignal,
		verticalScrollingFrameRef,
		impressionsTag,
		props.debugName
	})
	local content

	if props.view then
		local sduiComponentWrapper = getSduiComponentWrapper(props.view)
		local createElement = React.createElement
		local v5 = {
			componentConfig = props.view,
			sduiContext = sduiContext,
			parentAnalyticsContext = 0,
			debugName = 0,
			extraLocalProps = 0
		}
		local parentAnalyticsContext

		if not props.view.__isClientBinding then
			parentAnalyticsContext = collectionAnalyticsContext
		end

		v5.parentAnalyticsContext = parentAnalyticsContext
		v5.debugName = not props.debugName and "View" or `{props.debugName}.View`
		v5.extraLocalProps = {
			containerRef = ref,
			children = children,
			layoutOrder = props.layoutOrder
		}
		content = createElement(sduiComponentWrapper, v5)
	else
		content = React.createElement(SduiView, {
			containerRef = ref,
			layoutOrder = props.layoutOrder
		}, children)
	end

	local createElement = React.createElement
	local fragment = React.Fragment
	local impressionDetector

	if impressionsTag then
		local createElement2 = React.createElement
		local v5 = {
			parentRef = parentRef,
			pageContext = routeName,
			impressionsTag = impressionsTag,
			scrollViewPositionChangedSignal = scrollViewPositionChangedSignal,
			sendImpressions = sendImpressions,
			dataUpdatedTimestamp = sduiContext.dataUpdatedTimestamp,
			respectClipAncestors = 0
		}
		local respectClipAncestors

		if FFlagLuaAppRespectClipAncestorImpressions then
			respectClipAncestors = props.respectClipAncestors
		end

		v5.respectClipAncestors = respectClipAncestors
		impressionDetector = createElement2(FrameBoundsImpressionsTracker, v5)
	end

	return createElement(fragment, nil, {
		Content = content,
		ImpressionDetector = impressionDetector
	})
end

return React.memo(SduiVerticalListWithImpressions)
