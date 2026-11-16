local GameCollections = script:FindFirstAncestor("GameCollections")

local GameCollectionNavigationBindings = require(GameCollections.GameCollectionNavigationBindings)
local useControllerBarFocusNavigationBindings = GameCollectionNavigationBindings.useControllerBarFocusNavigationBindings
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

local parent = GameCollections.Parent
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local t = require(parent.t)
local DiscoveryUtils = require(parent.DiscoveryUtils)
local validateProps = DiscoveryUtils.validateProps
local composeRefs = DiscoveryUtils.composeRefs
local GameTile = require(parent.GameTile)
local getGameTileCollectionItemSize = GameTile.getGameTileCollectionItemSize
local getGameTileHiddenStore = GameTile.getGameTileHiddenStore
local GameTileConstants = GameTile.GameTileConstants
require(parent.VideoUtils)
require(parent.AppCommonLib)
local Responsive = require(parent.Responsive)
local usePreferredInput = Responsive.usePreferredInput
local useBreakpointXOrSmaller = Responsive.useBreakpointXOrSmaller
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local CollectionViews = require(parent.CollectionViews)
local CollectionGrid = CollectionViews.CollectionGrid
local CollectionViews2 = require(parent.CollectionViews)
local useCollectionLayout = CollectionViews2.useCollectionLayout
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local UIBlox = require(parent.UIBlox)
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset
local HoldToPlay = require(parent.HoldToPlay)
local HoldToPlayLauncher = HoldToPlay.HoldToPlayLauncher
local useHoldToPlayStateAndCallbacks = HoldToPlay.useHoldToPlayStateAndCallbacks
require(parent.DiscoveryTypes)
local Cryo = require(parent.Cryo)
require(parent.CollectionViews)
local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppEnableReportExperience = SharedFlags.FFlagLuaAppEnableReportExperience
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppCompositionAlways = SharedFlags2.FFlagLuaAppCompositionAlways
local SharedFlags3 = require(parent.SharedFlags)
local FFlagLuaAppNarrowTileHideRating = SharedFlags3.FFlagLuaAppNarrowTileHideRating
local SharedFlags4 = require(parent.SharedFlags)
local FFlagLuaAppNarrowTileHidePlayerCount = SharedFlags4.FFlagLuaAppNarrowTileHidePlayerCount
local SharedFlags5 = require(parent.SharedFlags)
local FFlagLuaAppRfyRevealRows = SharedFlags5.FFlagLuaAppRfyRevealRows
local SharedFlags6 = require(parent.SharedFlags)
local FFlagLuaAppSortHeaderAnchorTag = SharedFlags6.FFlagLuaAppSortHeaderAnchorTag

local defineFastInt = game:DefineFastInt("LuaAppGameGridBufferRowsBelowScreen", 2)
local defineFastInt2 = game:DefineFastInt("LuaAppGameGridBufferRowsAboveScreen", 1)

local strictInterface = t.strictInterface
local v = {}
v.entries = t.optional(t.table)
v.title = t.optional(t.string)
v.headerComponent = t.optional(t.table)
local headerTag

if FFlagLuaAppSortHeaderAnchorTag then
	headerTag = t.optional(t.string)
end

v.headerTag = headerTag
v.verticalScrollingFrameRef = t.table
v.gridContainerRef = t.optional(t.union(t.table, t.callback))
local layoutOrder

if FFlagLuaAppRfyRevealRows then
	layoutOrder = t.optional(t.number)
end

v.LayoutOrder = layoutOrder
local zIndex

if FFlagLuaAppRfyRevealRows then
	zIndex = t.optional(t.number)
end

v.ZIndex = zIndex
v.maxNumRows = t.optional(t.number)
v.useGridTiles = t.optional(t.boolean)
v.gameSortId = t.string
v.sortIndex = t.number
v.pageContext = t.string
v.scrollViewPositionChangedSignal = t.optional(t.table)
v.friendFooterEnabled = t.optional(t.boolean)
v.playerCountStyle = t.optional(t.string)
v.isSponsoredFooterAllowed = t.optional(t.boolean)
v.componentType = t.optional(t.string)
v.gameTileLayoutType = t.optional(t.string)
v.infoText = t.optional(t.string)
v.linkPath = t.optional(t.string)
v.gridSupportAllowed = t.optional(t.boolean)
v.isHoverSupportEnabled = t.optional(t.boolean)
v.onItemsPerRowChanged = t.optional(t.callback)
v.startRow = t.optional(t.number)
v.playButtonStyle = t.optional(t.string)
local sideMargin2

