local DiscoveryMonolith = script:FindFirstAncestor("DiscoveryMonolith")
local DiscoveryMonolithParent = DiscoveryMonolith.Parent
local React = require(DiscoveryMonolithParent.React)
local RoactUtils = require(DiscoveryMonolithParent.RoactUtils)
local useRoactService = require(DiscoveryMonolithParent.RobloxAppHooks).useRoactService
local RoactServiceTags = require(DiscoveryMonolithParent.RoactServiceTags)
local AppEventIngestService = RoactServiceTags.AppEventIngestService
local RoactAnalytics = RoactServiceTags.RoactAnalytics
local RoactAnalyticsCommonGameEvents = RoactServiceTags.RoactAnalyticsCommonGameEvents
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local AppPage = require(DiscoveryMonolithParent.RobloxAppEnums).AppPage
local SongTile = require(DiscoveryMonolithParent.SongTile).SongTile
local t = require(DiscoveryMonolithParent.t)
local CollectionViews = require(DiscoveryMonolithParent.CollectionViews)
local CollectionCarousel = CollectionViews.CollectionCarousel
local CollectionItemSize = CollectionViews.CollectionViewTypes.CollectionItemSize
local usePageSideMargin = CollectionViews.usePageSideMargin
local useCollectionImpressionsSignal = CollectionViews.useCollectionImpressionsSignal
local validateProps = require(DiscoveryMonolithParent.DiscoveryUtils).validateProps
local GameTile = require(DiscoveryMonolithParent.GameTile)
local mutedError = require(DiscoveryMonolithParent.Loggers).mutedError
local RetrievalStatus = require(DiscoveryMonolithParent.Http).Enum.RetrievalStatus
local Modules = DiscoveryMonolith.Modules
local OmniFeedProps = require(Modules.Personalization.OmniFeed.OmniFeedProps)
local GameSortGroups = require(DiscoveryMonolithParent.DiscoveryTypes).GameSortGroups
local TopicInfosRodux = require(DiscoveryMonolithParent.TopicInfosRodux)
local TopicInfosReducer = TopicInfosRodux.TopicInfosReducer
local TopicInfoModel = TopicInfosRodux.TopicInfoModel
local TopicContentsReducer = require(DiscoveryMonolithParent.TopicContentsRodux).TopicContentsReducer
local FetchStatusRodux = require(DiscoveryMonolithParent.FetchStatusRodux)
local FetchStatusReducer = FetchStatusRodux.FetchStatusReducer
local FetchStatusNamespace = FetchStatusRodux.FetchStatusNamespace
local GameCollections = require(DiscoveryMonolithParent.GameCollections)
local useGameCollectionLayoutParams = GameCollections.useGameCollectionLayoutParams
local useGameSortTooltipParams = GameCollections.useGameSortTooltipParams
local useGetGameTileHeight = GameCollections.useGetGameTileHeight
local Impressions = require(DiscoveryMonolithParent.Impressions)
local ScreenSizeImpressionsTracker = Impressions.ScreenSizeImpressionsTracker
local FrameBoundsImpressionsTracker = Impressions.FrameBoundsImpressionsTracker
local UnifiedLogging = require(DiscoveryMonolithParent.UnifiedLogging)
local SendItemImpressions = UnifiedLogging.SendItemImpressions
local SendItemActionEvent = UnifiedLogging.SendItemActionEvent
local ContentType = UnifiedLogging.ContentType
local useTextSizeOffset = require(DiscoveryMonolithParent.UIBlox).Core.Style.useTextSizeOffset
local OpenSongList = require(DiscoveryMonolithParent.DiscoveryRouting).OpenSongList
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local FFlagEnableTopSongsSort = require(DiscoveryMonolithParent.SharedFlags).FFlagEnableTopSongsSort
local FFlagLuaAppCompositionAlways = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppCompositionAlways
local FFlagLuaAppUseFrameBoundsImpressions = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppUseFrameBoundsImpressions
local GameTileConstants = GameTile.GameTileConstants
local v51 = t.strictInterface({
	[OmniFeedProps.key] = OmniFeedProps.interface,
	sortIndex = t.number,
	isOmni = t.optional(t.boolean),
	topicLayoutData = t.optional(t.table)
})

