local module = require("@luauforge/deferred/gEe")

local useRoactService = require("@luauforge/deferred/gEg").useRoactService
local module2 = require("@luauforge/deferred/gEh")
local appEventIngestService = module2.AppEventIngestService
local roactAnalytics = module2.RoactAnalytics
local roactAnalyticsCommonGameEvents = module2.RoactAnalyticsCommonGameEvents

local module3 = require("@luauforge/deferred/gEf")
local collectionCarousel = module3.CollectionCarousel
local useCollectionImpressionsSignal = module3.useCollectionImpressionsSignal

local module4 = require("@luauforge/deferred/gEO")

local module5 = require("@luauforge/deferred/gEt")

local module6 = require("@luauforge/deferred/gEi")
local useGameCollectionLayoutParams = module6.useGameCollectionLayoutParams
local useGetGameTileHeight = module6.useGetGameTileHeight
local useRenderGameCollectionItem = module6.useRenderGameCollectionItem

local frameBoundsImpressionsTracker = require("@luauforge/deferred/gEj").FrameBoundsImpressionsTracker

local flaggedMutedError = require("@luauforge/deferred/gEP").flaggedMutedError

local sendItemImpressions = require("@luauforge/deferred/gEk").SendItemImpressions
local contentType = require("@luauforge/deferred/gEk").ContentType

local useTextSizeOffset = require("@luauforge/deferred/gEl").Core.Style.useTextSizeOffset

local gameTileConstants = require("@luauforge/deferred/gEp").GameTileConstants

local module7 = require("@luauforge/deferred/gEm")
local usePreferredInput = module7.usePreferredInput

return module.memo(function(props)
	local state, setState = module.useState(nil)
	local v5 = useGameCollectionLayoutParams("Narrow", state, false, {
		fractionalItemAmount = props.fractionalItemAmount,
		numColumns = props.numColumns,
		sideMargin = props.sideMargin
	})

	local v6 = useTextSizeOffset()

	local v7 = useRoactService(appEventIngestService)
	local v8 = useRoactService(roactAnalytics)
	local v9 = useRoactService(roactAnalyticsCommonGameEvents)

	local ref = module.useRef(nil)

	local v10 = module.useCallback(function(p2)
		local items = props.items

		if items == nil or v7 == nil or p2 == nil then
			return
		end

		local item = items[p2]

		if not item then
			flaggedMutedError(
				"SongExperiencesCollectionCarouselMissingEntry",
				"Entry not found for index: " .. tostring(p2)
			)

			return
		end

		local placeId = item.placeId
		local isSponsored = item.isSponsored
		local adId = item.adId
		local universeId = item.universeId
		local v11 = #items
		local songId = props.songId

		v9.reportOpenGameDetailFromSongDetail(
			placeId,
			p2,
			v11,
			isSponsored,
			adId,
			universeId,
			props.pageContext,
			songId
		)
	end, { props.items, v7, v8, v9, props.songId, props.pageContext })

	local v11 = module.useCallback(function(p2)
		if props.items ~= nil then
			local v12 = {}

			for i, item in ipairs(props.items) do
				table.insert(v12, (module5.Dictionary.union(item, {
					id = item.universeId
				})))
			end

			sendItemImpressions.sendFromItemCollection(
				v7,
				v8,
				p2,
				v12,
				#v12,
				props.pageContext,
				props.layoutOrder,
				contentType.Game,
				#v12,
				nil,
				props.songId
			)
		end
	end, { v7, v8, props.items, props.songId, props.layoutOrder, props.pageContext })

	local v12 = usePreferredInput() == module7.Input.Pointer
	local v13 = useGetGameTileHeight(
		v12,
		"Narrow",
		v12,
		false,
		false,
		0,
		0,
		gameTileConstants.TileTextLines.Narrow.titleTextLines
	)

	local v14, v15 = useCollectionImpressionsSignal()
	local ref2 = module.useRef(os.clock())
	module.useEffect(function()
		ref2.current = os.clock()
	end, { props.items })

	local v16 = useRenderGameCollectionItem(
		nil,
		false,
		"Narrow",
		true,
		false,
		props.impressionsTag,
		false,
		v10,
		function()
			error("Need to implement")
		end,
		module4.Constants.Context.ExperienceTile,
		nil,
		nil,
		nil,
		nil,
		nil,
		false,
		nil,
		nil,
		false,
		false,
		nil,
		nil,
		nil,
		v6,
		gameTileConstants.TileTextLines.Narrow.titleTextLines,
		nil,
		nil,
		nil,
		nil
	)

	return module.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Size = UDim2.fromScale(1, 1),
		ref = setState
	}, {
		GameCarousel = module.createElement(collectionCarousel, {
			columnGap = v5.columnGap,
			fractionalItemAmount = v5.fractionalItemAmount,
			getItemHeight = v13,
			items = props.items,
			maxItemsToShow = v5.maxTilesToShow,
			numColumns = v5.numColumns,
			onViewableItemsChanged = v15,
			onChangeCanvasPosition = v15,
			renderItem = v16,
			scrollingFrameRef = ref,
			sideMargin = v5.sideMargin,
			title = props.title
		}),
		SongTileImpressionsTracker = module.createElement(frameBoundsImpressionsTracker, {
			parentRef = ref,
			pageContext = props.pageContext,
			impressionsTag = props.impressionsTag,
			scrollViewPositionChangedSignal = v14,
			sendImpressions = v11,
			dataUpdatedTimestamp = ref2.current
		})
	})
end)
