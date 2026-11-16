local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/React")
local CollectionViews = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/CollectionViews")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Localization")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Foundation")
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/RobloxAppHooks")

local collectionCarousel = CollectionViews.CollectionCarousel
local useCollectionLayoutParams = CollectionViews.useCollectionLayoutParams
local useCollectionLayout = CollectionViews.useCollectionLayout
local collectionViewTypes = CollectionViews.CollectionViewTypes
local usePageSideMargin = CollectionViews.usePageSideMargin
local collectionItemSize = collectionViewTypes.CollectionItemSize
local useLocalization = Localization.Hooks.useLocalization
local TileComponents = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Common/TileComponents")
local tile = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Common/Enums").Tile
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Common/Constants")
local useSocialCarouselContext = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Contexts/useSocialCarouselContext")
local useColdStartLayoutReady = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Hooks/useColdStartLayoutReady")
local useAddFriendsTileSeenImpression = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Hooks/useAddFriendsTileSeenImpression")
local useTokens = Foundation.Hooks.useTokens
local useTilesSeenCollection = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Analytics/useTilesSeenCollection")
local FFlagSocialCarouselShowLoadingSkeleton = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Flags/FFlagSocialCarouselShowLoadingSkeleton")
local FFlagSocialCarouselFixColdStartJitter = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Flags/FFlagSocialCarouselFixColdStartJitter")
local defineFastFlag = game:DefineFastFlag("FixCarouselTileSizeScaling", false)
local FFlagFlyoutHideFriendsHeader = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Flags/FFlagFlyoutHideFriendsHeader")
local flyoutSidePanelIXP = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedExperimentDefinition").FlyoutSidePanelIXP
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags")
local fFlagEnableFlyoutFriendsHeaderFix = SharedFlags.FFlagEnableFlyoutFriendsHeaderFix
local fFlagLuaAppCompositionAlways = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags").FFlagLuaAppCompositionAlways
local fFlagLuaAppFriendsSortHeaderByPosition = SharedFlags.FFlagLuaAppFriendsSortHeaderByPosition
local fFlagSocialCarouselInGameTitleMarquee = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags").FFlagSocialCarouselInGameTitleMarquee
local fFlagSocialCarouselBuildPresence = SharedFlags.FFlagSocialCarouselBuildPresence

local FFlagSocialCarouselLogNewFriendRequestsBadge = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Flags/FFlagSocialCarouselLogNewFriendRequestsBadge")
local fFlagShowRequestsInCarouselForAllUsers = SharedFlags.FFlagShowRequestsInCarouselForAllUsers
local useCarouselMarquee

if fFlagSocialCarouselInGameTitleMarquee then
	useCarouselMarquee = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Components/Carousel/useCarouselMarquee").useCarouselMarquee
else
	useCarouselMarquee = nil
end

local function friendTileMarqueeProps(p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12)
	if p2 ~= tile.Friend or p4 == nil then
		return nil, nil, nil, nil, nil, nil
	end

	local v5 = p4[p3] == true and (p5 and "Paused" or "Playing") or "Idle"

	if not p10 then
		p7 = nil
	end

	local v6 = p11 or p12

	if not v6 then
		p8 = nil
	end

	if not v6 then
		p9 = nil
	end

	if p12 then
		return v5, p7, p6, p8, p9, true
	end

	return v5, p7, p6, p8, p9, nil
end

local v5 = {}

local function findAddFriendsTileIndex(list)
	if list == nil then
		return nil
	end

	for i, item in ipairs(list) do
		if item and item.tileType == tile.AddFriends then
			return i
		end
	end

	return nil
end

