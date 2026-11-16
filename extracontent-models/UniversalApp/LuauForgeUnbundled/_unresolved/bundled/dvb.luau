local module = require("@luauforge/bundled/drY")
local module2 = require("@luauforge/bundled/drj")
local validateProps = require("@luauforge/bundled/dqK").validateProps
local module3 = require("@luauforge/bundled/drl")
local gameTileConstants = module3.GameTileConstants
local getGameTileCollectionItemSize = module3.getGameTileCollectionItemSize
require("@luauforge/bundled/dvc")
require("@luauforge/bundled/dqY")
local module4 = require("@luauforge/bundled/dsq")
local usePreferredInput = module4.usePreferredInput
local useBreakpointXOrSmaller = module4.useBreakpointXOrSmaller
local useAppPolicy = require("@luauforge/bundled/drN").useAppPolicy
local module5 = require("@luauforge/bundled/dsr")
local collectionCarousel = module5.CollectionCarousel
local useCollectionLayout = module5.useCollectionLayout
local module6 = require("@luauforge/bundled/dsy")
local useCountdownSubtitleTextBinding = module6.useCountdownSubtitleTextBinding
local useGetGameTileHeight = module6.useGetGameTileHeight
local useRenderGameCollectionItem = module6.useRenderGameCollectionItem
local useGameCollectionLayoutParams = module6.useGameCollectionLayoutParams
local isSeeAllTileEnabled = module6.isSeeAllTileEnabled
local useGameSortHeaderButtonParams = module6.useGameSortHeaderButtonParams
local useIsHoldToPlayEnabledForGames = module6.useIsHoldToPlayEnabledForGames
local waitForPropWrapper = module6.WaitForPropWrapper
local module7 = require("@luauforge/bundled/dqo")

local useControllerBarFocusNavigationBindings = module6.GameCollectionNavigationBindings.useControllerBarFocusNavigationBindings
local useGameSortAnalytics = module6.useGameSortAnalytics
local useGameSortData = module6.useGameSortData
local useGameSortImpressionsParams = module6.useGameSortImpressionsParams
local useGameSortTooltipParams = module6.useGameSortTooltipParams
local appPage = require("@luauforge/bundled/drn").AppPage
local scrollDetector = require("@luauforge/bundled/dvd").ScrollDetector
local frameBoundsImpressionsTracker = require("@luauforge/bundled/dsb").FrameBoundsImpressionsTracker
local screenSizeImpressionsTracker = require("@luauforge/bundled/dsb").ScreenSizeImpressionsTracker
local holdToPlayLauncher = require("@luauforge/bundled/dve").HoldToPlayLauncher
local useHoldToPlayStateAndCallbacks = require("@luauforge/bundled/dve").useHoldToPlayStateAndCallbacks
local useTextSizeOffset = require("@luauforge/bundled/drd").Core.Style.useTextSizeOffset
local hoverTileCoordinator = require("@luauforge/bundled/drl").HoverTileCoordinator
local useVideoAnalytics = require("@luauforge/bundled/drl").useVideoAnalytics
local module8 = require("@luauforge/bundled/dqn")
local omniFeedConstants = module8.OmniFeedConstants
local module9 = require("@luauforge/bundled/dvf")
local enum = module9.Analytics.Enum
local socialUpsellType = module9.Enum.SocialUpsellType

local module10 = require("@luauforge/bundled/dvg")
local module11 = require("@luauforge/bundled/dvi")
local module12 = require("@luauforge/bundled/dvj")

