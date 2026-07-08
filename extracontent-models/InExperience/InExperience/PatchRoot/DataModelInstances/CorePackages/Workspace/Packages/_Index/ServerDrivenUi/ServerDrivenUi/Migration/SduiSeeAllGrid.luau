local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local ServerDrivenUiParent = ServerDrivenUi.Parent
local ArgCheck = require(ServerDrivenUiParent.ArgCheck)
local React = require(ServerDrivenUiParent.React)
local tutils = require(ServerDrivenUiParent.tutils)
local useSelector = require(ServerDrivenUiParent.RoactUtils).Hooks.RoactRodux.useSelector
local SduiCoreSystem = require(ServerDrivenUiParent.SduiCoreSystem)
local SduiBuilder = SduiCoreSystem.SduiBuilder
local SduiComponentType = SduiCoreSystem.SduiComponentType
local SduiConfigReducer = require(ServerDrivenUi.Rodux.SduiConfigReducer)
local SduiComponent = SduiCoreSystem.SduiComponent
local SduiErrors = SduiCoreSystem.SduiErrors
local SduiParsers = SduiCoreSystem.SduiParsers
local useSduiContext = require(ServerDrivenUi.System.useSduiContext)
local useCollectionLayoutConfig = require(ServerDrivenUiParent.CollectionViews).useCollectionLayoutConfig
local FIntLuaAppDelayImpressionsMaxUpdates = require(ServerDrivenUiParent.SharedFlags).FIntLuaAppDelayImpressionsMaxUpdates
local FFlagLuaAppLayoutParamsInContext = require(ServerDrivenUiParent.SharedFlags).FFlagLuaAppLayoutParamsInContext

