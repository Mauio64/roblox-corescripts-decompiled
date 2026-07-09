local DiscoveryMonolith = script:FindFirstAncestor("DiscoveryMonolith")
local DiscoveryMonolithParent = DiscoveryMonolith.Parent
local UIBlox = require(DiscoveryMonolithParent.UIBlox)
local GridMetrics = UIBlox.App.Grid.GridMetrics
local useStyle = UIBlox.Core.Style.useStyle
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset
local getExperienceTileRelativeHeight = UIBlox.App.Tile.getExperienceTileRelativeHeight
local AspectRatioModeEnum = UIBlox.App.Tile.AspectRatioModeEnum
local Roact = require(DiscoveryMonolithParent.Roact)
local Cryo = require(DiscoveryMonolithParent.Cryo)
local GameTile = require(DiscoveryMonolithParent.GameTile)
local GameTileTypes = GameTile.GameTileTypes
local AppGameTile = GameTile.AppGameTile
local getTileBadgeByPositionConfigFromEntry = GameTile.getTileBadgeByPositionConfigFromEntry
local GameTileViewConfig = GameTile.GameTileViewConfig
local Symbol = require(DiscoveryMonolithParent.AppCommonLib).Symbol
local RoactRodux = require(DiscoveryMonolithParent.RoactRodux)
local FormFactor = require(DiscoveryMonolithParent.FormFactor).Enums.FormFactor
local OpenGameDetails = require(DiscoveryMonolithParent.GameDetail).OpenGameDetails
local withNavigation = require(DiscoveryMonolithParent.RoactNavigation).withNavigation
local useDesignTokens = require(DiscoveryMonolithParent.Style).useDesignTokens
local useTokens = require(DiscoveryMonolithParent.Foundation).Hooks.useTokens
local useUiModeInfo = require(DiscoveryMonolithParent.RobloxAppHooks).useUiModeInfo
local useRoactService = require(DiscoveryMonolithParent.RobloxAppHooks).useRoactService
local RoactNetworking = require(DiscoveryMonolithParent.RoactServiceTags).RoactNetworking
local UiMode = require(DiscoveryMonolithParent.RobloxAppEnums).UiMode
local DiscoveryTypes = require(DiscoveryMonolithParent.DiscoveryTypes)
local GameTileConstants = GameTile.GameTileConstants
local Responsive = require(DiscoveryMonolithParent.Responsive)
local useBreakpointXOrSmaller = Responsive.useBreakpointXOrSmaller
local useCollectionLayout = require(DiscoveryMonolithParent.CollectionViews).useCollectionLayout
local SharedFlags = require(DiscoveryMonolithParent.SharedFlags)
local FFlagRenameDeprecatedUIBloxTokens = SharedFlags.FFlagRenameDeprecatedUIBloxTokens
local FFlagLuaAppCompositionAlways = SharedFlags.FFlagLuaAppCompositionAlways
local FFlagLuaAppGameTileLockedBadge = SharedFlags.FFlagLuaAppGameTileLockedBadge
local FFlagSduiEdpPrefetchPlayability = SharedFlags.FFlagSduiEdpPrefetchPlayability
local FFlagLuaAppSduiEdpEnabled = SharedFlags.FFlagLuaAppSduiEdpEnabled
local Modules = DiscoveryMonolith.Modules
local AppFeaturedGameTileTwoByTwo = require(Modules.LuaApp.Components.Games.AppFeaturedGameTileTwoByTwo)
local GridView = require(Modules.LuaApp.Components.Generic.GridView)
local GetFFlagLuaAppUpdateGameSortGridRowHeight10ft = require(Modules.LuaApp.Flags.GetFFlagLuaAppUpdateGameSortGridRowHeight10ft)
local v42 = game:DefineFastFlag("LuaAppFixConsoleSeeAllGridContainment", false)
local v43 = Roact.PureComponent:extend("GameGrid")
local GAME_GRID_CHILD_PADDING = DiscoveryTypes.Constants.GAME_GRID_CHILD_PADDING
local GAME_GRID_TILE_FOOTER_HEIGHT = DiscoveryTypes.Constants.GAME_GRID_TILE_FOOTER_HEIGHT
local v46 = Symbol.named("TilePlaceHolder")
local Square = AspectRatioModeEnum.Square

v43.defaultProps = {
	friendFooterEnabled = false,
	useGridTiles = false,
	searchResultGrid = false,
	gameEmphasis = false,
	source = nil,
	showFriendActivity = false,
	getItemMetrics = GridMetrics.getSmallMetrics,
	horizontalAlignment = Enum.HorizontalAlignment.Center,
	gameTileLayoutType = GameTileTypes.GameTileLayoutType.Narrow
}