local fFlagLuaAppHeaderButtonText = require("@luauforge/bundled/dqB").FFlagLuaAppHeaderButtonText
local fFlagLuaAppHomeGameCarouselRemount = require("@luauforge/bundled/dqB").FFlagLuaAppHomeGameCarouselRemount
local fFlagLuaAppUseFrameBoundsImpressions = require("@luauforge/bundled/dqB").FFlagLuaAppUseFrameBoundsImpressions
local fFlagLuaAppCompositionAlways = require("@luauforge/bundled/dqB").FFlagLuaAppCompositionAlways
local fFlagLuaAppNarrowTileHideRating = require("@luauforge/bundled/dqB").FFlagLuaAppNarrowTileHideRating
local fFlagLuaAppNarrowTileHidePlayerCount = require("@luauforge/bundled/dqB").FFlagLuaAppNarrowTileHidePlayerCount

local fFlagLuaAppUsePrevalidatedVideoGamePlayability = require("@luauforge/bundled/dqB").FFlagLuaAppUsePrevalidatedVideoGamePlayability
local fFlagLuaAppContinueSortInstantPlay = require("@luauforge/bundled/dqB").FFlagLuaAppContinueSortInstantPlay

local strictInterface = module2.strictInterface
local v5 = {}
v5.useGridTiles = module2.optional(module2.boolean)
v5.gameSortId = module2.string
v5.sortIndex = module2.number
v5.pageContext = module2.string
v5.scrollViewPositionChangedSignal = module2.optional(module2.table)
v5.friendFooterEnabled = module2.optional(module2.boolean)
v5.playerCountStyle = module2.optional(module2.string)
v5.isSponsoredFooterAllowed = module2.optional(module2.boolean)
v5.componentType = module2.optional(module2.string)
v5.hideSeeAll = module2.optional(module2.boolean)
v5.gameTileLayoutType = module2.optional(module2.string)
v5.infoText = module2.optional(module2.string)
v5.endTimestamp = module2.optional(module2.number)
v5.countdownString = module2.optional(module2.string)
v5.linkPath = module2.optional(module2.string)
v5.subtitleLinkPath = module2.optional(module2.string)
v5.ampUpsellFeatureName = module2.optional(module2.string)
v5.ampUpsellNamespace = module2.optional(module2.string)
v5.refreshFeed = module2.optional(module2.callback)
v5.gridSupportAllowed = module2.optional(module2.boolean)
v5.isHoverSupportEnabled = module2.optional(module2.boolean)
v5.startRow = module2.optional(module2.number)
v5.playButtonStyle = module2.optional(module2.string)
local v6 = if not fFlagLuaAppCompositionAlways then module2.optional(module2.number) else nil
v5.sideMargin = v6
v5.backgroundMuralUrl = module2.optional(module2.string)
local v7 = if fFlagLuaAppHeaderButtonText then module2.optional(module2.string) else nil
v5.headerButtonText = v7
v5.shouldHideTileMetadata = module2.optional(module2.boolean)
v5.shouldHideTileTitle = module2.optional(module2.boolean)
v5.containedTile = module2.optional(module2.boolean)
v5.shouldUseFrameBoundsForImpressions = module2.optional(module2.boolean)
v5.layoutOverrides = module2.optional(module2.table)
v5.numUpdatesToDelayImpressions = module2.optional(module2.number)
v5.selectionOrderBase = module2.optional(module2.number)
v5.defaultContainerSize = module2.optional(module2.Vector2)
v5.appCompositionEnabled = module2.optional(module2.boolean)

local v8 = if fFlagLuaAppUsePrevalidatedVideoGamePlayability then module2.optional(module2.boolean) else nil
v5.hasPrevalidatedVideoGamePlayability = v8

v5.videoPlaybackContext = module2.optional(module2.table)
local v9 = if fFlagLuaAppContinueSortInstantPlay then module2.optional(module2.boolean) else nil
v5.enableInstantPlay = v9
local v10 = if fFlagLuaAppContinueSortInstantPlay then module2.optional(module2.string) else nil
v5.instantPlayTreatment = v10
local v11 = strictInterface(v5)