local function SongCarouselFeedItem(t1: {[any]: any}) -- line: 91
	-- upvalues: validateProps (copy), v51 (copy), OmniFeedProps (copy), FFlagLuaAppCompositionAlways (copy), FFlagEnableTopSongsSort (copy), useSelector (copy), GameSortGroups (copy), TopicInfosReducer (copy), TopicContentsReducer (copy), FetchStatusReducer (copy), FetchStatusNamespace (copy), RetrievalStatus (copy), useRoactService (copy), AppEventIngestService (copy), RoactAnalytics (copy), RoactAnalyticsCommonGameEvents (copy), React (copy), SendItemActionEvent (copy), ContentType (copy), SongTile (copy), usePageSideMargin (copy), useTextSizeOffset (copy), useGetGameTileHeight (copy), GameTileConstants (copy), useGameCollectionLayoutParams (copy), useDispatch (copy), OpenSongList (copy), useGameSortTooltipParams (copy), TopicInfoModel (copy), useCollectionImpressionsSignal (copy), SendItemImpressions (copy), AppPage (copy), mutedError (copy), CollectionCarousel (copy), CollectionItemSize (copy), FFlagLuaAppUseFrameBoundsImpressions (copy), FrameBoundsImpressionsTracker (copy), ScreenSizeImpressionsTracker (copy)
	validateProps(v51, t1)

	local v54 = t1[OmniFeedProps.key]
	local appPage = v54.appPage
	local v56 = not not FFlagLuaAppCompositionAlways or v54.appCompositionEnabled

	assert(FFlagEnableTopSongsSort, "SongCarouselFeedItem should only be used when FFlagEnableTopSongsSort is enabled")

	local v57 = useSelector(function(p1) -- line: 100
		-- upvalues: GameSortGroups (copy)
		return p1.GameSortGroups[GameSortGroups.Games]
	end).sorts[t1.sortIndex]
	local v58 = `TOPSONGS_CAROUSEL_${ v57 }`
	local v59 = useSelector(function(p2) -- line: 106
		-- upvalues: TopicInfosReducer (copy), v57 (copy)
		return p2.Personalization[TopicInfosReducer.key][v57]
	end)
	local v60 = useSelector(function(p3) -- line: 109
		-- upvalues: TopicContentsReducer (copy), v57 (copy)
		return p3.Personalization[TopicContentsReducer.key][v57]
	end)
	local v61 = useSelector(function(p4) -- line: 112
		-- upvalues: FetchStatusReducer (copy), FetchStatusNamespace (copy), v57 (copy), RetrievalStatus (copy)
		return p4.Personalization[FetchStatusReducer.key][FetchStatusNamespace.GameSorts][v57] or RetrievalStatus.NotStarted
	end)
	local v62 = useSelector(function(p5) -- line: 117
		-- upvalues: v57 (copy), TopicContentsReducer (copy)
		if v57 then
			return p5.Personalization and (p5.Personalization[TopicContentsReducer.key] and (p5.Personalization[TopicContentsReducer.key][v57] and p5.Personalization[TopicContentsReducer.key][v57].updatedTimestamp))
		end

		return nil
	end)
	local v63 = useRoactService(AppEventIngestService)
	local v64 = useRoactService(RoactAnalytics)
	local v65 = useRoactService(RoactAnalyticsCommonGameEvents)
	local v66 = v60 and v60.entries or nil
	local v67 = React.useCallback(function(s1: string, n1: number) -- line: 134
		-- upvalues: v66 (copy), SendItemActionEvent (copy), v63 (copy), v64 (copy), appPage (copy), t1 (copy), v57 (copy), ContentType (copy)
		if not v66 then
			return
		end

		SendItemActionEvent.sendFromItemCollection(v63, v64, {
			id = s1
		}, 1, n1, appPage, t1.sortIndex, v57, #v66, ContentType.Song, "OpenSongDetails")
	end, {
		v63,
		v64,
		v57,
		v66,
		t1.sortIndex,
		appPage
	})
	local v68 = React.useCallback(function(t2: {[any]: any}, n2: number, uDim2: UDim2, _: number?) -- line: 144
		-- upvalues: React (copy), SongTile (copy), v58 (copy), v67 (copy)
		return React.createElement(SongTile, {
			contentId = t2.contentId,
			zIndex = -n2,
			size = uDim2,
			layoutOrder = n2,
			impressionsTag = v58,
			reportTileOpened = function() -- line: 151
				-- upvalues: v67 (copy), t2 (copy), n2 (copy)
				v67(t2.contentId, n2)
			end
		}), "SongTile"
	end, {
		v67,
		v58
	})
	local v69, v70 = React.useState(nil)
	local v71 = if FFlagLuaAppCompositionAlways then nil else usePageSideMargin(v69)
	local v72 = React.useRef(nil)
	local v73 = useTextSizeOffset()
	local v74 = useGetGameTileHeight(false, "Narrow", false, false, false, v73, nil, GameTileConstants.TileTextLines.Narrow.titleTextLines)
	local v75 = useGameCollectionLayoutParams("Narrow", v69, false, {
		sideMargin = v71
	})
	local v76 = useDispatch()
	local v77 = React.useCallback(function() -- line: 182
		-- upvalues: v76 (copy), OpenSongList (copy), v57 (copy), appPage (copy), v65 (copy), t1 (copy)
		v76(OpenSongList(v57, appPage))
		v65.reportSeeAllWithId(v57, nil, t1.sortIndex)
	end, {
		v76,
		v57,
		appPage,
		v65,
		t1.sortIndex
	})
	local v78, v79 = useGameSortTooltipParams(v59 or TopicInfoModel.new(), false, v59 and (not not v59.topicLayoutData and v59.topicLayoutData.infoText) or nil)
	local v80 = v79 and v79 ~= ""
	local scrollViewPositionChangedSignal = t1[OmniFeedProps.key].scrollViewPositionChangedSignal
	local v82, v83 = useCollectionImpressionsSignal(scrollViewPositionChangedSignal)
	local v84 = React.useCallback(function(p6) -- line: 198
		-- upvalues: v66 (copy), SendItemImpressions (copy), v63 (copy), v64 (copy), appPage (copy), t1 (copy), ContentType (copy), v57 (copy)
		if v66 ~= nil then
			local t3 = {}

			for _, v in ipairs(v66) do
				table.insert(t3, {
					id = v.contentId
				})
			end

			SendItemImpressions.sendFromItemCollection(v63, v64, p6, t3, #t3, appPage, t1.sortIndex, ContentType.Song, #t3, nil, v57)
		end
	end, {
		v63,
		v64,
		v66,
		v57,
		t1.sortIndex
	})

	if appPage ~= AppPage.Games then
		mutedError("SongCarouselFeedItem should only be used on AppPage.Games")

		return nil
	end

	if not v59 or v61 ~= RetrievalStatus.Done or not v66 or #v66 == 0 then
		return nil
	end

	return React.createElement(React.Fragment, nil, {
		SongCarousel = React.createElement(CollectionCarousel, {
			collectionItemSize = if not v56 then nil else CollectionItemSize.Small,
			columnGap = if not v56 then v75.columnGap else nil,
			containerRef = v70,
			fractionalItemAmount = if not v56 then v75.fractionalItemAmount else nil,
			onViewableItemsChanged = v83,
			onChangeCanvasPosition = v83,
			getItemHeight = v74,
			items = v66,
			maxItemsToShow = v75.maxTilesToShow,
			numColumns = if not v56 then v75.numColumns else nil,
			onActivateHeader = v77,
			onActivateInfoIcon = v80 and v78 or nil,
			renderItem = v68,
			scrollingFrameRef = v72,
			sideMargin = if not v56 then v75.sideMargin else nil,
			subtitle = v59.subtitle,
			thresholdFromEnd = v75.loadMoreThreshold,
			title = v59.displayName,
			tooltipInfoText = v80 and v79 or nil
		}),
		SongCarouselImpressionDetector = React.createElement(if not FFlagLuaAppUseFrameBoundsImpressions then ScreenSizeImpressionsTracker else FrameBoundsImpressionsTracker, {
			parentRef = v72,
			pageContext = appPage,
			impressionsTag = v58,
			scrollViewPositionChangedSignal = v82,
			sendImpressions = v84,
			dataUpdatedTimestamp = v62
		})
	})
end

return SongCarouselFeedItem
