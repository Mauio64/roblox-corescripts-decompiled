local GameTile = script:FindFirstAncestor("GameTile")

require(GameTile.GameTileTypes)

local v = {}

local function getGameTileLayoutData(p, p2: string?)
	if p and p.layoutDataBySort and p2 and p2 ~= "" and p.layoutDataBySort[p2] then
		return p.layoutDataBySort[p2]
	end

	return if p and p.defaultLayoutData then p.defaultLayoutData else v
end

return getGameTileLayoutData