function v43.init(p1) -- line: 76
	-- upvalues: FFlagSduiEdpPrefetchPlayability (copy), FFlagLuaAppSduiEdpEnabled (copy), GameTileConstants (copy)
	function p1.navigateToGameDetails(p2, p3) -- line: 77
		-- upvalues: p1 (copy), FFlagSduiEdpPrefetchPlayability (copy), FFlagLuaAppSduiEdpEnabled (copy)
		p1.props.openGameDetails(p2, p3, p1.props.navigation, if not FFlagSduiEdpPrefetchPlayability or not FFlagLuaAppSduiEdpEnabled then nil else p1.props.networking)
	end

	p1.state = {
		numLinesForTitle = GameTileConstants.TileTextLines[p1.props.gameTileLayoutType].titleTextLines,
		numLinesForMetadata = if not p1.props.metadataCompact then GameTileConstants.TileTextLines[p1.props.gameTileLayoutType].metadataTextLines else GameTileConstants.TileTextLines[p1.props.gameTileLayoutType].largeMetadataTextLines
	}
end
function v43.didUpdate(p4, p5, _) -- line: 93
	-- upvalues: GameTileConstants (copy)
	if p5.metadataCompact ~= p4.props.metadataCompact then
		p4:setState({
			numLinesForMetadata = if not p4.props.metadataCompact then GameTileConstants.TileTextLines[p4.props.gameTileLayoutType].metadataTextLines else GameTileConstants.TileTextLines[p4.props.gameTileLayoutType].largeMetadataTextLines
		})
	end
end
function v43.renderItem(p7, p8, p9, p10, p11) -- line: 103
	-- upvalues: Roact (copy), AppFeaturedGameTileTwoByTwo (copy), v46 (copy), v42 (copy), UiMode (copy), AppGameTile (copy), FFlagLuaAppGameTileLockedBadge (copy), getTileBadgeByPositionConfigFromEntry (copy)
	local reportGameDetailOpened = p7.props.reportGameDetailOpened
	local reportExperienceLaunched = p7.props.reportExperienceLaunched
	local source = p7.props.source
	local hideGameStats = p7.props.hideGameStats

	if type(p8) == "table" and p8.featured then
		return Roact.createElement(AppFeaturedGameTileTwoByTwo, {
			layoutOrder = p10,
			entry = p8,
			size = p9,
			index = p8.realGameEntryIndex or p10,
			source = source,
			reportGameDetailOpened = reportGameDetailOpened,
			reportExperienceLaunched = reportExperienceLaunched,
			impressionsTag = p7.props.impressionsTag,
			launchExperienceEventContext = p7.props.launchExperienceEventContext
		})
	end

	if type(p8) == "userdata" and p8 == v46 then
		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = p10,
			Size = UDim2.new(0, p9.X, 0, p9.Y)
		})
	end

	local v64 = v42 and (p7.props.uiModeInfo and p7.props.uiModeInfo.uiMode == UiMode.TenFoot)

	return Roact.createElement(AppGameTile, {
		layoutOrder = p10,
		entry = p8,
		Size = UDim2.new(0, p9.X, 0, p9.Y),
		index = p8.realGameEntryIndex or p10,
		source = source,
		reportGameDetailOpened = reportGameDetailOpened,
		reportExperienceLaunched = reportExperienceLaunched,
		hideGameStats = hideGameStats,
		referralSource = p7.props.referralSource,
		rowNum = p11,
		showFriendActivity = p7.props.showFriendActivity,
		impressionsTag = p7.props.impressionsTag,
		friendFooterEnabled = if not p7.props.useGridTiles then nil else p7.props.friendFooterEnabled,
		useGridTile = p7.props.useGridTiles,
		launchExperienceEventContext = p7.props.launchExperienceEventContext,
		playerCountStyle = p7.props.playerCountStyle,
		isSponsoredFooterAllowed = p7.props.isSponsoredFooterAllowed,
		topicId = p7.props.topicId,
		gameTileLayoutType = p7.props.gameTileLayoutType,
		navigateToGameDetails = p7.navigateToGameDetails,
		playButtonStyle = p7.props.playButtonStyle,
		isContained = not not v64 or nil,
		textSizeOffset = p7.props.textSizeOffset,
		contentTextLineCount = p7.state.numLinesForTitle,
		metadataTextLineCount = p7.state.numLinesForMetadata,
		isNarrowScreenXSmall = p7.props.isNarrowScreenXSmall,
		badgeOverride = if not FFlagLuaAppGameTileLockedBadge then nil else getTileBadgeByPositionConfigFromEntry(p8)
	})
