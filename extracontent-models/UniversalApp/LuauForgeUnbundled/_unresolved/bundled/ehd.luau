local CorePackages = game:GetService("CorePackages")

local UIBlox = require(CorePackages.Packages.UIBlox)

local Roact = require(CorePackages.Packages.Roact)
local Cryo = require(CorePackages.Packages.Cryo)
local t = require(CorePackages.Packages.t)

local module = require("@luauforge/bundled/dzD")

local gridView = require("@luauforge/bundled/dtb").Modules.LuaApp.Components.Generic.GridView

local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local gridMetrics = UIBlox.App.Grid.GridMetrics
local uiMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").UiMode
local useUiModeInfo = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useUiModeInfo
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset

local module2 = require("@luauforge/bundled/cBc")

local module3 = require("@luauforge/bundled/ehg")
local useCollectionLayout = module3.useCollectionLayout
local collectionItemSize = module3.CollectionItemSize

local module4 = require("@luauforge/bundled/ehh")
local getTileRowInSort = require("@luauforge/bundled/ehc").Analytics.getTileRowInSort
local calculateRowPositionFields = require("@luauforge/bundled/ehE").calculateRowPositionFields

local fFlagLuaAppSearchPeopleUnifiedSchemaFields = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppSearchPeopleUnifiedSchemaFields
local fFlagLuaAppCompositionAlways = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppCompositionAlways

local fFlagLuaAppCompositionPlayerGrid = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppCompositionPlayerGrid

local PLAYER_GRID_TILE_FOOTER_HEIGHT = module.PLAYER_GRID_TILE_FOOTER_HEIGHT

local extended = Roact.PureComponent:extend("PlayerGrid")

local strictInterface = t.strictInterface
local v5 = {
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
	enableOnlineFrequents = t.optional(t.boolean),
	appCompositionEnabled = 0,
	appCompositionActive = 0,
	collectionLayout = 0
}
local v6 = if fFlagLuaAppCompositionPlayerGrid then t.optional(t.boolean) else nil
v5.appCompositionEnabled = v6
local v7 = if fFlagLuaAppCompositionPlayerGrid then t.optional(t.boolean) else nil
v5.appCompositionActive = v7
local v8 = if fFlagLuaAppCompositionPlayerGrid then t.table else nil
v5.collectionLayout = v8
extended.validateProps = strictInterface(v5)

extended.defaultProps = {
	horizontalAlignment = Enum.HorizontalAlignment.Center,
	mappedProfilesInsights = {}
}

function extended.renderItem(p2, p3, p4, p5)
	local v9

	if fFlagLuaAppSearchPeopleUnifiedSchemaFields then
		v9 = calculateRowPositionFields(p5, p2.props.itemsPerRow, p2.props.startRowNumber)
	end

	local createElement = Roact.createElement
	local v11 = {
		index = p5,
		user = p3,
		size = UDim2.new(0, p4.X, 0, p4.Y),
		searchParameters = p2.props.searchParameters,
		hasEmphasis = p3.featured or false,
		impressionsTag = p2.props.impressionsTag,
		profileInsight = p2.props.mappedProfilesInsights[p3.id],
		Analytics = p2.props.Analytics,
		shouldUseCompactTiles = p2.props.shouldUseCompactTiles,
		enablePresenceIndicator = p2.props.enablePresenceIndicator,
		subpage = p2.props.subpage,
		rowInSort = 0,
		positionInRow = 0,
		feedRowNumber = 0
	}

	local v12 = if fFlagLuaAppSearchPeopleUnifiedSchemaFields then v9.rowInSort else getTileRowInSort(
		p5,
		p2.props.startRowNumber,
		p2.props.itemsPerRow
	)
	v11.rowInSort = v12

	local v13 = if fFlagLuaAppSearchPeopleUnifiedSchemaFields then v9.positionInRow else nil
	v11.positionInRow = v13
	local v14 = if fFlagLuaAppSearchPeopleUnifiedSchemaFields then v9.rowOnPage else nil
	v11.feedRowNumber = v14
	return createElement(module4, v11)
end

function extended:getCardWidthForCompactTiles(p3)
	local windowSize = self.props.windowSize
	local smallMetrics = gridMetrics.getSmallMetrics(windowSize.X, p3)

	if windowSize.X < windowSize.Y then
		return smallMetrics.itemWidth
	end

	local v9 = smallMetrics.itemsPerRow + 1
	return (math.floor((windowSize.X - (v9 - 1) * p3) / v9))
end

