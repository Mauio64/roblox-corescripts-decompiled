local parent = script:FindFirstAncestor("GameCollections").Parent

local CollectionViews = require(parent.CollectionViews)
local GameTile = require(parent.GameTile)
local GameTileViewConfig = GameTile.GameTileViewConfig
local CollectionLayoutCalculators = CollectionViews.CollectionLayoutCalculators
require(parent.Style)

return {
	calculateNumColumns = CollectionLayoutCalculators.calculateNumColumns,
	calculateTileHeightFromWidth = function(p: number, _: boolean?, p2, p3, flag: boolean?, flag2: boolean?, flag3: boolean?, p4: number?, p5: number?, p6: number?, p7: number?)
		return GameTileViewConfig.getTileHeight(p3, p, p2, flag, flag2, flag3, p4, p5, p6, p7)
	end,
	calculateSideMargin = CollectionLayoutCalculators.calculateSideMargin,
	calculateColumnGap = CollectionLayoutCalculators.calculateColumnGap,
	calculateVerticalPadding = CollectionLayoutCalculators.calculateVerticalPadding,
	calculateFractionalItemAmount = CollectionLayoutCalculators.calculateFractionalItemAmount,
	calculateMaxTilesToShow = CollectionLayoutCalculators.calculateMaxTilesToShow,
	calculateLoadMoreThreshold = CollectionLayoutCalculators.calculateLoadMoreThreshold
}
