local module = require("@luauforge/bundled/drY")
local module2 = require("@luauforge/bundled/dsv")
local useRoactService = require("@luauforge/bundled/dsp").useRoactService
local module3 = require("@luauforge/bundled/drk")
local appEventIngestService = module3.AppEventIngestService
local roactAnalytics = module3.RoactAnalytics
local roactAnalyticsCommonGameEvents = module3.RoactAnalyticsCommonGameEvents
local useSelector = module2.Hooks.RoactRodux.useSelector
local appPage = require("@luauforge/bundled/drn").AppPage
local songTile = require("@luauforge/bundled/dvK").SongTile
local module4 = require("@luauforge/bundled/drj")
local module5 = require("@luauforge/bundled/dsr")
local collectionCarousel = module5.CollectionCarousel
local collectionItemSize = module5.CollectionViewTypes.CollectionItemSize
local usePageSideMargin = module5.usePageSideMargin
local useCollectionImpressionsSignal = module5.useCollectionImpressionsSignal
local validateProps = require("@luauforge/bundled/dqK").validateProps
local module6 = require("@luauforge/bundled/drl")
local mutedError = require("@luauforge/bundled/dru").mutedError

local retrievalStatus = require("@luauforge/bundled/drq").Enum.RetrievalStatus

local module7 = require("@luauforge/bundled/dvt")

local gameSortGroups = require("@luauforge/bundled/dqn").GameSortGroups

local module8 = require("@luauforge/bundled/dqr")
local topicInfosReducer = module8.TopicInfosReducer
local topicInfoModel = module8.TopicInfoModel

local topicContentsReducer = require("@luauforge/bundled/dqs").TopicContentsReducer

local module9 = require("@luauforge/bundled/drs")
local fetchStatusReducer = module9.FetchStatusReducer
local fetchStatusNamespace = module9.FetchStatusNamespace

local module10 = require("@luauforge/bundled/dsy")
local useGameCollectionLayoutParams = module10.useGameCollectionLayoutParams
local useGameSortTooltipParams = module10.useGameSortTooltipParams
local useGetGameTileHeight = module10.useGetGameTileHeight

local module11 = require("@luauforge/bundled/dsb")
local screenSizeImpressionsTracker = module11.ScreenSizeImpressionsTracker
local frameBoundsImpressionsTracker = module11.FrameBoundsImpressionsTracker

local module12 = require("@luauforge/bundled/dvY")
local sendItemImpressions = module12.SendItemImpressions
local sendItemActionEvent = module12.SendItemActionEvent
local contentType = module12.ContentType

local useTextSizeOffset = require("@luauforge/bundled/drd").Core.Style.useTextSizeOffset

local openSongList = require("@luauforge/bundled/dvZ").OpenSongList

local useDispatch = module2.Hooks.RoactRodux.useDispatch

local fFlagEnableTopSongsSort = require("@luauforge/bundled/dqB").FFlagEnableTopSongsSort
local fFlagLuaAppCompositionAlways = require("@luauforge/bundled/dqB").FFlagLuaAppCompositionAlways
local fFlagLuaAppUseFrameBoundsImpressions = require("@luauforge/bundled/dqB").FFlagLuaAppUseFrameBoundsImpressions

local gameTileConstants = module6.GameTileConstants

local v5 = module4.strictInterface({
	[module7.key] = module7.interface,
	sortIndex = module4.number,
	isOmni = module4.optional(module4.boolean),
	topicLayoutData = module4.optional(module4.table)
})

