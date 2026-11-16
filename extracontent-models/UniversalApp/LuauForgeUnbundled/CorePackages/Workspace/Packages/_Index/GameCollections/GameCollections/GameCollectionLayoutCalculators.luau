local CollectionViews = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/CollectionViews")
local gameTileViewConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/GameTile").GameTileViewConfig
local collectionLayoutCalculators = CollectionViews.CollectionLayoutCalculators
require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/Style")

return {
	calculateNumColumns = collectionLayoutCalculators.calculateNumColumns,
	calculateTileHeightFromWidth = function(p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12)
		return gameTileViewConfig.getTileHeight(p5, p2, p4, p6, p7, p8, p9, p10, p11, p12)
	end,
	calculateSideMargin = collectionLayoutCalculators.calculateSideMargin,
	calculateColumnGap = collectionLayoutCalculators.calculateColumnGap,
	calculateVerticalPadding = collectionLayoutCalculators.calculateVerticalPadding,
	calculateFractionalItemAmount = collectionLayoutCalculators.calculateFractionalItemAmount,
	calculateMaxTilesToShow = collectionLayoutCalculators.calculateMaxTilesToShow,
	calculateLoadMoreThreshold = collectionLayoutCalculators.calculateLoadMoreThreshold
}
