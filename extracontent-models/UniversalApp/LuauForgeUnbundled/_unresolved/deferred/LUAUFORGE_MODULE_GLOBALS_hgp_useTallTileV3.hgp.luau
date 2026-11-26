local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/dSW")
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local defineFastFlag = game:DefineFastFlag("AXFixTallTilesForSubcategories", false)

function LUAUFORGE_MODULE_GLOBALS_hgp_useTallTileV3(p2): boolean
	local catalogSelectionStore = module.getCatalogSelectionStore()
	local catalogSearchSelectionStore = module.getCatalogSearchSelectionStore()

	if defineFastFlag then
		local v5 = useSignalState(catalogSelectionStore.selectedCategoryInfo)
		local v6 = useSignalState(catalogSearchSelectionStore.selectedCategoryInfo)

		if p2 then
			v5 = v6
		end

		return v5.TileType == "Tall"
	else
		local v5 = useSignalState(catalogSelectionStore.selectedCategory)
		local v6 = useSignalState(catalogSearchSelectionStore.selectedCategory)

		if p2 then
			v5 = v6
		end

		return v5.TileType == "Tall"
	end
end

return LUAUFORGE_MODULE_GLOBALS_hgp_useTallTileV3