if not FFlagLuaAppCompositionAlways then
	sideMargin2 = t.optional(t.number)
end

v.sideMargin = sideMargin2

v.shouldHideTileMetadata = t.optional(t.boolean)
v.shouldHideTileTitle = t.optional(t.boolean)
v.containedTile = t.optional(t.boolean)

v.numUpdatesToDelayImpressions = t.optional(t.number)
v.selectionOrderBase = t.optional(t.number)
v.enableExplicitFeedback = t.optional(t.boolean)
v.sponsoredUserCohort = t.optional(t.string)
v.enableSponsoredFeedback = t.optional(t.boolean)
v.enableReportAd = t.optional(t.boolean)
local enableReportExperience2

if FFlagLuaAppEnableReportExperience then
	enableReportExperience2 = t.optional(t.boolean)
end

v.enableReportExperience = enableReportExperience2

v.searchParams = t.optional(t.table)
v.layoutOverrides = t.optional(t.table)
v.isSponsoredRatingFooterAllowed = t.optional(t.boolean)
v.launchExperienceEventContextOverride = t.optional(t.string)
v.appCompositionEnabled = t.optional(t.boolean)

v.videoPlaybackContext = t.optional(t.table)
local v2 = strictInterface(v)

local function GameCollectionGrid(props)
	validateProps(v2, props)

	local v3 = useAppPolicy(function(p)
		return p.useGridPageLayout()
	end)

	local v4 = usePreferredInput()

	local v5 = props.isHoverSupportEnabled and v3 and v4 == Responsive.Input.Pointer

	local gameTileLayoutType = props.gameTileLayoutType or "Narrow"
	local v6 = FFlagLuaAppCompositionAlways or props.appCompositionEnabled

	local v7 = useBreakpointXOrSmaller(Responsive.Keys.Small)

	if v6 then
		if gameTileLayoutType ~= "Narrow" then
			v7 = false
		end
	else
		v7 = v6
	end

	local v8

	if FFlagLuaAppNarrowTileHideRating then
		v8 = v7
	end

	local v9

	if FFlagLuaAppNarrowTileHidePlayerCount then
		v9 = v7
	end

	local collectionItemSize

	if v6 then
		collectionItemSize = getGameTileCollectionItemSize(gameTileLayoutType)
	end

	local state, setState = React.useState(nil)

	local ref = React.useRef(state)
	ref.current = state

	local containerRef = React.useMemo(function()
		return (composeRefs(setState, props.gridContainerRef))
	end, { props.gridContainerRef })

	local v10 = useGameSortData(
		props.gameSortId,
		props.pageContext,
		props.searchParams and props.searchParams.searchUuid
	)

	local v11 = useGameCollectionLayoutParams(gameTileLayoutType, state, false, (React.useMemo(function()
		local sideMargin

		if not v3 then
			sideMargin = props.sideMargin
		end

		if not (props.layoutOverrides or sideMargin) then
			return nil
		end

		local join = Cryo.Dictionary.join
		local layoutOverrides = props.layoutOverrides or {}

		if props.layoutOverrides and props.layoutOverrides.sideMargin then
			sideMargin = props.layoutOverrides.sideMargin
		end

		return join(layoutOverrides, { sideMargin = sideMargin })
	end, { props.layoutOverrides, v3, props.sideMargin })))

	local v12 = useCollectionLayout(collectionItemSize)
	local itemsPerRow = v12.itemsPerRow

	local entries = props.entries
	local v13 = if v6 then v12.gutter else v11.columnGap
	local v14 = if v6 then v12.verticalGap else v11.verticalPadding
	local items = useSizeAdjustedEntries(entries, v13, v14)

	local v15 = v6 and (itemsPerRow or 0) or v11.numColumns or 0

	local v16, reportExperienceLaunched = useGameSortAnalytics(
		v10.sort,
		v10.isOmni,
		props.sortIndex,
		props.pageContext,
		nil,
		items,
		v15,
		props.startRow
	)

	local v17 = GameTile.useVideoAnalytics(v10.sort, v10.isOmni, props.pageContext, props.sortIndex, items)

	local onActivateInfoIcon, tooltipInfoText = useGameSortTooltipParams(v10.sort, v10.isOmni, props.infoText)

	local sendGameImpressions, scrollViewPositionChangedSignal, onViewableItemsChanged = useGameSortImpressionsParams(
		v10.sort,
		v10.isOmni,
		props.sortIndex,
		props.pageContext,
		props.useGridTiles,
		props.componentType,
		v10.gamesApiSortPageId,
		props.gameSortId,
		props.scrollViewPositionChangedSignal,
		v15,
		props.startRow,
		items,
		props.searchParams
	)
	local searchUuid

	if props.searchParams then
		searchUuid = props.searchParams.searchUuid
	else
		searchUuid = nil
	end

	local impressionsTag = React.useMemo(function()
		local v18 = `GameGrid_{props.pageContext}`

		if searchUuid then
			v18 ..= `_{searchUuid}`
		end

		return v18 .. `_{props.gameSortId}_{props.sortIndex}`
	end, { props.pageContext, searchUuid, props.gameSortId, props.sortIndex })

	local v18 = useIsHoldToPlayEnabledForGames()
	local v19 = useHoldToPlayStateAndCallbacks()
	local v20

	if v18 then
		v20 = v19.holdToPlayEventHandler
	end

	local v21 = useControllerBarFocusNavigationBindings(nil, v20)

	React.useEffect(function()
		if v21 then
			v21(state)
		end
	end, { v21, state })

	local shouldHideTileTitle = props.shouldHideTileTitle or false
	local shouldHideTileMetadata = props.shouldHideTileMetadata or false
	local containedTile = props.containedTile or false

	local v22 = useTextSizeOffset()
	local titleTextLines = GameTileConstants.TileTextLines[gameTileLayoutType]
		and GameTileConstants.TileTextLines[gameTileLayoutType].titleTextLines
	local v23

	if FFlagLuaAppNarrowTileHideRating or FFlagLuaAppNarrowTileHidePlayerCount then
		v23 = v8 or v9
	end

	local getItemHeight = useGetGameTileHeight(
		v5,
		gameTileLayoutType,
		containedTile,
		shouldHideTileMetadata,
		shouldHideTileTitle,
		v22,
		nil,
		titleTextLines,
		v23
	)

	local gameTileHiddenStore = getGameTileHiddenStore(props.gameSortId)
	local v24 = SignalsReact.useSignalState(gameTileHiddenStore.getHiddenGames)
	local setGameHidden = gameTileHiddenStore.setGameHidden
	local v25

	if gameTileLayoutType == "Narrow" and not props.playerCountStyle then
		v25 = GameTileConstants.PlayerCountStyleValues.Footer
	else
		v25 = props.playerCountStyle
	end

	local isSponsoredFooterAllowed = props.isSponsoredFooterAllowed

	local friendFooterEnabled = props.friendFooterEnabled
	local v26 = props.pageContext == AppPage.Home
	local v27

	if props.launchExperienceEventContextOverride then
		v27 = props.launchExperienceEventContextOverride
	else
		v27 = DiscoveryAnalytics.Constants.Context.ExperienceTile
	end

	local gameSortId

	if v10.isOmni then
		gameSortId = props.gameSortId
	end

	local playButtonStyle = props.playButtonStyle
	local onHoldableFocused

	if v18 then
		onHoldableFocused = v19.onHoldableFocused
	end

	local onHoldableUnfocused

	if v18 then
		onHoldableUnfocused = v19.onHoldableUnfocused
	end

	local shouldDisableHoldable

	if v18 then
		shouldDisableHoldable = v19.shouldDisableHoldable
	end

	local selectionOrderBase = props.selectionOrderBase
	local enableExplicitFeedback = props.enableExplicitFeedback

	local pageContext = props.pageContext
	local sponsoredUserCohort = props.sponsoredUserCohort
	local enableSponsoredFeedback = props.enableSponsoredFeedback
	local enableReportAd = props.enableReportAd
	local enableReportExperience

	if FFlagLuaAppEnableReportExperience then
		enableReportExperience = props.enableReportExperience
	end

	local v28 = #items
	local isSponsoredRatingFooterAllowed = props.isSponsoredRatingFooterAllowed

	if not FFlagLuaAppNarrowTileHideRating then
		v8 = nil
	end

	if not FFlagLuaAppNarrowTileHidePlayerCount then
		v9 = nil
	end

	local renderItem = useRenderGameCollectionItem(
		v25,
		isSponsoredFooterAllowed,
		gameTileLayoutType,
		friendFooterEnabled,
		v26,
		impressionsTag,
		v5,
		v16,
		reportExperienceLaunched,
		v27,
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
		v22,
		titleTextLines,
		nil,
		nil,
		v17,
		nil,
		selectionOrderBase,
		enableExplicitFeedback,
		v24,
		setGameHidden,
		pageContext,
		sponsoredUserCohort,
		enableSponsoredFeedback,
		enableReportAd,
		enableReportExperience,
		v28,
		isSponsoredRatingFooterAllowed,
		nil,
		nil,
		nil,
		v7,
		v8,
		v9,
		props.videoPlaybackContext
	)

	if not FFlagLuaAppCompositionAlways then
		local ref2 = React.useRef(0)
		React.useEffect(function()
			if not v6 and v11.numColumns ~= ref2.current then
				ref2.current = v11.numColumns

				if props.onItemsPerRowChanged then
					props.onItemsPerRowChanged(v11.numColumns)
				end
			end
		end, { v11.numColumns, props.onItemsPerRowChanged, ref2, v6 })
	end

	if not v10.gameSortDataFound then
		return nil
	end

	local createElement = React.createElement
	local v29 = {
		parentRef = ref,
		pageContext = props.pageContext,
		impressionsTag = impressionsTag,
		scrollViewPositionChangedSignal = scrollViewPositionChangedSignal,
		sendGameImpressions = sendGameImpressions,
		dataUpdatedTimestamp = 0
	}
	local dataUpdatedTimestamp

	if v10.gameSortContents then
		dataUpdatedTimestamp = v10.gameSortContents.updatedTimestamp or nil
	end

	v29.dataUpdatedTimestamp = dataUpdatedTimestamp
	local element = createElement(GameSortImpressionsDetector, v29)

	local createElement2 = React.createElement
	local fragment = React.Fragment
	local createElement3 = React.createElement

	if not v6 then
		collectionItemSize = nil
	end

	local layoutOrder2

	if FFlagLuaAppRfyRevealRows then
		layoutOrder2 = props.LayoutOrder
	end

	local zIndex2

	if FFlagLuaAppRfyRevealRows then
		zIndex2 = props.ZIndex
	end

	local v30 = {
		collectionItemSize = collectionItemSize,
		LayoutOrder = layoutOrder2,
		ZIndex = zIndex2,
		title = props.title,
		subtitle = v10.sort and v10.sort.subtitle or nil,
		onViewableItemsChanged = onViewableItemsChanged,
		containerRef = containerRef,
		tooltipInfoText = tooltipInfoText,
		hideHeaderButton = true,
		items = items,
		onActivateInfoIcon = onActivateInfoIcon,
		verticalScrollingFrameRef = props.verticalScrollingFrameRef,
		renderItem = renderItem,
		getItemHeight = getItemHeight,
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
	local numColumns

	if not v6 then
		numColumns = v11.numColumns
	end

	v30.numColumns = numColumns
	local columnGap

	if not v6 then
		columnGap = v11.columnGap
	end

	v30.columnGap = columnGap
	local sideMargin

	if not v6 then
		sideMargin = v11.sideMargin
	end

	v30.sideMargin = sideMargin
	local verticalPadding

	if not v6 then
		verticalPadding = v11.verticalPadding
	end

	v30.verticalPadding = verticalPadding
	v30.maxNumRows = props.maxNumRows
	v30.bufferRowsBelowScreen = defineFastInt
	v30.bufferRowsAboveScreen = defineFastInt2
	v30.headerComponent = props.headerComponent
	local headerTag2

	if FFlagLuaAppSortHeaderAnchorTag then
		headerTag2 = props.headerTag
	end

	v30.headerTag = headerTag2
	local testId

	if props.gameSortId then
		testId = `--{props.gameSortId}-game-collection-grid`
	end

	v30.testId = testId
	local children = {
		GameGrid = createElement3(CollectionGrid, v30),
		GameSortImpressionsDetector = React.createElement(WaitForPropWrapper, {
			waitForProp = props.startRow,
			maxUpdatesToDelay = props.numUpdatesToDelayImpressions,
			wrappedComponent = element
		}),
		HoldToPlayLauncher = 0
	}
	local holdToPlayLauncher

	if v18 and v19.shouldRenderHoldToPlayLauncher then
		holdToPlayLauncher = React.createElement(HoldToPlayLauncher, {
			selectedIndex = v19.selectedIndex,
			selectedEntry = v19.selectedEntry,
			selectedNavigationUniverseId = v19.selectedNavigationUniverseId,
			holdState = v19.holdState,
			holdProgress = v19.holdProgress,
			cancelHold = v19.cancelHold,
			launchContext = DiscoveryAnalytics.Constants.Context.HoldToPlayLauncher,
			referralSource = props.pageContext,
			reportExperienceLaunched = reportExperienceLaunched
		})
	end

	children.HoldToPlayLauncher = holdToPlayLauncher
	return createElement2(fragment, nil, children)
end

return React.memo(GameCollectionGrid)
