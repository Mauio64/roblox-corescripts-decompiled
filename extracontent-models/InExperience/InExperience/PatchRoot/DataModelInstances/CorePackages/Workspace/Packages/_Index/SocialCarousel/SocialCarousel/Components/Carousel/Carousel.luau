local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local SocialCarouselParent = SocialCarousel.Parent
local React = require(SocialCarouselParent.React)
local CollectionViews = require(SocialCarouselParent.CollectionViews)
local Localization = require(SocialCarouselParent.Localization)
local Foundation = require(SocialCarouselParent.Foundation)
local CollectionCarousel = CollectionViews.CollectionCarousel
local useCollectionLayoutParams = CollectionViews.useCollectionLayoutParams
local useCollectionLayout = CollectionViews.useCollectionLayout
local CollectionViewTypes = CollectionViews.CollectionViewTypes
local usePageSideMargin = CollectionViews.usePageSideMargin
local CollectionItemSize = CollectionViewTypes.CollectionItemSize
local useLocalization = Localization.Hooks.useLocalization
local TileComponents = require(SocialCarousel.Common.TileComponents)
local Tile = require(SocialCarousel.Common.Enums).Tile
local Constants = require(SocialCarousel.Common.Constants)
local useSocialCarouselContext = require(SocialCarousel.Contexts.useSocialCarouselContext)
local useTokens = Foundation.Hooks.useTokens
local useTilesSeenCollection = require(SocialCarousel.Analytics.useTilesSeenCollection)
local FFlagSocialCarouselShowLoadingSkeleton = require(SocialCarousel.Flags.FFlagSocialCarouselShowLoadingSkeleton)
local v21 = game:DefineFastFlag("FixCarouselTileSizeScaling", false)
local FFlagFlyoutHideFriendsHeader = require(SocialCarousel.Flags.FFlagFlyoutHideFriendsHeader)
local FlyoutSidePanelIXP = require(SocialCarouselParent.SharedExperimentDefinition).FlyoutSidePanelIXP
local SharedFlags = require(SocialCarouselParent.SharedFlags)
local FFlagConnectionsToFriendsRename = SharedFlags.FFlagConnectionsToFriendsRename
local FFlagEnableFlyoutFriendsHeaderFix = SharedFlags.FFlagEnableFlyoutFriendsHeaderFix
local FFlagLuaAppCompositionAlways = require(SocialCarouselParent.SharedFlags).FFlagLuaAppCompositionAlways
local FFlagLuaAppFriendsSortHeaderByPosition = SharedFlags.FFlagLuaAppFriendsSortHeaderByPosition

