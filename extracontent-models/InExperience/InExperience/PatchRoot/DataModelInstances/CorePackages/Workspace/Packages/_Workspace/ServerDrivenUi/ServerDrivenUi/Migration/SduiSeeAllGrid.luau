local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local parent = ServerDrivenUi.Parent
local ArgCheck = require(parent.ArgCheck)
local React = require(parent.React)
local tutils = require(parent.tutils)
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiBuilder = SduiCoreSystem.SduiBuilder
local SduiComponentType = SduiCoreSystem.SduiComponentType
local SduiConfigReducer = require(ServerDrivenUi.Rodux.SduiConfigReducer)
local SduiComponent = SduiCoreSystem.SduiComponent
local SduiErrors = SduiCoreSystem.SduiErrors
local SduiParsers = SduiCoreSystem.SduiParsers
local useSduiContext = require(ServerDrivenUi.System.useSduiContext)
local CollectionViews = require(parent.CollectionViews)
local useCollectionLayoutConfig = CollectionViews.useCollectionLayoutConfig

local SharedFlags = require(parent.SharedFlags)
local FIntLuaAppDelayImpressionsMaxUpdates = SharedFlags.FIntLuaAppDelayImpressionsMaxUpdates
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppLayoutParamsInContext = SharedFlags2.FFlagLuaAppLayoutParamsInContext

