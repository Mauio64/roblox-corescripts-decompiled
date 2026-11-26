local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ArgCheck")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
local omniFeedPropsKey = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DiscoveryTypes").OmniFeedPropsKey
local usePageSideMargin = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/CollectionViews").usePageSideMargin
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RobloxAppEnums").AppPage

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiErrors = SduiCoreSystem.SduiErrors
local getSduiComponentWrapper = SduiCoreSystem.getSduiComponentWrapper

local fIntLuaAppDelayImpressionsMaxUpdates = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FIntLuaAppDelayImpressionsMaxUpdates
local fFlagLuaAppCompositionAlways = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppCompositionAlways

local v5 = game:DefineFastInt("SduiOmniFeedItemLogDelayMs", 500) / 1000

local useSduiItemCollectionSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/DataStore/useSduiItemCollectionSignal")

local function SduiOmniFeedItem(data)
	local appPage2 = data[omniFeedPropsKey].appPage
	local feedItemStartRow = data[omniFeedPropsKey].feedItemStartRow
	local verticalScrollingFrameRef = data[omniFeedPropsKey].verticalScrollingFrameRef
	local scrollViewPositionChangedSignal = data[omniFeedPropsKey].scrollViewPositionChangedSignal
	local sduiContext = data[omniFeedPropsKey].sduiContext
	local selectionOrderBase = data[omniFeedPropsKey].selectionOrderBase

	local v6 = fFlagLuaAppCompositionAlways and true or data[omniFeedPropsKey].appCompositionEnabled

	ArgCheck.assert(appPage2 ~= nil, "appPage must exist")
	ArgCheck.assert(data.topicId ~= nil, "topicId id must exist")
	ArgCheck.assert(data.sortIndex ~= nil, "sortIndex id must exist")

	local ref = React.useRef(false)
	React.useEffect(function()
		ref.current = true
		return function()
			ref.current = false
		end
	end, {})
	local v7

	if fFlagLuaAppCompositionAlways then
		v7 = nil
	else
		v7 = usePageSideMargin(verticalScrollingFrameRef.current)
	end

	local v8 = React.useMemo(function()
		if appPage2 == appPage.SearchPage and data.searchUuid then
			return `{appPage2}_{data.searchUuid}`
		end

		return nil
	end, { appPage2, data.searchUuid })
	local v9 = useSduiItemCollectionSignal(appPage2, data.topicId, data.sortIndex, v8)

	local sduiConfig = v9 and v9.sduiConfig or nil
	local v10 = React.useMemo(function()
		return { collectionPosition = data.sortIndex }
	end, { data.sortIndex })
	local formatted = `SduiOmniFeedItem-{data.topicId}`

	local ref2 = React.useRef(sduiConfig)
	ref2.current = sduiConfig

	if sduiConfig == nil then
		task.delay(v5, function()
			if ref.current and ref2.current == nil then
				sduiContext.dependencies.logger.reportError(
					sduiErrors.SduiErrorType.NilComponentConfig,
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
		return React.createElement(sduiComponentWrapper, {
			debugName = formatted,
			componentConfig = sduiConfig,
			sduiContext = sduiContext,
			extraLocalProps = {
				scrollViewPositionChangedSignal = scrollViewPositionChangedSignal,
				verticalScrollingFrameRef = verticalScrollingFrameRef,
				index = data.sortIndex,
				collectionPosition = data.sortIndex,
				pageSideMargin = if not v6 then v7 else nil,
				startRow = feedItemStartRow,
				numUpdatesToDelayImpressions = fIntLuaAppDelayImpressionsMaxUpdates,
				selectionOrderBase = selectionOrderBase,
				appCompositionEnabled = v6
			},
			localAnalyticsData = v10
		})
	end, {
		sduiConfig,
		formatted,
		v10,
		feedItemStartRow,
		v7,
		data.topicId,
		data.sortIndex,
		scrollViewPositionChangedSignal,
		verticalScrollingFrameRef,
		sduiContext,
		selectionOrderBase
	}))
end

return React.memo(SduiOmniFeedItem)
