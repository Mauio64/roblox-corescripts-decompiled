local GameTile = script:FindFirstAncestor("GameTile")

require(GameTile.GameTileTypes)

local t1 = {}

local function getGameTileLayoutData(t2: {[any]: any}?, s1: string?) -- line: 17
	-- upvalues: t1 (copy)
	if t2 and (t2.layoutDataBySort and s1 and s1 ~= "" and t2.layoutDataBySort[s1]) then
		return t2.layoutDataBySort[s1]
	end

	if t2 and t2.defaultLayoutData then
		return t2.defaultLayoutData
	end

	return t1
end

return getGameTileLayoutData
