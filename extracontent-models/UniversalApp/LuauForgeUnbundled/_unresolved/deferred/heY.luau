local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch

local module = require("@luauforge/bundled/fCI")
local module2 = require("@luauforge/bundled/dPN")
local module3 = require("@luauforge/bundled/dAB")
local module4 = require("@luauforge/bundled/fCe")
require("@luauforge/bundled/dKT")

return function(p2)
	local renderOutfitItemTiles = module4.getAvatarEditorCategoryInfoFromState(p2).RenderOutfitItemTiles == true
	local assetTypeKey = module.selectAssetTypeKey(p2)

	local v5 = module3.Failed

	if not assetTypeKey then
		return v5
	end

	if renderOutfitItemTiles then
		return (performFetch.GetStatus(p2, module2.OutfitsKey .. assetTypeKey))
	end

	v5 = performFetch.GetStatus(p2, module2.UserInventoryKey .. assetTypeKey)

	return v5
end
