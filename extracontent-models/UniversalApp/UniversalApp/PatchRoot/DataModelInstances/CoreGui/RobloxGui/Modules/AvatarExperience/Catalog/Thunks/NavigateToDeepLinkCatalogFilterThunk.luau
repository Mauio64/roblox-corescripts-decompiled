local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local FFlagAXCatalogCategoriesSDUILinks = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXCatalogCategoriesSDUILinks
local NavigatedToDeepLinkCatalogFilter = require(Modules.AvatarExperience.Catalog.Actions.NavigatedToDeepLinkCatalogFilter)
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local GetCatalogCategoriesStore = require(Modules.AvatarExperience.Catalog.Stores.GetCatalogCategoriesStore)
local GetCatalogCategoriesFromStore = require(Modules.AvatarExperience.Catalog.GetCatalogCategoriesFromStore)

return function(p1) -- line: 14
	-- upvalues: NavigatedToDeepLinkCatalogFilter (copy), FFlagAXCatalogCategoriesSDUILinks (copy), GetCatalogCategoriesStore (copy), GetCatalogCategoriesFromStore (copy), CatalogUtils (copy)
	return function(p2) -- line: 15
		-- upvalues: NavigatedToDeepLinkCatalogFilter (copy), p1 (copy), FFlagAXCatalogCategoriesSDUILinks (copy), GetCatalogCategoriesStore (copy), GetCatalogCategoriesFromStore (copy), CatalogUtils (copy)
		p2:dispatch(NavigatedToDeepLinkCatalogFilter(p1))

		if FFlagAXCatalogCategoriesSDUILinks and not GetCatalogCategoriesStore.getCatalogCategoriesStore().getHasFetchedCategories(false) then
			return
		end

		local v10 = GetCatalogCategoriesStore.getCatalogSelectionStore()
		local taxonomy = p1.taxonomy

		if taxonomy then
			local v12 = GetCatalogCategoriesFromStore()
			local v13, v14 = CatalogUtils.findCategoryIdsByTaxonomy(taxonomy, v12)

			if v13 then
				v10.changeCategory(v13, v14)
			end

			return
		end

		local v16

		if p1.category then
			local v15 = GetCatalogCategoriesFromStore()

			v16 = CatalogUtils.findCategoryByCategoryId(p1.category, v15)
		else
			local v17 = v10.selectedCategoryId(false)

			v16 = CatalogUtils.getCategoryId(v17)
		end

		if v16 == nil then
			return
		end

		local Id = v16.Id
		local Id2 = nil

		if p1.subcategory and v16 and v16.Subcategories then
			local v20 = CatalogUtils.findSubcategoryBySubcategoryId(p1.subcategory, v16.Subcategories)

			if v20 then
				Id2 = v20.Id
			end
		end

		v10.changeCategory(Id, Id2)
	end
end
