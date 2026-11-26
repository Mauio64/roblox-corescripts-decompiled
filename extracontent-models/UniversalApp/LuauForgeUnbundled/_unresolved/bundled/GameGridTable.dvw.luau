local module = require("@luauforge/bundled/dva")
local useSelector = require("@luauforge/bundled/dvx").Hooks.RoactRodux.useSelector
local module2 = require("@luauforge/bundled/dvy")
local module3 = require("@luauforge/bundled/duf")
local responsiveGrid = module3.App.Container.Grid.ResponsiveGrid
local responsiveLayoutProvider = module3.Core.Layout.Responsive.ResponsiveLayoutProvider
local module4 = require("@luauforge/bundled/dun")
local gameTileConstants = module4.GameTileConstants
local gameTileLayoutType = module4.GameTileTypes.GameTileLayoutType
local gameTileViewConfig = module4.GameTileViewConfig
local appGameTile = module4.AppGameTile
local getTileBadgeByPositionConfigFromEntry = module4.getTileBadgeByPositionConfigFromEntry
local layoutConfig = require("@luauforge/bundled/dup").LayoutConfig
local useResponsiveLayout = module3.Core.Layout.Responsive.useResponsiveLayout
local useTextSizeOffset = module3.Core.Style.useTextSizeOffset
local useDispatch = require("@luauforge/bundled/dvx").Hooks.RoactRodux.useDispatch
local useNavigation = require("@luauforge/bundled/dvz").useNavigation
local useRoactService = require("@luauforge/bundled/dvr").useRoactService
local roactNetworking = require("@luauforge/bundled/dum").RoactNetworking
local openGameDetails = require("@luauforge/bundled/dve").OpenGameDetails
local useDesignTokens = require("@luauforge/bundled/dvl").useDesignTokens
local useTokens = require("@luauforge/bundled/dvi").Hooks.useTokens
local useGameCollectionLayoutParams = require("@luauforge/bundled/dvA").useGameCollectionLayoutParams
local useCollectionLayout = require("@luauforge/bundled/dvt").useCollectionLayout
local module5 = require("@luauforge/bundled/dvs")
local useBreakpointXOrSmaller = module5.useBreakpointXOrSmaller

local discoveryEventErrorLogger = require("@luauforge/bundled/dtM").DiscoveryEventErrorLogger

local module6 = require("@luauforge/bundled/duZ")

local module7 = require("@luauforge/bundled/dtD")
local fFlagLuaAppCompositionAlways = module7.FFlagLuaAppCompositionAlways
local fFlagLuaAppSduiEdpEnabled = module7.FFlagLuaAppSduiEdpEnabled

local function getCellSpan(p2): number
	if p2.featured then
		return 2
	end

	return 1
end