local function SongCarouselFeedItem(p2)
	validateProps(v5, p2)

	local v6 = p2[module7.key]
	local appPage2 = v6.appPage
	local v7 = fFlagLuaAppCompositionAlways and true or v6.appCompositionEnabled

	assert(
		fFlagEnableTopSongsSort,
		"SongCarouselFeedItem should only be used when FFlagEnableTopSongsSort is enabled"
	)

	local sort = useSelector(function(p3)
		return p3.GameSortGroups[gameSortGroups.Games]
	end).sorts[p2.sortIndex]
	local formatted = `TOPSONGS_CAROUSEL_${sort}`

	local v8 = useSelector(function(p3)
		return p3.Personalization[topicInfosReducer.key][sort]
	end)

	local v9 = useSelector(function(p3)
		return p3.Personalization[topicContentsReducer.key][sort]
	end)

	local v10 = useSelector(function(p3)
		return p3.Personalization[fetchStatusReducer.key][fetchStatusNamespace.GameSorts][sort]
			or retrievalStatus.NotStarted
	end)

	local v11 = useSelector(function(p3)
		if sort then
			return p3.Personalization
				and p3.Personalization[topicContentsReducer.key]
				and p3.Personalization[topicContentsReducer.key][sort]
				and p3.Personalization[topicContentsReducer.key][sort].updatedTimestamp
		end

		return nil
	end)

	local v12 = useRoactService(appEventIngestService)
	local v13 = useRoactService(roactAnalytics)
	local v14 = useRoactService(roactAnalyticsCommonGameEvents)

	local entries = v9 and v9.entries or nil

	local v15 = module.useCallback(function(p3, p4)
		if not entries then
			return
		end

		sendItemActionEvent.sendFromItemCollection(
			v12,
			v13,
			{ id = p3 },
			1,
			p4,
			appPage2,
			p2.sortIndex,
			sort,
			#entries,
			contentType.Song,
			"OpenSongDetails"
		)
	end, { v12, v13, sort, entries, p2.sortIndex, appPage2 })

	local v16 = module.useCallback(function(p3, p4, p5, p6)
		return module.createElement(songTile, {
			contentId = p3.contentId,
			zIndex = -p4,
			size = p5,
			layoutOrder = p4,
			impressionsTag = formatted,
			reportTileOpened = function()
				v15(p3.contentId, p4)
			end
		}), "SongTile"
	end, { v15, formatted })

	local state, setState = module.useState(nil)
	local v17 = if not fFlagLuaAppCompositionAlways then usePageSideMargin(state) else nil

	local ref = module.useRef(nil)
	local v19 = useGetGameTileHeight(
		false,
		"Narrow",
		false,
		false,
		false,
		useTextSizeOffset(),
		nil,
		gameTileConstants.TileTextLines.Narrow.titleTextLines
	)

	local v20 = useGameCollectionLayoutParams("Narrow", state, false, {
		sideMargin = v17
	})

	local v21 = useDispatch()

	local v22 = module.useCallback(function()
		v21(openSongList(sort, appPage2))
		v14.reportSeeAllWithId(sort, nil, p2.sortIndex)
	end, { v21, sort, appPage2, v14, p2.sortIndex })

	local v24 = v8 or topicInfoModel.new()

	local v26 = if v8 and v8.topicLayoutData then v8.topicLayoutData.infoText or nil else nil
	local v27, v28 = useGameSortTooltipParams(v24, false, v26)
	local v29 = v28 and v28 ~= ""
	local v30, v31 = useCollectionImpressionsSignal(p2[module7.key].scrollViewPositionChangedSignal)

	local v32 = module.useCallback(function(p3)
		if entries ~= nil then
			local v33 = {}

			for i, entry in ipairs(entries) do
				table.insert(v33, { id = entry.contentId })
			end

			sendItemImpressions.sendFromItemCollection(
				v12,
				v13,
				p3,
				v33,
				#v33,
				appPage2,
				p2.sortIndex,
				contentType.Song,
				#v33,
				nil,
				sort
			)
		end
	end, { v12, v13, entries, sort, p2.sortIndex })

	if appPage2 ~= appPage.Games then
		mutedError("SongCarouselFeedItem should only be used on AppPage.Games")
		return nil
	end

	if not v8 or v10 ~= retrievalStatus.Done or not entries or #entries == 0 then
		return nil
	end

	local createElement = module.createElement
	local fragment = module.Fragment
	local createElement2 = module.createElement
	local v36 = if v7 then collectionItemSize.Small else nil
	local v37 = if not v7 then v20.columnGap else nil

	local v38 = if not v7 then v20.fractionalItemAmount else nil
	local v35 = {
		collectionItemSize = v36,
		columnGap = v37,
		containerRef = setState,
		fractionalItemAmount = v38,
		onViewableItemsChanged = v31,
		onChangeCanvasPosition = v31,
		getItemHeight = v19,
		items = entries,
		maxItemsToShow = v20.maxTilesToShow,
		numColumns = 0,
		onActivateHeader = 0,
		onActivateInfoIcon = 0,
		renderItem = 0,
		scrollingFrameRef = 0,
		sideMargin = 0,
		subtitle = 0,
		thresholdFromEnd = 0,
		title = 0,
		tooltipInfoText = 0
	}
	local v39 = if not v7 then v20.numColumns else nil
	v35.numColumns = v39
	v35.onActivateHeader = v22
	v35.onActivateInfoIcon = v29 and v27 or nil
	v35.renderItem = v16
	v35.scrollingFrameRef = ref
	local v40 = if not v7 then v20.sideMargin else nil
	v35.sideMargin = v40
	v35.subtitle = v8.subtitle
	v35.thresholdFromEnd = v20.loadMoreThreshold
	v35.title = v8.displayName
	v35.tooltipInfoText = v29 and v28 or nil
	local children = {
		SongCarousel = createElement2(collectionCarousel, v35),
		SongCarouselImpressionDetector = 0
	}

	local createElement3 = module.createElement
	local v41

	if fFlagLuaAppUseFrameBoundsImpressions then
		v41 = frameBoundsImpressionsTracker
	else
		v41 = screenSizeImpressionsTracker
	end

	children.SongCarouselImpressionDetector = createElement3(v41, {
		parentRef = ref,
		pageContext = appPage2,
		impressionsTag = formatted,
		scrollViewPositionChangedSignal = v30,
		sendImpressions = v32,
		dataUpdatedTimestamp = v11
	})
	return createElement(fragment, nil, children)
end

return SongCarouselFeedItem