local function SduiSeeAllGrid(data)
	local layoutOrder = data.layoutOrder

	local verticalScrollingFrameRef = data.verticalScrollingFrameRef
	local scrollViewPositionChangedSignal = data.scrollViewPositionChangedSignal

	ArgCheck.assert(data.collectionId ~= nil, "collectionId id must exist")
	ArgCheck.assert(data.collectionIndex ~= nil, "collectionIndex id must exist")

	local v = useSelector(function(p)
		local result = {}
		local v = p.Personalization[SduiConfigReducer.key][data.appPage]

		if not v then
			return result
		end

		for _, itemCollection in v.itemCollections do
			local analyticsData = itemCollection.sduiConfig.analyticsData

			if tostring(data.collectionId) == tostring(analyticsData.collectionId) then
				result.feedItemData = itemCollection
				break
			end
		end

		result.templates = v.rootConfig and v.rootConfig.templates or nil

		return result
	end, tutils.shallowEqual)
	local pageLayoutConfig

	if FFlagLuaAppLayoutParamsInContext then
		pageLayoutConfig = useCollectionLayoutConfig(data.contentFrame, 0)
	end

	local v2 = {
		appPage = data.appPage,
		templates = v.templates,
		dataUpdatedTimestamp = v.feedItemData and v.feedItemData.dataUpdatedTimestamp,
		pageLayoutConfig = 0
	}

	if not FFlagLuaAppLayoutParamsInContext then
		pageLayoutConfig = nil
	end

	v2.pageLayoutConfig = pageLayoutConfig
	local sduiContext = useSduiContext(v2)

	local feedItemData = v.feedItemData

	local componentConfig = React.useMemo(function()
		if not (feedItemData and feedItemData.sduiConfig) then
			sduiContext.dependencies.logger.reportError(
				SduiErrors.SduiErrorType.NilComponentConfig,
				{
					name = "SduiSeeAllGrid",
					message = `Missing component config client-driven SDUI grid for see-all. CollectionId: {data.collectionId}`
				},
				sduiContext.appPage
			)
			return nil
		end

		if not feedItemData.sduiConfig.props then
			sduiContext.dependencies.logger.reportError(
				SduiErrors.SduiErrorType.InvalidComponentConfig,
				{
					name = "SduiSeeAllGrid",
					message = `Missing props for component config for client-driven SDUI grid for see-all. CollectionId: {data.collectionId}`
				},
				sduiContext.appPage
			)
			return nil
		end

		local sduiConfig = feedItemData.sduiConfig
		local itemHeightFromWidth

		if
			not sduiConfig.props.items
			or not (#sduiConfig.props.items > 0)
			or sduiConfig.props.itemHeightFromWidth ~= nil
		then
			itemHeightFromWidth = sduiConfig.props.itemHeightFromWidth

			return {
				componentType = SduiComponentType.CollectionGrid,
				props = {
					items = sduiConfig.props.items,
					impressionEventName = sduiConfig.props.impressionEventName,
					skipItemImpressionsLog = sduiConfig.props.skipItemImpressionsLog,
					collectionItemSize = sduiConfig.props.collectionItemSize,
					itemTemplateKey = sduiConfig.props.itemTemplateKey,
					itemHeightFromWidth = itemHeightFromWidth
				},
				analyticsData = sduiConfig.analyticsData
			}
		end

		local item = sduiConfig.props.items[1]

		if sduiConfig.props.itemTemplateKey and item.templateKey == nil then
			item.templateKey = sduiConfig.props.itemTemplateKey
		end

		if not SduiBuilder.getComponentType(item, sduiContext) then
			sduiContext.dependencies.logger.reportError(
				SduiErrors.SduiErrorType.NilComponentType,
				{
					name = "SduiSeeAllGrid",
					message = `Missing componentType for first item. CollectionId: {data.collectionId}`
				},
				sduiContext.appPage
			)
			return nil
		end

		local v3 = nil

		if item then
			local v4 = item.props
				and item.props.imageAspectRatio
				and SduiParsers.safeParseNumber(item.props.imageAspectRatio, sduiContext, {})

			if v4 and v4 > 0 then
				v3 = 1 / v4
			end
		end

		local v4 = v3
			or (sduiConfig.props.collectionItemSize == "Medium" or sduiConfig.props.collectionItemSize == "Large")
			and 0.5625
			or 1
		local v5

		if item then
			v5 = (item.props and item.props.titleLines or 1) * 20 + 20 + 8
		end

		itemHeightFromWidth = UDim.new(v4, v5)

		return {
			componentType = SduiComponentType.CollectionGrid,
			props = {
				items = sduiConfig.props.items,
				impressionEventName = sduiConfig.props.impressionEventName,
				skipItemImpressionsLog = sduiConfig.props.skipItemImpressionsLog,
				collectionItemSize = sduiConfig.props.collectionItemSize,
				itemTemplateKey = sduiConfig.props.itemTemplateKey,
				itemHeightFromWidth = itemHeightFromWidth
			},
			analyticsData = sduiConfig.analyticsData
		}
	end, { feedItemData and feedItemData.sduiConfig, sduiContext })

	return (React.useMemo(function()
		if componentConfig ~= nil then
			return React.createElement(SduiComponent, {
				debugName = "SeeAllGrid",
				componentConfig = componentConfig,
				sduiContext = sduiContext,
				extraLocalProps = {
					dataUpdatedTimestamp = feedItemData.dataUpdatedTimestamp,
					scrollViewPositionChangedSignal = scrollViewPositionChangedSignal,
					verticalScrollingFrameRef = verticalScrollingFrameRef,
					index = data.collectionIndex,
					collectionPosition = data.collectionIndex,
					pageSideMargin = 0,
					startRow = 1,
					numUpdatesToDelayImpressions = FIntLuaAppDelayImpressionsMaxUpdates,
					layoutOrder = layoutOrder,
					layoutOverrides = not FFlagLuaAppLayoutParamsInContext and {
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
				localAnalyticsData = { collectionPosition = data.collectionIndex, seeAllFlag = 1 }
			})
		end

		sduiContext.dependencies.logger.reportError(
			SduiErrors.SduiErrorType.NilComponentConfig,
			{
				name = "SduiSeeAllGrid",
				message = `Unable to generate component config for client-driven SDUI grid for see-all. CollectionId: {data.collectionId}`
			},
			sduiContext.appPage
		)
		return nil
	end, {
		componentConfig,
		layoutOrder,
		feedItemData and feedItemData.dataUpdatedTimestamp or nil,
		1,
		data.collectionId,
		data.collectionIndex,
		scrollViewPositionChangedSignal,
		verticalScrollingFrameRef,
		sduiContext,
		data.impressionsTag,
		data.setLogImpressions,
		data.sendGameImpressions,
		data.onCollectionViewabilityChanged
	}))
end

return React.memo(SduiSeeAllGrid)
