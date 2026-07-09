local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local CatalogCategories = AvatarExperienceCommon.Enums.CatalogCategories
local CatalogSubcategories = AvatarExperienceCommon.Enums.CatalogSubcategories
local GetCatalogCategoriesStore = require(Modules.AvatarExperience.Catalog.Stores.GetCatalogCategoriesStore)
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local FFlagAXTallTilesForMakeupLooks = AvatarExperienceFlags.FFlagAXTallTilesForMakeupLooks

function useTallTileV2(b1: boolean?, _: string) -- line: 15
	-- upvalues: GetCatalogCategoriesStore (copy), useSignalState (copy), CatalogCategories (copy), CatalogSubcategories (copy), FFlagAXTallTilesForMakeupLooks (copy)
	local v12 = GetCatalogCategoriesStore.getCatalogSelectionStore()
	local v13 = GetCatalogCategoriesStore.getCatalogSearchSelectionStore()
	local v14 = useSignalState(v12.selectedCategoryId)
	local v15 = useSignalState(v12.selectedSubcategoryId)
	local v16 = useSignalState(v13.selectedCategoryId)
	local v17 = useSignalState(v13.selectedSubcategoryId)
	local v18 = if not b1 then v14 else v16
	local v19 = if not b1 then v15 else v17

	return v18 == CatalogCategories.AllAnimations:rawValue() or (v18 == CatalogCategories.Characters:rawValue() or (v18 == CatalogCategories.Avatars:rawValue() or (v19 == CatalogSubcategories.FullBodies:rawValue() or FFlagAXTallTilesForMakeupLooks and v19 == CatalogSubcategories.MakeupLooks:rawValue())))
end

return useTallTileV2
