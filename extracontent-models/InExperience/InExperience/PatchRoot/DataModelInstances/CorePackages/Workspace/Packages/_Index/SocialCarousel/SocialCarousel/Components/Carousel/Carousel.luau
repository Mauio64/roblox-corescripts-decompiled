local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local parent = SocialCarousel.Parent
local React = require(parent.React)
local CollectionViews = require(parent.CollectionViews)
local Localization = require(parent.Localization)
local Foundation = require(parent.Foundation)
local RobloxAppHooks = require(parent.RobloxAppHooks)

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
local useCarouselMarquee

if FFlagSocialCarouselInGameTitleMarquee then
	local useCarouselMarquee2 = require(SocialCarousel.Components.Carousel.useCarouselMarquee)
	useCarouselMarquee = useCarouselMarquee2.useCarouselMarquee
else
	useCarouselMarquee = nil
end

local function friendTileMarqueeProps(p, p2: number, p3, flag: boolean, p4: number?, callback, callback2, callback3, flag2: boolean, flag3: boolean, flag4: boolean)
	if p ~= Tile.Friend or p3 == nil then
		return nil, nil, nil, nil, nil, nil
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

	if flag4 then
		return v, callback, p4, callback2, callback3, true
	end

	return v, callback, p4, callback2, callback3, nil
end

