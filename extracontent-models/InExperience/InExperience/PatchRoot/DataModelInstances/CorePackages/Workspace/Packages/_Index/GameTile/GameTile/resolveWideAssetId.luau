local GameTile = script:FindFirstAncestor("GameTile")
local getGameTileLayoutData = require(GameTile.getGameTileLayoutData)
local ItemLayoutDataParsingUtils = require(GameTile.ItemLayoutDataParsingUtils)

local function resolveWideAssetId(s1: string?, t1: {[any]: any}?, s2: string?) -- line: 20
	-- upvalues: getGameTileLayoutData (copy), ItemLayoutDataParsingUtils (copy)
	if s1 then
		return s1
	end

	local v8 = getGameTileLayoutData(t1, s2)

	return ItemLayoutDataParsingUtils.getWideImageAssetId(v8) or (t1 and t1.primaryWideAssetId or nil)
end

return resolveWideAssetId
