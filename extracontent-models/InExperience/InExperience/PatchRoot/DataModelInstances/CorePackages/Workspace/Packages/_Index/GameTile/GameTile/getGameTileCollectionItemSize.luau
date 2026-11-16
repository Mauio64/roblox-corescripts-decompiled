local GameTile = script:FindFirstAncestor("GameTile")
local GameTileTypes = require(GameTile.GameTileTypes)
local GameTileLayoutType = GameTileTypes.GameTileLayoutType

local parent = GameTile.Parent
local CollectionViews = require(parent.CollectionViews)
local CollectionItemSize = CollectionViews.CollectionViewTypes.CollectionItemSize

local function getGameTileCollectionItemSize(p)
	if p == GameTileLayoutType.Narrow then
		return CollectionItemSize.Small
	end

	if p == GameTileLayoutType.Wide then
		return CollectionItemSize.Medium
	end

	if p == GameTileLayoutType.Event then
		return CollectionItemSize.Large
	end

	return CollectionItemSize.Small
end

return getGameTileCollectionItemSize
