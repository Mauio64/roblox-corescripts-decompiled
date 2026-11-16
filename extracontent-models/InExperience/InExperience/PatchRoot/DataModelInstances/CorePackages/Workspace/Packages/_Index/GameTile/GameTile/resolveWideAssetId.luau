local GameTile = script:FindFirstAncestor("GameTile")

local getGameTileLayoutData = require(GameTile.getGameTileLayoutData)
local ItemLayoutDataParsingUtils = require(GameTile.ItemLayoutDataParsingUtils)

local function resolveWideAssetId(p: string?, p2, p3: string?)
	if p then
		return p
	end

	local gameTileLayoutData = getGameTileLayoutData(p2, p3)
	return ItemLayoutDataParsingUtils.getWideImageAssetId(gameTileLayoutData) or p2 and p2.primaryWideAssetId or nil
end

return resolveWideAssetId
