local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local ServerDrivenUiParent = ServerDrivenUi.Parent
local ArgCheck = require(ServerDrivenUiParent.ArgCheck)
local React = require(ServerDrivenUiParent.React)
local OmniFeedPropsKey = require(ServerDrivenUiParent.DiscoveryTypes).OmniFeedPropsKey
local usePageSideMargin = require(ServerDrivenUiParent.CollectionViews).usePageSideMargin
local AppPage = require(ServerDrivenUiParent.RobloxAppEnums).AppPage
local SduiCoreSystem = require(ServerDrivenUiParent.SduiCoreSystem)
local SduiErrors = SduiCoreSystem.SduiErrors
local getSduiComponentWrapper = SduiCoreSystem.getSduiComponentWrapper
local FIntLuaAppDelayImpressionsMaxUpdates = require(ServerDrivenUiParent.SharedFlags).FIntLuaAppDelayImpressionsMaxUpdates
local FFlagLuaAppCompositionAlways = require(ServerDrivenUiParent.SharedFlags).FFlagLuaAppCompositionAlways
local FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone = require(ServerDrivenUiParent.SharedFlags).FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone
local v14 = game:DefineFastInt("SduiOmniFeedItemLogDelayMs", 500) / 1000
local useSduiItemCollectionSignal = require(ServerDrivenUi.DataStore.useSduiItemCollectionSignal)

local function SduiOmniFeedItem(t1: {[any]: any}) -- line: 48
	-- upvalues: OmniFeedPropsKey (copy), FFlagLuaAppCompositionAlways (copy), ArgCheck (copy), React (copy), usePageSideMargin (copy), AppPage (copy), useSduiItemCollectionSignal (copy), v14 (copy), SduiErrors (copy), getSduiComponentWrapper (copy), FIntLuaAppDelayImpressionsMaxUpdates (copy), FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone (copy)
	local appPage = t1[OmniFeedPropsKey].appPage
	local feedItemStartRow = t1[OmniFeedPropsKey].feedItemStartRow
	local verticalScrollingFrameRef = t1[OmniFeedPropsKey].verticalScrollingFrameRef
	local scrollViewPositionChangedSignal = t1[OmniFeedPropsKey].scrollViewPositionChangedSignal
	local sduiContext = t1[OmniFeedPropsKey].sduiContext
	local selectionOrderBase = t1[OmniFeedPropsKey].selectionOrderBase
	local v24 = not not FFlagLuaAppCompositionAlways or t1[OmniFeedPropsKey].appCompositionEnabled

	ArgCheck.assert(appPage ~= nil, "appPage must exist")
	ArgCheck.assert(t1.topicId ~= nil, "topicId id must exist")
	ArgCheck.assert(t1.sortIndex ~= nil, "sortIndex id must exist")

	local v25 = React.useRef(false)

	React.useEffect(function() -- line: 64
		-- upvalues: v25 (copy)
		v25.current = true

		return function() -- line: 66
			-- upvalues: v25 (copy)
			v25.current = false
		end
	end, {})

	local v26 = if FFlagLuaAppCompositionAlways then nil else usePageSideMargin(verticalScrollingFrameRef.current)
	local v27 = React.useMemo(function() -- line: 74
		-- upvalues: appPage (copy), AppPage (copy), t1 (copy)
		if appPage == AppPage.SearchPage and t1.searchUuid then
			return `{ appPage }_{ t1.searchUuid }`
		end

		return nil
	end, {
		appPage,
		t1.searchUuid
	})
	local v28 = useSduiItemCollectionSignal(appPage, t1.topicId, t1.sortIndex, v27)
	local v29 = v28 and v28.sduiConfig or nil
	local v30 = React.useMemo(function() -- line: 85
		-- upvalues: t1 (copy)
		return {
			collectionPosition = t1.sortIndex
		}
	end, { t1.sortIndex })
	local v31 = `SduiOmniFeedItem-{ t1.topicId }`
	local v32 = React.useRef(v29)

	v32.current = v29

	if v29 == nil then
		task.delay(v14, function() -- line: 96
			-- upvalues: v25 (copy), v32 (copy), sduiContext (copy), SduiErrors (copy), v31 (copy), t1 (copy)
			if v25.current and v32.current == nil then
				sduiContext.dependencies.logger.reportError(SduiErrors.SduiErrorType.NilComponentConfig, {
					name = v31,
					message = `Unable to render omni feed item for sdui. CollectionId: { t1.topicId }`
				}, sduiContext.appPage)
			end
		end)
	end

	return (React.useMemo(function() -- line: 108
		-- upvalues: v29 (copy), getSduiComponentWrapper (copy), React (copy), v31 (copy), sduiContext (copy), scrollViewPositionChangedSignal (copy), verticalScrollingFrameRef (copy), t1 (copy), v24 (copy), v26 (copy), feedItemStartRow (copy), FIntLuaAppDelayImpressionsMaxUpdates (copy), selectionOrderBase (copy), FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone (copy), OmniFeedPropsKey (copy), v30 (copy)
		if v29 == nil then
			return nil
		end

		local v33 = getSduiComponentWrapper(v29)

		return React.createElement(v33, {
			debugName = v31,
			componentConfig = v29,
			sduiContext = sduiContext,
			extraLocalProps = {
				scrollViewPositionChangedSignal = scrollViewPositionChangedSignal,
				verticalScrollingFrameRef = verticalScrollingFrameRef,
				index = t1.sortIndex,
				collectionPosition = t1.sortIndex,
				pageSideMargin = if not v24 then v26 else nil,
				startRow = feedItemStartRow,
				numUpdatesToDelayImpressions = FIntLuaAppDelayImpressionsMaxUpdates,
				selectionOrderBase = selectionOrderBase,
				appCompositionEnabled = v24,
				onTileImageLoaded = if not FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone then nil else t1[OmniFeedPropsKey].onTileImageLoaded
			},
			localAnalyticsData = v30
		})
	end, {
		v29,
		v31,
		v30,
		feedItemStartRow,
		v26,
		t1.topicId,
		t1.sortIndex,
		scrollViewPositionChangedSignal,
		verticalScrollingFrameRef,
		sduiContext,
		selectionOrderBase,
		if not FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone then nil else t1[OmniFeedPropsKey].onTileImageLoaded
	}))
end

return React.memo(SduiOmniFeedItem)
