local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local parent = SocialCarousel.Parent
local React = require(parent.React)
local CollectionViews = require(parent.CollectionViews)
local Localization = require(parent.Localization)
local Foundation = require(parent.Foundation)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local RobloxAppEnums = require(parent.RobloxAppEnums)

local CollectionCarousel = CollectionViews.CollectionCarousel
local useCollectionLayoutParams = CollectionViews.useCollectionLayoutParams
local useCollectionLayout = CollectionViews.useCollectionLayout
local CollectionViewTypes = CollectionViews.CollectionViewTypes
local usePageSideMargin = CollectionViews.usePageSideMargin
local CollectionItemSize = CollectionViewTypes.CollectionItemSize
local useLocalization = Localization.Hooks.useLocalization
local TileComponents = require(SocialCarousel.Common.TileComponents)
local Enums = require(SocialCarousel.Common.Enums)
local Tile = Enums.Tile
local Constants = require(SocialCarousel.Common.Constants)
local useSocialCarouselContext = require(SocialCarousel.Contexts.useSocialCarouselContext)
local useColdStartLayoutReady = require(SocialCarousel.Hooks.useColdStartLayoutReady)
local useAddFriendsTileSeenImpression = require(SocialCarousel.Hooks.useAddFriendsTileSeenImpression)
local useTokens = Foundation.Hooks.useTokens
local useTilesSeenCollection = require(SocialCarousel.Analytics.useTilesSeenCollection)
local FFlagSocialCarouselShowLoadingSkeleton = require(SocialCarousel.Flags.FFlagSocialCarouselShowLoadingSkeleton)
local FFlagSocialCarouselFixColdStartJitter = require(SocialCarousel.Flags.FFlagSocialCarouselFixColdStartJitter)
local defineFastFlag = game:DefineFastFlag("FixCarouselTileSizeScaling", false)
local FFlagFlyoutHideFriendsHeader = require(SocialCarousel.Flags.FFlagFlyoutHideFriendsHeader)
local SharedExperimentDefinition = require(parent.SharedExperimentDefinition)
local FlyoutSidePanelIXP = SharedExperimentDefinition.FlyoutSidePanelIXP
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableFlyoutFriendsHeaderFix = SharedFlags.FFlagEnableFlyoutFriendsHeaderFix
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppCompositionAlways = SharedFlags2.FFlagLuaAppCompositionAlways
local FFlagLuaAppFriendsSortHeaderByPosition = SharedFlags.FFlagLuaAppFriendsSortHeaderByPosition
local SharedFlags3 = require(parent.SharedFlags)
local FFlagSocialCarouselInGameTitleMarquee = SharedFlags3.FFlagSocialCarouselInGameTitleMarquee
local FFlagSocialCarouselBuildPresence = SharedFlags.FFlagSocialCarouselBuildPresence

local FFlagSocialCarouselLogNewFriendRequestsBadge = require(SocialCarousel.Flags.FFlagSocialCarouselLogNewFriendRequestsBadge)
local FFlagShowRequestsInCarouselForAllUsers = SharedFlags.FFlagShowRequestsInCarouselForAllUsers
local FFlagSocialCarouselXXSmallTiles = require(SocialCarousel.Flags.FFlagSocialCarouselXXSmallTiles)
local FFlagSocialCarouselXSmallTileText = require(SocialCarousel.Flags.FFlagSocialCarouselXSmallTileText)
local MarqueeScrollContext = require(SocialCarousel.Stores.MarqueeSession.MarqueeScrollContext)
local marqueeScrollContext = MarqueeScrollContext.MarqueeScrollContext
local useCarouselMarquee

if FFlagSocialCarouselInGameTitleMarquee then
	local useCarouselMarquee2 = require(SocialCarousel.Components.Carousel.useCarouselMarquee)
	useCarouselMarquee = useCarouselMarquee2.useCarouselMarquee
else
	useCarouselMarquee = nil
end

local function friendTileMarqueeProps(p, p2: number, p3, flag: boolean, p4: number?, callback, callback2, callback3, flag2: boolean, flag3: boolean, flag4: boolean, flag5: boolean)
	if p ~= Tile.Friend or p3 == nil then
		return nil, nil, nil, nil, nil, nil, nil
	end

	local v = p3[p2] == true and (flag and "Paused" or "Playing") or "Idle"

	if not flag2 then
		callback = nil
	end

	local v2 = flag3 or flag4

	if not v2 then
		callback2 = nil
	end

	if not v2 then
		callback3 = nil
	end

	return v, callback, p4, callback2, callback3, flag4 and true or nil, flag5
