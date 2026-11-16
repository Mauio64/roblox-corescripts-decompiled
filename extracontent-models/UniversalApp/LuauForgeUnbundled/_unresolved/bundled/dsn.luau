local module = require("@luauforge/bundled/drd")
local gridMetrics = module.App.Grid.GridMetrics
local useStyle = module.Core.Style.useStyle
local useTextSizeOffset = module.Core.Style.useTextSizeOffset
local getExperienceTileRelativeHeight = module.App.Tile.getExperienceTileRelativeHeight
local aspectRatioModeEnum = module.App.Tile.AspectRatioModeEnum
local module2 = require("@luauforge/bundled/drf")
local module3 = require("@luauforge/bundled/dqd")
local module4 = require("@luauforge/bundled/drl")
local gameTileTypes = module4.GameTileTypes
local appGameTile = module4.AppGameTile
local getTileBadgeByPositionConfigFromEntry = module4.getTileBadgeByPositionConfigFromEntry
local gameTileViewConfig = module4.GameTileViewConfig
local symbol = require("@luauforge/bundled/dqY").Symbol
local module5 = require("@luauforge/bundled/drg")
local formFactor = require("@luauforge/bundled/dso").Enums.FormFactor
local openGameDetails = require("@luauforge/bundled/dsc").OpenGameDetails
local withNavigation = require("@luauforge/bundled/drZ").withNavigation
local useDesignTokens = require("@luauforge/bundled/dsj").useDesignTokens
local useTokens = require("@luauforge/bundled/dsg").Hooks.useTokens
local useUiModeInfo = require("@luauforge/bundled/dsp").useUiModeInfo
local useRoactService = require("@luauforge/bundled/dsp").useRoactService
local roactNetworking = require("@luauforge/bundled/drk").RoactNetworking
local uiMode = require("@luauforge/bundled/drn").UiMode
local module6 = require("@luauforge/bundled/dqn")
local gameTileConstants = module4.GameTileConstants
local module7 = require("@luauforge/bundled/dsq")
local useBreakpointXOrSmaller = module7.useBreakpointXOrSmaller
local useCollectionLayout = require("@luauforge/bundled/dsr").useCollectionLayout

local module8 = require("@luauforge/bundled/dqB")

local fFlagLuaAppCompositionAlways = module8.FFlagLuaAppCompositionAlways
local fFlagLuaAppSduiEdpEnabled = module8.FFlagLuaAppSduiEdpEnabled

local module9 = require("@luauforge/bundled/drX")
local module10 = require("@luauforge/bundled/dss")

local module11 = require("@luauforge/bundled/dst")

local defineFastFlag = game:DefineFastFlag("LuaAppFixConsoleSeeAllGridContainment", false)

local extended = module2.PureComponent:extend("GameGrid")

local GAME_GRID_CHILD_PADDING = module6.Constants.GAME_GRID_CHILD_PADDING
local GAME_GRID_TILE_FOOTER_HEIGHT = module6.Constants.GAME_GRID_TILE_FOOTER_HEIGHT

local named = symbol.named("TilePlaceHolder")

local square = aspectRatioModeEnum.Square

extended.defaultProps = {
	friendFooterEnabled = false,
	useGridTiles = false,
	getItemMetrics = gridMetrics.getSmallMetrics,
	horizontalAlignment = Enum.HorizontalAlignment.Center,
	searchResultGrid = false,
	gameEmphasis = false,
	source = nil,
	showFriendActivity = false,
	gameTileLayoutType = gameTileTypes.GameTileLayoutType.Narrow
}

function extended:init()
	function self.navigateToGameDetails(p3, p4)
		local openGameDetails2 = self.props.openGameDetails

		local navigation = self.props.navigation
		local v5 = if fFlagLuaAppSduiEdpEnabled then self.props.networking else nil
		openGameDetails2(p3, p4, navigation, v5)
	end
	local v5 = {
		numLinesForTitle = gameTileConstants.TileTextLines[self.props.gameTileLayoutType].titleTextLines,
		numLinesForMetadata = 0
	}
	local v6 = if self.props.metadataCompact then gameTileConstants.TileTextLines[self.props.gameTileLayoutType].largeMetadataTextLines else gameTileConstants.TileTextLines[self.props.gameTileLayoutType].metadataTextLines
	v5.numLinesForMetadata = v6
	self.state = v5
end

function extended.didUpdate(object, p2, p3)
	if p2.metadataCompact ~= object.props.metadataCompact then
		local v6 = if object.props.metadataCompact then gameTileConstants.TileTextLines[object.props.gameTileLayoutType].largeMetadataTextLines else gameTileConstants.TileTextLines[object.props.gameTileLayoutType].metadataTextLines
		object:setState({ numLinesForMetadata = v6 })
	end
end

