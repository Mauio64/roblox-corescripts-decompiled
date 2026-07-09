local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local UIBlox = require(CorePackages.Packages.UIBlox)
local Roact = require(CorePackages.Packages.Roact)
local Cryo = require(CorePackages.Packages.Cryo)
local t = require(CorePackages.Packages.t)
local Constants = require(Modules.LuaApp.Constants)
local GridView = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules.LuaApp.Components.Generic.GridView
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local GridMetrics = UIBlox.App.Grid.GridMetrics
local UiMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).UiMode
local useUiModeInfo = require(CorePackages.Workspace.Packages.RobloxAppHooks).useUiModeInfo
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset
local DiscoveryTypes = require(CorePackages.Workspace.Packages.DiscoveryTypes)
local Container = require(Modules.LuaApp.Components.UserSearch.UserSearchTileUniversalWrapper.Container)
local getTileRowInSort = require(Modules.LuaApp.Components.UserSearch.api).Analytics.getTileRowInSort
local calculateRowPositionFields = require(CorePackages.Workspace.Packages.UnifiedLogging).calculateRowPositionFields
local FFlagLuaAppSearchPeopleUnifiedSchemaFields = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppSearchPeopleUnifiedSchemaFields
local PLAYER_GRID_TILE_FOOTER_HEIGHT = Constants.PLAYER_GRID_TILE_FOOTER_HEIGHT
local v20 = Roact.PureComponent:extend("PlayerGrid")

v20.validateProps = t.strictInterface({
	entries = t.table,
	LayoutOrder = t.optional(t.integer),
	numberOfRowsToShow = t.optional(t.integer),
	windowSize = t.Vector2,
	horizontalAlignment = t.optional(t.enum(Enum.HorizontalAlignment)),
	searchParameters = t.table,
	impressionsTag = t.string,
	mappedProfilesInsights = t.optional(t.table),
	uiModeInfo = t.table,
	cellSpacingHorizontal = t.number,
	cellSpacingVertical = t.number,
	tileHeightOffset = t.number,
	Analytics = t.any,
	shouldUseCompactTiles = t.optional(t.boolean),
	subpage = t.optional(t.string),
	onItemsPerRowChanged = t.optional(t.any),
	startRowNumber = t.optional(t.number),
	itemsPerRow = t.optional(t.number),
	textSizeOffset = t.number,
	enablePresenceIndicator = t.optional(t.boolean),
	enableOnlineFrequents = t.optional(t.boolean)
})
v20.defaultProps = {
	horizontalAlignment = Enum.HorizontalAlignment.Center,
	mappedProfilesInsights = {}
}

function v20.renderItem(p1, p2, p3, p4) -- line: 68
	-- upvalues: FFlagLuaAppSearchPeopleUnifiedSchemaFields (copy), calculateRowPositionFields (copy), Roact (copy), Container (copy), getTileRowInSort (copy)
	local v26 = nil

	if FFlagLuaAppSearchPeopleUnifiedSchemaFields then
		v26 = calculateRowPositionFields(p4, p1.props.itemsPerRow, p1.props.startRowNumber)
	end

	return Roact.createElement(Container, {
		index = p4,
		user = p2,
		size = UDim2.new(0, p3.X, 0, p3.Y),
		searchParameters = p1.props.searchParameters,
		hasEmphasis = p2.featured or false,
		impressionsTag = p1.props.impressionsTag,
		profileInsight = p1.props.mappedProfilesInsights[p2.id],
		Analytics = p1.props.Analytics,
		shouldUseCompactTiles = p1.props.shouldUseCompactTiles,
		enablePresenceIndicator = p1.props.enablePresenceIndicator,
		subpage = p1.props.subpage,
		rowInSort = if not FFlagLuaAppSearchPeopleUnifiedSchemaFields then getTileRowInSort(p4, p1.props.startRowNumber, p1.props.itemsPerRow) else v26.rowInSort,
		positionInRow = if not FFlagLuaAppSearchPeopleUnifiedSchemaFields then nil else v26.positionInRow,
		feedRowNumber = if not FFlagLuaAppSearchPeopleUnifiedSchemaFields then nil else v26.rowOnPage
	})