end

local v = {}
local v2 = {
	[Tile.AddFriends] = "add-friends",
	[Tile.ShareQR] = "share-qr",
	[Tile.StartSquad] = "start-squad",
	[Tile.Skeleton] = "skeleton"
}

local function findAddFriendsTileIndex(tiles) -- 1 equivalent call inferred from this helper
	if tiles == nil then
		return nil
	end

	for i, item in ipairs(tiles) do
		if item and item.tileType == Tile.AddFriends then
			return i
		end
	end

	return nil
end

local function Carousel(props)
	local appCompositionEnabled = FFlagLuaAppCompositionAlways or props.appCompositionEnabled
	local v3

	if defineFastFlag then
		v3 = useTokens()
	else
		v3 = nil
	end

	local v4 = useSocialCarouselContext()
	local v5 = useTilesSeenCollection()
	local state, setState = React.useState(nil)
	local ref = React.useRef(nil)
	local ref2 = React.useRef({ startIndex = 1, endIndex = 1 })
	local ref3 = React.useRef(false)
	local ref4 = React.useRef(nil)
	local ref5 = React.useRef(nil)
	local v6

	if FFlagSocialCarouselShowLoadingSkeleton then
		v6 = not v4.isLoading and v4.friendCount > 0
	else
		v6 = v4.friendCount > 0
	end

	local friendsLabel

	if v6 then
		friendsLabel = {
			Constants.LOCALIZATION.FRIENDS_LABEL_WITH_COUNT,
			friendCount = v4.friendCount
		}
	else
		friendsLabel = Constants.LOCALIZATION.FRIENDS_LABEL
	end

	local v7 = useLocalization({ friendsLabel = friendsLabel })
	local sideMargin

	if not FFlagLuaAppCompositionAlways then
		sideMargin = usePageSideMargin(state)
	end

	if appCompositionEnabled then
		sideMargin = nil
	end

	local v8 = useCollectionLayoutParams(CollectionItemSize.XSmall, state, true, {
		sideMargin = sideMargin
	})
	local v9

	if FFlagSocialCarouselXXSmallTiles or FFlagSocialCarouselXSmallTileText then
		v9 = RobloxAppHooks.useDeviceType() == RobloxAppEnums.DeviceType.Phone
	else
		v9 = false
	end

	local v10 = useCollectionLayout(CollectionItemSize.XSmall)
	local numColumns

	if FFlagSocialCarouselXXSmallTiles and v9 then
		numColumns = v10.itemsPerRow + 1
	else
		numColumns = v10.itemsPerRow
	end

	local v11

	if appCompositionEnabled then
		v11 = numColumns
	else
		v11 = v8.numColumns
	end

	local isColdStartLayoutReady, onContainerSizeChanged

	if FFlagSocialCarouselFixColdStartJitter then
		local state2, setState2 = React.useState(Vector2.zero)
		isColdStartLayoutReady = useColdStartLayoutReady(
			RobloxAppHooks.useDeviceOrientation() ~= nil,
			RobloxAppHooks.useScreenSize(),
			state2.X,
			v11
		)
		onContainerSizeChanged = React.useCallback(function(vector2: Vector2)
			setState2(vector2)
		end, {})
	else
		isColdStartLayoutReady = false
	end

	local ref6, setState2

	if FFlagSocialCarouselLogNewFriendRequestsBadge then
		local v12 = React.useMemo(function()
			return findAddFriendsTileIndex(v4.tiles) -- inferred equivalent call
		end, { v4.tiles })
		ref6 = React.useRef(nil)
		local state2
		state2, setState2 = React.useState(nil)

		if state2 == nil or v12 == nil or not (state2.startIndex <= v12 and v12 <= state2.endIndex) then
			v12 = nil
		end

		useAddFriendsTileSeenImpression(v12)
	else
		setState2 = nil
		ref6 = nil
	end

	React.useEffect(function()
		if v11 ~= ref4.current then
			ref4.current = v11
			ref3.current = false

			if ref5.current then
				pcall(task.cancel, ref5.current)
			end

			ref5.current = task.delay(0.2, function()
				ref3.current = true
				ref5.current = nil
			end)
		end
	end, { v11 })

	React.useEffect(function()
		return function()
			if ref5.current then
				pcall(task.cancel, ref5.current)
			end
		end
	end, {})
	local v12

	if FFlagSocialCarouselXSmallTileText and v9 then
		v12 = Constants.XSMALL_TILE_TEXT_HEIGHT
	else
		v12 = Constants.TILE_TEXT_HEIGHT
	end

	local useCallback = React.useCallback
	local function fn(p: number)
		local v13

		if defineFastFlag then
			v13 = v12 * v3.Config.UI.Scale
		else
			v13 = v12
		end

		return p + v13
	end

	local v13

	if FFlagSocialCarouselXSmallTileText then
		v13 = v12
	end

	local v14

	if FFlagSocialCarouselXSmallTileText and v3 then
		v14 = v3.Config.UI.Scale
	end

	local getItemHeight = useCallback(fn, { v13, v14 })

	local selectionOrderBase = v4.selectionOrderBase
	local isLoading = FFlagSocialCarouselShowLoadingSkeleton and v4.isLoading
	local activeByIndex, v15, onMarqueeFinished, onManualMarqueeStart, onManualMarqueeEnd, marqueeRunId, v16, v17, v18, v19, scrollContext

	if FFlagSocialCarouselInGameTitleMarquee then
		local v20 = v4.source == Constants.ANALYTICS.SRC.HOMEPAGE_FRIENDS_CAROUSEL

		local tiles = v4.tiles
		local v21

		if FFlagSocialCarouselBuildPresence then
			v21 = v4.openGameJoinCardUserId or v4.openBuildCardUserId
		else
			v21 = v4.openGameJoinCardUserId
		end

		local v22 = useCarouselMarquee(ref, tiles, v21, {
			appCompositionEnabled = appCompositionEnabled,
			itemsPerRow = v11,
			showSkeleton = isLoading,
			isColdStartLayoutReady = isColdStartLayoutReady,
			defaultSkeletonCount = 5,
			containerFrame = state,
			gutter = v10.gutter,
			carouselPeek = v10.carouselPeek,
			columnGap = v8.columnGap,
			sideMargin = v8.sideMargin,
			fractionalItemAmount = v8.fractionalItemAmount,
			maxTilesToShow = v8.maxTilesToShow
		}, v4.joinPopoverUserIdRef, v4.joinSheetUserIdRef, v4.source, v20)

		activeByIndex = v22.activeByIndex
		v15 = v22.isPaused
		onMarqueeFinished = v22.onMarqueeFinished
		onManualMarqueeStart = v22.onManualMarqueeStart
		onManualMarqueeEnd = v22.onManualMarqueeEnd
		marqueeRunId = v22.marqueeRunId
		v16 = v22.handsOff
		v17 = v22.desktopEnabled
		v18 = v22.consoleEnabled
		v19 = v22.marqueeShortTitlesEnabled == true
		scrollContext = v22.scrollContext
	else
		activeByIndex = nil
		v15 = false
		marqueeRunId = nil
		onMarqueeFinished = nil
		onManualMarqueeStart = nil
		onManualMarqueeEnd = nil
		v16 = false
		v17 = false
		v18 = false
		v19 = false
	end

	local v20

	if FFlagSocialCarouselXXSmallTiles then
		v20 = v9 and appCompositionEnabled == true
	else
		v20 = nil
	end

	local useCallback2 = React.useCallback
	local function fn2(p, p2, p3)
		local v21

		if selectionOrderBase then
			v21 = selectionOrderBase + p2
		end

		local v22, v23, v24, v25, v26, v27, v28

		if FFlagSocialCarouselInGameTitleMarquee then
			local v29 = activeByIndex
			local v30 = v15
			v22 = marqueeRunId
			v23 = onMarqueeFinished
			v24 = onManualMarqueeStart
			v25 = onManualMarqueeEnd
			local v31 = v16
			local v32 = v17
			local v41 = v18
			v26 = v19

			if p.tileType == Tile.Friend and v29 ~= nil then
				v27 = v29[p2] == true and (v30 and "Paused" or "Playing") or "Idle"

				if not v31 then
					v23 = nil
				end

				local v42 = v32 or v41

				if not v42 then
					v24 = nil
				end

				if not v42 then
					v25 = nil
				end

				v28 = v41 and true or nil
			else
				v23 = nil
				v22 = nil
				v24 = nil
				v25 = nil
				v26 = nil
			end
		end

		local v29 = TileComponents[p.tileType](p, p2, p3, v21, function(p4: string, p5: number, p6)
			if FFlagShowRequestsInCarouselForAllUsers and p6 then
				local current = ref2.current

				if current.startIndex <= p5 and p5 <= current.endIndex then
					v5.addTileToCollection(p4, p5, p6)
				end
			end

			if props.onTileContentChanged then
				props.onTileContentChanged(p4, p5, FFlagShowRequestsInCarouselForAllUsers and p6 or p)
			end
		end, v20, v27, v23, v22, v24, v25, v28, v26)

		local v30 = v2[p.tileType]

		if not v30 then
			return v29, p.tileType
		end

		local sortAnalyticsData = v4.sortAnalyticsData
		local source = v4.source or "carousel"
		local v31 = not sortAnalyticsData and 1 or sortAnalyticsData.sortIndex
		v29 = React.cloneElement(v29, {
			testId = `--social-social-carousel-view-{v30}-{source}-{v31}-{p2}`
		})

		return v29, p.tileType
	end

	local onTileContentChanged = props.onTileContentChanged
	local source = v4.source
	local sortAnalyticsData = v4.sortAnalyticsData
	local v21

	if FFlagShowRequestsInCarouselForAllUsers then
		v21 = v5
	end

	local v22

	if FFlagSocialCarouselInGameTitleMarquee then
		v22 = activeByIndex
	end

	local v23

	if FFlagSocialCarouselInGameTitleMarquee then
		v23 = v15
	end

	local v24

	if FFlagSocialCarouselInGameTitleMarquee then
		v24 = onMarqueeFinished
	end

	local v25

	if FFlagSocialCarouselInGameTitleMarquee then
		v25 = marqueeRunId
	end

	local v26

	if FFlagSocialCarouselInGameTitleMarquee then
		v26 = onManualMarqueeStart
	end

	local v27

	if FFlagSocialCarouselInGameTitleMarquee then
		v27 = onManualMarqueeEnd
	end

	local v28

	if FFlagSocialCarouselInGameTitleMarquee then
		v28 = v16
	end

	local v29

	if FFlagSocialCarouselInGameTitleMarquee then
		v29 = v17
	end

	local v30

	if FFlagSocialCarouselInGameTitleMarquee then
		v30 = v18
	end

	local v31

	if FFlagSocialCarouselInGameTitleMarquee then
		v31 = v19
	end

	local renderItem = useCallback2(fn2, {
		selectionOrderBase,
		v20,
		onTileContentChanged,
		source,
		sortAnalyticsData,
		v21,
		v22,
		v23,
		v24,
		v25,
		v26,
		v27,
		v28,
		v29,
		v30,
		v31
	})

	local onViewableItemsChanged = React.useCallback(function(startIndex: number, endIndex: number)
		if FFlagSocialCarouselLogNewFriendRequestsBadge and setState2 ~= nil and ref6 ~= nil then
			local current = ref6.current

			if current == nil or current.startIndex ~= startIndex or current.endIndex ~= endIndex then
				local current2 = { startIndex = startIndex, endIndex = endIndex }

				ref6.current = current2
				setState2(current2)
			end
		end

		if v4.unifiedLogging then
			v4.unifiedLogging.onCollectionViewabilityChanged(startIndex, endIndex)
		end

		if v4.tiles and state and ref.current and ref3.current then
			local current = ref.current
			local absoluteSize = state.AbsoluteSize
			local canvasPosition = current.CanvasPosition
			local v32 = absoluteSize.X / v11
			local x = canvasPosition.X
			local x2 = absoluteSize.X

			local startIndex2 = math.max(1, math.floor(x / v32) + 1)

			local endIndex2 = math.min(#v4.tiles, (math.ceil((x + x2) / v32)))

			ref2.current = { startIndex = startIndex2, endIndex = endIndex2 }

			for i = startIndex2, endIndex2 do
				local tile = v4.tiles[i]

				if tile and tile.id then
					v5.addTileToCollection(tile.id, i, tile)
				end
			end
		end
	end, {
		props.onViewableItemsChanged,
		v4.tiles,
		v4.unifiedLogging,
		state,
		ref,
		v11,
		v5,
		setState2,
		ref6
	})

	local items = React.useMemo(function()
		local result = {}

		if not FFlagSocialCarouselShowLoadingSkeleton then
			return result
		end

		for i = 1, (v11 or 5) + 1 do
			result[i] = {
				id = "skeleton_" .. i,
				tileType = Tile.Skeleton
			}
		end

		return result
	end, { v11 })

	if not isLoading then
		items = v4.tiles
	end

	if FFlagSocialCarouselFixColdStartJitter and not isColdStartLayoutReady then
		items = v
	end

	local createElement = React.createElement
	local v32 = { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 }

	local v46 = {
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 0),
			PaddingRight = UDim.new(0, 0)
		}),
		CollectionCarousel = 0,
		ScreenSizeImpressionsTracker = 0
	}

	local createElement2 = React.createElement
	local v47 = {
		containerRef = setState,
		scrollingFrameRef = ref,
		onContainerSizeChanged = nil,
		LayoutOrder = 1,
		title = 0,
		items = 0,
		renderItem = 0,
		getItemHeight = 0,
		collectionItemSize = 0,
		numColumns = 0,
		fractionalItemAmount = 0,
		columnGap = 0,
		sideMargin = 0,
		maxItemsToShow = 0,
		thresholdFromEnd = 0,
		onViewableItemsChanged = 0,
		onChangeCanvasPosition = 0,
		onActivateHeader = 0,
		headerComponent = 0
	}

	if not FFlagSocialCarouselFixColdStartJitter then
		onContainerSizeChanged = nil
	end

	v47.onContainerSizeChanged = onContainerSizeChanged

	v47.title = v7.friendsLabel
	v47.items = items
	v47.renderItem = renderItem
	v47.getItemHeight = getItemHeight
	local collectionItemSize

	if appCompositionEnabled then
		collectionItemSize = CollectionItemSize.XSmall
	end

	v47.collectionItemSize = collectionItemSize

	if appCompositionEnabled then
		if not (FFlagSocialCarouselXXSmallTiles and v9) then
			numColumns = nil
		end
	else
		numColumns = v8.numColumns
	end

	v47.numColumns = numColumns
	local fractionalItemAmount

	if not appCompositionEnabled then
		fractionalItemAmount = v8.fractionalItemAmount
	end

	v47.fractionalItemAmount = fractionalItemAmount
	local columnGap

	if not appCompositionEnabled then
		columnGap = v8.columnGap
	end

	v47.columnGap = columnGap
	local sideMargin2

	if not appCompositionEnabled then
		sideMargin2 = v8.sideMargin
	end

	v47.sideMargin = sideMargin2
	v47.maxItemsToShow = v8.maxTilesToShow
	v47.thresholdFromEnd = v8.loadMoreThreshold

	if isLoading or FFlagSocialCarouselFixColdStartJitter and not isColdStartLayoutReady then
		onViewableItemsChanged = nil
	end

	v47.onViewableItemsChanged = onViewableItemsChanged
	local onChangeCanvasPosition

	if
		v4.unifiedLogging
		and not isLoading
		and (not FFlagSocialCarouselFixColdStartJitter or isColdStartLayoutReady)
	then
		onChangeCanvasPosition = v4.unifiedLogging.onCollectionViewabilityChanged
	end

	v47.onChangeCanvasPosition = onChangeCanvasPosition

	v47.onActivateHeader = props.onActivateHeader
	local headerComponent

	if FFlagLuaAppFriendsSortHeaderByPosition then
		if v4.hideCarouselHeader then
			headerComponent = React.createElement(React.Fragment, nil, {})
		end
	elseif v4.hideCarouselHeader then
		headerComponent = React.createElement(React.Fragment, nil, {})
	elseif FFlagFlyoutHideFriendsHeader then
		local v54

		if FFlagEnableFlyoutFriendsHeaderFix then
			v54 = FlyoutSidePanelIXP.isFriendsSortHeaderHiddenInFlyoutIxp()
		else
			v54 = FlyoutSidePanelIXP.isFlyoutSidePanelEnabled()
		end

		if v54 then
			headerComponent = React.createElement(React.Fragment, nil, {})
		end
	end

	v47.headerComponent = headerComponent
	v46.CollectionCarousel = createElement2(CollectionCarousel, v47)
	local screenSizeImpressionsTracker

	if v4.unifiedLogging and (not FFlagSocialCarouselFixColdStartJitter or isColdStartLayoutReady) then
		screenSizeImpressionsTracker = v4.unifiedLogging.renderImpressionsTrackerComponent(ref)
	end

	v46.ScreenSizeImpressionsTracker = screenSizeImpressionsTracker
	local element = createElement("Frame", v32, v46)

	if scrollContext == nil then
		return element
	end

	return React.createElement(marqueeScrollContext.Provider, { value = scrollContext }, {
		Carousel = element
	})
end

return Carousel