local function SduiSeeAllGrid(t1: {[any]: any}) -- line: 50
	-- upvalues: ArgCheck (copy), useSelector (copy), SduiConfigReducer (copy), tutils (copy), FFlagLuaAppLayoutParamsInContext (copy), useCollectionLayoutConfig (copy), useSduiContext (copy), React (copy), SduiErrors (copy), SduiBuilder (copy), SduiParsers (copy), SduiComponentType (copy), SduiComponent (copy), FIntLuaAppDelayImpressionsMaxUpdates (copy)
	local layoutOrder = t1.layoutOrder
	local verticalScrollingFrameRef = t1.verticalScrollingFrameRef
	local scrollViewPositionChangedSignal = t1.scrollViewPositionChangedSignal

	ArgCheck.assert(t1.collectionId ~= nil, "collectionId id must exist")
	ArgCheck.assert(t1.collectionIndex ~= nil, "collectionIndex id must exist")

	local v23 = useSelector(function(p1) -- line: 60
		-- upvalues: SduiConfigReducer (copy), t1 (copy)
		local t2 = {}
		local v30 = p1.Personalization[SduiConfigReducer.key][t1.appPage]

		if v30 then
			for _, v32 in v30.itemCollections do
				local analyticsData = v32.sduiConfig.analyticsData

				if tostring(t1.collectionId) == tostring(analyticsData.collectionId) then
					t2.feedItemData = v32

					break
				end
			end

			t2.templates = v30.rootConfig and v30.rootConfig.templates or nil
		end

		return t2
	end, tutils.shallowEqual)
	local v24 = if not FFlagLuaAppLayoutParamsInContext then nil else useCollectionLayoutConfig(t1.contentFrame, 0)
	local v25 = useSduiContext({
		appPage = t1.appPage,
		templates = v23.templates,
		dataUpdatedTimestamp = v23.feedItemData and v23.feedItemData.dataUpdatedTimestamp,
		pageLayoutConfig = if not FFlagLuaAppLayoutParamsInContext then nil else v24
	})
	local feedItemData = v23.feedItemData
	local v27 = React.useMemo(function() -- line: 91
		-- upvalues: feedItemData (copy), v25 (copy), SduiErrors (copy), t1 (copy), SduiBuilder (copy), SduiParsers (copy), SduiComponentType (copy)
		if not feedItemData or not feedItemData.sduiConfig then
			v25.dependencies.logger.reportError(SduiErrors.SduiErrorType.NilComponentConfig, {
				name = "SduiSeeAllGrid",
				message = `Missing component config client-driven SDUI grid for see-all. CollectionId: { t1.collectionId }`
			}, v25.appPage)

			return nil
		end

		if not feedItemData.sduiConfig.props then
			v25.dependencies.logger.reportError(SduiErrors.SduiErrorType.InvalidComponentConfig, {
				name = "SduiSeeAllGrid",
				message = `Missing props for component config for client-driven SDUI grid for see-all. CollectionId: { t1.collectionId }`
			}, v25.appPage)

			return nil
		end

		local sduiConfig = feedItemData.sduiConfig
		local uDim

		if sduiConfig.props.items and #sduiConfig.props.items > 0 and sduiConfig.props.itemHeightFromWidth == nil then
			local v35 = sduiConfig.props.items[1]

			if sduiConfig.props.itemTemplateKey and v35.templateKey == nil then
				v35.templateKey = sduiConfig.props.itemTemplateKey
			end

			if not SduiBuilder.getComponentType(v35, v25) then
				v25.dependencies.logger.reportError(SduiErrors.SduiErrorType.NilComponentType, {
					name = "SduiSeeAllGrid",
					message = `Missing componentType for first item. CollectionId: { t1.collectionId }`
				}, v25.appPage)

				return nil
			end

			local v36 = nil

			if v35 then
				local v37 = v35.props and (v35.props.imageAspectRatio and SduiParsers.safeParseNumber(v35.props.imageAspectRatio, v25, {}))

				if v37 and v37 > 0 then
					v36 = 1 / v37
				end
			end

			if not v36 then
				v36 = sduiConfig.props.collectionItemSize ~= "Medium" and sduiConfig.props.collectionItemSize ~= "Large" and 1 or 0.5625
			end

			local v38 = nil

			if v35 then
				v38 = (v35.props and v35.props.titleLines or 1) * 20 + 20 + 8
			end

			uDim = UDim.new(v36, v38)
		else
			uDim = sduiConfig.props.itemHeightFromWidth
		end

		return {
			componentType = SduiComponentType.CollectionGrid,
			props = {
				items = sduiConfig.props.items,
				impressionEventName = sduiConfig.props.impressionEventName,
				skipItemImpressionsLog = sduiConfig.props.skipItemImpressionsLog,
				collectionItemSize = sduiConfig.props.collectionItemSize,
				itemTemplateKey = sduiConfig.props.itemTemplateKey,
				itemHeightFromWidth = uDim
			},
			analyticsData = sduiConfig.analyticsData
		}
	end, {
		feedItemData and feedItemData.sduiConfig,
		v25
	})

	return (React.useMemo(function() -- line: 181
		-- upvalues: v27 (copy), v25 (copy), SduiErrors (copy), t1 (copy), React (copy), SduiComponent (copy), feedItemData (copy), scrollViewPositionChangedSignal (copy), verticalScrollingFrameRef (copy), FIntLuaAppDelayImpressionsMaxUpdates (copy), layoutOrder (copy), FFlagLuaAppLayoutParamsInContext (copy)
		if v27 == nil then
			v25.dependencies.logger.reportError(SduiErrors.SduiErrorType.NilComponentConfig, {
				name = "SduiSeeAllGrid",
				message = `Unable to generate component config for client-driven SDUI grid for see-all. CollectionId: { t1.collectionId }`
			}, v25.appPage)

			return nil
		end

		return React.createElement(SduiComponent, {
			debugName = "SeeAllGrid",
			componentConfig = v27,
			sduiContext = v25,
			extraLocalProps = {
				pageSideMargin = 0,
				startRow = 1,
				disableImpressionsDetector = true,
				dataUpdatedTimestamp = feedItemData.dataUpdatedTimestamp,
				scrollViewPositionChangedSignal = scrollViewPositionChangedSignal,
				verticalScrollingFrameRef = verticalScrollingFrameRef,
				index = t1.collectionIndex,
				collectionPosition = t1.collectionIndex,
				numUpdatesToDelayImpressions = FIntLuaAppDelayImpressionsMaxUpdates,
				layoutOrder = layoutOrder,
				layoutOverrides = if not FFlagLuaAppLayoutParamsInContext then {
					sideMargin = 0,
					fractionalItemAmount = 0,
					overrideLoadMoreThreshold = 1e999
				} else nil,
				impressionsTag = t1.impressionsTag,
				setLogImpressions = t1.setLogImpressions,
				sendGameImpressions = t1.sendGameImpressions,
				onCollectionViewabilityChanged = t1.onCollectionViewabilityChanged
			},
			localAnalyticsData = {
				seeAllFlag = 1,
				collectionPosition = t1.collectionIndex
			}
		})
	end, {
		v27,
		layoutOrder,
		feedItemData and feedItemData.dataUpdatedTimestamp or nil,
		1,
		t1.collectionId,
		t1.collectionIndex,
		scrollViewPositionChangedSignal,
		verticalScrollingFrameRef,
		v25,
		t1.impressionsTag,
		t1.setLogImpressions,
		t1.sendGameImpressions,
		t1.onCollectionViewabilityChanged
	}))
end

return React.memo(SduiSeeAllGrid)