end
function v20.getCardWidthForCompactTiles(p5, p6) -- line: 94
	-- upvalues: GridMetrics (copy)
	local windowSize = p5.props.windowSize
	local v30 = GridMetrics.getSmallMetrics(windowSize.X, p6)

	if windowSize.X < windowSize.Y then
		return v30.itemWidth
	end

	local v31 = v30.itemsPerRow + 1

	return (math.floor((windowSize.X - (v31 - 1) * p6) / v31))
end
function v20.render(p7) -- line: 107
	-- upvalues: DiscoveryTypes (copy), GridMetrics (copy), PLAYER_GRID_TILE_FOOTER_HEIGHT (copy), Cryo (copy), UiMode (copy), Roact (copy), GridView (copy)
	local entries = p7.props.entries
	local propsLayoutOrder = p7.props.LayoutOrder
	local numberOfRowsToShow = p7.props.numberOfRowsToShow
	local windowSize = p7.props.windowSize
	local horizontalAlignment = p7.props.horizontalAlignment
	local t1 = nil
	local cellSpacingHorizontal, vector2, v41, n1

	if p7.props.shouldUseCompactTiles then
		cellSpacingHorizontal = p7.props.cellSpacingHorizontal
		vector2 = Vector2.new(cellSpacingHorizontal, p7.props.cellSpacingVertical)
		v41 = p7:getCardWidthForCompactTiles(cellSpacingHorizontal)
		n1 = 60
	else
		cellSpacingHorizontal = DiscoveryTypes.Constants.GAME_GRID_CHILD_PADDING
		vector2 = Vector2.new(cellSpacingHorizontal, cellSpacingHorizontal * 2)
		v41 = GridMetrics.getMediumMetrics(windowSize.X, cellSpacingHorizontal).itemWidth
		n1 = PLAYER_GRID_TILE_FOOTER_HEIGHT
	end

	local v43 = math.floor(v41 + n1)
	local vector2_2 = Vector2.new(v41, v43)

	if not p7.props.shouldUseCompactTiles and #entries == 1 then
		t1 = { Cryo.Dictionary.join(entries[1], {
			featured = true
		}) }

		local itemWidth = GridMetrics.getLargeMetrics(windowSize.X, cellSpacingHorizontal).itemWidth

		vector2_2 = Vector2.new(itemWidth, itemWidth + PLAYER_GRID_TILE_FOOTER_HEIGHT)
	end

	if p7.props.uiModeInfo.uiMode == UiMode.TenFoot then
		local itemWidth = GridMetrics.getMetricsForFixedColumns(windowSize.X, p7.props.cellSpacingHorizontal, 6).itemWidth
		local v47 = math.floor(itemWidth + p7.props.tileHeightOffset)

		vector2_2 = Vector2.new(itemWidth, v47)
		vector2 = Vector2.new(p7.props.cellSpacingHorizontal, p7.props.cellSpacingVertical)
	end

	local vector2_3 = Vector2.new(vector2_2.X, vector2_2.Y + p7.props.textSizeOffset * 3)

	return Roact.createElement(GridView, {
		layoutOrder = propsLayoutOrder,
		items = t1 or entries,
		renderItem = function(...) -- line: 165
			-- upvalues: p7 (copy)
			return p7:renderItem(...)
		end,
		windowAbsoluteSize = windowSize,
		itemAbsoluteSize = vector2_3,
		cellPaddingOffset = vector2,
		numberOfRowsToShow = numberOfRowsToShow,
		horizontalAlignment = horizontalAlignment,
		onItemsPerRowChanged = p7.props.onItemsPerRowChanged
	})
end

local v21 = v20

return function(p8) -- line: 178
	-- upvalues: useDesignTokens (copy), useUiModeInfo (copy), useTextSizeOffset (copy), Cryo (copy), Roact (copy), v21 (copy)
	local v50 = useDesignTokens()
	local v51 = useUiModeInfo()
	local v52 = useTextSizeOffset()
	local v53 = Cryo.Dictionary.join(p8, {
		uiModeInfo = v51,
		cellSpacingHorizontal = v50.Size.Size_600,
		cellSpacingVertical = if not p8.shouldUseCompactTiles then v50.Size.Size_800 else v50.Size.Size_400,
		tileHeightOffset = v50.Size.Size_1600,
		textSizeOffset = v52
	})

	return Roact.createElement(v21, v53)
end