end
function v43.render(p12) -- line: 166
	-- upvalues: GridMetrics (copy), UiMode (copy), FFlagRenameDeprecatedUIBloxTokens (copy), FormFactor (copy), GameTileViewConfig (copy), GAME_GRID_TILE_FOOTER_HEIGHT (copy), GAME_GRID_CHILD_PADDING (copy), GetFFlagLuaAppUpdateGameSortGridRowHeight10ft (copy), getExperienceTileRelativeHeight (copy), Square (copy), v46 (copy), Cryo (copy), Roact (copy), GridView (copy)
	local entries = p12.props.entries
	local propsLayoutOrder = p12.props.LayoutOrder
	local numberOfRowsToShow = p12.props.numberOfRowsToShow
	local windowSize = p12.props.windowSize
	local screenSize = p12.props.screenSize
	local horizontalAlignment = p12.props.horizontalAlignment
	local searchResultGrid = p12.props.searchResultGrid
	local t1 = nil
	local v74 = searchResultGrid and GridMetrics.getMediumMetrics or p12.props.getItemMetrics
	local itemWidth, v80, vector2

	if p12.props.useGridTiles then
		local itemsPerRow, gutter, verticalGap

		if p12.props.appCompositionActive then
			local collectionLayout = p12.props.collectionLayout

			itemsPerRow = collectionLayout.itemsPerRow
			gutter = collectionLayout.gutter
			verticalGap = collectionLayout.verticalGap
		elseif p12.props.uiModeInfo.uiMode == UiMode.TenFoot then
			itemsPerRow = 5
			gutter = if not FFlagRenameDeprecatedUIBloxTokens then p12.props.designTokens.Global.Space_300 else p12.props.designTokens.Size.Size_600
			verticalGap = 51
		elseif p12.props.formFactor == FormFactor.WIDE then
			itemsPerRow = 4
			gutter = 8
			verticalGap = 28
		else
			itemsPerRow = 2
			gutter = 8
			verticalGap = 28
		end

		itemWidth = GridMetrics.getMetricsForFixedColumns(windowSize.X, gutter, itemsPerRow).itemWidth
		v80 = GameTileViewConfig.getTileHeight(p12.props.designTokens, itemWidth, p12.props.gameTileLayoutType, false, false, false, p12.props.textSizeOffset, nil, p12.state.numLinesForTitle, p12.state.numLinesForMetadata)
		vector2 = Vector2.new(gutter, verticalGap)
	else
		local v82 = GAME_GRID_TILE_FOOTER_HEIGHT

		vector2 = Vector2.new(GAME_GRID_CHILD_PADDING, GAME_GRID_CHILD_PADDING * 2)

		if p12.props.appCompositionActive then
			local collectionLayout = p12.props.collectionLayout

			vector2 = Vector2.new(collectionLayout.gutter, collectionLayout.verticalGap)
			itemWidth = GridMetrics.getMetricsForFixedColumns(windowSize.X, collectionLayout.gutter, collectionLayout.itemsPerRow).itemWidth
			v82 = GameTileViewConfig.getFooterHeight(p12.props.designTokens, false, false, false, p12.props.textSizeOffset, 0, p12.state.numLinesForTitle, p12.props.foundationTokens, true, p12.state.numLinesForMetadata)
		elseif p12.props.uiModeInfo.uiMode == UiMode.TenFoot then
			vector2 = Vector2.new(p12.props.cellSpacingHorizontal, p12.props.cellSpacingVertical)
			itemWidth = GridMetrics.getMetricsForFixedColumns(windowSize.X, vector2.X, 8).itemWidth
		else
			itemWidth = v74(windowSize.X, GAME_GRID_CHILD_PADDING).itemWidth
			v82 = GameTileViewConfig.getFooterHeight(p12.props.designTokens, false, false, false, p12.props.textSizeOffset, 0, p12.state.numLinesForTitle, p12.props.foundationTokens, true, p12.state.numLinesForMetadata)
		end

		if GetFFlagLuaAppUpdateGameSortGridRowHeight10ft() then
			v82 = getExperienceTileRelativeHeight(p12.props.style, Square, 2).Offset
		end

		v80 = math.floor(itemWidth + v82)
	end

	local vector2_2 = Vector2.new(itemWidth, v80)

	if searchResultGrid and #entries > 0 and p12.props.gameEmphasis then
		t1 = {}
		table.insert(t1, v46)
		table.insert(t1, v46)

		local v85 = math.floor((windowSize.X + vector2.X) / (vector2_2.X + vector2.X)) - 2
		local n1 = 2

		while n1 < v85 + 2 do
			if n1 <= #entries then
				table.insert(t1, Cryo.Dictionary.join(entries[n1], {
					realGameEntryIndex = n1
				}))
			else
				table.insert(t1, v46)
			end

			n1 += 1
		end

		table.insert(t1, Cryo.Dictionary.join(entries[1], {
			featured = true,
			realGameEntryIndex = 1
		}))
		table.insert(t1, v46)

		for i = n1, #entries do
			table.insert(t1, Cryo.Dictionary.join(entries[i], {
				realGameEntryIndex = i
			}))
		end
	end

	return Roact.createElement(GridView, {
		layoutOrder = propsLayoutOrder,
		items = t1 or entries,
		renderItem = function(...) -- line: 335
			-- upvalues: p12 (copy)
			return p12:renderItem(...)
		end,
		windowAbsoluteSize = windowSize,
		screenSize = screenSize,
		itemAbsoluteSize = vector2_2,
		cellPaddingOffset = vector2,
		numberOfRowsToShow = numberOfRowsToShow,
		horizontalAlignment = horizontalAlignment,
		onItemsPerRowChanged = p12.props.onItemsPerRowChanged
	})
