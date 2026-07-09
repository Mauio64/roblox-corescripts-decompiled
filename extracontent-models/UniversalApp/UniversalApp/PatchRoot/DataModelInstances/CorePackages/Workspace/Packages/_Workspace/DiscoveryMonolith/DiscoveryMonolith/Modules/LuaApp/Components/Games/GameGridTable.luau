local DiscoveryMonolith = script:FindFirstAncestor("DiscoveryMonolith")
local DiscoveryMonolithParent = DiscoveryMonolith.Parent
local React = require(DiscoveryMonolithParent.React)
local useSelector = require(DiscoveryMonolithParent.RoactUtils).Hooks.RoactRodux.useSelector
local LuauPolyfill = require(DiscoveryMonolithParent.LuauPolyfill)
local UIBlox = require(DiscoveryMonolithParent.UIBlox)
local ResponsiveGrid = UIBlox.App.Container.Grid.ResponsiveGrid
local ResponsiveLayoutProvider = UIBlox.Core.Layout.Responsive.ResponsiveLayoutProvider
local GameTile = require(DiscoveryMonolithParent.GameTile)
local GameTileConstants = GameTile.GameTileConstants
local GameTileLayoutType = GameTile.GameTileTypes.GameTileLayoutType
local GameTileViewConfig = GameTile.GameTileViewConfig
local AppGameTile = GameTile.AppGameTile
local getTileBadgeByPositionConfigFromEntry = GameTile.getTileBadgeByPositionConfigFromEntry
local LayoutConfig = require(DiscoveryMonolithParent.RobloxAppEnums).LayoutConfig
local useResponsiveLayout = UIBlox.Core.Layout.Responsive.useResponsiveLayout
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset
local useDispatch = require(DiscoveryMonolithParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useNavigation = require(DiscoveryMonolithParent.Navigation).useNavigation
local useRoactService = require(DiscoveryMonolithParent.RobloxAppHooks).useRoactService
local RoactNetworking = require(DiscoveryMonolithParent.RoactServiceTags).RoactNetworking
local OpenGameDetails = require(DiscoveryMonolithParent.GameDetail).OpenGameDetails
local useDesignTokens = require(DiscoveryMonolithParent.Style).useDesignTokens
local useTokens = require(DiscoveryMonolithParent.Foundation).Hooks.useTokens
local useGameCollectionLayoutParams = require(DiscoveryMonolithParent.GameCollections).useGameCollectionLayoutParams
local useCollectionLayout = require(DiscoveryMonolithParent.CollectionViews).useCollectionLayout
local Responsive = require(DiscoveryMonolithParent.Responsive)
local useBreakpointXOrSmaller = Responsive.useBreakpointXOrSmaller
local DiscoveryEventErrorLogger = require(DiscoveryMonolithParent.DiscoveryUtils).DiscoveryEventErrorLogger
local Modules = DiscoveryMonolith.Modules
local AppFeaturedGameTileTwoByTwo = require(Modules.LuaApp.Components.Games.AppFeaturedGameTileTwoByTwo)
local SharedFlags = require(DiscoveryMonolithParent.SharedFlags)
local FFlagLuaAppCompositionAlways = SharedFlags.FFlagLuaAppCompositionAlways
local FFlagLuaAppGameTileLockedBadge = SharedFlags.FFlagLuaAppGameTileLockedBadge
local FFlagSduiEdpPrefetchPlayability = SharedFlags.FFlagSduiEdpPrefetchPlayability
local FFlagLuaAppSduiEdpEnabled = SharedFlags.FFlagLuaAppSduiEdpEnabled
local v37 = game:DefineFastFlag("LuaAppFixGameGridTableNilRelativeHeight", false)

local function getCellSpan(t1: {[any]: any}) -- line: 76
	if t1.featured then
		return 2
	end

	return 1
end
local function GameGridTable(t2: {[any]: any}) -- line: 80
	-- upvalues: LayoutConfig (copy), useTokens (copy), React (copy), LuauPolyfill (copy), useDispatch (copy), useNavigation (copy), FFlagSduiEdpPrefetchPlayability (copy), FFlagLuaAppSduiEdpEnabled (copy), useRoactService (copy), RoactNetworking (copy), OpenGameDetails (copy), useTextSizeOffset (copy), useResponsiveLayout (copy), FFlagLuaAppCompositionAlways (copy), useCollectionLayout (copy), GameTile (copy), GameTileLayoutType (copy), useGameCollectionLayoutParams (copy), useBreakpointXOrSmaller (copy), Responsive (copy), useDesignTokens (copy), GameTileConstants (copy), GameTileViewConfig (copy), v37 (copy), DiscoveryEventErrorLogger (copy), AppFeaturedGameTileTwoByTwo (copy), AppGameTile (copy), FFlagLuaAppGameTileLockedBadge (copy), getTileBadgeByPositionConfigFromEntry (copy), useSelector (copy), ResponsiveGrid (copy), getCellSpan (copy), ResponsiveLayoutProvider (copy)
	local v42 = if not t2.useGridTiles then LayoutConfig.Kind.Experiences.WithFooter else LayoutConfig.Kind.Experiences.GridTile
	local v43 = useTokens()
	local v44 = t2.entries or {}
	local v45 = t2.gameEmphasis or false
	local v46 = React.useMemo(function() -- line: 92
		-- upvalues: LuauPolyfill (copy), v44 (copy), v45 (copy)
		return LuauPolyfill.Array.map(v44, function(p1, p2) -- line: 93
			-- upvalues: LuauPolyfill (copy), v45 (copy)
			return LuauPolyfill.Object.assign({
				index = p2,
				featured = p2 == 1 and v45
			}, p1)
		end)
	end, {
		v44,
		v45
	})
	local v47 = useDispatch()
	local v48 = useNavigation()
	local u49 = nil

	if FFlagSduiEdpPrefetchPlayability and FFlagLuaAppSduiEdpEnabled then
		u49 = useRoactService(RoactNetworking)
	end

	local v50 = React.useCallback(function(p3, p4) -- line: 109
		-- upvalues: v47 (copy), OpenGameDetails (copy), v48 (copy), FFlagSduiEdpPrefetchPlayability (copy), FFlagLuaAppSduiEdpEnabled (copy), u49 (ref)
		v47(OpenGameDetails(p3, v48, p4, if not FFlagSduiEdpPrefetchPlayability or not FFlagLuaAppSduiEdpEnabled then nil else u49))
	end, {
		v48,
		if not FFlagSduiEdpPrefetchPlayability or not FFlagLuaAppSduiEdpEnabled then nil else u49
	})
	local v51 = t2.windowSize or Vector2.one
	local v52 = useTextSizeOffset()
	local source = t2.source
	local referralSource = t2.referralSource
	local hideGameStats = t2.hideGameStats
	local v56 = t2.useHoverTile == nil or t2.useHoverTile
	local reportGameDetailOpened = t2.reportGameDetailOpened
	local reportExperienceLaunched = t2.reportExperienceLaunched
	local v59 = t2.showFriendActivity or false
	local u60 = useResponsiveLayout("relativeHeight", v42)
	local v61 = FFlagLuaAppCompositionAlways or t2.appCompositionEnabled
	local v62 = useCollectionLayout(GameTile.getGameTileCollectionItemSize(t2.gameTileLayoutType or GameTileLayoutType.Narrow))
	local v63 = t2.enableCollectionLayout or v61
	local v64, v65 = React.useState(nil)
	local v66 = useGameCollectionLayoutParams(t2.gameTileLayoutType or GameTileLayoutType.Narrow, v64, false)
	local v67 = React.useRef(1)
	local v68 = useResponsiveLayout("columns", v42)
	local v69 = if not v61 then if not v63 then v68 else v66.numColumns else v62.itemsPerRow
	local v70 = useBreakpointXOrSmaller(Responsive.Keys.XSmall)

	React.useEffect(function() -- line: 156
		-- upvalues: v67 (copy), v69 (copy), t2 (copy)
		if v67.current ~= v69 then
			v67.current = v69

			if t2.onItemsPerRowChanged then
				t2.onItemsPerRowChanged(v69)
			end
		end
	end, {
		v69,
		v67,
		t2.onItemsPerRowChanged
	})

	local v71 = useDesignTokens()
	local v72 = GameTileConstants.TileTextLines[t2.gameTileLayoutType or GameTileLayoutType.Narrow]
	local v73 = GameTileViewConfig.getFooterHeight(v71, true, false, false, v52, nil, v72.titleTextLines, v43, true)

	if v37 and (u60 == nil or u60.Scale == nil) then
		DiscoveryEventErrorLogger.reportError("GameGridTable_NilRelativeHeight", "relativeHeight is nil", {
			rowKind = tostring(v42),
			relativeHeightType = typeof(u60),
			relativeHeightValue = tostring(u60),
			responsiveLayoutColumns = tostring(v68),
			useGridTiles = tostring(t2.useGridTiles or false),
			enableCollectionLayout = tostring(t2.enableCollectionLayout or false),
			gameTileLayoutType = tostring(t2.gameTileLayoutType or "nil")
		})
	else
		u60 = UDim.new(u60.Scale, v73)
	end

	local v74 = React.useCallback(function(t3: {[any]: any}, p5) -- line: 194
		-- upvalues: React (copy), AppFeaturedGameTileTwoByTwo (copy), source (copy), reportGameDetailOpened (copy), reportExperienceLaunched (copy), t2 (copy), AppGameTile (copy), hideGameStats (copy), referralSource (copy), v59 (copy), v56 (copy), v50 (copy), v52 (copy), v70 (copy), FFlagLuaAppGameTileLockedBadge (copy), getTileBadgeByPositionConfigFromEntry (copy)
		if t3.featured then
			return React.createElement(AppFeaturedGameTileTwoByTwo, {
				hasBackground = true,
				hasActionRow = true,
				isDynamic = true,
				entry = t3,
				index = t3.realGameEntryIndex or t3.index,
				source = source,
				reportGameDetailOpened = reportGameDetailOpened,
				reportExperienceLaunched = reportExperienceLaunched,
				impressionsTag = t2.impressionsTag,
				launchExperienceEventContext = t2.launchExperienceEventContext
			})
		end

		return React.createElement(AppGameTile, {
			isContained = true,
			entry = t3,
			index = t3.realGameEntryIndex or t3.index,
			source = source,
			reportGameDetailOpened = reportGameDetailOpened,
			reportExperienceLaunched = reportExperienceLaunched,
			hideGameStats = hideGameStats,
			referralSource = referralSource,
			rowNum = math.ceil(t3.index / (p5.columns or 1)),
			showFriendActivity = v59,
			playerCountStyle = t2.playerCountStyle,
			isSponsoredFooterAllowed = t2.isSponsoredFooterAllowed,
			useHoverTile = v56,
			useGridTile = t2.useGridTiles,
			friendFooterEnabled = not not t2.useGridTiles or nil,
			impressionsTag = t2.impressionsTag,
			launchExperienceEventContext = t2.launchExperienceEventContext,
			topicId = t2.topicId,
			gameTileLayoutType = t2.gameTileLayoutType,
			navigateToGameDetails = v50,
			playButtonStyle = t2.playButtonStyle,
			textSizeOffset = v52,
			isNarrowScreenXSmall = v70,
			badgeOverride = if not FFlagLuaAppGameTileLockedBadge then nil else getTileBadgeByPositionConfigFromEntry(t3)
		})
	end, {
		source,
		referralSource,
		hideGameStats,
		v59,
		reportGameDetailOpened,
		reportExperienceLaunched,
		t2.impressionsTag,
		t2.launchExperienceEventContext,
		t2.playerCountStyle,
		t2.useGridTiles,
		t2.isSponsoredFooterAllowed,
		t2.playButtonStyle,
		v70
	})
	local v75 = if not t2.screenSize then v51.Y else t2.screenSize.Y
	local v76 = useSelector(function(p6) -- line: 258
		if p6.ScreenSize then
			return p6.ScreenSize.X
		end

		return nil
	end)
	local v77 = useResponsiveLayout("verticalGutter", v42)
	local v78 = if not v61 then v77 else v62.verticalGap
	local v79 = if not v61 then v66.columnGap else v62.gutter
	local v80 = if not v61 then v66.sideMargin else 0
	local v81 = React.useMemo(function() -- line: 271
		-- upvalues: v63 (copy), v71 (copy), v69 (copy), v79 (copy), v80 (copy), v78 (copy), u60 (ref)
		if not v63 then
			return nil
		end

		local Layout = v71.LuaApps.Layout

		if not Layout then
			return nil
		end

		local grid = Layout.grid
		local tiles = Layout.tiles

		return {
			columns = v69,
			gutter = v79,
			margin = v80,
			verticalGutter = v78,
			relativeHeight = u60,
			hoverTileTopOffset = tiles.hover.topOffset,
			hoverTileBottomOffset = tiles.hover.bottomOffset,
			hoverTileHorizontalOffset = tiles.hover.horizontalOffset,
			scrollableMaxTilesPerRow = grid.default.scrollableMaxTilesPerRow
		}
	end, {
		v63,
		v71.LuaApps.Layout,
		v69,
		v79,
		v80,
		v78,
		u60
	})
	local v82 = React.createElement(ResponsiveGrid, {
		enableDeferredRefPropEvents = true,
		ref = v65,
		kind = v42,
		data = v46,
		renderItem = v74,
		layoutOrder = t2.LayoutOrder,
		getCellColspan = getCellSpan,
		getCellRowspan = getCellSpan,
		relativeHeight = u60,
		absoluteWindowTop = -v75,
		absoluteWindowHeight = v75 * 3
	})

	if v63 then
		v82 = React.createElement(ResponsiveLayoutProvider, {
			width = v76,
			config = v81
		}, {
			ResponsiveGrid = v82
		})
	end

	return v82
end

return GameGridTable
