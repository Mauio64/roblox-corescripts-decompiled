local Parent = script:FindFirstAncestor("SongDetails").Parent
local React = require(Parent.React)
local CollectionViews = require(Parent.CollectionViews)
local CollectionCarousel = CollectionViews.CollectionCarousel
local useCollectionImpressionsSignal = CollectionViews.useCollectionImpressionsSignal
local useRoactService = require(Parent.RobloxAppHooks).useRoactService
local RoactServiceTags = require(Parent.RoactServiceTags)
local AppEventIngestService = RoactServiceTags.AppEventIngestService
local RoactAnalytics = RoactServiceTags.RoactAnalytics
local GameCollections = require(Parent.GameCollections)
local useGameCollectionLayoutParams = GameCollections.useGameCollectionLayoutParams
local useGetGameTileHeight = GameCollections.useGetGameTileHeight
local FrameBoundsImpressionsTracker = require(Parent.Impressions).FrameBoundsImpressionsTracker
local SendItemImpressions = require(Parent.UnifiedLogging).SendItemImpressions
local SendItemActionEvent = require(Parent.UnifiedLogging).SendItemActionEvent
local ContentType = require(Parent.UnifiedLogging).ContentType
local useTextSizeOffset = require(Parent.UIBlox).Core.Style.useTextSizeOffset
local Responsive = require(Parent.Responsive)
local usePreferredInput = Responsive.usePreferredInput
local SongTile = require(Parent.SongTile).SongTile
local FFlagSongEdpCarouselIxp = require(Parent.SharedFlags).FFlagSongEdpCarouselIxp
local FFlagSongCarouselPropUpdate = require(Parent.SharedFlags).FFlagSongCarouselPropUpdate
local FFlagUpdateSongCarouselClipDefault = require(Parent.SharedFlags).FFlagUpdateSongCarouselClipDefault
local GameTileConstants = require(Parent.GameTile).GameTileConstants

return React.memo(function(t1: {[any]: any}) -- line: 56
	-- upvalues: useTextSizeOffset (copy), usePreferredInput (copy), Responsive (copy), useGetGameTileHeight (copy), GameTileConstants (copy), useRoactService (copy), AppEventIngestService (copy), RoactAnalytics (copy), React (copy), useGameCollectionLayoutParams (copy), FFlagSongEdpCarouselIxp (copy), SendItemActionEvent (copy), FFlagSongCarouselPropUpdate (copy), ContentType (copy), SongTile (copy), useCollectionImpressionsSignal (copy), SendItemImpressions (copy), FFlagUpdateSongCarouselClipDefault (copy), CollectionCarousel (copy), FrameBoundsImpressionsTracker (copy)
	local v26 = useTextSizeOffset()
	local v27 = usePreferredInput() == Responsive.Input.Pointer
	local v28 = useGetGameTileHeight(v27, "Narrow", v27, false, false, v26, nil, GameTileConstants.TileTextLines.Narrow.titleTextLines)
	local v29 = useRoactService(AppEventIngestService)
	local v30 = useRoactService(RoactAnalytics)
	local v31, v32 = React.useState(nil)
	local v33 = useGameCollectionLayoutParams("Narrow", v31, false, {
		numColumns = t1.numColumns,
		sideMargin = if not FFlagSongEdpCarouselIxp then nil else 0,
		columnGap = if not FFlagSongEdpCarouselIxp then nil else t1.columnGap,
		fractionalItemAmount = t1.fractionalItemAmount
	})
	local v34 = React.useCallback(function(s1: string, n1: number) -- line: 81
		-- upvalues: SendItemActionEvent (copy), v29 (copy), v30 (copy), t1 (copy), FFlagSongCarouselPropUpdate (copy), ContentType (copy)
		SendItemActionEvent.sendFromItemCollection(v29, v30, {
			id = s1
		}, 1, n1, t1.pageContext, if not FFlagSongCarouselPropUpdate then t1.layoutOrder else t1.collectionOrder, t1.referralId, #t1.songIds, ContentType.Song, "OpenSongDetails")
	end, {
		v29,
		v30,
		if not FFlagSongCarouselPropUpdate then t1.layoutOrder else t1.collectionOrder,
		t1.title,
		t1.songIds,
		t1.pageContext,
		t1.referralId
	})
	local v35 = React.useCallback(function(s2: string, n2: number, uDim2: UDim2, _: number?) -- line: 107
		-- upvalues: React (copy), SongTile (copy), v27 (copy), t1 (copy), v34 (copy)
		return React.createElement(SongTile, {
			contentId = s2,
			hasBackground = v27,
			impressionsTag = t1.impressionsTag,
			layoutOrder = n2,
			size = uDim2,
			zIndex = -n2,
			useLargerFooterFont = v27,
			reportTileOpened = function() -- line: 116
				-- upvalues: v34 (copy), s2 (copy), n2 (copy)
				v34(s2, n2)
			end
		}), "SongTile"
	end, {
		v27,
		t1.impressionsTag,
		v34
	})
	local v36 = React.useRef(nil)
	local v37, v38 = useCollectionImpressionsSignal()
	local v39 = React.useRef(os.clock())

	React.useEffect(function() -- line: 127
		-- upvalues: v39 (copy)
		v39.current = os.clock()
	end, { t1.songIds })

	local v40 = React.useCallback(function(p1) -- line: 131
		-- upvalues: t1 (copy), SendItemImpressions (copy), v29 (copy), v30 (copy), FFlagSongCarouselPropUpdate (copy), ContentType (copy)
		if not t1.songIds then
			return
		end

		local t2 = {}

		for _, v in ipairs(t1.songIds) do
			table.insert(t2, {
				id = v
			})
		end

		SendItemImpressions.sendFromItemCollection(v29, v30, p1, t2, #t2, t1.pageContext, if not FFlagSongCarouselPropUpdate then t1.layoutOrder else t1.collectionOrder, ContentType.Song, #t2, nil, t1.referralId)
	end, {
		v29,
		v30,
		t1.songIds,
		t1.title,
		if not FFlagSongCarouselPropUpdate then t1.layoutOrder else t1.collectionOrder,
		t1.pageContext
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = not FFlagSongEdpCarouselIxp and not FFlagUpdateSongCarouselClipDefault or (t1.clipsDescendants or false),
		Size = UDim2.fromScale(1, 1),
		ref = v32
	}, {
		Carousel = React.createElement(CollectionCarousel, {
			columnGap = v33.columnGap,
			fractionalItemAmount = v33.fractionalItemAmount,
			getItemHeight = v28,
			items = t1.songIds,
			maxItemsToShow = v33.maxTilesToShow,
			numColumns = v33.numColumns,
			onViewableItemsChanged = v38,
			onChangeCanvasPosition = v38,
			renderItem = v35,
			scrollingFrameRef = v36,
			title = t1.title
		}),
		SongTileImpressionsTracker = React.createElement(FrameBoundsImpressionsTracker, {
			parentRef = v36,
			pageContext = t1.pageContext,
			impressionsTag = t1.impressionsTag,
			scrollViewPositionChangedSignal = v37,
			sendImpressions = v40,
			dataUpdatedTimestamp = v39.current
		})
	})
end)
