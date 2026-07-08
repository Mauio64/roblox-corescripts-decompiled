local GameTile = script:FindFirstAncestor("GameTile")
local GameTileLayoutType = require(GameTile.GameTileTypes).GameTileLayoutType
local GameTileParent = GameTile.Parent
local CollectionItemSize = require(GameTileParent.CollectionViews).CollectionViewTypes.CollectionItemSize

local function getGameTileCollectionItemSize(p1) -- line: 12
	-- upvalues: GameTileLayoutType (copy), CollectionItemSize (copy)
	if p1 == GameTileLayoutType.Narrow then
		return CollectionItemSize.Small
	end

	if p1 == GameTileLayoutType.Wide then
		return CollectionItemSize.Medium
	end

	if p1 == GameTileLayoutType.Event then
		return CollectionItemSize.Large
	end

	return CollectionItemSize.Small
end

return getGameTileCollectionItemSize