local v = {}

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
	local v2

	if defineFastFlag then
		v2 = useTokens()
	else
		v2 = nil
	end

	local v3 = useSocialCarouselContext()
	local v4 = useTilesSeenCollection()
	local state, setState = React.useState(nil)
	local ref = React.useRef(nil)
	local ref2 = React.useRef({ startIndex = 1, endIndex = 1 })
	local ref3 = React.useRef(false)
	local ref4 = React.useRef(nil)
	local ref5 = React.useRef(nil)
	local v5

	if FFlagSocialCarouselShowLoadingSkeleton then
		v5 = not v3.isLoading and v3.friendCount > 0
	else
		v5 = v3.friendCount > 0
	end

	local friendsLabel

	if v5 then
		friendsLabel = {
			Constants.LOCALIZATION.FRIENDS_LABEL_WITH_COUNT,
			friendCount = v3.friendCount
		}
	else
		friendsLabel = Constants.LOCALIZATION.FRIENDS_LABEL
	end

	local v6 = useLocalization({ friendsLabel = friendsLabel })
	local sideMargin

	if not FFlagLuaAppCompositionAlways then
		sideMargin = usePageSideMargin(state)
	end

	if appCompositionEnabled then
		sideMargin = nil
	end

	local v7 = useCollectionLayoutParams(CollectionItemSize.XSmall, state, true, {
		sideMargin = sideMargin
	})

	local v8 = useCollectionLayout(CollectionItemSize.XSmall)
	local v9 = v8.itemsPerRow

	if not appCompositionEnabled then
		v9 = v7.numColumns
	end

	local isColdStartLayoutReady, onContainerSizeChanged

	if FFlagSocialCarouselFixColdStartJitter then
		local state2, setState2 = React.useState(Vector2.zero)
		isColdStartLayoutReady = useColdStartLayoutReady(
			RobloxAppHooks.useDeviceOrientation() ~= nil,
			RobloxAppHooks.useScreenSize(),
			state2.X,
			v9
		)
		onContainerSizeChanged = React.useCallback(function(vector2: Vector2)
			setState2(vector2)
		end, {})
	else
		isColdStartLayoutReady = false
	end

	local ref6, setState2

	if FFlagSocialCarouselLogNewFriendRequestsBadge then
		local v10 = React.useMemo(function()
			return findAddFriendsTileIndex(v3.tiles) -- inferred equivalent call
		end, { v3.tiles })
		ref6 = React.useRef(nil)
		local state2
		state2, setState2 = React.useState(nil)

		if state2 == nil or v10 == nil or not (state2.startIndex <= v10 and v10 <= state2.endIndex) then
			v10 = nil
		end

		useAddFriendsTileSeenImpression(v10)
	else
		setState2 = nil
		ref6 = nil
	end

	React.useEffect(function()
		if v9 ~= ref4.current then
			ref4.current = v9
			ref3.current = false

			if ref5.current then
				pcall(task.cancel, ref5.current)
			end

			ref5.current = task.delay(0.2, function()
				ref3.current = true
				ref5.current = nil
			end)
		end
	end, { v9 })

	React.useEffect(function()
		return function()
			if ref5.current then
				pcall(task.cancel, ref5.current)
			end
		end
	end, {})

	local getItemHeight = React.useCallback(function(p: number)
		local v10

		if defineFastFlag then
			v10 = Constants.TILE_TEXT_HEIGHT * v2.Config.UI.Scale
		else
			v10 = Constants.TILE_TEXT_HEIGHT
		end

		return p + v10
	end, {})

	local selectionOrderBase = v3.selectionOrderBase
	local isLoading = FFlagSocialCarouselShowLoadingSkeleton and v3.isLoading
	local activeByIndex, v10, onMarqueeFinished, onManualMarqueeStart, onManualMarqueeEnd, marqueeRunId, v11, v12, v13

	if FFlagSocialCarouselInGameTitleMarquee then
		local tiles = v3.tiles
		local v14

		if FFlagSocialCarouselBuildPresence then
			v14 = v3.openGameJoinCardUserId or v3.openBuildCardUserId
		else
			v14 = v3.openGameJoinCardUserId
		end

		local v15 = useCarouselMarquee(ref, tiles, v14, {
			appCompositionEnabled = appCompositionEnabled,
			itemsPerRow = v9,
			showSkeleton = isLoading,
			isColdStartLayoutReady = isColdStartLayoutReady,
			defaultSkeletonCount = 5,
			containerFrame = state,
			gutter = v8.gutter,
			carouselPeek = v8.carouselPeek,
			columnGap = v7.columnGap,
			sideMargin = v7.sideMargin,
			fractionalItemAmount = v7.fractionalItemAmount,
			maxTilesToShow = v7.maxTilesToShow
		})

		activeByIndex = v15.activeByIndex
		v10 = v15.isPaused
		onMarqueeFinished = v15.onMarqueeFinished
		onManualMarqueeStart = v15.onManualMarqueeStart
		onManualMarqueeEnd = v15.onManualMarqueeEnd
		marqueeRunId = v15.marqueeRunId
		v11 = v15.handsOff
		v12 = v15.desktopEnabled
		v13 = v15.consoleEnabled
	else
		activeByIndex = nil
		v10 = false
		marqueeRunId = nil
		onMarqueeFinished = nil
		onManualMarqueeStart = nil
		onManualMarqueeEnd = nil
		v11 = false
		v12 = false
		v13 = false
	end

	local useCallback = React.useCallback
	local function fn(p, p2, p3)
		local v14

		if selectionOrderBase then
			v14 = selectionOrderBase + p2
		end

		local v15, v16, v17, v18, v19, v20

		if FFlagSocialCarouselInGameTitleMarquee then
			local v21 = activeByIndex
			local v22 = v10
			v15 = marqueeRunId
			v16 = onMarqueeFinished
			v17 = onManualMarqueeStart
			v18 = onManualMarqueeEnd
			local v23 = v11
			local v24 = v12
			local v25 = v13

			if p.tileType == Tile.Friend and v21 ~= nil then
				v19 = v21[p2] == true and (v22 and "Paused" or "Playing") or "Idle"

				if not v23 then
					v16 = nil
				end

				local v26 = v24 or v25

				if not v26 then
					v17 = nil
				end

				if not v26 then
					v18 = nil
				end

				if v25 then
					v20 = true
				end
			else
				v16 = nil
				v15 = nil
				v17 = nil
				v18 = nil
			end
		end

		return TileComponents[p.tileType](p, p2, p3, v14, function(p4: string, p5: number, p6)
			if FFlagShowRequestsInCarouselForAllUsers and p6 then
				local current = ref2.current

				if current.startIndex <= p5 and p5 <= current.endIndex then
					v4.addTileToCollection(p4, p5, p6)
				end
			end

			if props.onTileContentChanged then
				props.onTileContentChanged(p4, p5, FFlagShowRequestsInCarouselForAllUsers and p6 or p)
			end
		end, v19, v16, v15, v17, v18, v20), p.tileType
	end

	local onTileContentChanged = props.onTileContentChanged
	local v14

	if FFlagShowRequestsInCarouselForAllUsers then
		v14 = v4
	end

	local v15

	if FFlagSocialCarouselInGameTitleMarquee then
		v15 = activeByIndex
	end

	local v16

	if FFlagSocialCarouselInGameTitleMarquee then
		v16 = v10
	end

	local v17

	if FFlagSocialCarouselInGameTitleMarquee then
		v17 = onMarqueeFinished
	end

	local v18

	if FFlagSocialCarouselInGameTitleMarquee then
		v18 = marqueeRunId
	end

	local v19

	if FFlagSocialCarouselInGameTitleMarquee then
		v19 = onManualMarqueeStart
	end

	local v20

	if FFlagSocialCarouselInGameTitleMarquee then
		v20 = onManualMarqueeEnd
	end

	local v21

	if FFlagSocialCarouselInGameTitleMarquee then
		v21 = v11
	end

	local v22

	if FFlagSocialCarouselInGameTitleMarquee then
		v22 = v12
	end

	local v23

	if FFlagSocialCarouselInGameTitleMarquee then
		v23 = v13
	end

	local renderItem = useCallback(fn, {
		selectionOrderBase,
		onTileContentChanged,
		v14,
		v15,
		v16,
		v17,
		v18,
		v19,
		v20,
		v21,
		v22,
		v23
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

		if v3.unifiedLogging then
			v3.unifiedLogging.onCollectionViewabilityChanged(startIndex, endIndex)
		end

		if v3.tiles and state and ref.current and ref3.current then
			local current = ref.current
			local absoluteSize = state.AbsoluteSize
			local canvasPosition = current.CanvasPosition
			local v24 = absoluteSize.X / v9
			local x = canvasPosition.X
			local x2 = absoluteSize.X

			local startIndex2 = math.max(1, math.floor(x / v24) + 1)

			local endIndex2 = math.min(#v3.tiles, (math.ceil((x + x2) / v24)))

			ref2.current = { startIndex = startIndex2, endIndex = endIndex2 }

			for i = startIndex2, endIndex2 do
				local tile = v3.tiles[i]

				if tile and tile.id then
					v4.addTileToCollection(tile.id, i, tile)
				end
			end
		end
	end, {
		props.onViewableItemsChanged,
		v3.tiles,
		v3.unifiedLogging,
		state,
		ref,
		v9,
		v4,
		setState2,
		ref6
	})

	local items = React.useMemo(function()
		local result = {}

		if not FFlagSocialCarouselShowLoadingSkeleton then
			return result
		end

		for i = 1, (v9 or 5) + 1 do
			result[i] = {
				id = "skeleton_" .. i,
				tileType = Tile.Skeleton
			}
		end

		return result
	end, { v9 })

	if not isLoading then
		items = v3.tiles
	end

	if FFlagSocialCarouselFixColdStartJitter and not isColdStartLayoutReady then
		items = v
	end

	local createElement = React.createElement
	local v24 = { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 }

	local v25 = {
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 0),
			PaddingRight = UDim.new(0, 0)
		}),
		CollectionCarousel = 0,
		ScreenSizeImpressionsTracker = 0
	}

	local createElement2 = React.createElement
	local v26 = {
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

	v26.onContainerSizeChanged = onContainerSizeChanged

	v26.title = v6.friendsLabel
	v26.items = items
	v26.renderItem = renderItem
	v26.getItemHeight = getItemHeight
	local collectionItemSize

	if appCompositionEnabled then
		collectionItemSize = CollectionItemSize.XSmall
	end

	v26.collectionItemSize = collectionItemSize
	local numColumns

	if not appCompositionEnabled then
		numColumns = v7.numColumns
	end

	v26.numColumns = numColumns
	local fractionalItemAmount

	if not appCompositionEnabled then
		fractionalItemAmount = v7.fractionalItemAmount
	end

	v26.fractionalItemAmount = fractionalItemAmount
	local columnGap

	if not appCompositionEnabled then
		columnGap = v7.columnGap
	end

	v26.columnGap = columnGap
	local sideMargin2

	if not appCompositionEnabled then
		sideMargin2 = v7.sideMargin
	end

	v26.sideMargin = sideMargin2
	v26.maxItemsToShow = v7.maxTilesToShow
	v26.thresholdFromEnd = v7.loadMoreThreshold

	if isLoading or FFlagSocialCarouselFixColdStartJitter and not isColdStartLayoutReady then
		onViewableItemsChanged = nil
	end

	v26.onViewableItemsChanged = onViewableItemsChanged
	local onChangeCanvasPosition

	if
		v3.unifiedLogging
		and not isLoading
		and (not FFlagSocialCarouselFixColdStartJitter or isColdStartLayoutReady)
	then
		onChangeCanvasPosition = v3.unifiedLogging.onCollectionViewabilityChanged
	end

	v26.onChangeCanvasPosition = onChangeCanvasPosition

	v26.onActivateHeader = props.onActivateHeader
	local headerComponent

	if FFlagLuaAppFriendsSortHeaderByPosition then
		if v3.hideCarouselHeader then
			headerComponent = React.createElement(React.Fragment, nil, {})
		end
	elseif v3.hideCarouselHeader then
		headerComponent = React.createElement(React.Fragment, nil, {})
	elseif FFlagFlyoutHideFriendsHeader then
		local v27

		if FFlagEnableFlyoutFriendsHeaderFix then
			v27 = FlyoutSidePanelIXP.isFriendsSortHeaderHiddenInFlyoutIxp()
		else
			v27 = FlyoutSidePanelIXP.isFlyoutSidePanelEnabled()
		end

		if v27 then
			headerComponent = React.createElement(React.Fragment, nil, {})
		end
	end

	v26.headerComponent = headerComponent
	v25.CollectionCarousel = createElement2(CollectionCarousel, v26)
	local screenSizeImpressionsTracker

	if v3.unifiedLogging and (not FFlagSocialCarouselFixColdStartJitter or isColdStartLayoutReady) then
		screenSizeImpressionsTracker = v3.unifiedLogging.renderImpressionsTrackerComponent(ref)
	end

	v25.ScreenSizeImpressionsTracker = screenSizeImpressionsTracker
	return createElement("Frame", v24, v25)
end

return Carousel
