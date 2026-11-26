require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/Style")
local CollectionViews = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/CollectionViews")
local GameCollectionLayoutCalculators = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/GameCollections/GameCollectionLayoutCalculators")
local collectionItemSize = CollectionViews.CollectionViewTypes.CollectionItemSize
local useCollectionLayoutParams = CollectionViews.useCollectionLayoutParams
local gameTileLayoutType = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/GameTile").GameTileTypes.GameTileLayoutType

local v5 = {
	[gameTileLayoutType.Event] = collectionItemSize.Large,
	[gameTileLayoutType.Wide] = collectionItemSize.Medium,
	[gameTileLayoutType.Narrow] = collectionItemSize.Small
}

local function useGameCollectionLayoutParams(p2, p3, p4, p5, p6)
	return useCollectionLayoutParams(v5[p2] or collectionItemSize.Small, p3, p4, p5, GameCollectionLayoutCalculators, p6)
end

return useGameCollectionLayoutParams
