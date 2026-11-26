local gameTileLayoutType = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/GameTileTypes").GameTileLayoutType

local collectionItemSize = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/CollectionViews").CollectionViewTypes.CollectionItemSize

local function getGameTileCollectionItemSize(p2)
	if p2 == gameTileLayoutType.Narrow then
		return collectionItemSize.Small
	end

	if p2 == gameTileLayoutType.Wide then
		return collectionItemSize.Medium
	end

	if p2 == gameTileLayoutType.Event then
		return collectionItemSize.Large
	end

	return collectionItemSize.Small
end

return getGameTileCollectionItemSize