local function Carousel(props)
	local v6 = fFlagLuaAppCompositionAlways or props.appCompositionEnabled
	local v7 = if defineFastFlag then useTokens() else nil
	local v8 = useSocialCarouselContext()
	local v9 = useTilesSeenCollection()
	local state, setState = React.useState(nil)
	local ref = React.useRef(nil)
	local ref2 = React.useRef({ startIndex = 1, endIndex = 1 })
	local ref3 = React.useRef(false)
	local ref4 = React.useRef(nil)
	local ref5 = React.useRef(nil)

	local v10 = if FFlagSocialCarouselShowLoadingSkeleton then not v8.isLoading and v8.friendCount > 0 else v8.friendCount > 0
	local v11

	if v10 then
		v11 = {
			Constants.LOCALIZATION.FRIENDS_LABEL_WITH_COUNT,
			friendCount = v8.friendCount
		}
	else
		v11 = Constants.LOCALIZATION.FRIENDS_LABEL
	end

	local v12 = useLocalization({ friendsLabel = v11 })

	local v13 = if not fFlagLuaAppCompositionAlways then usePageSideMargin(state) else nil

	if v6 then
		v13 = nil
	end

	local v14 = useCollectionLayoutParams(collectionItemSize.XSmall, state, true, {
		sideMargin = v13
	})

	local v15 = useCollectionLayout(collectionItemSize.XSmall)
	local v16 = v15.itemsPerRow

	if not v6 then
		v16 = v14.numColumns
	end

	local v17, v18

	if FFlagSocialCarouselFixColdStartJitter then
		local state2, setState2 = React.useState(Vector2.zero)
		v17 = useColdStartLayoutReady(RobloxAppHooks.useDeviceOrientation() ~= nil, RobloxAppHooks.useScreenSize(), state2.X, v16)
		v18 = React.useCallback(function(p2)
			setState2(p2)
		end, {})
	else
		v17 = false
	end

	local ref6, setState2

	if FFlagSocialCarouselLogNewFriendRequestsBadge then
		local v19 = React.useMemo(function()
			local tiles = v8.tiles

			if tiles == nil then
				return nil
			end

			for i, tile2 in ipairs(tiles) do
				if tile2 and tile2.tileType == tile.AddFriends then
					return i
				end
			end

			return nil
		end, { v8.tiles })
		ref6 = React.useRef(nil)
		local state2
		state2, setState2 = React.useState(nil)

		if state2 == nil or v19 == nil or not (state2.startIndex <= v19 and v19 <= state2.endIndex) then
			v19 = nil
		end

		useAddFriendsTileSeenImpression(v19)
	else
		setState2 = nil
		ref6 = nil
	end

	React.useEffect(function()
		if v16 ~= ref4.current then
			ref4.current = v16
			ref3.current = false

			if ref5.current then
				pcall(task.cancel, ref5.current)
			end

			ref5.current = task.delay(0.2, function()
				ref3.current = true
				ref5.current = nil
			end)
		end
	end, { v16 })

	React.useEffect(function()
		return function()
			if ref5.current then
				pcall(task.cancel, ref5.current)
			end
		end
	end, {})

	local v19 = React.useCallback(function(p2)
		local v20 = if defineFastFlag then Constants.TILE_TEXT_HEIGHT * v7.Config.UI.Scale else Constants.TILE_TEXT_HEIGHT
		return p2 + v20
	end, {})

	local selectionOrderBase = v8.selectionOrderBase
	local isLoading = FFlagSocialCarouselShowLoadingSkeleton and v8.isLoading
	local activeByIndex, v20, onMarqueeFinished, onManualMarqueeStart, onManualMarqueeEnd, marqueeRunId, v21, v22, v23

	if fFlagSocialCarouselInGameTitleMarquee then
		local tiles = v8.tiles
		local v25

		if fFlagSocialCarouselBuildPresence then
			v25 = v8.openGameJoinCardUserId or v8.openBuildCardUserId
		else
			v25 = v8.openGameJoinCardUserId
		end

		local v26 = useCarouselMarquee(ref, tiles, v25, {
			appCompositionEnabled = v6,
			itemsPerRow = v16,
			showSkeleton = isLoading,
			isColdStartLayoutReady = v17,
			defaultSkeletonCount = 5,
			containerFrame = state,
			gutter = v15.gutter,
			carouselPeek = v15.carouselPeek,
			columnGap = v14.columnGap,
			sideMargin = v14.sideMargin,
			fractionalItemAmount = v14.fractionalItemAmount,
			maxTilesToShow = v14.maxTilesToShow
		})

		activeByIndex = v26.activeByIndex
		v20 = v26.isPaused
		onMarqueeFinished = v26.onMarqueeFinished
		onManualMarqueeStart = v26.onManualMarqueeStart
		onManualMarqueeEnd = v26.onManualMarqueeEnd
		marqueeRunId = v26.marqueeRunId
		v21 = v26.handsOff
		v22 = v26.desktopEnabled
		v23 = v26.consoleEnabled
	else
		activeByIndex = nil
		v20 = false
		marqueeRunId = nil
		onMarqueeFinished = nil
		onManualMarqueeStart = nil
		onManualMarqueeEnd = nil
		v21 = false
		v22 = false
		v23 = false
	end

	local useCallback = React.useCallback
	local function fn(p2, p3, p4)
		local v24 = if selectionOrderBase then selectionOrderBase + p3 else nil
		local v25, v26, v27, v28, v29, v30

		if fFlagSocialCarouselInGameTitleMarquee then
			local v31 = activeByIndex
			local v32 = v20
			v25 = marqueeRunId
			v26 = onMarqueeFinished
			v27 = onManualMarqueeStart
			v28 = onManualMarqueeEnd
			local v33 = v21
			local v34 = v22
			local v35 = v23

			if p2.tileType == tile.Friend and v31 ~= nil then
				v29 = v31[p3] == true and (v32 and "Paused" or "Playing") or "Idle"

				if not v33 then
					v26 = nil
				end

				local v36 = v34 or v35

				if not v36 then
					v27 = nil
				end

				if not v36 then
					v28 = nil
				end

				if v35 then
					v30 = true
				end
			else
				v26 = nil
				v25 = nil
				v27 = nil
				v28 = nil
			end
		end

		return TileComponents[p2.tileType](p2, p3, p4, v24, function(p5, p6, p7)
			if fFlagShowRequestsInCarouselForAllUsers and p7 then
				local current = ref2.current

				if current.startIndex <= p6 and p6 <= current.endIndex then
					v9.addTileToCollection(p5, p6, p7)
				end
			end

			if props.onTileContentChanged then
				props.onTileContentChanged(p5, p6, fFlagShowRequestsInCarouselForAllUsers and p7 or p2)
			end
		end, v29, v26, v25, v27, v28, v30), p2.tileType
	end

	local onTileContentChanged = props.onTileContentChanged
	local v25 = if fFlagShowRequestsInCarouselForAllUsers then v9 else nil
	local v26 = if fFlagSocialCarouselInGameTitleMarquee then activeByIndex else nil
	local v27 = if fFlagSocialCarouselInGameTitleMarquee then v20 else nil
	local v28 = if fFlagSocialCarouselInGameTitleMarquee then onMarqueeFinished else nil
	local v29 = if fFlagSocialCarouselInGameTitleMarquee then marqueeRunId else nil
	local v30 = if fFlagSocialCarouselInGameTitleMarquee then onManualMarqueeStart else nil
	local v31 = if fFlagSocialCarouselInGameTitleMarquee then onManualMarqueeEnd else nil
	local v32 = if fFlagSocialCarouselInGameTitleMarquee then v21 else nil
	local v33 = if fFlagSocialCarouselInGameTitleMarquee then v22 else nil
	local v35 = useCallback(fn, {
		selectionOrderBase,
		onTileContentChanged,
		v25,
		v26,
		v27,
		v28,
		v29,
		v30,
		v31,
		v32,
		v33,
		if fFlagSocialCarouselInGameTitleMarquee then v23 else nil
	})

	local v36 = React.useCallback(function(p2, p3)
		if FFlagSocialCarouselLogNewFriendRequestsBadge and setState2 ~= nil and ref6 ~= nil then
			local current = ref6.current

			if current == nil or current.startIndex ~= p2 or current.endIndex ~= p3 then
				local v37 = { startIndex = p2, endIndex = p3 }

				ref6.current = v37
				setState2(v37)
			end
		end

		if v8.unifiedLogging then
			v8.unifiedLogging.onCollectionViewabilityChanged(p2, p3)
		end

		if v8.tiles and state and ref.current and ref3.current then
			local current = ref.current
			local absoluteSize = state.AbsoluteSize
			local canvasPosition = current.CanvasPosition
			local v37 = absoluteSize.X / v16
			local x = canvasPosition.X
			local x2 = absoluteSize.X

			local v38 = math.max(1, math.floor(x / v37) + 1)

			local v39 = math.min(#v8.tiles, (math.ceil((x + x2) / v37)))

			ref2.current = { startIndex = v38, endIndex = v39 }

			for i = v38, v39 do
				local tile2 = v8.tiles[i]

				if tile2 and tile2.id then
					v9.addTileToCollection(tile2.id, i, tile2)
				end
			end
		end
	end, {
		props.onViewableItemsChanged,
		v8.tiles,
		v8.unifiedLogging,
		state,
		ref,
		v16,
		v9,
		setState2,
		ref6
	})

	local v37 = React.useMemo(function()
		local result = {}

		if not FFlagSocialCarouselShowLoadingSkeleton then
			return result
		end

		for i = 1, (v16 or 5) + 1 do
			result[i] = {
				id = "skeleton_" .. i,
				tileType = tile.Skeleton
			}
		end

		return result
	end, { v16 })

	if not isLoading then
		v37 = v8.tiles
	end

	if FFlagSocialCarouselFixColdStartJitter and not v17 then
		v37 = v5
	end

	local createElement = React.createElement
	local v39 = { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 }

	local v40 = {
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 0),
			PaddingRight = UDim.new(0, 0)
		}),
		CollectionCarousel = 0,
		ScreenSizeImpressionsTracker = 0
	}

	local createElement2 = React.createElement
	local v42 = {
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
		v18 = nil
	end

	v42.onContainerSizeChanged = v18

	v42.title = v12.friendsLabel
	v42.items = v37
	v42.renderItem = v35
	v42.getItemHeight = v19
	local v43 = if v6 then collectionItemSize.XSmall else nil
	v42.collectionItemSize = v43
	local v44 = if not v6 then v14.numColumns else nil
	v42.numColumns = v44
	local v45 = if not v6 then v14.fractionalItemAmount else nil
	v42.fractionalItemAmount = v45
	local v46 = if not v6 then v14.columnGap else nil
	v42.columnGap = v46
	local v47 = if not v6 then v14.sideMargin else nil
	v42.sideMargin = v47
	v42.maxItemsToShow = v14.maxTilesToShow
	v42.thresholdFromEnd = v14.loadMoreThreshold

	if isLoading or FFlagSocialCarouselFixColdStartJitter and not v17 then
		v36 = nil
	end

	v42.onViewableItemsChanged = v36

	local v48 = if v8.unifiedLogging and not isLoading and (not FFlagSocialCarouselFixColdStartJitter or v17) then v8.unifiedLogging.onCollectionViewabilityChanged else nil
	v42.onChangeCanvasPosition = v48

	v42.onActivateHeader = props.onActivateHeader
	local v49

	if fFlagLuaAppFriendsSortHeaderByPosition then
		if v8.hideCarouselHeader then
			v49 = React.createElement(React.Fragment, nil, {})
		end
	elseif v8.hideCarouselHeader then
		v49 = React.createElement(React.Fragment, nil, {})
	elseif FFlagFlyoutHideFriendsHeader then
		local v50

		if fFlagEnableFlyoutFriendsHeaderFix then
			v50 = flyoutSidePanelIXP.isFriendsSortHeaderHiddenInFlyoutIxp()
		else
			v50 = flyoutSidePanelIXP.isFlyoutSidePanelEnabled()
		end

		if v50 then
			v49 = React.createElement(React.Fragment, nil, {})
		end
	end

	v42.headerComponent = v49
	v40.CollectionCarousel = createElement2(collectionCarousel, v42)

	local v50 = if v8.unifiedLogging and (not FFlagSocialCarouselFixColdStartJitter or v17) then v8.unifiedLogging.renderImpressionsTrackerComponent(ref) else nil
	v40.ScreenSizeImpressionsTracker = v50
	return createElement("Frame", v39, v40)
end

return Carousel
