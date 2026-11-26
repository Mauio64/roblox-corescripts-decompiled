require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/GameTileTypes")

local v5 = {}

local function getGameTileLayoutData(p2, p3)
	if p2 and p2.layoutDataBySort and p3 and p3 ~= "" and p2.layoutDataBySort[p3] then
		return p2.layoutDataBySort[p3]
	end

	if p2 and p2.defaultLayoutData then
		return p2.defaultLayoutData
	end

	return v5
end

return getGameTileLayoutData
