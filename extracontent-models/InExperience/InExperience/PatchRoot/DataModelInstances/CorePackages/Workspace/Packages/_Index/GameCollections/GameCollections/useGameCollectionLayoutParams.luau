local GameCollections = script:FindFirstAncestor("GameCollections")
local parent = GameCollections.Parent

require(parent.Style)
local CollectionViews = require(parent.CollectionViews)
local GameCollectionLayoutCalculators = require(GameCollections.GameCollectionLayoutCalculators)
local CollectionItemSize = CollectionViews.CollectionViewTypes.CollectionItemSize
local useCollectionLayoutParams = CollectionViews.useCollectionLayoutParams
local GameTile = require(parent.GameTile)
local GameTileLayoutType = GameTile.GameTileTypes.GameTileLayoutType

local v = {
	[GameTileLayoutType.Event] = CollectionItemSize.Large,
	[GameTileLayoutType.Wide] = CollectionItemSize.Medium,
	[GameTileLayoutType.Narrow] = CollectionItemSize.Small
}

local function useGameCollectionLayoutParams(p, p2, flag: boolean?, p3, vector2: Vector2?)
	return useCollectionLayoutParams(
		v[p] or CollectionItemSize.Small,
		p2,
		flag,
		p3,
		GameCollectionLayoutCalculators,
		vector2
	)
end

return useGameCollectionLayoutParams