local function GameGridTable(props)
	local v5

	if props.useGridTiles then
		v5 = layoutConfig.Kind.Experiences.GridTile
	else
		v5 = layoutConfig.Kind.Experiences.WithFooter
	end

	local v6 = useTokens()

	local entries = props.entries or {}
	local gameEmphasis = props.gameEmphasis or false
	local v7 = module.useMemo(function()
		return module2.Array.map(entries, function(p2, p3)
			return module2.Object.assign({
				index = p3,
				featured = p3 == 1 and gameEmphasis
			}, p2)
		end)
	end, { entries, gameEmphasis })

	local v8 = useDispatch()
	local v9 = useNavigation()

	local v10 = if fFlagLuaAppSduiEdpEnabled then useRoactService(roactNetworking) else nil

	local function fn(p2, p3)
		v8(openGameDetails(p2, v9, p3, if fFlagLuaAppSduiEdpEnabled then v10 else nil))
	end

	local v13 = module.useCallback(fn, { v9, if fFlagLuaAppSduiEdpEnabled then v10 else nil })

	local windowSize = props.windowSize or Vector2.one
	local v14 = useTextSizeOffset()
	local source = props.source
	local referralSource = props.referralSource
	local hideGameStats = props.hideGameStats
	local v15 = props.useHoverTile == nil or props.useHoverTile
	local reportGameDetailOpened = props.reportGameDetailOpened
	local reportExperienceLaunched = props.reportExperienceLaunched
	local showFriendActivity = props.showFriendActivity or false

	local v16 = useResponsiveLayout("relativeHeight", v5)

	local v17 = fFlagLuaAppCompositionAlways or props.appCompositionEnabled
	local v18 = useCollectionLayout(module4.getGameTileCollectionItemSize(props.gameTileLayoutType or gameTileLayoutType.Narrow))

	local enableCollectionLayout = props.enableCollectionLayout or v17
	local state, setState = module.useState(nil)

	local v19 = useGameCollectionLayoutParams(
		props.gameTileLayoutType or gameTileLayoutType.Narrow,
		state,
		false
	)

	local ref = module.useRef(1)
	local v20 = useResponsiveLayout("columns", v5)

	local v21 = if v17 then v18.itemsPerRow elseif enableCollectionLayout then v19.numColumns else v20

	local v22 = useBreakpointXOrSmaller(module5.Keys.XSmall)

	module.useEffect(function()
		if ref.current ~= v21 then
			ref.current = v21

			if props.onItemsPerRowChanged then
				props.onItemsPerRowChanged(v21)
			end
		end
	end, { v21, ref, props.onItemsPerRowChanged })

	local v23 = useDesignTokens()

	local tileTextLine = gameTileConstants.TileTextLines[props.gameTileLayoutType or gameTileLayoutType.Narrow]
	local footerHeight = gameTileViewConfig.getFooterHeight(
		v23,
		true,
		false,
		false,
		v14,
		nil,
		tileTextLine.titleTextLines,
		v6,
		true
	)

	if v16 == nil or v16.Scale == nil then
		discoveryEventErrorLogger.reportError("GameGridTable_NilRelativeHeight", "relativeHeight is nil", {
			rowKind = tostring(v5),
			relativeHeightType = typeof(v16),
			relativeHeightValue = tostring(v16),
			responsiveLayoutColumns = tostring(v20),
			useGridTiles = tostring(props.useGridTiles or false),
			enableCollectionLayout = tostring(props.enableCollectionLayout or false),
			gameTileLayoutType = tostring(props.gameTileLayoutType or "nil")
		})
	else
		v16 = UDim.new(v16.Scale, footerHeight)
	end

	local v24 = module.useCallback(function(props2, p2)
		if props2.featured then
			return module.createElement(module6, {
				entry = props2,
				index = props2.realGameEntryIndex or props2.index,
				source = source,
				reportGameDetailOpened = reportGameDetailOpened,
				reportExperienceLaunched = reportExperienceLaunched,
				hasBackground = true,
				hasActionRow = true,
				isDynamic = true,
				impressionsTag = props.impressionsTag,
				launchExperienceEventContext = props.launchExperienceEventContext
			})
		end

		return module.createElement(appGameTile, {
			entry = props2,
			index = props2.realGameEntryIndex or props2.index,
			source = source,
			reportGameDetailOpened = reportGameDetailOpened,
			reportExperienceLaunched = reportExperienceLaunched,
			hideGameStats = hideGameStats,
			referralSource = referralSource,
			rowNum = math.ceil(props2.index / (p2.columns or 1)),
			showFriendActivity = showFriendActivity,
			playerCountStyle = props.playerCountStyle,
			isSponsoredFooterAllowed = props.isSponsoredFooterAllowed,
			useHoverTile = v15,
			useGridTile = props.useGridTiles,
			friendFooterEnabled = props.useGridTiles and true or nil,
			impressionsTag = props.impressionsTag,
			launchExperienceEventContext = props.launchExperienceEventContext,
			topicId = props.topicId,
			gameTileLayoutType = props.gameTileLayoutType,
			navigateToGameDetails = v13,
			playButtonStyle = props.playButtonStyle,
			isContained = true,
			textSizeOffset = v14,
			isNarrowScreenXSmall = v22,
			badgeOverride = getTileBadgeByPositionConfigFromEntry(props2)
		})
	end, {
		source,
		referralSource,
		hideGameStats,
		showFriendActivity,
		reportGameDetailOpened,
		reportExperienceLaunched,
		props.impressionsTag,
		props.launchExperienceEventContext,
		props.playerCountStyle,
		props.useGridTiles,
		props.isSponsoredFooterAllowed,
		props.playButtonStyle,
		v22
	})

	local y = if props.screenSize then props.screenSize.Y else windowSize.Y

	local v25 = useSelector(function(p2)
		if p2.ScreenSize then
			return p2.ScreenSize.X
		end

		return nil
	end)

	local v26 = useResponsiveLayout("verticalGutter", v5)

	if v17 then
		v26 = v18.verticalGap
	end

	local v27 = if v17 then v18.gutter else v19.columnGap
	local v28 = v17 and 0 or v19.sideMargin
	local v29 = module.useMemo(function()
		if not enableCollectionLayout then
			return nil
		end

		local layout = v23.LuaApps.Layout

		if not layout then
			return nil
		end

		local grid = layout.grid
		local tiles = layout.tiles
		return {
			columns = v21,
			gutter = v27,
			margin = v28,
			verticalGutter = v26,
			relativeHeight = v16,
			hoverTileTopOffset = tiles.hover.topOffset,
			hoverTileBottomOffset = tiles.hover.bottomOffset,
			hoverTileHorizontalOffset = tiles.hover.horizontalOffset,
			scrollableMaxTilesPerRow = grid.default.scrollableMaxTilesPerRow
		}
	end, { enableCollectionLayout, v23.LuaApps.Layout, v21, v27, v28, v26, v16 })

	local v30 = module.createElement(responsiveGrid, {
		ref = setState,
		kind = v5,
		data = v7,
		renderItem = v24,
		layoutOrder = props.LayoutOrder,
		getCellColspan = getCellSpan,
		getCellRowspan = getCellSpan,
		relativeHeight = v16,
		absoluteWindowTop = -y,
		absoluteWindowHeight = y * 3,
		enableDeferredRefPropEvents = true
	})

	if enableCollectionLayout then
		v30 = module.createElement(responsiveLayoutProvider, {
			width = v25,
			config = v29
		}, {
			ResponsiveGrid = v30
		})
	end

	return v30
end

return GameGridTable