local function Carousel(t1: {[any]: any}) -- line: 41
	-- upvalues: FFlagLuaAppCompositionAlways (copy), v21 (copy), useTokens (copy), useSocialCarouselContext (copy), useTilesSeenCollection (copy), React (copy), FFlagSocialCarouselShowLoadingSkeleton (copy), FFlagConnectionsToFriendsRename (copy), Constants (copy), useLocalization (copy), usePageSideMargin (copy), useCollectionLayoutParams (copy), CollectionItemSize (copy), useCollectionLayout (copy), TileComponents (copy), Tile (copy), CollectionCarousel (copy), FFlagLuaAppFriendsSortHeaderByPosition (copy), FFlagFlyoutHideFriendsHeader (copy), FFlagEnableFlyoutFriendsHeaderFix (copy), FlyoutSidePanelIXP (copy)
	local v31 = FFlagLuaAppCompositionAlways or t1.appCompositionEnabled
	local v32 = if not v21 then nil else useTokens()
	local v33 = useSocialCarouselContext()
	local v34 = useTilesSeenCollection()
	local v35, v36 = React.useState(nil)
	local v37 = React.useRef(nil)
	local v38 = React.useRef({
		startIndex = 1,
		endIndex = 1
	})
	local v39 = React.useRef(false)
	local v40 = React.useRef(nil)
	local v41 = React.useRef(nil)
	local v42 = if not FFlagSocialCarouselShowLoadingSkeleton then v33.friendCount > 0 else not v33.isLoading and v33.friendCount > 0
	local v43 = if FFlagConnectionsToFriendsRename then if v42 then {
		Constants.LOCALIZATION.FRIENDS_LABEL_WITH_COUNT,
		friendCount = v33.friendCount
	} else Constants.LOCALIZATION.FRIENDS_LABEL else if v42 then {
		Constants.LOCALIZATION.CONNECTIONS_LABEL_WITH_COUNT,
		connectionCount = v33.friendCount
	} else Constants.LOCALIZATION.CONNECTIONS_LABEL
	local v44 = useLocalization({
		friendsLabel = v43
	})
	local v45 = if FFlagLuaAppCompositionAlways then nil else usePageSideMargin(v35)
	local v46 = useCollectionLayoutParams(CollectionItemSize.XSmall, v35, true, {
		sideMargin = if not v31 then v45 else nil
	})
	local itemsPerRow = useCollectionLayout(CollectionItemSize.XSmall).itemsPerRow
	local v48 = if not v31 then v46.numColumns else itemsPerRow

	React.useEffect(function() -- line: 86
		-- upvalues: v48 (copy), v40 (copy), v39 (copy), v41 (copy)
		if v48 ~= v40.current then
			v40.current = v48
			v39.current = false

			if v41.current then
				pcall(task.cancel, v41.current)
			end

			v41.current = task.delay(0.2, function() -- line: 95
				-- upvalues: v39 (copy), v41 (copy)
				v39.current = true
				v41.current = nil
			end)
		end
	end, { v48 })
	React.useEffect(function() -- line: 102
		-- upvalues: v41 (copy)
		return function() -- line: 103
			-- upvalues: v41 (copy)
			if v41.current then
				pcall(task.cancel, v41.current)
			end
		end
	end, {})

	local v49 = React.useCallback(function(n1: number) -- line: 110
		-- upvalues: v21 (copy), Constants (copy), v32 (copy)
		return n1 + if not v21 then Constants.TILE_TEXT_HEIGHT else Constants.TILE_TEXT_HEIGHT * v32.Config.UI.Scale
	end, {})
	local selectionOrderBase = v33.selectionOrderBase
	local v51 = React.useCallback(function(p1, p2, p3) -- line: 120
		-- upvalues: selectionOrderBase (copy), TileComponents (copy), t1 (copy)
		local v60 = if not selectionOrderBase then nil else selectionOrderBase + p2

		return TileComponents[p1.tileType](p1, p2, p3, v60, function(s1: string, n2: number) -- line: 127
			-- upvalues: t1 (copy), p1 (copy)
			if t1.onTileContentChanged then
				t1.onTileContentChanged(s1, n2, p1)
			end
		end), p1.tileType
	end, {
		selectionOrderBase,
		t1.onTileContentChanged
	})
	local v52 = React.useCallback(function(n3: number, n4: number) -- line: 142
		-- upvalues: v33 (copy), v35 (copy), v37 (copy), v39 (copy), v48 (copy), v38 (copy), v34 (copy)
		if v33.unifiedLogging then
			v33.unifiedLogging.onCollectionViewabilityChanged(n3, n4)
		end

		if v33.tiles and v35 and v37.current and v39.current then
			local current = v37.current
			local AbsoluteSize = v35.AbsoluteSize
			local CanvasPosition = current.CanvasPosition
			local v66 = AbsoluteSize.X / v48
			local CanvasPositionX = CanvasPosition.X
			local AbsoluteSizeX = AbsoluteSize.X
			local v69 = math.max(1, math.floor(CanvasPositionX / v66) + 1)
			local v70 = math.min(#v33.tiles, (math.ceil((CanvasPositionX + AbsoluteSizeX) / v66)))

			v38.current = {
				startIndex = v69,
				endIndex = v70
			}

			for i = v69, v70 do
				local v72 = v33.tiles[i]

				if v72 and v72.id then
					v34.addTileToCollection(v72.id, i, v72)
				end
			end
		end
	end, {
		t1.onViewableItemsChanged,
		v33.tiles,
		v35,
		v37,
		v48,
		v34
	})
	local v53 = FFlagSocialCarouselShowLoadingSkeleton and v33.isLoading
	local v54 = React.useMemo(function() -- line: 182
		-- upvalues: FFlagSocialCarouselShowLoadingSkeleton (copy), v48 (copy), Tile (copy)
		local t2 = {}

		if not FFlagSocialCarouselShowLoadingSkeleton then
			return t2
		end

		for i = 1, v48 or 5 do
			t2[i] = {
				id = "skeleton_" .. i,
				tileType = Tile.Skeleton
			}
		end

		return t2
	end, { v48 })
	local v55 = if not v53 then v33.tiles else v54

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 0),
			PaddingRight = UDim.new(0, 0)
		}),
		CollectionCarousel = React.createElement(CollectionCarousel, {
			LayoutOrder = 1,
			containerRef = v36,
			scrollingFrameRef = v37,
			title = v44.friendsLabel,
			items = v55,
			renderItem = v51,
			getItemHeight = v49,
			collectionItemSize = if not v31 then nil else CollectionItemSize.XSmall,
			numColumns = if not v31 then v46.numColumns else nil,
			fractionalItemAmount = if not v31 then v46.fractionalItemAmount else nil,
			columnGap = if not v31 then v46.columnGap else nil,
			sideMargin = if not v31 then v46.sideMargin else nil,
			maxItemsToShow = v46.maxTilesToShow,
			thresholdFromEnd = v46.loadMoreThreshold,
			onViewableItemsChanged = if not v53 then v52 else nil,
			onChangeCanvasPosition = if not v33.unifiedLogging or v53 then nil else v33.unifiedLogging.onCollectionViewabilityChanged,
			onActivateHeader = t1.onActivateHeader,
			headerComponent = if not FFlagLuaAppFriendsSortHeaderByPosition then if not v33.hideCarouselHeader and (not FFlagFlyoutHideFriendsHeader or not if not FFlagEnableFlyoutFriendsHeaderFix then FlyoutSidePanelIXP.isFlyoutSidePanelEnabled() else FlyoutSidePanelIXP.isFriendsSortHeaderHiddenInFlyoutIxp()) then nil else React.createElement(React.Fragment, nil, {}) else if not v33.hideCarouselHeader then nil else React.createElement(React.Fragment, nil, {})
		}),
		ScreenSizeImpressionsTracker = if not v33.unifiedLogging then nil else v33.unifiedLogging.renderImpressionsTrackerComponent(v37)
	})
end

return Carousel
