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

local FFlagLuaAppEnableSponsoredReportAd = require(GameCollectionsParent.SharedFlags).FFlagLuaAppEnableSponsoredReportAd
local FFlagLuaAppCompositionAlways = require(GameCollectionsParent.SharedFlags).FFlagLuaAppCompositionAlways
local FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone = require(GameCollectionsParent.SharedFlags).FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone
local FFlagLuaAppNarrowTileSmallerFooterFont = require(GameCollectionsParent.SharedFlags).FFlagLuaAppNarrowTileSmallerFooterFont
local FFlagLuaAppNarrowTileHideRating = require(GameCollectionsParent.SharedFlags).FFlagLuaAppNarrowTileHideRating
local FFlagLuaAppNarrowTileHidePlayerCount = require(GameCollectionsParent.SharedFlags).FFlagLuaAppNarrowTileHidePlayerCount
local FFlagLuaAppFixSearchImpressions = require(GameCollectionsParent.SharedFlags).FFlagLuaAppFixSearchImpressions
local FFlagLuaAppFixCompositionSizeOverrideGap = require(GameCollectionsParent.SharedFlags).FFlagLuaAppFixCompositionSizeOverrideGap
local FFlagLuaAppRfyRevealRows = require(GameCollectionsParent.SharedFlags).FFlagLuaAppRfyRevealRows
local FFlagLuaAppSortHeaderAnchorTag = require(GameCollectionsParent.SharedFlags).FFlagLuaAppSortHeaderAnchorTag
local FFlagLuaAppHomeReduceRenders = require(GameCollectionsParent.SharedFlags).FFlagLuaAppHomeReduceRenders
local FFlagLuaAppRfyRevealRowsFocusFix = require(GameCollectionsParent.SharedFlags).FFlagLuaAppRfyRevealRowsFocusFix
local v50 = game:DefineFastInt("LuaAppGameGridBufferRowsBelowScreen", 2)
local v51 = game:DefineFastInt("LuaAppGameGridBufferRowsAboveScreen", 1)
local v52 = t.strictInterface({
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
	sponsoredUserCohort = t.optional(t.string),
	enableSponsoredFeedback = t.optional(t.boolean),
	enableReportAd = if not FFlagLuaAppEnableSponsoredReportAd then nil else t.optional(t.boolean),
	searchParams = t.optional(t.table),
	layoutOverrides = t.optional(t.table),
	isSponsoredRatingFooterAllowed = t.optional(t.boolean),
	launchExperienceEventContextOverride = t.optional(t.string),
	appCompositionEnabled = t.optional(t.boolean),
	onTileImageLoaded = if not FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone then nil else t.optional(t.callback),
	videoPlaybackContext = t.optional(t.table)
})

