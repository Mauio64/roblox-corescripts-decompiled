local module = require("@luauforge/deferred/gEe")
local module2 = require("@luauforge/deferred/gEf")
local collectionCarousel = module2.CollectionCarousel
local useCollectionImpressionsSignal = module2.useCollectionImpressionsSignal

local useRoactService = require("@luauforge/deferred/gEg").useRoactService
local module3 = require("@luauforge/deferred/gEh")
local appEventIngestService = module3.AppEventIngestService
local roactAnalytics = module3.RoactAnalytics

local module4 = require("@luauforge/deferred/gEi")
local useGameCollectionLayoutParams = module4.useGameCollectionLayoutParams
local useGetGameTileHeight = module4.useGetGameTileHeight

local frameBoundsImpressionsTracker = require("@luauforge/deferred/gEj").FrameBoundsImpressionsTracker

local sendItemImpressions = require("@luauforge/deferred/gEk").SendItemImpressions
local sendItemActionEvent = require("@luauforge/deferred/gEk").SendItemActionEvent
local contentType = require("@luauforge/deferred/gEk").ContentType

local useTextSizeOffset = require("@luauforge/deferred/gEl").Core.Style.useTextSizeOffset

local module5 = require("@luauforge/deferred/gEm")
local usePreferredInput = module5.usePreferredInput

local songTile = require("@luauforge/deferred/gEn").SongTile

local fFlagSongEdpCarouselIxp = require("@luauforge/deferred/gEo").FFlagSongEdpCarouselIxp
local fFlagSongCarouselPropUpdate = require("@luauforge/deferred/gEo").FFlagSongCarouselPropUpdate
local fFlagUpdateSongCarouselClipDefault = require("@luauforge/deferred/gEo").FFlagUpdateSongCarouselClipDefault

local gameTileConstants = require("@luauforge/deferred/gEp").GameTileConstants

return module.memo(function(props)
	local v5 = useTextSizeOffset()
	local v6 = usePreferredInput() == module5.Input.Pointer
	local v7 = useGetGameTileHeight(
		v6,
		"Narrow",
		v6,
		false,
		false,
		v5,
		nil,
		gameTileConstants.TileTextLines.Narrow.titleTextLines
	)

	local v8 = useRoactService(appEventIngestService)
	local v9 = useRoactService(roactAnalytics)
	local state, setState = module.useState(nil)
	local v13 = {
		numColumns = props.numColumns,
		sideMargin = fFlagSongEdpCarouselIxp and 0 or nil,
		columnGap = 0,
		fractionalItemAmount = 0
	}

	local v14 = if fFlagSongEdpCarouselIxp then props.columnGap else nil
	v13.columnGap = v14
	v13.fractionalItemAmount = props.fractionalItemAmount
	local v15 = useGameCollectionLayoutParams("Narrow", state, false, v13)

	local useCallback = module.useCallback
	local function fn(p2, p3)
		local sendFromItemCollection = sendItemActionEvent.sendFromItemCollection

		local pageContext = props.pageContext
		local v20 = if fFlagSongCarouselPropUpdate then props.collectionOrder else props.layoutOrder
		sendFromItemCollection(
			v8,
			v9,
			{ id = p2 },
			1,
			p3,
			pageContext,
			v20,
			props.referralId,
			#props.songIds,
			contentType.Song,
			"OpenSongDetails"
		)
	end

	local v17 = if fFlagSongCarouselPropUpdate then props.collectionOrder else props.layoutOrder
	local v18 = useCallback(fn, {
		v8,
		v9,
		v17,
		props.title,
		props.songIds,
		props.pageContext,
		props.referralId
	})

	local v19 = module.useCallback(function(p2, p3, p4, p5)
		return module.createElement(songTile, {
			contentId = p2,
			hasBackground = v6,
			impressionsTag = props.impressionsTag,
			layoutOrder = p3,
			size = p4,
			zIndex = -p3,
			useLargerFooterFont = v6,
			reportTileOpened = function()
				v18(p2, p3)
			end
		}), "SongTile"
	end, { v6, props.impressionsTag, v18 })

	local ref = module.useRef(nil)

	local v20, v21 = useCollectionImpressionsSignal()
	local ref2 = module.useRef(os.clock())
	module.useEffect(function()
		ref2.current = os.clock()
	end, { props.songIds })

	local useCallback2 = module.useCallback
	local function fn2(p2)
		if not props.songIds then
			return
		end

		local v22 = {}

		for i, songId in ipairs(props.songIds) do
			table.insert(v22, { id = songId })
		end

		local sendFromItemCollection = sendItemImpressions.sendFromItemCollection

		local v25 = #v22
		local pageContext = props.pageContext
		local v26 = if fFlagSongCarouselPropUpdate then props.collectionOrder else props.layoutOrder
		sendFromItemCollection(
			v8,
			v9,
			p2,
			v22,
			v25,
			pageContext,
			v26,
			contentType.Song,
			#v22,
			nil,
			props.referralId
		)
	end

	local songIds = props.songIds
	local title = props.title
	local v23 = if fFlagSongCarouselPropUpdate then props.collectionOrder else props.layoutOrder
	local v24 = useCallback2(fn2, { v8, v9, songIds, title, v23, props.pageContext })

	return module.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = not (fFlagSongEdpCarouselIxp or fFlagUpdateSongCarouselClipDefault) or (props.clipsDescendants or false),
		Size = UDim2.fromScale(1, 1),
		ref = setState
	}, {
		Carousel = module.createElement(collectionCarousel, {
			columnGap = v15.columnGap,
			fractionalItemAmount = v15.fractionalItemAmount,
			getItemHeight = v7,
			items = props.songIds,
			maxItemsToShow = v15.maxTilesToShow,
			numColumns = v15.numColumns,
			onViewableItemsChanged = v21,
			onChangeCanvasPosition = v21,
			renderItem = v19,
			scrollingFrameRef = ref,
			title = props.title
		}),
		SongTileImpressionsTracker = module.createElement(frameBoundsImpressionsTracker, {
			parentRef = ref,
			pageContext = props.pageContext,
			impressionsTag = props.impressionsTag,
			scrollViewPositionChangedSignal = v20,
			sendImpressions = v24,
			dataUpdatedTimestamp = ref2.current
		})
	})
end)
