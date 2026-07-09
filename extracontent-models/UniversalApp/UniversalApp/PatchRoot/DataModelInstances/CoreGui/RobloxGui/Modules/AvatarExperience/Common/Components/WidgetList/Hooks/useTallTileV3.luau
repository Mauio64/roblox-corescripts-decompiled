local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local GetCatalogCategoriesStore = require(Modules.AvatarExperience.Catalog.Stores.GetCatalogCategoriesStore)
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local v5 = game:DefineFastFlag("AXFixTallTilesForSubcategories", false)

function useTallTileV3(b1: boolean?) -- line: 11
	-- upvalues: GetCatalogCategoriesStore (copy), v5 (copy), useSignalState (copy)
	local v7 = GetCatalogCategoriesStore.getCatalogSelectionStore()
	local v8 = GetCatalogCategoriesStore.getCatalogSearchSelectionStore()

	if v5 then
		local v9 = useSignalState(v7.selectedCategoryInfo)
		local v10 = useSignalState(v8.selectedCategoryInfo)

		return ((if not b1 then v9 else v10)).TileType == "Tall"
	end

	local v11 = useSignalState(v7.selectedCategory)
	local v12 = useSignalState(v8.selectedCategory)

	return ((if not b1 then v11 else v12)).TileType == "Tall"
end

return useTallTileV3
