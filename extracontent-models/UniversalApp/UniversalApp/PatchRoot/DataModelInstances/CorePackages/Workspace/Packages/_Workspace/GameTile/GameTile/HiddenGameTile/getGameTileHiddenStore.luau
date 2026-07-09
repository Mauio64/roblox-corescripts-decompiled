local GameTile = script:FindFirstAncestor("GameTile")
local createGameTileHiddenStore = require(GameTile.HiddenGameTile.createGameTileHiddenStore)
local t1 = {}

local function getGameTileHiddenStore(s1: string) -- line: 8
	-- upvalues: t1 (copy), createGameTileHiddenStore (copy)
	local v6 = t1[s1]

	if v6 == nil then
		t1[s1] = createGameTileHiddenStore()
		v6 = t1[s1]
	end

	return v6
end

return getGameTileHiddenStore
