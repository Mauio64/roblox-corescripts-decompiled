local DiscoveryMonolith = script:FindFirstAncestor("DiscoveryMonolith")
local DiscoveryMonolithParent = DiscoveryMonolith.Parent
local React = require(DiscoveryMonolithParent.React)
local t = require(DiscoveryMonolithParent.t)
local validateProps = require(DiscoveryMonolithParent.DiscoveryUtils).validateProps
local GameTile = require(DiscoveryMonolithParent.GameTile)
local GameTileConstants = GameTile.GameTileConstants
local getGameTileCollectionItemSize = GameTile.getGameTileCollectionItemSize

require(DiscoveryMonolithParent.VideoUtils)
require(DiscoveryMonolithParent.AppCommonLib)

local Responsive = require(DiscoveryMonolithParent.Responsive)
local usePreferredInput = Responsive.usePreferredInput
local useBreakpointXOrSmaller = Responsive.useBreakpointXOrSmaller
local useAppPolicy = require(DiscoveryMonolithParent.UniversalAppPolicy).useAppPolicy
local CollectionViews = require(DiscoveryMonolithParent.CollectionViews)
local CollectionCarousel = CollectionViews.CollectionCarousel
local useCollectionLayout = CollectionViews.useCollectionLayout
local GameCollections = require(DiscoveryMonolithParent.GameCollections)
local useCountdownSubtitleTextBinding = GameCollections.useCountdownSubtitleTextBinding
local useGetGameTileHeight = GameCollections.useGetGameTileHeight
local useRenderGameCollectionItem = GameCollections.useRenderGameCollectionItem
local useGameCollectionLayoutParams = GameCollections.useGameCollectionLayoutParams
local isSeeAllTileEnabled = GameCollections.isSeeAllTileEnabled
local useGameSortHeaderButtonParams = GameCollections.useGameSortHeaderButtonParams
local useIsHoldToPlayEnabledForGames = GameCollections.useIsHoldToPlayEnabledForGames
local WaitForPropWrapper = GameCollections.WaitForPropWrapper
local DiscoveryAnalytics = require(DiscoveryMonolithParent.DiscoveryAnalytics)
local useControllerBarFocusNavigationBindings = GameCollections.GameCollectionNavigationBindings.useControllerBarFocusNavigationBindings
local useGameSortAnalytics = GameCollections.useGameSortAnalytics
local GameSortImpressionsDetector = GameCollections.GameSortImpressionsDetector
local useGameSortData = GameCollections.useGameSortData
local useGameSortImpressionsParams = GameCollections.useGameSortImpressionsParams
local useGameSortTooltipParams = GameCollections.useGameSortTooltipParams
local AppPage = require(DiscoveryMonolithParent.RobloxAppEnums).AppPage
local ScrollDetector = require(DiscoveryMonolithParent.ScrollTelemetry).ScrollDetector
local FrameBoundsImpressionsTracker = require(DiscoveryMonolithParent.Impressions).FrameBoundsImpressionsTracker
local ScreenSizeImpressionsTracker = require(DiscoveryMonolithParent.Impressions).ScreenSizeImpressionsTracker
local HoldToPlayLauncher = require(DiscoveryMonolithParent.HoldToPlay).HoldToPlayLauncher
local useHoldToPlayStateAndCallbacks = require(DiscoveryMonolithParent.HoldToPlay).useHoldToPlayStateAndCallbacks
local useTextSizeOffset = require(DiscoveryMonolithParent.UIBlox).Core.Style.useTextSizeOffset
local HoverTileCoordinator = require(DiscoveryMonolithParent.GameTile).HoverTileCoordinator
local useVideoAnalytics = require(DiscoveryMonolithParent.GameTile).useVideoAnalytics
local DiscoveryTypes = require(DiscoveryMonolithParent.DiscoveryTypes)
local OmniFeedConstants = DiscoveryTypes.OmniFeedConstants
local SocialUpsell = require(DiscoveryMonolithParent.SocialUpsell)
local Enum = SocialUpsell.Analytics.Enum
local SocialUpsellType = SocialUpsell.Enum.SocialUpsellType
local Modules = DiscoveryMonolith.Modules
local useAmpUpsellAction = require(Modules.Personalization.Games.useAmpUpsellAction)
local useLoadGamesForSortFromGamesApi = require(Modules.Personalization.Games.useLoadGamesForSortFromGamesApi)
local useLoadMoreGames = require(Modules.Personalization.Games.useLoadMoreGames)
local SharedFlags = require(DiscoveryMonolithParent.SharedFlags)
local FFlagLuaAppHeaderButtonText = SharedFlags.FFlagLuaAppHeaderButtonText
local FFlagSearchOmniAutocompletePage = SharedFlags.FFlagSearchOmniAutocompletePage
local FFlagLuaAppHomeGameCarouselRemount = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppHomeGameCarouselRemount
local FFlagLuaAppTileVideoDeviceMemoryBlocking = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppTileVideoDeviceMemoryBlocking
local FFlagLuaAppUseFrameBoundsImpressions = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppUseFrameBoundsImpressions
local FFlagLuaAppCompositionAlways = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppCompositionAlways
local FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone
local FFlagLuaAppNarrowTileSmallerFooterFont = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppNarrowTileSmallerFooterFont
local FFlagLuaAppNarrowTileHideRating = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppNarrowTileHideRating
local FFlagLuaAppNarrowTileHidePlayerCount = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppNarrowTileHidePlayerCount
local FFlagLuaAppHomeTouchAutoplay = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppHomeTouchAutoplay
local FFlagLuaAppGameCarouselAmpUpsellAction = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppGameCarouselAmpUpsellAction
local FFlagLuaAppUsePrevalidatedVideoGamePlayability = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppUsePrevalidatedVideoGamePlayability
local FFlagLuaAppCarouselAmpUpsellSubtitleClickAnalytics = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppCarouselAmpUpsellSubtitleClickAnalytics
local FFlagLuaAppHideCarouselSubtitleChevron = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppHideCarouselSubtitleChevron
local v66 = if not FFlagLuaAppGameCarouselAmpUpsellAction then nil else "gameCarousel"
local v67 = t.strictInterface({
	useGridTiles = t.optional(t.boolean),
	gameSortId = t.string,
	sortIndex = t.number,
	pageContext = t.string,
	scrollViewPositionChangedSignal = t.optional(t.table),
	friendFooterEnabled = t.optional(t.boolean),
	playerCountStyle = t.optional(t.string),
	isSponsoredFooterAllowed = t.optional(t.boolean),
	componentType = t.optional(t.string),
	hideSeeAll = t.optional(t.boolean),
	gameTileLayoutType = t.optional(t.string),
	infoText = t.optional(t.string),
	endTimestamp = t.optional(t.number),
	countdownString = t.optional(t.string),
	linkPath = t.optional(t.string),
	subtitleLinkPath = t.optional(t.string),
	ampUpsellFeatureName = if not FFlagLuaAppGameCarouselAmpUpsellAction then nil else t.optional(t.string),
	ampUpsellNamespace = if not FFlagLuaAppGameCarouselAmpUpsellAction then nil else t.optional(t.string),
	refreshFeed = if not FFlagLuaAppGameCarouselAmpUpsellAction then nil else t.optional(t.callback),
	gridSupportAllowed = t.optional(t.boolean),
	isHoverSupportEnabled = t.optional(t.boolean),
	startRow = t.optional(t.number),
	playButtonStyle = t.optional(t.string),
	sideMargin = if FFlagLuaAppCompositionAlways then nil else t.optional(t.number),
	backgroundMuralUrl = t.optional(t.string),
	headerButtonText = if not FFlagLuaAppHeaderButtonText then nil else t.optional(t.string),
	shouldHideTileMetadata = t.optional(t.boolean),
	shouldHideTileTitle = t.optional(t.boolean),
	containedTile = t.optional(t.boolean),
	shouldUseFrameBoundsForImpressions = if not FFlagSearchOmniAutocompletePage then nil else t.optional(t.boolean),
	layoutOverrides = if not FFlagSearchOmniAutocompletePage then nil else t.optional(t.table),
	numUpdatesToDelayImpressions = t.optional(t.number),
	selectionOrderBase = t.optional(t.number),
	defaultContainerSize = t.optional(t.Vector2),
	appCompositionEnabled = t.optional(t.boolean),
	onTileImageLoaded = if not FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone then nil else t.optional(t.callback),
	hasPrevalidatedVideoGamePlayability = if not FFlagLuaAppUsePrevalidatedVideoGamePlayability then nil else t.optional(t.boolean),
	videoPlaybackContext = if not FFlagLuaAppHomeTouchAutoplay then nil else t.optional(t.table)
})

