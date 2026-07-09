local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local GetCatalogCategoriesStore = require(Modules.AvatarExperience.Catalog.Stores.GetCatalogCategoriesStore)
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local React = require(CorePackages.Packages.React)

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local FFlagAXCatalogCategoriesStoreImprovePerf = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXCatalogCategoriesStoreImprovePerf

local function useCatalogCategoryImpressionsInfo(b1: boolean?, p1, p2, p3) -- line: 20
	-- upvalues: FFlagAXCatalogCategoriesStoreImprovePerf (copy), GetCatalogCategoriesStore (copy), useSignalState (copy), React (copy)
	local u12, u13, u14

	if FFlagAXCatalogCategoriesStoreImprovePerf then
		u12 = if not p1 then nil else p1.Name
		u13 = if not p2 then nil else p2.Name
		u14 = if not p3 then nil else p3.TaxonomyUuid
	else
		local v15 = GetCatalogCategoriesStore.getCatalogSelectionStore()
		local v16 = useSignalState(v15.selectedCategory)
		local v17 = useSignalState(v15.selectedSubcategory)
		local v18 = useSignalState(v15.selectedCategoryInfo)
		local v19 = GetCatalogCategoriesStore.getCatalogSearchSelectionStore()
		local v20 = useSignalState(v19.selectedCategory)
		local v21 = useSignalState(v19.selectedSubcategory)
		local v22 = useSignalState(v19.selectedCategoryInfo)

		if b1 then
			u12 = if not v20 then nil else v20.Name
			u13 = if not v21 then nil else v21.Name
			u14 = if not v22 then nil else v22.TaxonomyUuid
		else
			u12 = if not v16 then nil else v16.Name
			u13 = if not v17 then nil else v17.Name
			u14 = if not v18 then nil else v18.TaxonomyUuid
		end
	end

	return React.useMemo(function() -- line: 60
		-- upvalues: u12 (ref), u13 (ref), u14 (ref)
		return {
			impressionsCategory = u12,
			impressionsSubcategory = u13,
			impressionsTaxonomyId = u14
		}
	end, {
		u12,
		u13,
		u14
	})
end

return useCatalogCategoryImpressionsInfo
