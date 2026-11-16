local getGameTileLayoutData = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/getGameTileLayoutData")
local ItemLayoutDataParsingUtils = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/ItemLayoutDataParsingUtils")

local function resolveWideAssetId(p2, p3, p4)
	if p2 then
		return p2
	end

	local v5 = getGameTileLayoutData(p3, p4)
	return ItemLayoutDataParsingUtils.getWideImageAssetId(v5) or p3 and p3.primaryWideAssetId or nil
end

return resolveWideAssetId
