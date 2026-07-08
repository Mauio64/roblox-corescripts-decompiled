local GameCollections = script:FindFirstAncestor("GameCollections")
local useControllerBarFocusNavigationBindings = require(GameCollections.GameCollectionNavigationBindings).useControllerBarFocusNavigationBindings
local useGetGameTileHeight = require(GameCollections.useGetGameTileHeight)
local useIsHoldToPlayEnabledForGames = require(GameCollections.useIsHoldToPlayEnabledForGames)
local useRenderGameCollectionItem = require(GameCollections.useRenderGameCollectionItem)
local useGameCollectionLayoutParams = require(GameCollections.useGameCollectionLayoutParams)
local useGameSortAnalytics = require(GameCollections.useGameSortAnalytics)
local GameSortImpressionsDetector = require(GameCollections.Impressions.GameSortImpressionsDetector)
local useGameSortData = require(GameCollections.useGameSortData)
local useGameSortImpressionsParams = require(GameCollections.Impressions.useGameSortImpressionsParams)
local useGameSortTooltipParams = require(GameCollections.useGameSortTooltipParams)
local WaitForPropWrapper = require(GameCollections.Impressions.WaitForPropWrapper)
local useSizeAdjustedEntries = require(GameCollections.useSizeAdjustedEntries)
local GameCollectionsParent = GameCollections.Parent
local React = require(GameCollectionsParent.React)
local SignalsReact = require(GameCollectionsParent.SignalsReact)
local t = require(GameCollectionsParent.t)
local DiscoveryUtils = require(GameCollectionsParent.DiscoveryUtils)
local validateProps = DiscoveryUtils.validateProps
local composeRefs = DiscoveryUtils.composeRefs
local GameTile = require(GameCollectionsParent.GameTile)
local getGameTileCollectionItemSize = GameTile.getGameTileCollectionItemSize
local getGameTileHiddenStore = GameTile.getGameTileHiddenStore
local GameTileConstants = GameTile.GameTileConstants

require(GameCollectionsParent.VideoUtils)
require(GameCollectionsParent.AppCommonLib)

local Responsive = require(GameCollectionsParent.Responsive)
local usePreferredInput = Responsive.usePreferredInput
local useBreakpointXOrSmaller = Responsive.useBreakpointXOrSmaller
local useAppPolicy = require(GameCollectionsParent.UniversalAppPolicy).useAppPolicy
local CollectionGrid = require(GameCollectionsParent.CollectionViews).CollectionGrid
local useCollectionLayout = require(GameCollectionsParent.CollectionViews).useCollectionLayout
local AppPage = require(GameCollectionsParent.RobloxAppEnums).AppPage
local DiscoveryAnalytics = require(GameCollectionsParent.DiscoveryAnalytics)
local useTextSizeOffset = require(GameCollectionsParent.UIBlox).Core.Style.useTextSizeOffset
local HoldToPlay = require(GameCollectionsParent.HoldToPlay)
local HoldToPlayLauncher = HoldToPlay.HoldToPlayLauncher
local useHoldToPlayStateAndCallbacks = HoldToPlay.useHoldToPlayStateAndCallbacks

require(GameCollectionsParent.DiscoveryTypes)

local Cryo = require(GameCollectionsParent.Cryo)

require(GameCollectionsParent.CollectionViews)

