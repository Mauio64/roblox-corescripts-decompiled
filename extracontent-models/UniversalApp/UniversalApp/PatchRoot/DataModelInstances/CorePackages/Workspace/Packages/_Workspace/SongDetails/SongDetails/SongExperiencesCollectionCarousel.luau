local Parent = script:FindFirstAncestor("SongDetails").Parent
local React = require(Parent.React)
local useRoactService = require(Parent.RobloxAppHooks).useRoactService
local RoactServiceTags = require(Parent.RoactServiceTags)
local AppEventIngestService = RoactServiceTags.AppEventIngestService
local RoactAnalytics = RoactServiceTags.RoactAnalytics
local RoactAnalyticsCommonGameEvents = RoactServiceTags.RoactAnalyticsCommonGameEvents
local CollectionViews = require(Parent.CollectionViews)
local CollectionCarousel = CollectionViews.CollectionCarousel
local useCollectionImpressionsSignal = CollectionViews.useCollectionImpressionsSignal
local DiscoveryAnalytics = require(Parent.DiscoveryAnalytics)
local Cryo = require(Parent.Cryo)
local GameCollections = require(Parent.GameCollections)
local useGameCollectionLayoutParams = GameCollections.useGameCollectionLayoutParams
local useGetGameTileHeight = GameCollections.useGetGameTileHeight
local useRenderGameCollectionItem = GameCollections.useRenderGameCollectionItem
local FrameBoundsImpressionsTracker = require(Parent.Impressions).FrameBoundsImpressionsTracker
local flaggedMutedError = require(Parent.Loggers).flaggedMutedError
local SendItemImpressions = require(Parent.UnifiedLogging).SendItemImpressions
local ContentType = require(Parent.UnifiedLogging).ContentType
local useTextSizeOffset = require(Parent.UIBlox).Core.Style.useTextSizeOffset
local GameTileConstants = require(Parent.GameTile).GameTileConstants
local Responsive = require(Parent.Responsive)
local usePreferredInput = Responsive.usePreferredInput

return React.memo(function(t1: {[any]: any}) -- line: 56
	-- upvalues: React (copy), useGameCollectionLayoutParams (copy), useTextSizeOffset (copy), useRoactService (copy), AppEventIngestService (copy), RoactAnalytics (copy), RoactAnalyticsCommonGameEvents (copy), flaggedMutedError (copy), Cryo (copy), SendItemImpressions (copy), ContentType (copy), usePreferredInput (copy), Responsive (copy), useGetGameTileHeight (copy), GameTileConstants (copy), useCollectionImpressionsSignal (copy), useRenderGameCollectionItem (copy), DiscoveryAnalytics (copy), CollectionCarousel (copy), FrameBoundsImpressionsTracker (copy)
	local v26, v27 = React.useState(nil)
	local v28 = useGameCollectionLayoutParams("Narrow", v26, false, {
		fractionalItemAmount = t1.fractionalItemAmount,
		numColumns = t1.numColumns,
		sideMargin = t1.sideMargin
	})
	local v29 = useTextSizeOffset()
	local v30 = useRoactService(AppEventIngestService)
	local v31 = useRoactService(RoactAnalytics)
	local v32 = useRoactService(RoactAnalyticsCommonGameEvents)
	local v33 = React.useRef(nil)
	local v34 = React.useCallback(function(n1: number?) -- line: 73
		-- upvalues: t1 (copy), v30 (copy), flaggedMutedError (copy), v32 (copy)
		local items = t1.items

		if items == nil or (v30 == nil or n1 == nil) then
			return
		end

		local v44 = items[n1]

		if not v44 then
			flaggedMutedError("SongExperiencesCollectionCarouselMissingEntry", "Entry not found for index: " .. tostring(n1))

			return
		end

		local placeId = v44.placeId
		local isSponsored = v44.isSponsored
		local adId = v44.adId
		local universeId = v44.universeId
		local v49 = #items
		local songId = t1.songId

		v32.reportOpenGameDetailFromSongDetail(placeId, n1, v49, isSponsored, adId, universeId, t1.pageContext, songId)
	end, {
		t1.items,
		v30,
		v31,
		v32,
		t1.songId,
		t1.pageContext
	})
	local v35 = React.useCallback(function(p1) -- line: 116
		-- upvalues: t1 (copy), Cryo (copy), SendItemImpressions (copy), v30 (copy), v31 (copy), ContentType (copy)
		if t1.items ~= nil then
			local t2 = {}

			for _, v in ipairs(t1.items) do
				table.insert(t2, (Cryo.Dictionary.union(v, {
					id = v.universeId
				})))
			end

			SendItemImpressions.sendFromItemCollection(v30, v31, p1, t2, #t2, t1.pageContext, t1.layoutOrder, ContentType.Game, #t2, nil, t1.songId)
		end
	end, {
		v30,
		v31,
		t1.items,
		t1.songId,
		t1.layoutOrder,
		t1.pageContext
	})
	local v36 = usePreferredInput() == Responsive.Input.Pointer
	local v37 = useGetGameTileHeight(v36, "Narrow", v36, false, false, 0, 0, GameTileConstants.TileTextLines.Narrow.titleTextLines)
	local v38, v39 = useCollectionImpressionsSignal()
	local v40 = React.useRef(os.clock())

	React.useEffect(function() -- line: 154
		-- upvalues: v40 (copy)
		v40.current = os.clock()
	end, { t1.items })

	local v41 = useRenderGameCollectionItem(nil, false, "Narrow", true, false, t1.impressionsTag, false, v34, function() -- line: 167
		error("Need to implement")
	end, DiscoveryAnalytics.Constants.Context.ExperienceTile, nil, nil, nil, nil, nil, false, nil, nil, false, false, nil, nil, nil, v29, GameTileConstants.TileTextLines.Narrow.titleTextLines, nil, nil, nil, nil)

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Size = UDim2.fromScale(1, 1),
		ref = v27
	}, {
		GameCarousel = React.createElement(CollectionCarousel, {
			columnGap = v28.columnGap,
			fractionalItemAmount = v28.fractionalItemAmount,
			getItemHeight = v37,
			items = t1.items,
			maxItemsToShow = v28.maxTilesToShow,
			numColumns = v28.numColumns,
			onViewableItemsChanged = v39,
			onChangeCanvasPosition = v39,
			renderItem = v41,
			scrollingFrameRef = v33,
			sideMargin = v28.sideMargin,
			title = t1.title
		}),
		SongTileImpressionsTracker = React.createElement(FrameBoundsImpressionsTracker, {
			parentRef = v33,
			pageContext = t1.pageContext,
			impressionsTag = t1.impressionsTag,
			scrollViewPositionChangedSignal = v38,
			sendImpressions = v35,
			dataUpdatedTimestamp = v40.current
		})
	})
end)
