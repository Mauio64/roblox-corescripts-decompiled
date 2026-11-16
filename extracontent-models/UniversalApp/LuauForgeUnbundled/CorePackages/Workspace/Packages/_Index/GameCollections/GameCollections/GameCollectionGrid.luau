local useControllerBarFocusNavigationBindings = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/GameCollections/GameCollectionNavigationBindings").useControllerBarFocusNavigationBindings
local useGetGameTileHeight = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/GameCollections/useGetGameTileHeight")
local useIsHoldToPlayEnabledForGames = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/GameCollections/useIsHoldToPlayEnabledForGames")
local useRenderGameCollectionItem = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/GameCollections/useRenderGameCollectionItem")
local useGameCollectionLayoutParams = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/GameCollections/useGameCollectionLayoutParams")
local useGameSortAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/GameCollections/useGameSortAnalytics")
local module6 = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/GameCollections/Impressions/GameSortImpressionsDetector")
local useGameSortData = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/GameCollections/useGameSortData")
local useGameSortImpressionsParams = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/GameCollections/Impressions/useGameSortImpressionsParams")
local useGameSortTooltipParams = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/GameCollections/useGameSortTooltipParams")
local WaitForPropWrapper = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/GameCollections/Impressions/WaitForPropWrapper")
local useSizeAdjustedEntries = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/GameCollections/useSizeAdjustedEntries")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/SignalsReact")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/t")
local DiscoveryUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/DiscoveryUtils")
local validateProps = DiscoveryUtils.validateProps
local composeRefs = DiscoveryUtils.composeRefs
local GameTile = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/GameTile")
local getGameTileCollectionItemSize = GameTile.getGameTileCollectionItemSize
local getGameTileHiddenStore = GameTile.getGameTileHiddenStore
local gameTileConstants = GameTile.GameTileConstants
require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/VideoUtils")
require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/AppCommonLib")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/Responsive")
local usePreferredInput = Responsive.usePreferredInput
local useBreakpointXOrSmaller = Responsive.useBreakpointXOrSmaller
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/UniversalAppPolicy").useAppPolicy
local collectionGrid = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/CollectionViews").CollectionGrid
local useCollectionLayout = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/CollectionViews").useCollectionLayout
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/RobloxAppEnums").AppPage
local DiscoveryAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/DiscoveryAnalytics")
local useTextSizeOffset = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/UIBlox").Core.Style.useTextSizeOffset
local HoldToPlay = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/HoldToPlay")
local holdToPlayLauncher = HoldToPlay.HoldToPlayLauncher
local useHoldToPlayStateAndCallbacks = HoldToPlay.useHoldToPlayStateAndCallbacks
require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/DiscoveryTypes")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/Cryo")
require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/CollectionViews")
local fFlagLuaAppEnableReportExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/SharedFlags").FFlagLuaAppEnableReportExperience
local fFlagLuaAppCompositionAlways = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/SharedFlags").FFlagLuaAppCompositionAlways
local fFlagLuaAppNarrowTileHideRating = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/SharedFlags").FFlagLuaAppNarrowTileHideRating
local fFlagLuaAppNarrowTileHidePlayerCount = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/SharedFlags").FFlagLuaAppNarrowTileHidePlayerCount
local fFlagLuaAppRfyRevealRows = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/SharedFlags").FFlagLuaAppRfyRevealRows
local fFlagLuaAppSortHeaderAnchorTag = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/SharedFlags").FFlagLuaAppSortHeaderAnchorTag

local defineFastInt = game:DefineFastInt("LuaAppGameGridBufferRowsBelowScreen", 2)
local defineFastInt2 = game:DefineFastInt("LuaAppGameGridBufferRowsAboveScreen", 1)

local strictInterface = t.strictInterface
local v5 = {}
v5.entries = t.optional(t.table)
v5.title = t.optional(t.string)
v5.headerComponent = t.optional(t.table)
local v6 = if fFlagLuaAppSortHeaderAnchorTag then t.optional(t.string) else nil
v5.headerTag = v6
v5.verticalScrollingFrameRef = t.table
v5.gridContainerRef = t.optional(t.union(t.table, t.callback))
local v7 = if fFlagLuaAppRfyRevealRows then t.optional(t.number) else nil
v5.LayoutOrder = v7
local v8 = if fFlagLuaAppRfyRevealRows then t.optional(t.number) else nil
v5.ZIndex = v8
v5.maxNumRows = t.optional(t.number)
v5.useGridTiles = t.optional(t.boolean)
v5.gameSortId = t.string
v5.sortIndex = t.number
v5.pageContext = t.string
v5.scrollViewPositionChangedSignal = t.optional(t.table)
v5.friendFooterEnabled = t.optional(t.boolean)
v5.playerCountStyle = t.optional(t.string)
v5.isSponsoredFooterAllowed = t.optional(t.boolean)
v5.componentType = t.optional(t.string)
v5.gameTileLayoutType = t.optional(t.string)
v5.infoText = t.optional(t.string)
v5.linkPath = t.optional(t.string)
v5.gridSupportAllowed = t.optional(t.boolean)
v5.isHoverSupportEnabled = t.optional(t.boolean)
v5.onItemsPerRowChanged = t.optional(t.callback)
v5.startRow = t.optional(t.number)
v5.playButtonStyle = t.optional(t.string)