local FFlagLuaAppEnableWhyThisAdModal = require(GameCollectionsParent.SharedFlags).FFlagLuaAppEnableWhyThisAdModal
local FFlagLuaAppEnableSponsoredReportAd = require(GameCollectionsParent.SharedFlags).FFlagLuaAppEnableSponsoredReportAd
local FFlagLuaAppCompositionAlways = require(GameCollectionsParent.SharedFlags).FFlagLuaAppCompositionAlways
local FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone = require(GameCollectionsParent.SharedFlags).FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone
local FFlagLuaAppNarrowTileSmallerFooterFont = require(GameCollectionsParent.SharedFlags).FFlagLuaAppNarrowTileSmallerFooterFont
local FFlagLuaAppNarrowTileHideRating = require(GameCollectionsParent.SharedFlags).FFlagLuaAppNarrowTileHideRating
local FFlagLuaAppNarrowTileHidePlayerCount = require(GameCollectionsParent.SharedFlags).FFlagLuaAppNarrowTileHidePlayerCount
local FFlagLuaAppFixSearchImpressions = require(GameCollectionsParent.SharedFlags).FFlagLuaAppFixSearchImpressions
local FFlagLuaAppFixCompositionSizeOverrideGap = require(GameCollectionsParent.SharedFlags).FFlagLuaAppFixCompositionSizeOverrideGap
local FFlagLuaAppHomeTouchAutoplay = require(GameCollectionsParent.SharedFlags).FFlagLuaAppHomeTouchAutoplay
local FFlagLuaAppRfyRevealRows = require(GameCollectionsParent.SharedFlags).FFlagLuaAppRfyRevealRows
local FFlagLuaAppSortHeaderAnchorTag = require(GameCollectionsParent.SharedFlags).FFlagLuaAppSortHeaderAnchorTag
local FFlagLuaAppHomeReduceRenders = require(GameCollectionsParent.SharedFlags).FFlagLuaAppHomeReduceRenders
local FFlagLuaAppRfyRevealRowsFocusFix = require(GameCollectionsParent.SharedFlags).FFlagLuaAppRfyRevealRowsFocusFix
local v52 = game:DefineFastInt("LuaAppGameGridBufferRowsBelowScreen", 2)
local v53 = game:DefineFastInt("LuaAppGameGridBufferRowsAboveScreen", 1)
local v54 = t.strictInterface({
	entries = t.optional(t.table),
	title = t.optional(t.string),
	headerComponent = t.optional(t.table),
	headerTag = if not FFlagLuaAppSortHeaderAnchorTag then nil else t.optional(t.string),
	verticalScrollingFrameRef = t.table,
	gridContainerRef = if not FFlagLuaAppRfyRevealRowsFocusFix then nil else t.optional(t.union(t.table, t.callback)),
	LayoutOrder = if not FFlagLuaAppRfyRevealRows then nil else t.optional(t.number),
	ZIndex = if not FFlagLuaAppRfyRevealRows then nil else t.optional(t.number),
	maxNumRows = t.optional(t.number),
	useGridTiles = t.optional(t.boolean),
	gameSortId = t.string,
	sortIndex = t.number,
	pageContext = t.string,
	scrollViewPositionChangedSignal = t.optional(t.table),
	friendFooterEnabled = t.optional(t.boolean),
	playerCountStyle = t.optional(t.string),
	isSponsoredFooterAllowed = t.optional(t.boolean),
	componentType = t.optional(t.string),
	gameTileLayoutType = t.optional(t.string),
	infoText = t.optional(t.string),
	linkPath = t.optional(t.string),
	gridSupportAllowed = t.optional(t.boolean),
	isHoverSupportEnabled = t.optional(t.boolean),
	onItemsPerRowChanged = t.optional(t.callback),
	startRow = t.optional(t.number),
	playButtonStyle = t.optional(t.string),
	sideMargin = if FFlagLuaAppCompositionAlways then nil else t.optional(t.number),
	shouldHideTileMetadata = t.optional(t.boolean),
	shouldHideTileTitle = t.optional(t.boolean),
	containedTile = t.optional(t.boolean),
	numUpdatesToDelayImpressions = t.optional(t.number),
	selectionOrderBase = t.optional(t.number),
	enableExplicitFeedback = t.optional(t.boolean),
	sponsoredUserCohort = if not FFlagLuaAppEnableWhyThisAdModal then nil else t.optional(t.string),
	enableSponsoredFeedback = t.optional(t.boolean),
	enableReportAd = if not FFlagLuaAppEnableSponsoredReportAd then nil else t.optional(t.boolean),
	searchParams = t.optional(t.table),
	layoutOverrides = t.optional(t.table),
	isSponsoredRatingFooterAllowed = t.optional(t.boolean),
	launchExperienceEventContextOverride = t.optional(t.string),
	appCompositionEnabled = t.optional(t.boolean),
	onTileImageLoaded = if not FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone then nil else t.optional(t.callback),
	videoPlaybackContext = if not FFlagLuaAppHomeTouchAutoplay then nil else t.optional(t.table)
})

