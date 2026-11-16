local fFlagSduiErrorPaths = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagSduiErrorPaths

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/AppCommonLib")

local Impressions = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Impressions")
local frameBoundsImpressionsTracker = Impressions.FrameBoundsImpressionsTracker
local impressionsTagUtility = Impressions.ImpressionsTagUtility

require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/UnifiedLogging")

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCoreSystem")
local findAnalyticsField = SduiCoreSystem.findAnalyticsField
local getSduiComponentWrapper = SduiCoreSystem.getSduiComponentWrapper
local reportUnifiedLoggingImpressions = SduiCoreSystem.reportUnifiedLoggingImpressions
local sduiBuilder = SduiCoreSystem.SduiBuilder
local sduiCollectionAnalyticsBuilder = SduiCoreSystem.SduiCollectionAnalyticsBuilder
local sduiErrors = SduiCoreSystem.SduiErrors
local addSduiErrorContextFields = SduiCoreSystem.addSduiErrorContextFields

local SduiFeedContext = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/SduiFeedContext")
local SduiView = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/SduiView")
local useCollectionAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/useCollectionAnalyticsContext")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags")
local fFlagLuaAppRespectClipAncestorImpressions = SharedFlags.FFlagLuaAppRespectClipAncestorImpressions
local fFlagSduiCarouselUseNestedImpressionsFeedContext = SharedFlags.FFlagSduiCarouselUseNestedImpressionsFeedContext

local sduiParseHelpers = SduiCoreSystem.SduiParseHelpers

local frozen = table.freeze({})

local function ImpressionTaggedSduiItem(props)
	local ref = React.useRef(nil)

	React.useEffect(function()
		if not props.impressionsTag then
			return
		end

		impressionsTagUtility.AddTag(ref, props.impressionsTag, props.index)
		return function()
			impressionsTagUtility.RemoveTag(ref, props.impressionsTag, props.index)
		end
	end, { props.impressionsTag, props.index })

	local v5 = React.useCallback(function(current)
		ref.current = current

		if current and props.impressionsTag then
			impressionsTagUtility.AddTag(ref, props.impressionsTag, props.index)
		end
	end, { props.impressionsTag, props.index })

	local sduiComponentWrapper = getSduiComponentWrapper(props.item)

	local createElement = React.createElement
	local v7 = {
		ref = v5,
		BackgroundTransparency = 1,
		LayoutOrder = props.index,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}

	local createElement2 = React.createElement
	local v9 = {
		componentConfig = props.item,
		sduiContext = props.sduiContext,
		parentAnalyticsContext = 0,
		extraLocalProps = 0,
		debugName = 0,
		localAnalyticsData = 0
	}
	local v10 = if not props.item.__isClientBinding then props.collectionAnalyticsContext else nil
	v9.parentAnalyticsContext = v10
	v9.extraLocalProps = {
		index = props.index,
		layoutOrder = props.index,
		scrollViewPositionChangedSignal = props.scrollViewPositionChangedSignal,
		verticalScrollingFrameRef = props.verticalScrollingFrameRef
	}

	local v11 = if props.debugName then `{props.debugName}.Item_{props.index}` else `Item_{props.index}`
	v9.debugName = v11
	v9.localAnalyticsData = props.localAnalyticsData
	return createElement("Frame", v7, {
		Item = createElement2(sduiComponentWrapper, v9)
	})
end

local function resolveImpressionsTag(p2, p3, routeName, debugName, index, sduiContext)
	local current = p2.current

	if not current then
		sduiContext.dependencies.logger.reportError(
			sduiErrors.SduiErrorType.GetImpressionsTagMissingCollectionData,
			{ name = debugName },
			sduiContext.appPage
		)
		return nil
	end

	local v5 = current.collectionComponentType

	if not v5 then
		sduiContext.dependencies.logger.reportError(
			sduiErrors.SduiErrorType.GetImpressionsTagMissingCollectionComponentType,
			{ name = debugName },
			sduiContext.appPage
		)
		v5 = p3
	end

	local collectionId = current.collectionId

	if collectionId ~= nil and collectionId ~= -1 then
		return `{debugName}_{v5}_{routeName}_{collectionId}_{index}`
	end

	sduiContext.dependencies.logger.reportError(
		sduiErrors.SduiErrorType.GetImpressionsTagMissingCollectionId,
		{ name = debugName },
		sduiContext.appPage
	)
	return nil
end