local function GameCollectionCarousel(t1: {[any]: any}) -- line: 170
	-- upvalues: validateProps (copy), v67 (copy), useAppPolicy (copy), usePreferredInput (copy), Responsive (copy), FFlagLuaAppCompositionAlways (copy), FFlagLuaAppNarrowTileSmallerFooterFont (copy), FFlagLuaAppNarrowTileHideRating (copy), FFlagLuaAppNarrowTileHidePlayerCount (copy), useBreakpointXOrSmaller (copy), getGameTileCollectionItemSize (copy), React (copy), FFlagLuaAppHomeTouchAutoplay (copy), useGameSortData (copy), useLoadGamesForSortFromGamesApi (copy), DiscoveryTypes (copy), useLoadMoreGames (copy), useGameSortAnalytics (copy), FFlagLuaAppGameCarouselAmpUpsellAction (copy), OmniFeedConstants (copy), FFlagLuaAppCarouselAmpUpsellSubtitleClickAnalytics (copy), AppPage (copy), Enum (copy), SocialUpsellType (copy), useAmpUpsellAction (copy), v66 (copy), useGameSortHeaderButtonParams (copy), FFlagLuaAppHeaderButtonText (copy), useGameSortTooltipParams (copy), useGameSortImpressionsParams (copy), useVideoAnalytics (copy), useIsHoldToPlayEnabledForGames (copy), useHoldToPlayStateAndCallbacks (copy), useControllerBarFocusNavigationBindings (copy), FFlagSearchOmniAutocompletePage (copy), useGameCollectionLayoutParams (copy), useCollectionLayout (copy), GameTileConstants (copy), useTextSizeOffset (copy), useGetGameTileHeight (copy), isSeeAllTileEnabled (copy), useRenderGameCollectionItem (copy), DiscoveryAnalytics (copy), FFlagLuaAppTileVideoDeviceMemoryBlocking (copy), FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone (copy), FFlagLuaAppUsePrevalidatedVideoGamePlayability (copy), useCountdownSubtitleTextBinding (copy), HoverTileCoordinator (copy), FFlagLuaAppUseFrameBoundsImpressions (copy), FrameBoundsImpressionsTracker (copy), ScreenSizeImpressionsTracker (copy), GameSortImpressionsDetector (copy), FFlagLuaAppHomeGameCarouselRemount (copy), CollectionCarousel (copy), FFlagLuaAppHideCarouselSubtitleChevron (copy), WaitForPropWrapper (copy), ScrollDetector (copy), HoldToPlayLauncher (copy)
	validateProps(v67, t1)

	local v70 = useAppPolicy(function(p1) -- line: 174
		return p1.useGridPageLayout()
	end)
	local v71 = usePreferredInput()
	local v72 = t1.isHoverSupportEnabled and (v70 and v71 == Responsive.Input.Pointer)
	local v73 = t1.gameTileLayoutType or "Narrow"
	local v74 = FFlagLuaAppCompositionAlways or t1.appCompositionEnabled
	local v75 = nil
	local v76 = nil
	local v77 = nil

	if FFlagLuaAppNarrowTileSmallerFooterFont or (FFlagLuaAppNarrowTileHideRating or FFlagLuaAppNarrowTileHidePlayerCount) then
		local v78 = useBreakpointXOrSmaller(Responsive.Keys.Small)
		local v79 = v74 and (v73 == "Narrow" and v78)

		v75 = if not FFlagLuaAppNarrowTileSmallerFooterFont then nil else v79
		v76 = if not FFlagLuaAppNarrowTileHideRating then nil else v79
		v77 = if not FFlagLuaAppNarrowTileHidePlayerCount then nil else v79
	end

	local v80 = if not v74 then nil else getGameTileCollectionItemSize(v73)
	local v81, v82 = React.useState(nil)
	local v83 = React.useRef(v81)

	v83.current = v81

	local v84 = React.useRef(nil)
	local v85 = nil
	local v86 = nil

	if FFlagLuaAppHomeTouchAutoplay then
		local v87 = if not FFlagLuaAppHomeTouchAutoplay or not t1.videoPlaybackContext then nil else t1.videoPlaybackContext.viewportVideoAutoplayController

		v85 = React.useCallback(function() -- line: 220
			-- upvalues: v87 (copy)
			if v87 then
				v87:onScrollStart()
			end
		end, { v87 })
		v86 = React.useCallback(function(n1: number) -- line: 225
			-- upvalues: v87 (copy), v83 (copy)
			if v87 then
				v87:onScrollSettled("X", n1, v83)
			end
		end, {
			v87,
			v83
		})
	end

	local v88 = useGameSortData(t1.gameSortId, t1.pageContext)
	local v89 = v88.gameSortContents and v88.gameSortContents.entries or {}
	local v90 = useLoadGamesForSortFromGamesApi(t1.gameSortId)

	React.useEffect(function() -- line: 244
		-- upvalues: v88 (copy), DiscoveryTypes (copy), v90 (copy)
		if v88.sort and v88.sort.dataSource == DiscoveryTypes.DataSourceType.ExploreApi then
			v90()
		end
	end, {
		t1.gameSortId,
		v88.sort
	})

	local v91 = useLoadMoreGames(v88.gameSortContents, v88.sort, v88.gameSortFetchingStatus, t1.pageContext, v88.sortIndex)
	local v92, v93, v94, v95 = useGameSortAnalytics(v88.sort, v88.isOmni, t1.sortIndex, t1.pageContext, v84, v89, #v89, t1.startRow)
	local v96 = if not FFlagLuaAppGameCarouselAmpUpsellAction then nil else React.useCallback(function() -- line: 271
		-- upvalues: t1 (copy), OmniFeedConstants (copy)
		if not t1.refreshFeed then
			return
		end

		t1.refreshFeed(OmniFeedConstants.OmniRecommendationsRequestIntent.AmpUpsellFeatureGranted)
	end, { t1.refreshFeed })
	local v97 = if not FFlagLuaAppCarouselAmpUpsellSubtitleClickAnalytics then nil else React.useMemo(function() -- line: 280
		-- upvalues: t1 (copy), AppPage (copy), Enum (copy), SocialUpsellType (copy)
		return {
			upsellEntrySurface = if t1.pageContext ~= AppPage.Home then nil else Enum.UpsellEntrySurfaceType.Homepage,
			upsellComponent = Enum.UpsellComponent.Carousel,
			upsellStage = Enum.UpsellStage.Fae,
			upsellPurpose = SocialUpsellType.FacialAgeEstimation
		}
	end, { t1.pageContext })
	local v98 = if not FFlagLuaAppGameCarouselAmpUpsellAction then nil else useAmpUpsellAction(t1.ampUpsellFeatureName, t1.ampUpsellNamespace, v96, v66, if not FFlagLuaAppCarouselAmpUpsellSubtitleClickAnalytics then nil else v97)
	local v99, v100, v101 = useGameSortHeaderButtonParams(v94, v88.sort, v88.isOmni, v88.sortIndex, v88.gamesApiSortPageId, t1.gameSortId, t1.pageContext, t1.linkPath, t1.subtitleLinkPath, if not FFlagLuaAppHeaderButtonText then nil else t1.headerButtonText, if not FFlagLuaAppGameCarouselAmpUpsellAction then nil else v98)
	local v102, v103 = useGameSortTooltipParams(v88.sort, v88.isOmni, t1.infoText)
	local v104, v105, v106 = useGameSortImpressionsParams(v88.sort, v88.isOmni, t1.sortIndex, t1.pageContext, t1.useGridTiles, t1.componentType, v88.gamesApiSortPageId, t1.gameSortId, t1.scrollViewPositionChangedSignal, nil, t1.startRow, v89)
	local v107 = `GameCarousel_{ t1.gameSortId }{ t1.sortIndex }`
	local v108 = useVideoAnalytics(v88.sort, v88.isOmni, t1.pageContext, t1.sortIndex, v89)
	local v109 = useIsHoldToPlayEnabledForGames()
	local v110 = useHoldToPlayStateAndCallbacks()
	local v111 = useControllerBarFocusNavigationBindings(v99, if not v109 then nil else v110.holdToPlayEventHandler)

	React.useEffect(function() -- line: 348
		-- upvalues: v111 (copy), v81 (copy)
		if v111 then
			v111(v81)
		end
	end, {
		v111,
		v81
	})

	local v112 = if not FFlagSearchOmniAutocompletePage or not t1.layoutOverrides then if not v70 then {
		sideMargin = t1.sideMargin
	} else nil else t1.layoutOverrides
	local v113 = useGameCollectionLayoutParams(v73, v81, false, v112, t1.defaultContainerSize)
	local itemsPerRow = useCollectionLayout(v80).itemsPerRow
	local backgroundMuralUrl = t1.backgroundMuralUrl
	local v116 = t1.shouldHideTileTitle or false
	local v117 = t1.shouldHideTileMetadata or false
	local v118 = if t1.containedTile == nil then v70 and (not not t1.gridSupportAllowed and t1.gameTileLayoutType == "Narrow") or backgroundMuralUrl ~= nil and backgroundMuralUrl ~= "" else t1.containedTile
	local v119 = GameTileConstants.TileTextLines[v73] and GameTileConstants.TileTextLines[v73].titleTextLines
	local v120 = useTextSizeOffset()
	local v121 = useGetGameTileHeight(v72, v73, v118, v117, v116, v120, nil, v119, if not FFlagLuaAppNarrowTileHideRating and not FFlagLuaAppNarrowTileHidePlayerCount then nil else v76 or v77)
	local v122 = if not isSeeAllTileEnabled(t1.hideSeeAll, v113.maxTilesToShow, if not v74 then v113.numColumns else itemsPerRow, #v89, v99) then nil else v113.maxTilesToShow or #v89 + 1
	local v123 = if v73 ~= "Narrow" or t1.playerCountStyle then t1.playerCountStyle else GameTileConstants.PlayerCountStyleValues.Footer
	local v124 = useRenderGameCollectionItem(v123, t1.isSponsoredFooterAllowed, v73, t1.friendFooterEnabled, t1.pageContext == AppPage.Home, v107, v72, v92, v93, DiscoveryAnalytics.Constants.Context.ExperienceTile, nil, nil, v99, if not v88.isOmni or not v88.sort then nil else v88.sort.topicId, v122, nil, t1.playButtonStyle, v118, v116, v117, if not v109 then nil else v110.onHoldableFocused, if not v109 then nil else v110.onHoldableUnfocused, if not v109 then nil else v110.shouldDisableHoldable, v120, v119, nil, nil, v108, nil, t1.selectionOrderBase, nil, nil, nil, if not FFlagLuaAppTileVideoDeviceMemoryBlocking then nil else t1.pageContext, nil, nil, nil, nil, nil, nil, nil, nil, if not FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone then nil else t1.onTileImageLoaded, if not FFlagLuaAppNarrowTileSmallerFooterFont then nil else v75, if not FFlagLuaAppNarrowTileHideRating then nil else v76, if not FFlagLuaAppNarrowTileHidePlayerCount then nil else v77, if not FFlagLuaAppHomeTouchAutoplay then nil else t1.videoPlaybackContext, if not FFlagLuaAppUsePrevalidatedVideoGamePlayability then nil else t1.hasPrevalidatedVideoGamePlayability)
	local v125 = useCountdownSubtitleTextBinding(t1.endTimestamp, t1.countdownString, v88.sort and v88.sort.subtitle or "")
	local v126 = if not t1.endTimestamp or not t1.countdownString then v88.sort and v88.sort.subtitle or nil else v125
	local v127 = React.useCallback(function() -- line: 484
		-- upvalues: HoverTileCoordinator (copy)
		HoverTileCoordinator.default:reset()
	end, {})

	if not v88.gameSortDataFound then
		return nil
	end

	local v128 = if not FFlagSearchOmniAutocompletePage then React.createElement(GameSortImpressionsDetector, {
		parentRef = v84,
		pageContext = t1.pageContext,
		impressionsTag = v107,
		scrollViewPositionChangedSignal = v105,
		sendGameImpressions = v104,
		dataUpdatedTimestamp = v88.gameSortContents and v88.gameSortContents.updatedTimestamp or nil
	}) else not (not FFlagLuaAppUseFrameBoundsImpressions and not t1.shouldUseFrameBoundsForImpressions) and React.createElement(FrameBoundsImpressionsTracker, {
		parentRef = v84,
		pageContext = t1.pageContext,
		impressionsTag = v107,
		scrollViewPositionChangedSignal = v105,
		sendImpressions = v104,
		dataUpdatedTimestamp = v88.gameSortContents and v88.gameSortContents.updatedTimestamp or nil
	}) or React.createElement(ScreenSizeImpressionsTracker, {
		parentRef = v84,
		pageContext = t1.pageContext,
		impressionsTag = v107,
		scrollViewPositionChangedSignal = v105,
		sendImpressions = v104,
		dataUpdatedTimestamp = v88.gameSortContents and v88.gameSortContents.updatedTimestamp or nil
	})
	local v129 = (not FFlagLuaAppHomeGameCarouselRemount or t1.pageContext ~= AppPage.Home) and "GameCarousel" or `GameCarousel_{ t1.gameSortId }`

	return React.createElement(React.Fragment, nil, {
		[v129] = React.createElement(CollectionCarousel, {
			collectionItemSize = if not v74 then nil else v80,
			title = v88.sort and v88.sort.displayName or "",
			subtitle = v126,
			backgroundMuralUrl = backgroundMuralUrl,
			onViewableItemsChanged = v106,
			onChangeCanvasPosition = v106,
			containerRef = v82,
			scrollingFrameRef = v84,
			tooltipInfoText = v103,
			hideHeaderButton = t1.hideSeeAll,
			items = v89,
			onActivateHeader = v99,
			onActivateSubtitle = if not t1.subtitleLinkPath and (not FFlagLuaAppGameCarouselAmpUpsellAction or not v98) then nil else v101,
			hideSubtitleChevron = if not FFlagLuaAppHideCarouselSubtitleChevron then nil else not t1.subtitleLinkPath,
			onActivateInfoIcon = v102,
			renderItem = v124,
			getItemHeight = v121,
			numColumns = if not v74 then v113.numColumns else nil,
			fractionalItemAmount = if not v74 then v113.fractionalItemAmount else nil,
			columnGap = if not v74 then v113.columnGap else nil,
			sideMargin = if not v74 then v113.sideMargin else nil,
			maxItemsToShow = v113.maxTilesToShow,
			headerButtonText = v100,
			thresholdFromEnd = v113.loadMoreThreshold,
			onReachedThresholdFromEnd = v91,
			onScrollButtonEnter = v127,
			enableHoverOverflow = if not v74 then nil else v72,
			testId = if not t1.gameSortId then nil else `--{ t1.gameSortId }-game-collection-carousel`
		}),
		GameSortImpressionsDetector = React.createElement(WaitForPropWrapper, {
			waitForProp = t1.startRow,
			maxUpdatesToDelay = t1.numUpdatesToDelayImpressions,
			wrappedComponent = v128
		}),
		ScrollDetector = React.createElement(ScrollDetector, {
			scrollingFrameRef = v84,
			sendScrollEvent = v95,
			onScrollStart = if not FFlagLuaAppHomeTouchAutoplay then nil else v85,
			onScrollSettled = if not FFlagLuaAppHomeTouchAutoplay then nil else v86
		}),
		HoldToPlayLauncher = if not v109 or not v110.shouldRenderHoldToPlayLauncher then nil else React.createElement(HoldToPlayLauncher, {
			selectedIndex = v110.selectedIndex,
			selectedEntry = v110.selectedEntry,
			selectedNavigationUniverseId = v110.selectedNavigationUniverseId,
			holdState = v110.holdState,
			holdProgress = v110.holdProgress,
			cancelHold = v110.cancelHold,
			launchContext = DiscoveryAnalytics.Constants.Context.HoldToPlayLauncher,
			referralSource = t1.pageContext,
			reportExperienceLaunched = v93
		})
	})
end

return React.memo(GameCollectionCarousel)