local function GameCollectionGrid(t1: {[any]: any}) -- line: 177
	-- upvalues: validateProps (copy), v54 (copy), useAppPolicy (copy), usePreferredInput (copy), FFlagLuaAppHomeReduceRenders (copy), v52 (copy), Responsive (copy), v53 (copy), FFlagLuaAppCompositionAlways (copy), FFlagLuaAppNarrowTileSmallerFooterFont (copy), FFlagLuaAppNarrowTileHideRating (copy), FFlagLuaAppNarrowTileHidePlayerCount (copy), useBreakpointXOrSmaller (copy), getGameTileCollectionItemSize (copy), React (copy), FFlagLuaAppRfyRevealRowsFocusFix (copy), composeRefs (copy), useGameSortData (copy), Cryo (copy), useGameCollectionLayoutParams (copy), FFlagLuaAppFixCompositionSizeOverrideGap (copy), useCollectionLayout (copy), useSizeAdjustedEntries (copy), useGameSortAnalytics (copy), FFlagLuaAppHomeTouchAutoplay (copy), GameTile (copy), useGameSortTooltipParams (copy), useGameSortImpressionsParams (copy), FFlagLuaAppFixSearchImpressions (copy), useIsHoldToPlayEnabledForGames (copy), useHoldToPlayStateAndCallbacks (copy), useControllerBarFocusNavigationBindings (copy), useTextSizeOffset (copy), GameTileConstants (copy), useGetGameTileHeight (copy), getGameTileHiddenStore (copy), SignalsReact (copy), useRenderGameCollectionItem (copy), AppPage (copy), DiscoveryAnalytics (copy), FFlagLuaAppEnableWhyThisAdModal (copy), FFlagLuaAppEnableSponsoredReportAd (copy), FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone (copy), GameSortImpressionsDetector (copy), CollectionGrid (copy), FFlagLuaAppRfyRevealRows (copy), FFlagLuaAppSortHeaderAnchorTag (copy), WaitForPropWrapper (copy), HoldToPlayLauncher (copy)
	validateProps(v54, t1)

	local v57 = useAppPolicy(function(p1) -- line: 181
		return p1.useGridPageLayout()
	end)
	local v58 = usePreferredInput()
	local v59 = if not FFlagLuaAppHomeReduceRenders then v58 ~= Responsive.Input.Directional and 2 or 4 else v52
	local v60 = if not FFlagLuaAppHomeReduceRenders then v58 ~= Responsive.Input.Directional and 1 or 4 else v53
	local v61 = t1.isHoverSupportEnabled and (v57 and v58 == Responsive.Input.Pointer)
	local v62 = t1.gameTileLayoutType or "Narrow"
	local v63 = FFlagLuaAppCompositionAlways or t1.appCompositionEnabled
	local v64 = nil
	local v65 = nil
	local v66 = nil

	if FFlagLuaAppNarrowTileSmallerFooterFont or (FFlagLuaAppNarrowTileHideRating or FFlagLuaAppNarrowTileHidePlayerCount) then
		local v67 = useBreakpointXOrSmaller(Responsive.Keys.Small)
		local v68 = v63 and (v62 == "Narrow" and v67)

		v64 = if not FFlagLuaAppNarrowTileSmallerFooterFont then nil else v68
		v65 = if not FFlagLuaAppNarrowTileHideRating then nil else v68
		v66 = if not FFlagLuaAppNarrowTileHidePlayerCount then nil else v68
	end

	local v69 = if not v63 then nil else getGameTileCollectionItemSize(v62)
	local v70, v71 = React.useState(nil)
	local v72 = React.useRef(v70)

	v72.current = v70

	local v73 = nil

	if FFlagLuaAppRfyRevealRowsFocusFix then
		v73 = React.useMemo(function() -- line: 228
			-- upvalues: composeRefs (copy), v71 (copy), t1 (copy)
			return (composeRefs(v71, t1.gridContainerRef))
		end, { t1.gridContainerRef })
	end

	local v74 = useGameSortData(t1.gameSortId, t1.pageContext, t1.searchParams and t1.searchParams.searchUuid)
	local v75 = React.useMemo(function() -- line: 240
		-- upvalues: v57 (copy), t1 (copy), Cryo (copy)
		local v108 = if not v57 then t1.sideMargin else nil

		if not t1.layoutOverrides and not v108 then
			return nil
		end

		return Cryo.Dictionary.join(t1.layoutOverrides or {}, {
			sideMargin = if not t1.layoutOverrides or not t1.layoutOverrides.sideMargin then v108 else t1.layoutOverrides.sideMargin
		})
	end, {
		t1.layoutOverrides,
		v57,
		t1.sideMargin
	})
	local v76 = useGameCollectionLayoutParams(v62, v70, false, v75)
	local itemsPerRow, v79

	if FFlagLuaAppFixCompositionSizeOverrideGap then
		local v77 = useCollectionLayout(v69)

		itemsPerRow = v77.itemsPerRow
		v79 = useSizeAdjustedEntries(t1.entries, if not v63 then v76.columnGap else v77.gutter, if not v63 then v76.verticalPadding else v77.verticalGap)
	else
		v79 = useSizeAdjustedEntries(t1.entries, v76.columnGap, v76.verticalPadding)
		itemsPerRow = useCollectionLayout(v69).itemsPerRow
	end

	local v80 = if not v63 then v76.numColumns or 0 else itemsPerRow or 0
	local v81, v82 = useGameSortAnalytics(v74.sort, v74.isOmni, t1.sortIndex, t1.pageContext, nil, v79, v80, t1.startRow)
	local v83 = nil

	if FFlagLuaAppHomeTouchAutoplay then
		v83 = GameTile.useVideoAnalytics(v74.sort, v74.isOmni, t1.pageContext, t1.sortIndex, v79)
	end

	local v84, v85 = useGameSortTooltipParams(v74.sort, v74.isOmni, t1.infoText)
	local v86, v87, v88 = useGameSortImpressionsParams(v74.sort, v74.isOmni, t1.sortIndex, t1.pageContext, t1.useGridTiles, t1.componentType, v74.gamesApiSortPageId, t1.gameSortId, t1.scrollViewPositionChangedSignal, v80, t1.startRow, v79, t1.searchParams)
	local v89 = if not FFlagLuaAppFixSearchImpressions or not t1.searchParams then nil else t1.searchParams.searchUuid
	local v90 = if not FFlagLuaAppFixSearchImpressions then `GameGrid_{ t1.gameSortId }_{ t1.sortIndex }` else React.useMemo(function() -- line: 323
		-- upvalues: t1 (copy), v89 (copy)
		local v109 = `GameGrid_{ t1.pageContext }`

		if v89 then
			v109 ..= ("_%*"):format(v89)
		end

		return v109 .. `_{ t1.gameSortId }_{ t1.sortIndex }`
	end, {
		t1.pageContext,
		v89,
		t1.gameSortId,
		t1.sortIndex
	})
	local v91 = useIsHoldToPlayEnabledForGames()
	local v92 = useHoldToPlayStateAndCallbacks()
	local v93 = useControllerBarFocusNavigationBindings(nil, if not v91 then nil else v92.holdToPlayEventHandler)

	React.useEffect(function() -- line: 350
		-- upvalues: v93 (copy), v70 (copy)
		if v93 then
			v93(v70)
		end
	end, {
		v93,
		v70
	})

	local v94 = t1.shouldHideTileTitle or false
	local v95 = t1.shouldHideTileMetadata or false
	local v96 = t1.containedTile or false
	local v97 = useTextSizeOffset()
	local v98 = GameTileConstants.TileTextLines[v62] and GameTileConstants.TileTextLines[v62].titleTextLines
	local v99 = useGetGameTileHeight(v61, v62, v96, v95, v94, v97, nil, v98, if not FFlagLuaAppNarrowTileHideRating and not FFlagLuaAppNarrowTileHidePlayerCount then nil else v65 or v66)
	local v100 = getGameTileHiddenStore(t1.gameSortId)
	local v101 = SignalsReact.useSignalState(v100.getHiddenGames)
	local setGameHidden = v100.setGameHidden
	local v103 = if v62 ~= "Narrow" or t1.playerCountStyle then t1.playerCountStyle else GameTileConstants.PlayerCountStyleValues.Footer
	local v104 = useRenderGameCollectionItem(v103, t1.isSponsoredFooterAllowed, v62, t1.friendFooterEnabled, t1.pageContext == AppPage.Home, v90, v61, v81, v82, if not t1.launchExperienceEventContextOverride then DiscoveryAnalytics.Constants.Context.ExperienceTile else t1.launchExperienceEventContextOverride, nil, nil, nil, if not v74.isOmni then nil else t1.gameSortId, nil, nil, t1.playButtonStyle, v96, v94, v95, if not v91 then nil else v92.onHoldableFocused, if not v91 then nil else v92.onHoldableUnfocused, if not v91 then nil else v92.shouldDisableHoldable, v97, v98, nil, nil, if not FFlagLuaAppHomeTouchAutoplay then nil else v83, nil, t1.selectionOrderBase, t1.enableExplicitFeedback, v101, setGameHidden, t1.pageContext, if not FFlagLuaAppEnableWhyThisAdModal then nil else t1.sponsoredUserCohort, t1.enableSponsoredFeedback, if not FFlagLuaAppEnableSponsoredReportAd then nil else t1.enableReportAd, #v79, t1.isSponsoredRatingFooterAllowed, nil, nil, nil, if not FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone then nil else t1.onTileImageLoaded, if not FFlagLuaAppNarrowTileSmallerFooterFont then nil else v64, if not FFlagLuaAppNarrowTileHideRating then nil else v65, if not FFlagLuaAppNarrowTileHidePlayerCount then nil else v66, if not FFlagLuaAppHomeTouchAutoplay then nil else t1.videoPlaybackContext)

	if not FFlagLuaAppCompositionAlways then
		local v105 = React.useRef(0)

		React.useEffect(function() -- line: 449
			-- upvalues: v63 (copy), v76 (copy), v105 (copy), t1 (copy)
			if not v63 and v76.numColumns ~= v105.current then
				v105.current = v76.numColumns

				if t1.onItemsPerRowChanged then
					t1.onItemsPerRowChanged(v76.numColumns)
				end
			end
		end, {
			v76.numColumns,
			t1.onItemsPerRowChanged,
			v105,
			v63
		})
	end

	if not v74.gameSortDataFound then
		return nil
	end

	local v106 = React.createElement(GameSortImpressionsDetector, {
		parentRef = v72,
		pageContext = t1.pageContext,
		impressionsTag = v90,
		scrollViewPositionChangedSignal = v87,
		sendGameImpressions = v86,
		dataUpdatedTimestamp = v74.gameSortContents and v74.gameSortContents.updatedTimestamp or nil
	})

	return React.createElement(React.Fragment, nil, {
		GameGrid = React.createElement(CollectionGrid, {
			hideHeaderButton = true,
			collectionItemSize = if not v63 then nil else v69,
			LayoutOrder = if not FFlagLuaAppRfyRevealRows then nil else t1.LayoutOrder,
			ZIndex = if not FFlagLuaAppRfyRevealRows then nil else t1.ZIndex,
			title = t1.title,
			subtitle = v74.sort and v74.sort.subtitle or nil,
			onViewableItemsChanged = v88,
			containerRef = if not FFlagLuaAppRfyRevealRowsFocusFix then v71 else v73,
			tooltipInfoText = v85,
			items = v79,
			onActivateInfoIcon = v84,
			verticalScrollingFrameRef = t1.verticalScrollingFrameRef,
			renderItem = v104,
			getItemHeight = v99,
			numColumns = if not v63 then v76.numColumns else nil,
			columnGap = if not v63 then v76.columnGap else nil,
			sideMargin = if not v63 then v76.sideMargin else nil,
			verticalPadding = if not v63 then v76.verticalPadding else nil,
			maxNumRows = t1.maxNumRows,
			bufferRowsBelowScreen = v59,
			bufferRowsAboveScreen = v60,
			headerComponent = t1.headerComponent,
			headerTag = if not FFlagLuaAppSortHeaderAnchorTag then nil else t1.headerTag,
			testId = if not t1.gameSortId then nil else `--{ t1.gameSortId }-game-collection-grid`
		}),
		GameSortImpressionsDetector = React.createElement(WaitForPropWrapper, {
			waitForProp = t1.startRow,
			maxUpdatesToDelay = t1.numUpdatesToDelayImpressions,
			wrappedComponent = v106
		}),
		HoldToPlayLauncher = if not v91 or not v92.shouldRenderHoldToPlayLauncher then nil else React.createElement(HoldToPlayLauncher, {
			selectedIndex = v92.selectedIndex,
			selectedEntry = v92.selectedEntry,
			selectedNavigationUniverseId = v92.selectedNavigationUniverseId,
			holdState = v92.holdState,
			holdProgress = v92.holdProgress,
			cancelHold = v92.cancelHold,
			launchContext = DiscoveryAnalytics.Constants.Context.HoldToPlayLauncher,
			referralSource = t1.pageContext,
			reportExperienceLaunched = v82
		})
	})
end

return React.memo(GameCollectionGrid)