local function GameCollectionCarousel(props)
	validateProps(v11, props)

	local v12 = useAppPolicy(function(p2)
		return p2.useGridPageLayout()
	end)

	local v13 = usePreferredInput()
	local v14 = props.isHoverSupportEnabled and v12 and v13 == module4.Input.Pointer

	local gameTileLayoutType = props.gameTileLayoutType or "Narrow"
	local v15 = fFlagLuaAppCompositionAlways or props.appCompositionEnabled

	local v16 = useBreakpointXOrSmaller(module4.Keys.Small)

	if v15 then
		if gameTileLayoutType ~= "Narrow" then
			v16 = false
		end
	else
		v16 = v15
	end

	local v17 = if fFlagLuaAppNarrowTileHideRating then v16 else nil
	local v18 = if fFlagLuaAppNarrowTileHidePlayerCount then v16 else nil
	local v19 = if v15 then getGameTileCollectionItemSize(gameTileLayoutType) else nil

	local state, setState = module.useState(nil)

	local ref = module.useRef(state)
	ref.current = state

	local ref2 = module.useRef(nil)
	local viewportVideoAutoplayController

	if props.videoPlaybackContext then
		viewportVideoAutoplayController = props.videoPlaybackContext.viewportVideoAutoplayController
	else
		viewportVideoAutoplayController = nil
	end

	local v20 = module.useCallback(function()
		if viewportVideoAutoplayController then
			viewportVideoAutoplayController:onScrollStart()
		end
	end, { viewportVideoAutoplayController })
	local v21 = module.useCallback(function(p2)
		if viewportVideoAutoplayController then
			viewportVideoAutoplayController:onScrollSettled("X", p2, ref)
		end
	end, { viewportVideoAutoplayController, ref })

	local v22 = useGameSortData(props.gameSortId, props.pageContext)
	local entries = v22.gameSortContents and v22.gameSortContents.entries or {}

	local v23 = module11(props.gameSortId)
	module.useEffect(function()
		if v22.sort and v22.sort.dataSource == module8.DataSourceType.ExploreApi then
			v23()
		end
	end, { props.gameSortId, v22.sort })

	local v24 = module12(
		v22.gameSortContents,
		v22.sort,
		v22.gameSortFetchingStatus,
		props.pageContext,
		v22.sortIndex
	)

	local v25, v26, v27, v28 = useGameSortAnalytics(
		v22.sort,
		v22.isOmni,
		props.sortIndex,
		props.pageContext,
		ref2,
		entries,
		#entries,
		props.startRow
	)

	local v29 = module.useCallback(function()
		if not props.refreshFeed then
			return
		end

		props.refreshFeed(omniFeedConstants.OmniRecommendationsRequestIntent.AmpUpsellFeatureGranted)
	end, { props.refreshFeed })

	local v30 = module.useMemo(function()
		local v32 = if props.pageContext == appPage.Home then enum.UpsellEntrySurfaceType.Homepage else nil
		return {
			upsellEntrySurface = v32,
			upsellComponent = enum.UpsellComponent.Carousel,
			upsellStage = enum.UpsellStage.Fae,
			upsellPurpose = socialUpsellType.FacialAgeEstimation
		}
	end, { props.pageContext })

	local v31 = module10(props.ampUpsellFeatureName, props.ampUpsellNamespace, v29, "gameCarousel", v30)

	local sort = v22.sort
	local isOmni = v22.isOmni
	local sortIndex = v22.sortIndex
	local gamesApiSortPageId = v22.gamesApiSortPageId
	local gameSortId = props.gameSortId
	local pageContext = props.pageContext
	local linkPath = props.linkPath
	local subtitleLinkPath = props.subtitleLinkPath
	local v33 = if fFlagLuaAppHeaderButtonText then props.headerButtonText else nil
	local v34, v35, v36 = useGameSortHeaderButtonParams(
		v27,
		sort,
		isOmni,
		sortIndex,
		gamesApiSortPageId,
		gameSortId,
		pageContext,
		linkPath,
		subtitleLinkPath,
		v33,
		v31
	)

	local v37, v38 = useGameSortTooltipParams(v22.sort, v22.isOmni, props.infoText)

	local v39, v40, v41 = useGameSortImpressionsParams(
		v22.sort,
		v22.isOmni,
		props.sortIndex,
		props.pageContext,
		props.useGridTiles,
		props.componentType,
		v22.gamesApiSortPageId,
		props.gameSortId,
		props.scrollViewPositionChangedSignal,
		nil,
		props.startRow,
		entries
	)

	local formatted = `GameCarousel_{props.gameSortId}{props.sortIndex}`

	local v42 = useVideoAnalytics(v22.sort, v22.isOmni, props.pageContext, props.sortIndex, entries)

	local v43 = useIsHoldToPlayEnabledForGames()
	local v44 = useHoldToPlayStateAndCallbacks()

	local v46 = if v43 then v44.holdToPlayEventHandler else nil
	local v47 = useControllerBarFocusNavigationBindings(v34, v46)

	module.useEffect(function()
		if v47 then
			v47(state)
		end
	end, { v47, state })
	local v48

	if props.layoutOverrides then
		v48 = props.layoutOverrides
	else
		v48 = not v12 and { sideMargin = props.sideMargin } or nil
	end

	local v49 = useGameCollectionLayoutParams(
		gameTileLayoutType,
		state,
		false,
		v48,
		props.defaultContainerSize
	)

	local v50 = useCollectionLayout(v19).itemsPerRow

	local backgroundMuralUrl = props.backgroundMuralUrl
	local shouldHideTileTitle = props.shouldHideTileTitle or false
	local shouldHideTileMetadata = props.shouldHideTileMetadata or false
	local v51

	if props.containedTile == nil then
		if v12 and props.gridSupportAllowed and props.gameTileLayoutType == "Narrow" then
			v51 = true
		else
			v51 = not (backgroundMuralUrl == nil) and backgroundMuralUrl ~= ""
		end
	else
		v51 = props.containedTile
	end

	local titleTextLines = gameTileConstants.TileTextLines[gameTileLayoutType]
		and gameTileConstants.TileTextLines[gameTileLayoutType].titleTextLines
	local v52 = useTextSizeOffset()
	local v55

	if fFlagLuaAppNarrowTileHideRating or fFlagLuaAppNarrowTileHidePlayerCount then
		v55 = v17 or v18
	end

	local v56 = useGetGameTileHeight(
		v14,
		gameTileLayoutType,
		v51,
		shouldHideTileMetadata,
		shouldHideTileTitle,
		v52,
		nil,
		titleTextLines,
		v55
	)

	local hideSeeAll = props.hideSeeAll
	local maxTilesToShow = v49.maxTilesToShow

	if not v15 then
		v50 = v49.numColumns
	end

	local maxTilesToShow2

	if isSeeAllTileEnabled(hideSeeAll, maxTilesToShow, v50, #entries, v34) then
		maxTilesToShow2 = v49.maxTilesToShow or #entries + 1
	end

	local v58

	if gameTileLayoutType == "Narrow" and not props.playerCountStyle then
		v58 = gameTileConstants.PlayerCountStyleValues.Footer
	else
		v58 = props.playerCountStyle
	end

	local isSponsoredFooterAllowed = props.isSponsoredFooterAllowed

	local friendFooterEnabled = props.friendFooterEnabled
	local v60 = props.pageContext == appPage.Home

	local experienceTile = module7.Constants.Context.ExperienceTile

	local topicId = if v22.isOmni and v22.sort then v22.sort.topicId else nil

	local playButtonStyle = props.playButtonStyle

	local onHoldableFocused = if v43 then v44.onHoldableFocused else nil
	local onHoldableUnfocused = if v43 then v44.onHoldableUnfocused else nil
	local shouldDisableHoldable = if v43 then v44.shouldDisableHoldable else nil

	local selectionOrderBase = props.selectionOrderBase

	local pageContext2 = props.pageContext

	if not fFlagLuaAppNarrowTileHideRating then
		v17 = nil
	end

	if not fFlagLuaAppNarrowTileHidePlayerCount then
		v18 = nil
	end

	local videoPlaybackContext = props.videoPlaybackContext
	local hasPrevalidatedVideoGamePlayability

	if fFlagLuaAppUsePrevalidatedVideoGamePlayability then
		hasPrevalidatedVideoGamePlayability = props.hasPrevalidatedVideoGamePlayability
	end

	local enableInstantPlay = if fFlagLuaAppContinueSortInstantPlay then props.enableInstantPlay else nil
	local v79 = if fFlagLuaAppContinueSortInstantPlay then props.instantPlayTreatment else nil
	local v80 = useRenderGameCollectionItem(
		v58,
		isSponsoredFooterAllowed,
		gameTileLayoutType,
		friendFooterEnabled,
		v60,
		formatted,
		v14,
		v25,
		v26,
		experienceTile,
		nil,
		nil,
		v34,
		topicId,
		maxTilesToShow2,
		nil,
		playButtonStyle,
		v51,
		shouldHideTileTitle,
		shouldHideTileMetadata,
		onHoldableFocused,
		onHoldableUnfocused,
		shouldDisableHoldable,
		v52,
		titleTextLines,
		nil,
		nil,
		v42,
		nil,
		selectionOrderBase,
		nil,
		nil,
		nil,
		pageContext2,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		v16,
		v17,
		v18,
		videoPlaybackContext,
		hasPrevalidatedVideoGamePlayability,
		enableInstantPlay,
		v79
	)

	local v81 = useCountdownSubtitleTextBinding(
		props.endTimestamp,
		props.countdownString,
		v22.sort and v22.sort.subtitle or ""
	)

	if not (props.endTimestamp and props.countdownString) then
		v81 = if v22.sort then v22.sort.subtitle or nil else nil
	end

	local v82 = module.useCallback(function()
		hoverTileCoordinator.default:reset()
	end, {})

	if not v22.gameSortDataFound then
		return nil
	end

	local v83, createElement, v84, v85, updatedTimestamp

	if fFlagLuaAppUseFrameBoundsImpressions or props.shouldUseFrameBoundsForImpressions then
		local createElement2 = module.createElement
		local v87 = {
			parentRef = ref2,
			pageContext = props.pageContext,
			impressionsTag = formatted,
			scrollViewPositionChangedSignal = v40,
			sendImpressions = v39,
			dataUpdatedTimestamp = 0
		}

		local v88 = if v22.gameSortContents then v22.gameSortContents.updatedTimestamp or nil else nil
		v87.dataUpdatedTimestamp = v88
		v83 = createElement2(frameBoundsImpressionsTracker, v87)

		if not v83 then
			createElement = module.createElement
			v84 = screenSizeImpressionsTracker
			v85 = {
				parentRef = ref2,
				pageContext = props.pageContext,
				impressionsTag = formatted,
				scrollViewPositionChangedSignal = v40,
				sendImpressions = v39,
				dataUpdatedTimestamp = 0
			}

			if v22.gameSortContents then
				updatedTimestamp = v22.gameSortContents.updatedTimestamp or nil
			end

			v85.dataUpdatedTimestamp = updatedTimestamp
			v83 = createElement(v84, v85)
		end
	else
		createElement = module.createElement
		v84 = screenSizeImpressionsTracker
		v85 = {
			parentRef = ref2,
			pageContext = props.pageContext,
			impressionsTag = formatted,
			scrollViewPositionChangedSignal = v40,
			sendImpressions = v39,
			dataUpdatedTimestamp = 0
		}

		if v22.gameSortContents then
			updatedTimestamp = v22.gameSortContents.updatedTimestamp or nil
		end

		v85.dataUpdatedTimestamp = updatedTimestamp
		v83 = createElement(v84, v85)
	end

	local v86 = (not fFlagLuaAppHomeGameCarouselRemount or props.pageContext ~= appPage.Home)
		and "GameCarousel"
		or `GameCarousel_{props.gameSortId}`

	local createElement2 = module.createElement
	local fragment = module.Fragment

	local createElement3 = module.createElement

	if not v15 then
		v19 = nil
	end

	local v89 = {
		collectionItemSize = v19,
		title = v22.sort and v22.sort.displayName or "",
		subtitle = v81,
		backgroundMuralUrl = backgroundMuralUrl,
		onViewableItemsChanged = v41,
		onChangeCanvasPosition = v41,
		containerRef = setState,
		scrollingFrameRef = ref2,
		tooltipInfoText = v38,
		hideHeaderButton = props.hideSeeAll,
		items = entries,
		onActivateHeader = v34,
		onActivateSubtitle = 0,
		hideSubtitleChevron = 0,
		onActivateInfoIcon = 0,
		renderItem = 0,
		getItemHeight = 0,
		numColumns = 0,
		fractionalItemAmount = 0,
		columnGap = 0,
		sideMargin = 0,
		maxItemsToShow = 0,
		headerButtonText = 0,
		thresholdFromEnd = 0,
		onReachedThresholdFromEnd = 0,
		onScrollButtonEnter = 0,
		enableHoverOverflow = 0,
		testId = 0
	}

	if not (props.subtitleLinkPath or v31) then
		v36 = nil
	end

	v89.onActivateSubtitle = v36

	v89.hideSubtitleChevron = not props.subtitleLinkPath
	v89.onActivateInfoIcon = v37
	v89.renderItem = v80
	v89.getItemHeight = v56
	local v90 = if not v15 then v49.numColumns else nil
	v89.numColumns = v90
	local v91 = if not v15 then v49.fractionalItemAmount else nil
	v89.fractionalItemAmount = v91
	local v92 = if not v15 then v49.columnGap else nil
	v89.columnGap = v92
	local v93 = if not v15 then v49.sideMargin else nil
	v89.sideMargin = v93
	v89.maxItemsToShow = v49.maxTilesToShow
	v89.headerButtonText = v35
	v89.thresholdFromEnd = v49.loadMoreThreshold
	v89.onReachedThresholdFromEnd = v24
	v89.onScrollButtonEnter = v82

	if not v15 then
		v14 = nil
	end

	v89.enableHoverOverflow = v14
	local v94 = if props.gameSortId then `--{props.gameSortId}-game-collection-carousel` else nil
	v89.testId = v94
	local children = {
		[v86] = createElement3(collectionCarousel, v89),
		GameSortImpressionsDetector = module.createElement(waitForPropWrapper, {
			waitForProp = props.startRow,
			maxUpdatesToDelay = props.numUpdatesToDelayImpressions,
			wrappedComponent = v83
		}),
		ScrollDetector = module.createElement(scrollDetector, {
			scrollingFrameRef = ref2,
			sendScrollEvent = v28,
			onScrollStart = v20,
			onScrollSettled = v21
		})
	}

	local v95 = if v43 and v44.shouldRenderHoldToPlayLauncher then module.createElement(holdToPlayLauncher, {
		selectedIndex = v44.selectedIndex,
		selectedEntry = v44.selectedEntry,
		selectedNavigationUniverseId = v44.selectedNavigationUniverseId,
		holdState = v44.holdState,
		holdProgress = v44.holdProgress,
		cancelHold = v44.cancelHold,
		launchContext = module7.Constants.Context.HoldToPlayLauncher,
		referralSource = props.pageContext,
		reportExperienceLaunched = v26
	}) else nil
	children.HoldToPlayLauncher = v95
	return createElement2(fragment, nil, children)
end

return module.memo(GameCollectionCarousel)