function extended:render()
	local entries = self.props.entries
	local layoutOrder = self.props.LayoutOrder
	local numberOfRowsToShow = self.props.numberOfRowsToShow
	local windowSize = self.props.windowSize
	local horizontalAlignment = self.props.horizontalAlignment

	local v9 = nil
	local v10, vector2, v11, v12

	if fFlagLuaAppCompositionPlayerGrid and self.props.appCompositionActive then
		local collectionLayout = self.props.collectionLayout
		v10 = collectionLayout.gutter
		vector2 = Vector2.new(collectionLayout.gutter, collectionLayout.verticalGap)
		v11 = gridMetrics.getMetricsForFixedColumns(
			windowSize.X,
			collectionLayout.gutter,
			collectionLayout.itemsPerRow
		).itemWidth
		v12 = if self.props.shouldUseCompactTiles then 60 else PLAYER_GRID_TILE_FOOTER_HEIGHT
	elseif self.props.shouldUseCompactTiles then
		v10 = self.props.cellSpacingHorizontal
		vector2 = Vector2.new(v10, self.props.cellSpacingVertical)
		v11 = self:getCardWidthForCompactTiles(v10)
		v12 = 60
	else
		v10 = module2.Constants.GAME_GRID_CHILD_PADDING
		vector2 = Vector2.new(v10, v10 * 2)
		v11 = gridMetrics.getMediumMetrics(windowSize.X, v10).itemWidth
		v12 = PLAYER_GRID_TILE_FOOTER_HEIGHT
	end

	local v13 = math.floor(v11 + v12)
	local vector2_2 = Vector2.new(v11, v13)

	if not self.props.shouldUseCompactTiles and #entries == 1 then
		v9 = { Cryo.Dictionary.join(entries[1], { featured = true }) }

		local itemWidth = gridMetrics.getLargeMetrics(windowSize.X, v10).itemWidth
		vector2_2 = Vector2.new(itemWidth, itemWidth + PLAYER_GRID_TILE_FOOTER_HEIGHT)
	end

	if self.props.uiModeInfo.uiMode == uiMode.TenFoot then
		if not (fFlagLuaAppCompositionPlayerGrid and self.props.appCompositionActive) then
			v11 = gridMetrics.getMetricsForFixedColumns(windowSize.X, self.props.cellSpacingHorizontal, 6).itemWidth

			vector2 = Vector2.new(self.props.cellSpacingHorizontal, self.props.cellSpacingVertical)
		end

		local v14 = math.floor(v11 + self.props.tileHeightOffset)
		vector2_2 = Vector2.new(v11, v14)
	end

	local vector2_3 = Vector2.new(vector2_2.X, vector2_2.Y + self.props.textSizeOffset * 3)

	return Roact.createElement(gridView, {
		layoutOrder = layoutOrder,
		items = v9 or entries,
		renderItem = function(...)
			return self:renderItem(...)
		end,
		windowAbsoluteSize = windowSize,
		itemAbsoluteSize = vector2_3,
		cellPaddingOffset = vector2,
		numberOfRowsToShow = numberOfRowsToShow,
		horizontalAlignment = horizontalAlignment,
		onItemsPerRowChanged = self.props.onItemsPerRowChanged
	})
end

return function(p2)
	local v9 = useDesignTokens()
	local v10 = useUiModeInfo()
	local v11 = useTextSizeOffset()
	local v12

	if fFlagLuaAppCompositionPlayerGrid then
		v12 = useCollectionLayout(collectionItemSize.Small)
	end

	local join = Cryo.Dictionary.join
	local v13 = {
		uiModeInfo = v10,
		cellSpacingHorizontal = v9.Size.Size_600,
		cellSpacingVertical = 0,
		tileHeightOffset = 0,
		textSizeOffset = 0,
		appCompositionActive = 0,
		collectionLayout = 0
	}
	local v14 = if p2.shouldUseCompactTiles then v9.Size.Size_400 else v9.Size.Size_800
	v13.cellSpacingVertical = v14

	v13.tileHeightOffset = v9.Size.Size_1600
	v13.textSizeOffset = v11

	local v15 = if fFlagLuaAppCompositionPlayerGrid then fFlagLuaAppCompositionAlways or p2.appCompositionEnabled else nil
	v13.appCompositionActive = v15

	if not fFlagLuaAppCompositionPlayerGrid then
		v12 = nil
	end

	v13.collectionLayout = v12
	local v16 = join(p2, v13)

	return Roact.createElement(extended, v16)
end