function extended.renderItem(props, value, p2, p3, p4)
	local reportGameDetailOpened = props.props.reportGameDetailOpened
	local reportExperienceLaunched = props.props.reportExperienceLaunched
	local source = props.props.source
	local hideGameStats = props.props.hideGameStats

	if type(value) == "table" and value.featured then
		return module2.createElement(module9, {
			layoutOrder = p3,
			entry = value,
			size = p2,
			index = value.realGameEntryIndex or p3,
			source = source,
			reportGameDetailOpened = reportGameDetailOpened,
			reportExperienceLaunched = reportExperienceLaunched,
			impressionsTag = props.props.impressionsTag,
			launchExperienceEventContext = props.props.launchExperienceEventContext
		})
	end

	if type(value) == "userdata" and value == named then
		return module2.createElement("Frame", {
			LayoutOrder = p3,
			Size = UDim2.new(0, p2.X, 0, p2.Y),
			BackgroundTransparency = 1
		})
	end

	local v5 = defineFastFlag and props.props.uiModeInfo and props.props.uiModeInfo.uiMode == uiMode.TenFoot

	local createElement = module2.createElement
	local v7 = {
		layoutOrder = p3,
		entry = value,
		Size = UDim2.new(0, p2.X, 0, p2.Y),
		index = value.realGameEntryIndex or p3,
		source = source,
		reportGameDetailOpened = reportGameDetailOpened,
		reportExperienceLaunched = reportExperienceLaunched,
		hideGameStats = hideGameStats,
		referralSource = props.props.referralSource,
		rowNum = p4,
		showFriendActivity = props.props.showFriendActivity,
		impressionsTag = props.props.impressionsTag,
		friendFooterEnabled = 0,
		useGridTile = 0,
		launchExperienceEventContext = 0,
		playerCountStyle = 0,
		isSponsoredFooterAllowed = 0,
		topicId = 0,
		gameTileLayoutType = 0,
		navigateToGameDetails = 0,
		playButtonStyle = 0,
		isContained = 0,
		textSizeOffset = 0,
		contentTextLineCount = 0,
		metadataTextLineCount = 0,
		isNarrowScreenXSmall = 0,
		badgeOverride = 0
	}
	local v8 = if props.props.useGridTiles then props.props.friendFooterEnabled else nil
	v7.friendFooterEnabled = v8
	v7.useGridTile = props.props.useGridTiles
	v7.launchExperienceEventContext = props.props.launchExperienceEventContext
	v7.playerCountStyle = props.props.playerCountStyle
	v7.isSponsoredFooterAllowed = props.props.isSponsoredFooterAllowed
	v7.topicId = props.props.topicId
	v7.gameTileLayoutType = props.props.gameTileLayoutType
	v7.navigateToGameDetails = props.navigateToGameDetails
	v7.playButtonStyle = props.props.playButtonStyle
	v7.isContained = v5 and true or nil
	v7.textSizeOffset = props.props.textSizeOffset
	v7.contentTextLineCount = props.state.numLinesForTitle
	v7.metadataTextLineCount = props.state.numLinesForMetadata
	v7.isNarrowScreenXSmall = props.props.isNarrowScreenXSmall
	v7.badgeOverride = getTileBadgeByPositionConfigFromEntry(value)
	return createElement(appGameTile, v7)
end