end

local v48 = withNavigation((RoactRodux.connect(function(p13, _) -- line: 348
	return {
		formFactor = p13.FormFactor
	}
end, function(p15) -- line: 352
	-- upvalues: OpenGameDetails (copy), FFlagSduiEdpPrefetchPlayability (copy), FFlagLuaAppSduiEdpEnabled (copy)
	return {
		openGameDetails = function(p16, p17, p18, p19) -- line: 354
			-- upvalues: p15 (copy), OpenGameDetails (copy), FFlagSduiEdpPrefetchPlayability (copy), FFlagLuaAppSduiEdpEnabled (copy)
			p15(OpenGameDetails(p16, p18, p17, if not FFlagSduiEdpPrefetchPlayability or not FFlagLuaAppSduiEdpEnabled then nil else p19))
		end
	}
end)(v43)))

local function v49(p20) -- line: 370
	-- upvalues: useDesignTokens (copy), useTokens (copy), useUiModeInfo (copy), FFlagSduiEdpPrefetchPlayability (copy), FFlagLuaAppSduiEdpEnabled (copy), useRoactService (copy), RoactNetworking (copy), useTextSizeOffset (copy), useBreakpointXOrSmaller (copy), Responsive (copy), GameTileTypes (copy), FFlagLuaAppCompositionAlways (copy), useCollectionLayout (copy), GameTile (copy), Cryo (copy), FFlagRenameDeprecatedUIBloxTokens (copy), Roact (copy), v48 (copy)
	local v92 = useDesignTokens()
	local v93 = useTokens()
	local v94 = useUiModeInfo()
	local v95 = nil

	if FFlagSduiEdpPrefetchPlayability and FFlagLuaAppSduiEdpEnabled then
		v95 = useRoactService(RoactNetworking)
	end

	local v96 = useTextSizeOffset()
	local v97 = useBreakpointXOrSmaller(Responsive.Keys.Small)
	local v98 = if not p20.gameTileLayoutType then v97 and v96 > 0 else v97 and (p20.gameTileLayoutType == GameTileTypes.GameTileLayoutType.Narrow and v96 > 0)
	local v99 = useBreakpointXOrSmaller(Responsive.Keys.XSmall)
	local v100 = FFlagLuaAppCompositionAlways or p20.appCompositionEnabled
	local v101 = useCollectionLayout(GameTile.getGameTileCollectionItemSize(p20.gameTileLayoutType or GameTileTypes.GameTileLayoutType.Narrow))
	local v102 = Cryo.Dictionary.join(p20, {
		uiModeInfo = v94,
		networking = if not FFlagSduiEdpPrefetchPlayability or not FFlagLuaAppSduiEdpEnabled then nil else v95,
		cellSpacingHorizontal = if not FFlagRenameDeprecatedUIBloxTokens then v92.Global.Space_300 else v92.Size.Size_600,
		cellSpacingVertical = if not FFlagRenameDeprecatedUIBloxTokens then v92.Global.Space_400 else v92.Size.Size_800,
		designTokens = v92,
		textSizeOffset = v96,
		foundationTokens = v93,
		metadataCompact = v98,
		isNarrowScreenXSmall = v99,
		appCompositionActive = v100,
		collectionLayout = v101
	})

	return Roact.createElement(v48, v102)
end

if GetFFlagLuaAppUpdateGameSortGridRowHeight10ft() then
	local v50 = v49

	function v49(p21) -- line: 418
		-- upvalues: useStyle (copy), useTextSizeOffset (copy), Cryo (copy), Roact (copy), v50 (copy)
		local v104 = useStyle()
		local v105 = useTextSizeOffset()
		local v106 = Cryo.Dictionary.join(p21, {
			style = v104,
			textSizeOffset = v105
		})

		return Roact.createElement(v50, v106)
	end
end

return v49
