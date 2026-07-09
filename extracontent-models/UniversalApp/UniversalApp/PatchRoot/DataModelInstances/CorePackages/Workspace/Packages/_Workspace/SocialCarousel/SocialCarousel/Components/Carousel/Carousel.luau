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

local function Carousel(t1: {[any]: any}) -- line: 40
	-- upvalues: FFlagLuaAppCompositionAlways (copy), v21 (copy), useTokens (copy), useSocialCarouselContext (copy), useTilesSeenCollection (copy), React (copy), FFlagSocialCarouselShowLoadingSkeleton (copy), FFlagConnectionsToFriendsRename (copy), Constants (copy), useLocalization (copy), usePageSideMargin (copy), useCollectionLayoutParams (copy), CollectionItemSize (copy), useCollectionLayout (copy), TileComponents (copy), Tile (copy), CollectionCarousel (copy), FFlagFlyoutHideFriendsHeader (copy), FFlagEnableFlyoutFriendsHeaderFix (copy), FlyoutSidePanelIXP (copy)
	local v30 = FFlagLuaAppCompositionAlways or t1.appCompositionEnabled
	local v31 = if not v21 then nil else useTokens()
	local v32 = useSocialCarouselContext()
	local v33 = useTilesSeenCollection()
	local v34, v35 = React.useState(nil)
	local v36 = React.useRef(nil)
	local v37 = React.useRef({
		startIndex = 1,
		endIndex = 1
	})
	local v38 = React.useRef(false)
	local v39 = React.useRef(nil)
	local v40 = React.useRef(nil)
	local v41 = if not FFlagSocialCarouselShowLoadingSkeleton then v32.friendCount > 0 else not v32.isLoading and v32.friendCount > 0
	local v42 = if FFlagConnectionsToFriendsRename then if v41 then {
		Constants.LOCALIZATION.FRIENDS_LABEL_WITH_COUNT,
		friendCount = v32.friendCount
	} else Constants.LOCALIZATION.FRIENDS_LABEL else if v41 then {
		Constants.LOCALIZATION.CONNECTIONS_LABEL_WITH_COUNT,
		connectionCount = v32.friendCount
	} else Constants.LOCALIZATION.CONNECTIONS_LABEL
	local v43 = useLocalization({
		friendsLabel = v42
	})
	local v44 = if FFlagLuaAppCompositionAlways then nil else usePageSideMargin(v34)
	local v45 = useCollectionLayoutParams(CollectionItemSize.XSmall, v34, true, {
		sideMargin = if not v30 then v44 else nil
	})
	local itemsPerRow = useCollectionLayout(CollectionItemSize.XSmall).itemsPerRow
	local v47 = if not v30 then v45.numColumns else itemsPerRow

	React.useEffect(function() -- line: 85
		-- upvalues: v47 (copy), v39 (copy), v38 (copy), v40 (copy)
		if v47 ~= v39.current then
			v39.current = v47
			v38.current = false

			if v40.current then
				pcall(task.cancel, v40.current)
			end

			v40.current = task.delay(0.2, function() -- line: 94
				-- upvalues: v38 (copy), v40 (copy)
				v38.current = true
				v40.current = nil
			end)
		end
	end, { v47 })
	React.useEffect(function() -- line: 101
		-- upvalues: v40 (copy)
		return function() -- line: 102
			-- upvalues: v40 (copy)
			if v40.current then
				pcall(task.cancel, v40.current)
			end
		end
	end, {})

	local v48 = React.useCallback(function(n1: number) -- line: 109
		-- upvalues: v21 (copy), Constants (copy), v31 (copy)
		return n1 + if not v21 then Constants.TILE_TEXT_HEIGHT else Constants.TILE_TEXT_HEIGHT * v31.Config.UI.Scale
	end, {})
	local selectionOrderBase = v32.selectionOrderBase
	local v50 = React.useCallback(function(p1, p2, p3) -- line: 119
		-- upvalues: selectionOrderBase (copy), TileComponents (copy), t1 (copy)
		local v59 = if not selectionOrderBase then nil else selectionOrderBase + p2

		return TileComponents[p1.tileType](p1, p2, p3, v59, function(s1: string, n2: number) -- line: 126
			-- upvalues: t1 (copy), p1 (copy)
			if t1.onTileContentChanged then
				t1.onTileContentChanged(s1, n2, p1)
			end
		end), p1.tileType
	end, {
		selectionOrderBase,
		t1.onTileContentChanged
	})
	local v51 = React.useCallback(function(n3: number, n4: number) -- line: 141
		-- upvalues: v32 (copy), v34 (copy), v36 (copy), v38 (copy), v47 (copy), v37 (copy), v33 (copy)
		if v32.unifiedLogging then
			v32.unifiedLogging.onCollectionViewabilityChanged(n3, n4)
		end

		if v32.tiles and v34 and v36.current and v38.current then
			local current = v36.current
			local AbsoluteSize = v34.AbsoluteSize
			local CanvasPosition = current.CanvasPosition
			local v65 = AbsoluteSize.X / v47
			local CanvasPositionX = CanvasPosition.X
			local AbsoluteSizeX = AbsoluteSize.X
			local v68 = math.max(1, math.floor(CanvasPositionX / v65) + 1)
			local v69 = math.min(#v32.tiles, (math.ceil((CanvasPositionX + AbsoluteSizeX) / v65)))

			v37.current = {
				startIndex = v68,
				endIndex = v69
			}

			for i = v68, v69 do
				local v71 = v32.tiles[i]

				if v71 and v71.id then
					v33.addTileToCollection(v71.id, i, v71)
				end
			end
		end
	end, {
		t1.onViewableItemsChanged,
		v32.tiles,
		v34,
		v36,
		v47,
		v33
	})
	local v52 = FFlagSocialCarouselShowLoadingSkeleton and v32.isLoading
	local v53 = React.useMemo(function() -- line: 181
		-- upvalues: FFlagSocialCarouselShowLoadingSkeleton (copy), v47 (copy), Tile (copy)
		local t2 = {}

		if not FFlagSocialCarouselShowLoadingSkeleton then
			return t2
		end

		for i = 1, v47 or 5 do
			t2[i] = {
				id = "skeleton_" .. i,
				tileType = Tile.Skeleton
			}
		end

		return t2
	end, { v47 })
	local v54 = if not v52 then v32.tiles else v53

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
			containerRef = v35,
			scrollingFrameRef = v36,
			title = v43.friendsLabel,
			items = v54,
			renderItem = v50,
			getItemHeight = v48,
			collectionItemSize = if not v30 then nil else CollectionItemSize.XSmall,
			numColumns = if not v30 then v45.numColumns else nil,
			fractionalItemAmount = if not v30 then v45.fractionalItemAmount else nil,
			columnGap = if not v30 then v45.columnGap else nil,
			sideMargin = if not v30 then v45.sideMargin else nil,
			maxItemsToShow = v45.maxTilesToShow,
			thresholdFromEnd = v45.loadMoreThreshold,
			onViewableItemsChanged = if not v52 then v51 else nil,
			onChangeCanvasPosition = if not v32.unifiedLogging or v52 then nil else v32.unifiedLogging.onCollectionViewabilityChanged,
			onActivateHeader = t1.onActivateHeader,
			headerComponent = if not v32.hideCarouselHeader and (not FFlagFlyoutHideFriendsHeader or not if not FFlagEnableFlyoutFriendsHeaderFix then FlyoutSidePanelIXP.isFlyoutSidePanelEnabled() else FlyoutSidePanelIXP.isFriendsSortHeaderHiddenInFlyoutIxp()) then nil else React.createElement(React.Fragment, nil, {})
		}),
		ScreenSizeImpressionsTracker = if not v32.unifiedLogging then nil else v32.unifiedLogging.renderImpressionsTrackerComponent(v36)
	})
end

return Carousel