local function GameCollectionGrid(t1: {[any]: any}) -- line: 174
	-- upvalues: validateProps (copy), v52 (copy), useAppPolicy (copy), usePreferredInput (copy), FFlagLuaAppHomeReduceRenders (copy), v50 (copy), Responsive (copy), v51 (copy), FFlagLuaAppCompositionAlways (copy), FFlagLuaAppNarrowTileSmallerFooterFont (copy), FFlagLuaAppNarrowTileHideRating (copy), FFlagLuaAppNarrowTileHidePlayerCount (copy), useBreakpointXOrSmaller (copy), getGameTileCollectionItemSize (copy), React (copy), FFlagLuaAppRfyRevealRowsFocusFix (copy), composeRefs (copy), useGameSortData (copy), Cryo (copy), useGameCollectionLayoutParams (copy), FFlagLuaAppFixCompositionSizeOverrideGap (copy), useCollectionLayout (copy), useSizeAdjustedEntries (copy), useGameSortAnalytics (copy), GameTile (copy), useGameSortTooltipParams (copy), useGameSortImpressionsParams (copy), FFlagLuaAppFixSearchImpressions (copy), useIsHoldToPlayEnabledForGames (copy), useHoldToPlayStateAndCallbacks (copy), useControllerBarFocusNavigationBindings (copy), useTextSizeOffset (copy), GameTileConstants (copy), useGetGameTileHeight (copy), getGameTileHiddenStore (copy), SignalsReact (copy), useRenderGameCollectionItem (copy), AppPage (copy), DiscoveryAnalytics (copy), FFlagLuaAppEnableSponsoredReportAd (copy), FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone (copy), GameSortImpressionsDetector (copy), CollectionGrid (copy), FFlagLuaAppRfyRevealRows (copy), FFlagLuaAppSortHeaderAnchorTag (copy), WaitForPropWrapper (copy), HoldToPlayLauncher (copy)
	validateProps(v52, t1)

	local v55 = useAppPolicy(function(p1) -- line: 178
		return p1.useGridPageLayout()
	end)
	local v56 = usePreferredInput()
	local v57 = if not FFlagLuaAppHomeReduceRenders then v56 ~= Responsive.Input.Directional and 2 or 4 else v50
	local v58 = if not FFlagLuaAppHomeReduceRenders then v56 ~= Responsive.Input.Directional and 1 or 4 else v51
	local v59 = t1.isHoverSupportEnabled and (v55 and v56 == Responsive.Input.Pointer)
	local v60 = t1.gameTileLayoutType or "Narrow"
	local v61 = FFlagLuaAppCompositionAlways or t1.appCompositionEnabled
	local v62 = nil
	local v63 = nil
	local v64 = nil

	if FFlagLuaAppNarrowTileSmallerFooterFont or (FFlagLuaAppNarrowTileHideRating or FFlagLuaAppNarrowTileHidePlayerCount) then
		local v65 = useBreakpointXOrSmaller(Responsive.Keys.Small)
		local v66 = v61 and (v60 == "Narrow" and v65)

		v62 = if not FFlagLuaAppNarrowTileSmallerFooterFont then nil else v66
		v63 = if not FFlagLuaAppNarrowTileHideRating then nil else v66
		v64 = if not FFlagLuaAppNarrowTileHidePlayerCount then nil else v66
	end

	local v67 = if not v61 then nil else getGameTileCollectionItemSize(v60)
	local v68, v69 = React.useState(nil)
	local v70 = React.useRef(v68)

	v70.current = v68

	local v71 = nil

	if FFlagLuaAppRfyRevealRowsFocusFix then
		v71 = React.useMemo(function() -- line: 225
			-- upvalues: composeRefs (copy), v69 (copy), t1 (copy)
			return (composeRefs(v69, t1.gridContainerRef))
		end, { t1.gridContainerRef })
	end

	local v72 = useGameSortData(t1.gameSortId, t1.pageContext, t1.searchParams and t1.searchParams.searchUuid)
	local v73 = React.useMemo(function() -- line: 237
		-- upvalues: v55 (copy), t1 (copy), Cryo (copy)
		local v106 = if not v55 then t1.sideMargin else nil

		if not t1.layoutOverrides and not v106 then
			return nil
		end

		return Cryo.Dictionary.join(t1.layoutOverrides or {}, {
			sideMargin = if not t1.layoutOverrides or not t1.layoutOverrides.sideMargin then v106 else t1.layoutOverrides.sideMargin
		})
	end, {
		t1.layoutOverrides,
		v55,
		t1.sideMargin
	})
	local v74 = useGameCollectionLayoutParams(v60, v68, false, v73)
	local itemsPerRow, v77

	if FFlagLuaAppFixCompositionSizeOverrideGap then
		local v75 = useCollectionLayout(v67)

		itemsPerRow = v75.itemsPerRow
		v77 = useSizeAdjustedEntries(t1.entries, if not v61 then v74.columnGap else v75.gutter, if not v61 then v74.verticalPadding else v75.verticalGap)
	else
		v77 = useSizeAdjustedEntries(t1.entries, v74.columnGap, v74.verticalPadding)
		itemsPerRow = useCollectionLayout(v67).itemsPerRow
	end

	local v78 = if not v61 then v74.numColumns or 0 else itemsPerRow or 0
	local v79, v80 = useGameSortAnalytics(v72.sort, v72.isOmni, t1.sortIndex, t1.pageContext, nil, v77, v78, t1.startRow)
	local v81 = GameTile.useVideoAnalytics(v72.sort, v72.isOmni, t1.pageContext, t1.sortIndex, v77)
	local v82, v83 = useGameSortTooltipParams(v72.sort, v72.isOmni, t1.infoText)
	local v84, v85, v86 = useGameSortImpressionsParams(v72.sort, v72.isOmni, t1.sortIndex, t1.pageContext, t1.useGridTiles, t1.componentType, v72.gamesApiSortPageId, t1.gameSortId, t1.scrollViewPositionChangedSignal, v78, t1.startRow, v77, t1.searchParams)
	local v87 = if not FFlagLuaAppFixSearchImpressions or not t1.searchParams then nil else t1.searchParams.searchUuid
	local v88 = if not FFlagLuaAppFixSearchImpressions then `GameGrid_{ t1.gameSortId }_{ t1.sortIndex }` else React.useMemo(function() -- line: 317
		-- upvalues: t1 (copy), v87 (copy)
		local v107 = `GameGrid_{ t1.pageContext }`

		if v87 then
			v107 ..= ("_%*"):format(v87)
		end

		return v107 .. `_{ t1.gameSortId }_{ t1.sortIndex }`
	end, {
		t1.pageContext,
		v87,
		t1.gameSortId,
		t1.sortIndex
	})
	local v89 = useIsHoldToPlayEnabledForGames()
	local v90 = useHoldToPlayStateAndCallbacks()
	local v91 = useControllerBarFocusNavigationBindings(nil, if not v89 then nil else v90.holdToPlayEventHandler)

	React.useEffect(function() -- line: 344
		-- upvalues: v91 (copy), v68 (copy)
		if v91 then
			v91(v68)
		end
	end, {
		v91,
		v68
	})

	local v92 = t1.shouldHideTileTitle or false
	local v93 = t1.shouldHideTileMetadata or false
	local v94 = t1.containedTile or false
	local v95 = useTextSizeOffset()
	local v96 = GameTileConstants.TileTextLines[v60] and GameTileConstants.TileTextLines[v60].titleTextLines
	local v97 = useGetGameTileHeight(v59, v60, v94, v93, v92, v95, nil, v96, if not FFlagLuaAppNarrowTileHideRating and not FFlagLuaAppNarrowTileHidePlayerCount then nil else v63 or v64)
	local v98 = getGameTileHiddenStore(t1.gameSortId)
	local v99 = SignalsReact.useSignalState(v98.getHiddenGames)
	local setGameHidden = v98.setGameHidden
	local v101 = if v60 ~= "Narrow" or t1.playerCountStyle then t1.playerCountStyle else GameTileConstants.PlayerCountStyleValues.Footer
	local v102 = useRenderGameCollectionItem(v101, t1.isSponsoredFooterAllowed, v60, t1.friendFooterEnabled, t1.pageContext == AppPage.Home, v88, v59, v79, v80, if not t1.launchExperienceEventContextOverride then DiscoveryAnalytics.Constants.Context.ExperienceTile else t1.launchExperienceEventContextOverride, nil, nil, nil, if not v72.isOmni then nil else t1.gameSortId, nil, nil, t1.playButtonStyle, v94, v92, v93, if not v89 then nil else v90.onHoldableFocused, if not v89 then nil else v90.onHoldableUnfocused, if not v89 then nil else v90.shouldDisableHoldable, v95, v96, nil, nil, v81, nil, t1.selectionOrderBase, t1.enableExplicitFeedback, v99, setGameHidden, t1.pageContext, t1.sponsoredUserCohort, t1.enableSponsoredFeedback, if not FFlagLuaAppEnableSponsoredReportAd then nil else t1.enableReportAd, #v77, t1.isSponsoredRatingFooterAllowed, nil, nil, nil, if not FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone then nil else t1.onTileImageLoaded, if not FFlagLuaAppNarrowTileSmallerFooterFont then nil else v62, if not FFlagLuaAppNarrowTileHideRating then nil else v63, if not FFlagLuaAppNarrowTileHidePlayerCount then nil else v64, t1.videoPlaybackContext)

	if not FFlagLuaAppCompositionAlways then
		local v103 = React.useRef(0)

		React.useEffect(function() -- line: 443
			-- upvalues: v61 (copy), v74 (copy), v103 (copy), t1 (copy)
			if not v61 and v74.numColumns ~= v103.current then
				v103.current = v74.numColumns

				if t1.onItemsPerRowChanged then
					t1.onItemsPerRowChanged(v74.numColumns)
				end
			end
		end, {
			v74.numColumns,
			t1.onItemsPerRowChanged,
			v103,
			v61
		})
	end

	if not v72.gameSortDataFound then
		return nil
	end

	local v104 = React.createElement(GameSortImpressionsDetector, {
		parentRef = v70,
		pageContext = t1.pageContext,
		impressionsTag = v88,
		scrollViewPositionChangedSignal = v85,
		sendGameImpressions = v84,
		dataUpdatedTimestamp = v72.gameSortContents and v72.gameSortContents.updatedTimestamp or nil
	})

	return React.createElement(React.Fragment, nil, {
		GameGrid = React.createElement(CollectionGrid, {
			hideHeaderButton = true,
			collectionItemSize = if not v61 then nil else v67,
			LayoutOrder = if not FFlagLuaAppRfyRevealRows then nil else t1.LayoutOrder,
			ZIndex = if not FFlagLuaAppRfyRevealRows then nil else t1.ZIndex,
			title = t1.title,
			subtitle = v72.sort and v72.sort.subtitle or nil,
			onViewableItemsChanged = v86,
			containerRef = if not FFlagLuaAppRfyRevealRowsFocusFix then v69 else v71,
			tooltipInfoText = v83,
			items = v77,
			onActivateInfoIcon = v82,
			verticalScrollingFrameRef = t1.verticalScrollingFrameRef,
			renderItem = v102,
			getItemHeight = v97,
			numColumns = if not v61 then v74.numColumns else nil,
			columnGap = if not v61 then v74.columnGap else nil,
			sideMargin = if not v61 then v74.sideMargin else nil,
			verticalPadding = if not v61 then v74.verticalPadding else nil,
			maxNumRows = t1.maxNumRows,
			bufferRowsBelowScreen = v57,
			bufferRowsAboveScreen = v58,
			headerComponent = t1.headerComponent,
			headerTag = if not FFlagLuaAppSortHeaderAnchorTag then nil else t1.headerTag,
			testId = if not t1.gameSortId then nil else `--{ t1.gameSortId }-game-collection-grid`
		}),
		GameSortImpressionsDetector = React.createElement(WaitForPropWrapper, {
			waitForProp = t1.startRow,
			maxUpdatesToDelay = t1.numUpdatesToDelayImpressions,
			wrappedComponent = v104
		}),
		HoldToPlayLauncher = if not v89 or not v90.shouldRenderHoldToPlayLauncher then nil else React.createElement(HoldToPlayLauncher, {
			selectedIndex = v90.selectedIndex,
			selectedEntry = v90.selectedEntry,
			selectedNavigationUniverseId = v90.selectedNavigationUniverseId,
			holdState = v90.holdState,
			holdProgress = v90.holdProgress,
			cancelHold = v90.cancelHold,
			launchContext = DiscoveryAnalytics.Constants.Context.HoldToPlayLauncher,
			referralSource = t1.pageContext,
			reportExperienceLaunched = v80
		})
	})
end

return React.memo(GameCollectionGrid)
