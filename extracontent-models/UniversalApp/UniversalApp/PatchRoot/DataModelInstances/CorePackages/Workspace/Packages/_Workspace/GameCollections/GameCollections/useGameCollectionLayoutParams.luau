local GameCollections = script:FindFirstAncestor("GameCollections")
local GameCollectionsParent = GameCollections.Parent

require(GameCollectionsParent.Style)

local CollectionViews = require(GameCollectionsParent.CollectionViews)
local GameCollectionLayoutCalculators = require(GameCollections.GameCollectionLayoutCalculators)
local CollectionItemSize = CollectionViews.CollectionViewTypes.CollectionItemSize
local useCollectionLayoutParams = CollectionViews.useCollectionLayoutParams
local GameTileLayoutType = require(GameCollectionsParent.GameTile).GameTileTypes.GameTileLayoutType
local t1 = {
	[GameTileLayoutType.Event] = CollectionItemSize.Large,
	[GameTileLayoutType.Wide] = CollectionItemSize.Medium,
	[GameTileLayoutType.Narrow] = CollectionItemSize.Small
}

local function useGameCollectionLayoutParams(p1, p2, b1: boolean?, t2: {[any]: any}?, vector2: Vector2?) -- line: 29
	-- upvalues: t1 (copy), CollectionItemSize (copy), useCollectionLayoutParams (copy), GameCollectionLayoutCalculators (copy)
	local v15 = t1[p1] or CollectionItemSize.Small

	return useCollectionLayoutParams(v15, p2, b1, t2, GameCollectionLayoutCalculators, vector2)
end

return useGameCollectionLayoutParams