local v9 = if not fFlagLuaAppCompositionAlways then t.optional(t.number) else nil
v5.sideMargin = v9

v5.shouldHideTileMetadata = t.optional(t.boolean)
v5.shouldHideTileTitle = t.optional(t.boolean)
v5.containedTile = t.optional(t.boolean)

v5.numUpdatesToDelayImpressions = t.optional(t.number)
v5.selectionOrderBase = t.optional(t.number)
v5.enableExplicitFeedback = t.optional(t.boolean)
v5.sponsoredUserCohort = t.optional(t.string)
v5.enableSponsoredFeedback = t.optional(t.boolean)
v5.enableReportAd = t.optional(t.boolean)
local v10 = if fFlagLuaAppEnableReportExperience then t.optional(t.boolean) else nil
v5.enableReportExperience = v10

v5.searchParams = t.optional(t.table)
v5.layoutOverrides = t.optional(t.table)
v5.isSponsoredRatingFooterAllowed = t.optional(t.boolean)
v5.launchExperienceEventContextOverride = t.optional(t.string)
v5.appCompositionEnabled = t.optional(t.boolean)

v5.videoPlaybackContext = t.optional(t.table)
local v11 = strictInterface(v5)

local function GameCollectionGrid(props)
	validateProps(v11, props)

	local v12 = useAppPolicy(function(p2)
		return p2.useGridPageLayout()
	end)

	local v13 = usePreferredInput()

	local v16 = props.isHoverSupportEnabled and v12 and v13 == Responsive.Input.Pointer

	local gameTileLayoutType = props.gameTileLayoutType or "Narrow"
	local v17 = fFlagLuaAppCompositionAlways or props.appCompositionEnabled

	local v18 = useBreakpointXOrSmaller(Responsive.Keys.Small)

	if v17 then
		if gameTileLayoutType ~= "Narrow" then
			v18 = false
		end
	else
		v18 = v17
	end

	local v19 = if fFlagLuaAppNarrowTileHideRating then v18 else nil
	local v20 = if fFlagLuaAppNarrowTileHidePlayerCount then v18 else nil
	local v21 = if v17 then getGameTileCollectionItemSize(gameTileLayoutType) else nil

	local state, setState = React.useState(nil)

	local ref = React.useRef(state)
	ref.current = state

	local v22 = React.useMemo(function()
		return composeRefs(setState, props.gridContainerRef)
	end, { props.gridContainerRef })

	local v23 = useGameSortData(
		props.gameSortId,
		props.pageContext,
		props.searchParams and props.searchParams.searchUuid
	)

	local v25 = useGameCollectionLayoutParams(gameTileLayoutType, state, false, (React.useMemo(function()
		local sideMargin = if not v12 then props.sideMargin else nil

		if not (props.layoutOverrides or sideMargin) then
			return nil
		end

		local join = Cryo.Dictionary.join
		local layoutOverrides = props.layoutOverrides or {}

		if props.layoutOverrides and props.layoutOverrides.sideMargin then
			sideMargin = props.layoutOverrides.sideMargin
		end

		return join(layoutOverrides, { sideMargin = sideMargin })
	end, { props.layoutOverrides, v12, props.sideMargin })))

	local v26 = useCollectionLayout(v21)
	local itemsPerRow = v26.itemsPerRow

	local entries = props.entries
	local v28 = if v17 then v26.gutter else v25.columnGap
	local v29 = if v17 then v26.verticalGap else v25.verticalPadding
	local v30 = useSizeAdjustedEntries(entries, v28, v29)

	local v31 = v17 and (itemsPerRow or 0) or v25.numColumns or 0

	local v32, v33 = useGameSortAnalytics(
		v23.sort,
		v23.isOmni,
		props.sortIndex,
		props.pageContext,
		nil,
		v30,
		v31,
		props.startRow
	)

	local v34 = GameTile.useVideoAnalytics(v23.sort, v23.isOmni, props.pageContext, props.sortIndex, v30)

	local v35, v36 = useGameSortTooltipParams(v23.sort, v23.isOmni, props.infoText)

	local v37, v38, v39 = useGameSortImpressionsParams(
		v23.sort,
		v23.isOmni,
		props.sortIndex,
		props.pageContext,
		props.useGridTiles,
		props.componentType,
		v23.gamesApiSortPageId,
		props.gameSortId,
		props.scrollViewPositionChangedSignal,
		v31,
		props.startRow,
		v30,
		props.searchParams
	)

	local searchUuid = if props.searchParams then props.searchParams.searchUuid else nil
	local v40 = React.useMemo(function()
		local v41 = `GameGrid_{props.pageContext}`

		if searchUuid then
			v41 ..= `_{searchUuid}`
		end

		return v41 .. `_{props.gameSortId}_{props.sortIndex}`
	end, { props.pageContext, searchUuid, props.gameSortId, props.sortIndex })

	local v41 = useIsHoldToPlayEnabledForGames()
	local v42 = useHoldToPlayStateAndCallbacks()

	local v45 = if v41 then v42.holdToPlayEventHandler else nil
	local v46 = useControllerBarFocusNavigationBindings(nil, v45)

	React.useEffect(function()
		if v46 then
			v46(state)
		end
	end, { v46, state })

	local shouldHideTileTitle = props.shouldHideTileTitle or false
	local shouldHideTileMetadata = props.shouldHideTileMetadata or false
	local containedTile = props.containedTile or false

	local v47 = useTextSizeOffset()
	local titleTextLines = gameTileConstants.TileTextLines[gameTileLayoutType]
		and gameTileConstants.TileTextLines[gameTileLayoutType].titleTextLines
	local v50

	if fFlagLuaAppNarrowTileHideRating or fFlagLuaAppNarrowTileHidePlayerCount then
		v50 = v19 or v20
	end

	local v51 = useGetGameTileHeight(
		v16,
		gameTileLayoutType,
		containedTile,
		shouldHideTileMetadata,
		shouldHideTileTitle,
		v47,
		nil,
		titleTextLines,
		v50
	)

	local gameTileHiddenStore = getGameTileHiddenStore(props.gameSortId)
	local v52 = SignalsReact.useSignalState(gameTileHiddenStore.getHiddenGames)
	local setGameHidden = gameTileHiddenStore.setGameHidden
	local v53

	if gameTileLayoutType == "Narrow" and not props.playerCountStyle then
		v53 = gameTileConstants.PlayerCountStyleValues.Footer
	else
		v53 = props.playerCountStyle
	end

	local isSponsoredFooterAllowed = props.isSponsoredFooterAllowed

	local friendFooterEnabled = props.friendFooterEnabled
	local v55 = props.pageContext == appPage.Home
	local v56

	if props.launchExperienceEventContextOverride then
		v56 = props.launchExperienceEventContextOverride
	else
		v56 = DiscoveryAnalytics.Constants.Context.ExperienceTile
	end

	local gameSortId = if v23.isOmni then props.gameSortId else nil

	local playButtonStyle = props.playButtonStyle

	local onHoldableFocused = if v41 then v42.onHoldableFocused else nil

	local onHoldableUnfocused = if v41 then v42.onHoldableUnfocused else nil

	local shouldDisableHoldable = if v41 then v42.shouldDisableHoldable else nil

	local selectionOrderBase = props.selectionOrderBase
	local enableExplicitFeedback = props.enableExplicitFeedback

	local pageContext = props.pageContext
	local sponsoredUserCohort = props.sponsoredUserCohort
	local enableSponsoredFeedback = props.enableSponsoredFeedback
	local enableReportAd = props.enableReportAd
	local enableReportExperience = if fFlagLuaAppEnableReportExperience then props.enableReportExperience else nil
	local v65 = #v30
	local isSponsoredRatingFooterAllowed = props.isSponsoredRatingFooterAllowed

	if not fFlagLuaAppNarrowTileHideRating then
		v19 = nil
	end

	if not fFlagLuaAppNarrowTileHidePlayerCount then
		v20 = nil
	end

	local v69 = useRenderGameCollectionItem(
		v53,
		isSponsoredFooterAllowed,
		gameTileLayoutType,
		friendFooterEnabled,
		v55,
		v40,
		v16,
		v32,
		v33,
		v56,
		nil,
		nil,
		nil,
		gameSortId,
		nil,
		nil,
		playButtonStyle,
		containedTile,
		shouldHideTileTitle,
		shouldHideTileMetadata,
		onHoldableFocused,
		onHoldableUnfocused,
		shouldDisableHoldable,
		v47,
		titleTextLines,
		nil,
		nil,
		v34,
		nil,
		selectionOrderBase,
		enableExplicitFeedback,
		v52,
		setGameHidden,
		pageContext,
		sponsoredUserCohort,
		enableSponsoredFeedback,
		enableReportAd,
		enableReportExperience,
		v65,
		isSponsoredRatingFooterAllowed,
		nil,
		nil,
		nil,
		v18,
		v19,
		v20,
		props.videoPlaybackContext
	)

	if not fFlagLuaAppCompositionAlways then
		local ref2 = React.useRef(0)
		React.useEffect(function()
			if not v17 and v25.numColumns ~= ref2.current then
				ref2.current = v25.numColumns

				if props.onItemsPerRowChanged then
					props.onItemsPerRowChanged(v25.numColumns)
				end
			end
		end, { v25.numColumns, props.onItemsPerRowChanged, ref2, v17 })
	end

	if not v23.gameSortDataFound then
		return nil
	end

	local createElement = React.createElement
	local v71 = {
		parentRef = ref,
		pageContext = props.pageContext,
		impressionsTag = v40,
		scrollViewPositionChangedSignal = v38,
		sendGameImpressions = v37,
		dataUpdatedTimestamp = 0
	}

	local v72 = if v23.gameSortContents then v23.gameSortContents.updatedTimestamp or nil else nil
	v71.dataUpdatedTimestamp = v72
	local element = createElement(module6, v71)

	local createElement2 = React.createElement
	local fragment = React.Fragment
	local createElement3 = React.createElement

	if not v17 then
		v21 = nil
	end

	local v76 = if fFlagLuaAppRfyRevealRows then props.LayoutOrder else nil
	local v77 = if fFlagLuaAppRfyRevealRows then props.ZIndex else nil
	local v75 = {
		collectionItemSize = v21,
		LayoutOrder = v76,
		ZIndex = v77,
		title = props.title,
		subtitle = v23.sort and v23.sort.subtitle or nil,
		onViewableItemsChanged = v39,
		containerRef = v22,
		tooltipInfoText = v36,
		hideHeaderButton = true,
		items = v30,
		onActivateInfoIcon = v35,
		verticalScrollingFrameRef = props.verticalScrollingFrameRef,
		renderItem = v69,
		getItemHeight = v51,
		numColumns = 0,
		columnGap = 0,
		sideMargin = 0,
		verticalPadding = 0,
		maxNumRows = 0,
		bufferRowsBelowScreen = 0,
		bufferRowsAboveScreen = 0,
		headerComponent = 0,
		headerTag = 0,
		testId = 0
	}

	local v78 = if not v17 then v25.numColumns else nil
	v75.numColumns = v78
	local v79 = if not v17 then v25.columnGap else nil
	v75.columnGap = v79
	local v80 = if not v17 then v25.sideMargin else nil
	v75.sideMargin = v80
	local v81 = if not v17 then v25.verticalPadding else nil
	v75.verticalPadding = v81
	v75.maxNumRows = props.maxNumRows
	v75.bufferRowsBelowScreen = defineFastInt
	v75.bufferRowsAboveScreen = defineFastInt2
	v75.headerComponent = props.headerComponent
	local v82 = if fFlagLuaAppSortHeaderAnchorTag then props.headerTag else nil
	v75.headerTag = v82
	local v83 = if props.gameSortId then `--{props.gameSortId}-game-collection-grid` else nil
	v75.testId = v83
	local children = {
		GameGrid = createElement3(collectionGrid, v75),
		GameSortImpressionsDetector = React.createElement(WaitForPropWrapper, {
			waitForProp = props.startRow,
			maxUpdatesToDelay = props.numUpdatesToDelayImpressions,
			wrappedComponent = element
		}),
		HoldToPlayLauncher = 0
	}

	local v84 = if v41 and v42.shouldRenderHoldToPlayLauncher then React.createElement(holdToPlayLauncher, {
		selectedIndex = v42.selectedIndex,
		selectedEntry = v42.selectedEntry,
		selectedNavigationUniverseId = v42.selectedNavigationUniverseId,
		holdState = v42.holdState,
		holdProgress = v42.holdProgress,
		cancelHold = v42.cancelHold,
		launchContext = DiscoveryAnalytics.Constants.Context.HoldToPlayLauncher,
		referralSource = props.pageContext,
		reportExperienceLaunched = v33
	}) else nil
	children.HoldToPlayLauncher = v84
	return createElement2(fragment, nil, children)
end

return React.memo(GameCollectionGrid)
