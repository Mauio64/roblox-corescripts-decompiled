local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/dPG")
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local React = require(CorePackages.Packages.React)
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local fFlagAXCatalogCategoriesStoreImprovePerf = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXCatalogCategoriesStoreImprovePerf

local function useCatalogCategoryImpressionsInfo(p2, p3, p4, p5)
	local name, name2, taxonomyUuid

	if fFlagAXCatalogCategoriesStoreImprovePerf then
		name = if p3 then p3.Name else nil
		name2 = if p4 then p4.Name else nil
		taxonomyUuid = if p5 then p5.TaxonomyUuid else nil
	else
		local catalogSelectionStore = module.getCatalogSelectionStore()
		local v5 = useSignalState(catalogSelectionStore.selectedCategory)
		local v6 = useSignalState(catalogSelectionStore.selectedSubcategory)
		local v7 = useSignalState(catalogSelectionStore.selectedCategoryInfo)

		local catalogSearchSelectionStore = module.getCatalogSearchSelectionStore()
		local v8 = useSignalState(catalogSearchSelectionStore.selectedCategory)
		local v9 = useSignalState(catalogSearchSelectionStore.selectedSubcategory)
		local v10 = useSignalState(catalogSearchSelectionStore.selectedCategoryInfo)

		if p2 then
			name = if v8 then v8.Name else nil

			name2 = if v9 then v9.Name else nil

			taxonomyUuid = if v10 then v10.TaxonomyUuid else nil
		else
			name = if v5 then v5.Name else nil
			name2 = if v6 then v6.Name else nil

			taxonomyUuid = if v7 then v7.TaxonomyUuid else nil
		end
	end

	return React.useMemo(function()
		return {
			impressionsCategory = name,
			impressionsSubcategory = name2,
			impressionsTaxonomyId = taxonomyUuid
		}
	end, { name, name2, taxonomyUuid })
end

return useCatalogCategoryImpressionsInfo
