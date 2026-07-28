local Parent = script:FindFirstAncestor("GameCollections").Parent
local CollectionViews = require(Parent.CollectionViews)
local GameTileViewConfig = require(Parent.GameTile).GameTileViewConfig
local CollectionLayoutCalculators = CollectionViews.CollectionLayoutCalculators

require(Parent.Style)

return {
	calculateNumColumns = CollectionLayoutCalculators.calculateNumColumns,
	calculateTileHeightFromWidth = function(n1: number, _: boolean?, p1, p2, b2: boolean?, b3: boolean?, b4: boolean?, n2: number?, n3: number?, n4: number?, n5: number?) -- line: 15
		-- upvalues: GameTileViewConfig (copy)
		return GameTileViewConfig.getTileHeight(p2, n1, p1, b2, b3, b4, n2, n3, n4, n5)
	end,
	calculateSideMargin = CollectionLayoutCalculators.calculateSideMargin,
	calculateColumnGap = CollectionLayoutCalculators.calculateColumnGap,
	calculateVerticalPadding = CollectionLayoutCalculators.calculateVerticalPadding,
	calculateFractionalItemAmount = CollectionLayoutCalculators.calculateFractionalItemAmount,
	calculateMaxTilesToShow = CollectionLayoutCalculators.calculateMaxTilesToShow,
	calculateLoadMoreThreshold = CollectionLayoutCalculators.calculateLoadMoreThreshold
}
