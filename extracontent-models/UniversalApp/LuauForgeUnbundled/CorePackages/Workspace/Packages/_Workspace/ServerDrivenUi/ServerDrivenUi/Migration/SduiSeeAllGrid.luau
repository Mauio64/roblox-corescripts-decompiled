local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ArgCheck")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
local tutils = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/tutils")
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RoactUtils").Hooks.RoactRodux.useSelector

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiBuilder = SduiCoreSystem.SduiBuilder
local sduiComponentType = SduiCoreSystem.SduiComponentType
local SduiConfigReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Rodux/SduiConfigReducer")
local sduiComponent = SduiCoreSystem.SduiComponent
local sduiErrors = SduiCoreSystem.SduiErrors
local sduiParsers = SduiCoreSystem.SduiParsers
local useSduiContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/System/useSduiContext")
local useCollectionLayoutConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/CollectionViews").useCollectionLayoutConfig

local fIntLuaAppDelayImpressionsMaxUpdates = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FIntLuaAppDelayImpressionsMaxUpdates
local fFlagLuaAppLayoutParamsInContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppLayoutParamsInContext

local function SduiSeeAllGrid(data)
	local layoutOrder = data.layoutOrder

	local verticalScrollingFrameRef = data.verticalScrollingFrameRef
	local scrollViewPositionChangedSignal = data.scrollViewPositionChangedSignal

	ArgCheck.assert(data.collectionId ~= nil, "collectionId id must exist")
	ArgCheck.assert(data.collectionIndex ~= nil, "collectionIndex id must exist")

	local v5 = useSelector(function(p2)
		local result = {}
		local v6 = p2.Personalization[SduiConfigReducer.key][data.appPage]

		if not v6 then
			return result
		end

		for k, itemCollection in v6.itemCollections do
			local analyticsData = itemCollection.sduiConfig.analyticsData

			if tostring(data.collectionId) == tostring(analyticsData.collectionId) then
				result.feedItemData = itemCollection
				break
			end
		end

		result.templates = v6.rootConfig and v6.rootConfig.templates or nil

		return result
	end, tutils.shallowEqual)
	local v6

	if fFlagLuaAppLayoutParamsInContext then
		v6 = useCollectionLayoutConfig(data.contentFrame, 0)
	end

	local v8 = {
		appPage = data.appPage,
		templates = v5.templates,
		dataUpdatedTimestamp = v5.feedItemData and v5.feedItemData.dataUpdatedTimestamp,
		pageLayoutConfig = 0
	}

	if not fFlagLuaAppLayoutParamsInContext then
		v6 = nil
	end

	v8.pageLayoutConfig = v6
	local v9 = useSduiContext(v8)

	local feedItemData = v5.feedItemData

	local v10 = React.useMemo(function()
		if not (feedItemData and feedItemData.sduiConfig) then
			v9.dependencies.logger.reportError(
				sduiErrors.SduiErrorType.NilComponentConfig,
				{
					name = "SduiSeeAllGrid",
					message = `Missing component config client-driven SDUI grid for see-all. CollectionId: {data.collectionId}`
				},
				v9.appPage
			)
			return nil
		end

		if not feedItemData.sduiConfig.props then
			v9.dependencies.logger.reportError(
				sduiErrors.SduiErrorType.InvalidComponentConfig,
				{
					name = "SduiSeeAllGrid",
					message = `Missing props for component config for client-driven SDUI grid for see-all. CollectionId: {data.collectionId}`
				},
				v9.appPage
			)
			return nil
		end

		local sduiConfig = feedItemData.sduiConfig
		local v11

		if
			not sduiConfig.props.items
			or not (#sduiConfig.props.items > 0)
			or sduiConfig.props.itemHeightFromWidth ~= nil
		then
			v11 = sduiConfig.props.itemHeightFromWidth

			return {
				componentType = sduiComponentType.CollectionGrid,
				props = {
					items = sduiConfig.props.items,
					impressionEventName = sduiConfig.props.impressionEventName,
					skipItemImpressionsLog = sduiConfig.props.skipItemImpressionsLog,
					collectionItemSize = sduiConfig.props.collectionItemSize,
					itemTemplateKey = sduiConfig.props.itemTemplateKey,
					itemHeightFromWidth = v11
				},
				analyticsData = sduiConfig.analyticsData
			}
		end

		local item = sduiConfig.props.items[1]

		if sduiConfig.props.itemTemplateKey and item.templateKey == nil then
			item.templateKey = sduiConfig.props.itemTemplateKey
		end

		if not sduiBuilder.getComponentType(item, v9) then
			v9.dependencies.logger.reportError(
				sduiErrors.SduiErrorType.NilComponentType,
				{
					name = "SduiSeeAllGrid",
					message = `Missing componentType for first item. CollectionId: {data.collectionId}`
				},
				v9.appPage
			)
			return nil
		end

		local v12 = nil

		if item then
			local v13 = item.props
				and item.props.imageAspectRatio
				and sduiParsers.safeParseNumber(item.props.imageAspectRatio, v9, {})

			if v13 and v13 > 0 then
				v12 = 1 / v13
			end
		end

		local v13 = v12
			or (sduiConfig.props.collectionItemSize == "Medium" or sduiConfig.props.collectionItemSize == "Large")
			and 0.5625
			or 1

		local v14 = if item then (item.props and item.props.titleLines or 1) * 20 + 20 + 8 else nil

		v11 = UDim.new(v13, v14)

		return {
			componentType = sduiComponentType.CollectionGrid,
			props = {
				items = sduiConfig.props.items,
				impressionEventName = sduiConfig.props.impressionEventName,
				skipItemImpressionsLog = sduiConfig.props.skipItemImpressionsLog,
				collectionItemSize = sduiConfig.props.collectionItemSize,
				itemTemplateKey = sduiConfig.props.itemTemplateKey,
				itemHeightFromWidth = v11
			},
			analyticsData = sduiConfig.analyticsData
		}
	end, { feedItemData and feedItemData.sduiConfig, v9 })

	return (React.useMemo(function()
		if v10 ~= nil then
			return React.createElement(sduiComponent, {
				debugName = "SeeAllGrid",
				componentConfig = v10,
				sduiContext = v9,
				extraLocalProps = {
					dataUpdatedTimestamp = feedItemData.dataUpdatedTimestamp,
					scrollViewPositionChangedSignal = scrollViewPositionChangedSignal,
					verticalScrollingFrameRef = verticalScrollingFrameRef,
					index = data.collectionIndex,
					collectionPosition = data.collectionIndex,
					pageSideMargin = 0,
					startRow = 1,
					numUpdatesToDelayImpressions = fIntLuaAppDelayImpressionsMaxUpdates,
					layoutOrder = layoutOrder,
					layoutOverrides = not fFlagLuaAppLayoutParamsInContext and {
						sideMargin = 0,
						fractionalItemAmount = 0,
						overrideLoadMoreThreshold = 1e999
					} or nil,
					disableImpressionsDetector = true,
					impressionsTag = data.impressionsTag,
					setLogImpressions = data.setLogImpressions,
					sendGameImpressions = data.sendGameImpressions,
					onCollectionViewabilityChanged = data.onCollectionViewabilityChanged
				},
				localAnalyticsData = {
					collectionPosition = data.collectionIndex,
					seeAllFlag = 1
				}
			})
		end

		v9.dependencies.logger.reportError(
			sduiErrors.SduiErrorType.NilComponentConfig,
			{
				name = "SduiSeeAllGrid",
				message = `Unable to generate component config for client-driven SDUI grid for see-all. CollectionId: {data.collectionId}`
			},
			v9.appPage
		)
		return nil
	end, {
		v10,
		layoutOrder,
		feedItemData and feedItemData.dataUpdatedTimestamp or nil,
		1,
		data.collectionId,
		data.collectionIndex,
		scrollViewPositionChangedSignal,
		verticalScrollingFrameRef,
		v9,
		data.impressionsTag,
		data.setLogImpressions,
		data.sendGameImpressions,
		data.onCollectionViewabilityChanged
	}))
end

return React.memo(SduiSeeAllGrid)
