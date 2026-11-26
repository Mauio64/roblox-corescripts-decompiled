local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/React")
local CollectionViews = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/CollectionViews")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Localization")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Foundation")
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/RobloxAppHooks")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/RobloxAppEnums")

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
local FFlagSocialCarouselXXSmallTiles = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Flags/FFlagSocialCarouselXXSmallTiles")
local FFlagSocialCarouselXSmallTileText = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Flags/FFlagSocialCarouselXSmallTileText")
local marqueeScrollContext = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Stores/MarqueeSession/MarqueeScrollContext").MarqueeScrollContext
local useCarouselMarquee

if fFlagSocialCarouselInGameTitleMarquee then
	useCarouselMarquee = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Components/Carousel/useCarouselMarquee").useCarouselMarquee
else
	useCarouselMarquee = nil
end

local function friendTileMarqueeProps(p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13)
	if p2 ~= tile.Friend or p4 == nil then
		return nil, nil, nil, nil, nil, nil, nil
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

	return v5, p7, p6, p8, p9, p12 and true or nil, p13
end

local v5 = {}
local v6 = {
	[tile.AddFriends] = "add-friends",
	[tile.ShareQR] = "share-qr",
	[tile.StartSquad] = "start-squad",
	[tile.Skeleton] = "skeleton"
}

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
	local v7 = fFlagLuaAppCompositionAlways or props.appCompositionEnabled
	local v8 = if defineFastFlag then useTokens() else nil
	local v9 = useSocialCarouselContext()
	local v10 = useTilesSeenCollection()
	local state, setState = React.useState(nil)
	local ref = React.useRef(nil)
	local ref2 = React.useRef({ startIndex = 1, endIndex = 1 })
	local ref3 = React.useRef(false)
	local ref4 = React.useRef(nil)
	local ref5 = React.useRef(nil)

	local v11 = if FFlagSocialCarouselShowLoadingSkeleton then not v9.isLoading and v9.friendCount > 0 else v9.friendCount > 0
	local v12

	if v11 then
		v12 = {
			Constants.LOCALIZATION.FRIENDS_LABEL_WITH_COUNT,
			friendCount = v9.friendCount
		}
	else
		v12 = Constants.LOCALIZATION.FRIENDS_LABEL
	end

	local v13 = useLocalization({ friendsLabel = v12 })

	local v14 = if not fFlagLuaAppCompositionAlways then usePageSideMargin(state) else nil

	if v7 then
		v14 = nil
	end

	local v15 = useCollectionLayoutParams(collectionItemSize.XSmall, state, true, {
		sideMargin = v14
	})
	local v16

	if FFlagSocialCarouselXXSmallTiles or FFlagSocialCarouselXSmallTileText then
		v16 = RobloxAppHooks.useDeviceType() == RobloxAppEnums.DeviceType.Phone
	else
		v16 = false
	end

	local v17 = useCollectionLayout(collectionItemSize.XSmall)

	local v18 = if FFlagSocialCarouselXXSmallTiles and v16 then v17.itemsPerRow + 1 else v17.itemsPerRow
	local v19 = if v7 then v18 else v15.numColumns
	local v20, v21

	if FFlagSocialCarouselFixColdStartJitter then
		local state2, setState2 = React.useState(Vector2.zero)
		v20 = useColdStartLayoutReady(RobloxAppHooks.useDeviceOrientation() ~= nil, RobloxAppHooks.useScreenSize(), state2.X, v19)
		v21 = React.useCallback(function(p2)
			setState2(p2)
		end, {})
	else
		v20 = false
	end

	local ref6, setState2

	if FFlagSocialCarouselLogNewFriendRequestsBadge then
		local v22 = React.useMemo(function()
			local tiles = v9.tiles

			if tiles == nil then
				return nil
			end

			for i, tile2 in ipairs(tiles) do
				if tile2 and tile2.tileType == tile.AddFriends then
					return i
				end
			end

			return nil
		end, { v9.tiles })
		ref6 = React.useRef(nil)
		local state2
		state2, setState2 = React.useState(nil)

		if state2 == nil or v22 == nil or not (state2.startIndex <= v22 and v22 <= state2.endIndex) then
			v22 = nil
		end

		useAddFriendsTileSeenImpression(v22)
	else
		setState2 = nil
		ref6 = nil
	end

	React.useEffect(function()
		if v19 ~= ref4.current then
			ref4.current = v19
			ref3.current = false

			if ref5.current then
				pcall(task.cancel, ref5.current)
			end

			ref5.current = task.delay(0.2, function()
				ref3.current = true
				ref5.current = nil
			end)
		end
	end, { v19 })

	React.useEffect(function()
		return function()
			if ref5.current then
				pcall(task.cancel, ref5.current)
			end
		end
	end, {})

	local v22 = if FFlagSocialCarouselXSmallTileText and v16 then Constants.XSMALL_TILE_TEXT_HEIGHT else Constants.TILE_TEXT_HEIGHT
	local useCallback = React.useCallback
	local function fn(p2)
		local v23 = if defineFastFlag then v22 * v8.Config.UI.Scale else v22
		return p2 + v23
	end

	local v24 = if FFlagSocialCarouselXSmallTileText then v22 else nil
	local v25 = if FFlagSocialCarouselXSmallTileText and v8 then v8.Config.UI.Scale else nil
	local v26 = useCallback(fn, { v24, v25 })

	local selectionOrderBase = v9.selectionOrderBase
	local isLoading = FFlagSocialCarouselShowLoadingSkeleton and v9.isLoading
	local activeByIndex, v27, onMarqueeFinished, onManualMarqueeStart, onManualMarqueeEnd, marqueeRunId, v28, v29, v30, v31, scrollContext

	if fFlagSocialCarouselInGameTitleMarquee then
		local v32 = v9.source == Constants.ANALYTICS.SRC.HOMEPAGE_FRIENDS_CAROUSEL

		local tiles = v9.tiles
		local v34

		if fFlagSocialCarouselBuildPresence then
			v34 = v9.openGameJoinCardUserId or v9.openBuildCardUserId
		else
			v34 = v9.openGameJoinCardUserId
		end

		local v35 = useCarouselMarquee(ref, tiles, v34, {
			appCompositionEnabled = v7,
			itemsPerRow = v19,
			showSkeleton = isLoading,
			isColdStartLayoutReady = v20,
			defaultSkeletonCount = 5,
			containerFrame = state,
			gutter = v17.gutter,
			carouselPeek = v17.carouselPeek,
			columnGap = v15.columnGap,
			sideMargin = v15.sideMargin,
			fractionalItemAmount = v15.fractionalItemAmount,
			maxTilesToShow = v15.maxTilesToShow
		}, v9.joinPopoverUserIdRef, v9.joinSheetUserIdRef, v9.source, v32)

		activeByIndex = v35.activeByIndex
		v27 = v35.isPaused
		onMarqueeFinished = v35.onMarqueeFinished
		onManualMarqueeStart = v35.onManualMarqueeStart
		onManualMarqueeEnd = v35.onManualMarqueeEnd
		marqueeRunId = v35.marqueeRunId
		v28 = v35.handsOff
		v29 = v35.desktopEnabled
		v30 = v35.consoleEnabled
		v31 = v35.marqueeShortTitlesEnabled == true
		scrollContext = v35.scrollContext
	else
		activeByIndex = nil
		v27 = false
		marqueeRunId = nil
		onMarqueeFinished = nil
		onManualMarqueeStart = nil
		onManualMarqueeEnd = nil
		v28 = false
		v29 = false
		v30 = false
		v31 = false
	end

	local v32 = if FFlagSocialCarouselXXSmallTiles then v16 and v7 == true else nil
	local useCallback2 = React.useCallback
	local function fn2(p2, p3, p4)
		local v33 = if selectionOrderBase then selectionOrderBase + p3 else nil
		local v34, v35, v36, v37, v38, v39, v40

		if fFlagSocialCarouselInGameTitleMarquee then
			local v41 = activeByIndex
			local v42 = v27
			v34 = marqueeRunId
			v35 = onMarqueeFinished
			v36 = onManualMarqueeStart
			v37 = onManualMarqueeEnd
			local v43 = v28
			local v44 = v29
			local v45 = v30
			v38 = v31

			if p2.tileType == tile.Friend and v41 ~= nil then
				v39 = v41[p3] == true and (v42 and "Paused" or "Playing") or "Idle"

				if not v43 then
					v35 = nil
				end

				local v46 = v44 or v45

				if not v46 then
					v36 = nil
				end

				if not v46 then
					v37 = nil
				end

				v40 = v45 and true or nil
			else
				v35 = nil
				v34 = nil
				v36 = nil
				v37 = nil
				v38 = nil
			end
		end

		local v41 = TileComponents[p2.tileType](p2, p3, p4, v33, function(p5, p6, p7)
			if fFlagShowRequestsInCarouselForAllUsers and p7 then
				local current = ref2.current

				if current.startIndex <= p6 and p6 <= current.endIndex then
					v10.addTileToCollection(p5, p6, p7)
				end
			end

			if props.onTileContentChanged then
				props.onTileContentChanged(p5, p6, fFlagShowRequestsInCarouselForAllUsers and p7 or p2)
			end
		end, v32, v39, v35, v34, v36, v37, v40, v38)

		local v42 = v6[p2.tileType]

		if not v42 then
			return v41, p2.tileType
		end

		local sortAnalyticsData = v9.sortAnalyticsData
		local source = v9.source or "carousel"
		local v43 = not sortAnalyticsData and 1 or sortAnalyticsData.sortIndex
		v41 = React.cloneElement(v41, {
			testId = `--social-social-carousel-view-{v42}-{source}-{v43}-{p3}`
		})

		return v41, p2.tileType
	end

	local onTileContentChanged = props.onTileContentChanged
	local source = v9.source
	local sortAnalyticsData = v9.sortAnalyticsData
	local v34 = if fFlagShowRequestsInCarouselForAllUsers then v10 else nil
	local v35 = if fFlagSocialCarouselInGameTitleMarquee then activeByIndex else nil
	local v36 = if fFlagSocialCarouselInGameTitleMarquee then v27 else nil
	local v37 = if fFlagSocialCarouselInGameTitleMarquee then onMarqueeFinished else nil
	local v38 = if fFlagSocialCarouselInGameTitleMarquee then marqueeRunId else nil
	local v39 = if fFlagSocialCarouselInGameTitleMarquee then onManualMarqueeStart else nil
	local v40 = if fFlagSocialCarouselInGameTitleMarquee then onManualMarqueeEnd else nil
	local v41 = if fFlagSocialCarouselInGameTitleMarquee then v28 else nil
	local v42 = if fFlagSocialCarouselInGameTitleMarquee then v29 else nil
	local v43 = if fFlagSocialCarouselInGameTitleMarquee then v30 else nil
	local v45 = useCallback2(fn2, {
		selectionOrderBase,
		v32,
		onTileContentChanged,
		source,
		sortAnalyticsData,
		v34,
		v35,
		v36,
		v37,
		v38,
		v39,
		v40,
		v41,
		v42,
		v43,
		if fFlagSocialCarouselInGameTitleMarquee then v31 else nil
	})

	local v46 = React.useCallback(function(p2, p3)
		if FFlagSocialCarouselLogNewFriendRequestsBadge and setState2 ~= nil and ref6 ~= nil then
			local current = ref6.current

			if current == nil or current.startIndex ~= p2 or current.endIndex ~= p3 then
				local v47 = { startIndex = p2, endIndex = p3 }

				ref6.current = v47
				setState2(v47)
			end
		end

		if v9.unifiedLogging then
			v9.unifiedLogging.onCollectionViewabilityChanged(p2, p3)
		end

		if v9.tiles and state and ref.current and ref3.current then
			local current = ref.current
			local absoluteSize = state.AbsoluteSize
			local canvasPosition = current.CanvasPosition
			local v47 = absoluteSize.X / v19
			local x = canvasPosition.X
			local x2 = absoluteSize.X

			local v48 = math.max(1, math.floor(x / v47) + 1)

			local v49 = math.min(#v9.tiles, (math.ceil((x + x2) / v47)))

			ref2.current = { startIndex = v48, endIndex = v49 }

			for i = v48, v49 do
				local tile2 = v9.tiles[i]

				if tile2 and tile2.id then
					v10.addTileToCollection(tile2.id, i, tile2)
				end
			end
		end
	end, {
		props.onViewableItemsChanged,
		v9.tiles,
		v9.unifiedLogging,
		state,
		ref,
		v19,
		v10,
		setState2,
		ref6
	})

	local v47 = React.useMemo(function()
		local result = {}

		if not FFlagSocialCarouselShowLoadingSkeleton then
			return result
		end

		for i = 1, (v19 or 5) + 1 do
			result[i] = {
				id = "skeleton_" .. i,
				tileType = tile.Skeleton
			}
		end

		return result
	end, { v19 })

	if not isLoading then
		v47 = v9.tiles
	end

	if FFlagSocialCarouselFixColdStartJitter and not v20 then
		v47 = v5
	end

	local createElement = React.createElement
	local v49 = { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 }

	local v50 = {
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 0),
			PaddingRight = UDim.new(0, 0)
		}),
		CollectionCarousel = 0,
		ScreenSizeImpressionsTracker = 0
	}

	local createElement2 = React.createElement
	local v52 = {
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
		v21 = nil
	end

	v52.onContainerSizeChanged = v21

	v52.title = v13.friendsLabel
	v52.items = v47
	v52.renderItem = v45
	v52.getItemHeight = v26
	local v53 = if v7 then collectionItemSize.XSmall else nil
	v52.collectionItemSize = v53

	if v7 then
		if not (FFlagSocialCarouselXXSmallTiles and v16) then
			v18 = nil
		end
	else
		v18 = v15.numColumns
	end

	v52.numColumns = v18

	local v54 = if not v7 then v15.fractionalItemAmount else nil
	v52.fractionalItemAmount = v54
	local v55 = if not v7 then v15.columnGap else nil
	v52.columnGap = v55
	local v56 = if not v7 then v15.sideMargin else nil
	v52.sideMargin = v56
	v52.maxItemsToShow = v15.maxTilesToShow
	v52.thresholdFromEnd = v15.loadMoreThreshold

	if isLoading or FFlagSocialCarouselFixColdStartJitter and not v20 then
		v46 = nil
	end

	v52.onViewableItemsChanged = v46

	local v57 = if v9.unifiedLogging and not isLoading and (not FFlagSocialCarouselFixColdStartJitter or v20) then v9.unifiedLogging.onCollectionViewabilityChanged else nil
	v52.onChangeCanvasPosition = v57

	v52.onActivateHeader = props.onActivateHeader
	local v58

	if fFlagLuaAppFriendsSortHeaderByPosition then
		if v9.hideCarouselHeader then
			v58 = React.createElement(React.Fragment, nil, {})
		end
	elseif v9.hideCarouselHeader then
		v58 = React.createElement(React.Fragment, nil, {})
	elseif FFlagFlyoutHideFriendsHeader then
		local v59

		if fFlagEnableFlyoutFriendsHeaderFix then
			v59 = flyoutSidePanelIXP.isFriendsSortHeaderHiddenInFlyoutIxp()
		else
			v59 = flyoutSidePanelIXP.isFlyoutSidePanelEnabled()
		end

		if v59 then
			v58 = React.createElement(React.Fragment, nil, {})
		end
	end

	v52.headerComponent = v58
	v50.CollectionCarousel = createElement2(collectionCarousel, v52)

	local v59 = if v9.unifiedLogging and (not FFlagSocialCarouselFixColdStartJitter or v20) then v9.unifiedLogging.renderImpressionsTrackerComponent(ref) else nil
	v50.ScreenSizeImpressionsTracker = v59
	local element = createElement("Frame", v49, v50)

	if scrollContext == nil then
		return element
	end

	return React.createElement(marqueeScrollContext.Provider, { value = scrollContext }, {
		Carousel = element
	})
end

return Carousel
