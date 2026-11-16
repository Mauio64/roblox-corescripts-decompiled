local createGameTileHiddenStore = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/HiddenGameTile/createGameTileHiddenStore")

local v5 = {}

local function getGameTileHiddenStore(p2)
	local gameTileHiddenStore = v5[p2]

	if gameTileHiddenStore == nil then
		v5[p2] = createGameTileHiddenStore()
		gameTileHiddenStore = v5[p2]
	end

	return gameTileHiddenStore
end

return getGameTileHiddenStore