function extended:render()
	local entries = self.props.entries
	local layoutOrder = self.props.LayoutOrder
	local numberOfRowsToShow = self.props.numberOfRowsToShow
	local windowSize = self.props.windowSize
	local screenSize = self.props.screenSize
	local horizontalAlignment = self.props.horizontalAlignment
	local searchResultGrid = self.props.searchResultGrid

	local values = nil

	local getMediumMetrics = searchResultGrid and gridMetrics.getMediumMetrics or self.props.getItemMetrics
	local itemWidth, v5, vector2

	if self.props.useGridTiles then
		local v6, v7, v8

		if self.props.appCompositionActive then
			local collectionLayout = self.props.collectionLayout
			v6 = collectionLayout.itemsPerRow
			v7 = collectionLayout.gutter
			v8 = collectionLayout.verticalGap
		elseif self.props.uiModeInfo.uiMode == uiMode.TenFoot then
			v7 = self.props.designTokens.Size.Size_600
			v6 = 5
			v8 = 51
		else
			if self.props.formFactor == formFactor.WIDE then
				v7 = 8
				v6 = 4
			else
				v7 = 8
				v6 = 2
			end

			v8 = 28
		end

		itemWidth = gridMetrics.getMetricsForFixedColumns(windowSize.X, v7, v6).itemWidth
		v5 = gameTileViewConfig.getTileHeight(
			self.props.designTokens,
			itemWidth,
			self.props.gameTileLayoutType,
			false,
			false,
			false,
			self.props.textSizeOffset,
			nil,
			self.state.numLinesForTitle,
			self.state.numLinesForMetadata
		)

		vector2 = Vector2.new(v7, v8)
	else
		local v6 = GAME_GRID_TILE_FOOTER_HEIGHT
		vector2 = Vector2.new(GAME_GRID_CHILD_PADDING, GAME_GRID_CHILD_PADDING * 2)

		if self.props.appCompositionActive then
			local collectionLayout = self.props.collectionLayout
			vector2 = Vector2.new(collectionLayout.gutter, collectionLayout.verticalGap)
			itemWidth = gridMetrics.getMetricsForFixedColumns(
				windowSize.X,
				collectionLayout.gutter,
				collectionLayout.itemsPerRow
			).itemWidth
			v6 = gameTileViewConfig.getFooterHeight(
				self.props.designTokens,
				false,
				false,
				false,
				self.props.textSizeOffset,
				0,
				self.state.numLinesForTitle,
				self.props.foundationTokens,
				true,
				self.state.numLinesForMetadata
			)
		elseif self.props.uiModeInfo.uiMode == uiMode.TenFoot then
			vector2 = Vector2.new(self.props.cellSpacingHorizontal, self.props.cellSpacingVertical)
			itemWidth = gridMetrics.getMetricsForFixedColumns(windowSize.X, vector2.X, 8).itemWidth
		else
			itemWidth = getMediumMetrics(windowSize.X, GAME_GRID_CHILD_PADDING).itemWidth

			v6 = gameTileViewConfig.getFooterHeight(
				self.props.designTokens,
				false,
				false,
				false,
				self.props.textSizeOffset,
				0,
				self.state.numLinesForTitle,
				self.props.foundationTokens,
				true,
				self.state.numLinesForMetadata
			)
		end

		if module11() then
			v6 = getExperienceTileRelativeHeight(self.props.style, square, 2).Offset
		end

		v5 = math.floor(itemWidth + v6)
	end

	local vector2_2 = Vector2.new(itemWidth, v5)

	if searchResultGrid and #entries > 0 and self.props.gameEmphasis then
		values = {}

		table.insert(values, named)

		table.insert(values, named)

		local v6 = math.floor((windowSize.X + vector2.X) / (vector2_2.X + vector2.X)) - 2
		local v7 = 2

		while v7 < v6 + 2 do
			if v7 <= #entries then
				table.insert(values, module3.Dictionary.join(entries[v7], {
					realGameEntryIndex = v7
				}))
			else
				table.insert(values, named)
			end

			v7 += 1
		end

		table.insert(
			values,
			module3.Dictionary.join(entries[1], {
				featured = true,
				realGameEntryIndex = 1
			})
		)

		table.insert(values, named)

		for i = v7, #entries do
			table.insert(values, module3.Dictionary.join(entries[i], {
				realGameEntryIndex = i
			}))
		end
	end

	return module2.createElement(module10, {
		layoutOrder = layoutOrder,
		items = values or entries,
		renderItem = function(...)
			return self:renderItem(...)
		end,
		windowAbsoluteSize = windowSize,
		screenSize = screenSize,
		itemAbsoluteSize = vector2_2,
		cellPaddingOffset = vector2,
		numberOfRowsToShow = numberOfRowsToShow,
		horizontalAlignment = horizontalAlignment,
		onItemsPerRowChanged = self.props.onItemsPerRowChanged
	})
end

local v5 = withNavigation((module5.connect(function(p2, p3)
	return { formFactor = p2.FormFactor }
end, function(p2)
	return {
		openGameDetails = function(p3, p4, p5, p6)
			if not fFlagLuaAppSduiEdpEnabled then
				p6 = nil
			end

			p2(openGameDetails(p3, p5, p4, p6))
		end
	}
end)(extended)))

local function fn(p2)
	local v6 = useDesignTokens()
	local v7 = useTokens()
	local v8 = useUiModeInfo()

	local v9 = if fFlagLuaAppSduiEdpEnabled then useRoactService(roactNetworking) else nil

	local v10 = useTextSizeOffset()
	local v11 = useBreakpointXOrSmaller(module7.Keys.Small)

	if p2.gameTileLayoutType then
		if v11 then
			v11 = p2.gameTileLayoutType == gameTileTypes.GameTileLayoutType.Narrow and v10 > 0
		end
	else
		v11 = v11 and v10 > 0
	end

	local v12 = useBreakpointXOrSmaller(module7.Keys.XSmall)

	local v13 = fFlagLuaAppCompositionAlways or p2.appCompositionEnabled
	local v14 = useCollectionLayout(module4.getGameTileCollectionItemSize(p2.gameTileLayoutType or gameTileTypes.GameTileLayoutType.Narrow))

	local join = module3.Dictionary.join

	if not fFlagLuaAppSduiEdpEnabled then
		v9 = nil
	end

	local v16 = join(p2, {
		uiModeInfo = v8,
		networking = v9,
		cellSpacingHorizontal = v6.Size.Size_600,
		cellSpacingVertical = v6.Size.Size_800,
		designTokens = v6,
		textSizeOffset = v10,
		foundationTokens = v7,
		metadataCompact = v11,
		isNarrowScreenXSmall = v12,
		appCompositionActive = v13,
		collectionLayout = v14
	})

	return module2.createElement(v5, v16)
end

return module11() and function(p2)
	local v6 = useStyle()
	local v7 = useTextSizeOffset()
	local joined = module3.Dictionary.join(p2, { style = v6, textSizeOffset = v7 })

	return module2.createElement(fn, joined)
end or fn
