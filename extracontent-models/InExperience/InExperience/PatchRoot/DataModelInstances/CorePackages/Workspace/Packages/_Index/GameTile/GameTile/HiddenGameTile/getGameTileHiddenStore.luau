local GameTile = script:FindFirstAncestor("GameTile")
local createGameTileHiddenStore = require(GameTile.HiddenGameTile.createGameTileHiddenStore)

local v = {}

local function getGameTileHiddenStore(p: string)
	local gameTileHiddenStore = v[p]

	if gameTileHiddenStore == nil then
		v[p] = createGameTileHiddenStore()
		gameTileHiddenStore = v[p]
	end

	return gameTileHiddenStore
end

return getGameTileHiddenStore