local function SduiVerticalListWithImpressions(props)
	local sduiContext = props.sduiContext
	local items = props.items or frozen
	local v5 = #items
	local v6 = React.useContext(SduiFeedContext)

	local scrollViewPositionChangedSignal = v6.scrollViewPositionChangedSignal
		or props.scrollViewPositionChangedSignal
	local verticalScrollingFrameRef = v6.verticalScrollingFrameRef or props.verticalScrollingFrameRef

	local ref = React.useRef(nil)

	local v8 = (if fFlagSduiCarouselUseNestedImpressionsFeedContext then v6.impressionsParentScrollingFrameRef else nil)
		or ref

	local v9 = findAnalyticsField("componentType", props.analyticsContext.analyticsData or frozen)
		or sduiBuilder.getComponentType(props.componentConfig, sduiContext)

	local v10, v11 = useCollectionAnalyticsContext(
		props.analyticsContext,
		v9,
		1,
		v5,
		sduiContext,
		props.startRow,
		props.componentConfig.__isClientBinding
	)

	local ref2 = React.useRef({})

	local routeName = sduiContext.routeName or sduiContext.appPage
	local index = props.index or 0

	local impressionsTag = resolveImpressionsTag(v11, v9, routeName, props.debugName, index, sduiContext)

	local v12 = React.useCallback(function(list)
		if #items ~= 0 then
			reportUnifiedLoggingImpressions(
				sduiContext,
				list,
				ref2.current,
				v11.current,
				props.startRow,
				props.impressionEventName,
				props.skipItemImpressionsLog,
				impressionsTag
			)
		elseif list and #list > 0 then
			local v13 = if v10 then sduiParseHelpers.stringifyValue(v10.analyticsData) else nil

			sduiContext.dependencies.logger.reportError(
				sduiErrors.SduiErrorType.FailedToLogImpressions,
				{
					componentType = v9,
					name = impressionsTag,
					message = `Failed to log impressions. No configs. indexes: {table.concat(list, ",")} analytics: {v13}`
				},
				sduiContext.appPage
			)
		end
	end, {
		items,
		sduiContext,
		ref2,
		v11,
		v10,
		v9,
		impressionsTag,
		props.startRow,
		props.impressionEventName,
		props.skipItemImpressionsLog
	})

	local v13 = React.useMemo(function()
		local v14 = {}
		local children = {}

		for k, item in items do
			if item then
				local v15 = findAnalyticsField("componentType", item.analyticsData or frozen)
					or sduiBuilder.getComponentType(item, sduiContext)

				if v15 then
					local v16 = {
						itemPosition = k,
						itemComponentType = v15,
						componentType = v15
					}

					local buildAndValidateItemAnalyticsData = sduiCollectionAnalyticsBuilder.buildAndValidateItemAnalyticsData

					local analyticsData = item.analyticsData

					local v20 = if fFlagSduiErrorPaths then item.errorContext else nil
					v14[k] = buildAndValidateItemAnalyticsData(
						sduiContext,
						analyticsData,
						nil,
						v16,
						v15,
						nil,
						v20
					)

					children[`Item_{k}`] = React.createElement(ImpressionTaggedSduiItem, {
						item = item,
						index = k,
						debugName = props.debugName,
						impressionsTag = impressionsTag,
						sduiContext = sduiContext,
						collectionAnalyticsContext = v10,
						localAnalyticsData = v16,
						scrollViewPositionChangedSignal = scrollViewPositionChangedSignal,
						verticalScrollingFrameRef = verticalScrollingFrameRef
					})
				else
					local v16 = {
						componentType = v9,
						name = impressionsTag,
						message = `Nil componentType in SduiVerticalListWithImpressions at index {k}`
					}

					if fFlagSduiErrorPaths then
						addSduiErrorContextFields(v16, item.errorContext)
					end

					sduiContext.dependencies.logger.reportError(
						sduiErrors.SduiErrorType.NilComponentType,
						v16,
						sduiContext.appPage
					)
				end
			else
				sduiContext.dependencies.logger.reportError(
					sduiErrors.SduiErrorType.NilItem,
					{
						componentType = v9,
						name = impressionsTag,
						message = `Nil item in SduiVerticalListWithImpressions at index {k}`
					},
					sduiContext.appPage
				)
			end
		end

		ref2.current = v14
		return children
	end, {
		items,
		sduiContext,
		v10,
		v9,
		scrollViewPositionChangedSignal,
		verticalScrollingFrameRef,
		impressionsTag,
		props.debugName
	})
	local v14

	if props.view then
		local sduiComponentWrapper = getSduiComponentWrapper(props.view)
		local createElement = React.createElement
		local v15 = {
			componentConfig = props.view,
			sduiContext = sduiContext,
			parentAnalyticsContext = 0,
			debugName = 0,
			extraLocalProps = 0
		}

		local v16 = if not props.view.__isClientBinding then v10 else nil
		v15.parentAnalyticsContext = v16
		v15.debugName = not props.debugName and "View" or `{props.debugName}.View`
		v15.extraLocalProps = {
			containerRef = ref,
			children = v13,
			layoutOrder = props.layoutOrder
		}
		v14 = createElement(sduiComponentWrapper, v15)
	else
		v14 = React.createElement(SduiView, {
			containerRef = ref,
			layoutOrder = props.layoutOrder
		}, v13)
	end

	local createElement = React.createElement
	local fragment = React.Fragment
	local v17

	if impressionsTag then
		local createElement2 = React.createElement
		local v19 = {
			parentRef = v8,
			pageContext = routeName,
			impressionsTag = impressionsTag,
			scrollViewPositionChangedSignal = scrollViewPositionChangedSignal,
			sendImpressions = v12,
			dataUpdatedTimestamp = sduiContext.dataUpdatedTimestamp,
			respectClipAncestors = 0
		}

		local v20 = if fFlagLuaAppRespectClipAncestorImpressions then props.respectClipAncestors else nil
		v19.respectClipAncestors = v20
		v17 = createElement2(frameBoundsImpressionsTracker, v19)
	end

	return createElement(fragment, nil, { Content = v14, ImpressionDetector = v17 })
end

return React.memo(SduiVerticalListWithImpressions)
