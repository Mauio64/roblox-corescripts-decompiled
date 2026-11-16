local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local parent = ServerDrivenUi.Parent
local ArgCheck = require(parent.ArgCheck)
local React = require(parent.React)
local DiscoveryTypes = require(parent.DiscoveryTypes)
local OmniFeedPropsKey = DiscoveryTypes.OmniFeedPropsKey
local CollectionViews = require(parent.CollectionViews)
local usePageSideMargin = CollectionViews.usePageSideMargin
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiErrors = SduiCoreSystem.SduiErrors
local getSduiComponentWrapper = SduiCoreSystem.getSduiComponentWrapper

local SharedFlags = require(parent.SharedFlags)
local FIntLuaAppDelayImpressionsMaxUpdates = SharedFlags.FIntLuaAppDelayImpressionsMaxUpdates
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppCompositionAlways = SharedFlags2.FFlagLuaAppCompositionAlways

local v = game:DefineFastInt("SduiOmniFeedItemLogDelayMs", 500) / 1000

local useSduiItemCollectionSignal = require(ServerDrivenUi.DataStore.useSduiItemCollectionSignal)

local function SduiOmniFeedItem(data)
	local appPage = data[OmniFeedPropsKey].appPage
	local feedItemStartRow = data[OmniFeedPropsKey].feedItemStartRow
	local verticalScrollingFrameRef = data[OmniFeedPropsKey].verticalScrollingFrameRef
	local scrollViewPositionChangedSignal = data[OmniFeedPropsKey].scrollViewPositionChangedSignal
	local sduiContext = data[OmniFeedPropsKey].sduiContext
	local selectionOrderBase = data[OmniFeedPropsKey].selectionOrderBase

	local appCompositionEnabled = FFlagLuaAppCompositionAlways and true or data[OmniFeedPropsKey].appCompositionEnabled

	ArgCheck.assert(appPage ~= nil, "appPage must exist")
	ArgCheck.assert(data.topicId ~= nil, "topicId id must exist")
	ArgCheck.assert(data.sortIndex ~= nil, "sortIndex id must exist")

	local ref = React.useRef(false)
	React.useEffect(function()
		ref.current = true
		return function()
			ref.current = false
		end
	end, {})
	local v2

	if FFlagLuaAppCompositionAlways then
		v2 = nil
	else
		v2 = usePageSideMargin(verticalScrollingFrameRef.current)
	end

	local v3 = React.useMemo(function()
		if appPage == AppPage.SearchPage and data.searchUuid then
			return `{appPage}_{data.searchUuid}`
		end

		return nil
	end, { appPage, data.searchUuid })
	local v4 = useSduiItemCollectionSignal(appPage, data.topicId, data.sortIndex, v3)

	local sduiConfig = v4 and v4.sduiConfig or nil
	local localAnalyticsData = React.useMemo(function()
		return { collectionPosition = data.sortIndex }
	end, { data.sortIndex })
	local formatted = `SduiOmniFeedItem-{data.topicId}`

	local ref2 = React.useRef(sduiConfig)
	ref2.current = sduiConfig

	if sduiConfig == nil then
		task.delay(v, function()
			if ref.current and ref2.current == nil then
				sduiContext.dependencies.logger.reportError(
					SduiErrors.SduiErrorType.NilComponentConfig,
					{
						name = formatted,
						message = `Unable to render omni feed item for sdui. CollectionId: {data.topicId}`
					},
					sduiContext.appPage
				)
			end
		end)
	end

	return (React.useMemo(function()
		if sduiConfig == nil then
			return nil
		end

		local sduiComponentWrapper = getSduiComponentWrapper(sduiConfig)
		local createElement = React.createElement
		local v5 = {
			debugName = formatted,
			componentConfig = sduiConfig,
			sduiContext = sduiContext,
			extraLocalProps = 0,
			localAnalyticsData = 0
		}

		local extraLocalProps = {
			scrollViewPositionChangedSignal = scrollViewPositionChangedSignal,
			verticalScrollingFrameRef = verticalScrollingFrameRef,
			index = data.sortIndex,
			collectionPosition = data.sortIndex,
			pageSideMargin = 0,
			startRow = 0,
			numUpdatesToDelayImpressions = 0,
			selectionOrderBase = 0,
			appCompositionEnabled = 0
		}
		local pageSideMargin

		if not appCompositionEnabled then
			pageSideMargin = v2
		end

		extraLocalProps.pageSideMargin = pageSideMargin
		extraLocalProps.startRow = feedItemStartRow
		extraLocalProps.numUpdatesToDelayImpressions = FIntLuaAppDelayImpressionsMaxUpdates
		extraLocalProps.selectionOrderBase = selectionOrderBase
		extraLocalProps.appCompositionEnabled = appCompositionEnabled
		v5.extraLocalProps = extraLocalProps

		v5.localAnalyticsData = localAnalyticsData
		return createElement(sduiComponentWrapper, v5)
	end, {
		sduiConfig,
		formatted,
		localAnalyticsData,
		feedItemStartRow,
		v2,
		data.topicId,
		data.sortIndex,
		scrollViewPositionChangedSignal,
		verticalScrollingFrameRef,
		sduiContext,
		selectionOrderBase
	}))
end

return React.memo(SduiOmniFeedItem)
