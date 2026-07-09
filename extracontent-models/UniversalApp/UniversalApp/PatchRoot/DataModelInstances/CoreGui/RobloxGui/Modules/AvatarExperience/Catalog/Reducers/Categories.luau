local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)

require(CorePackages.Workspace.Packages.AvatarExperienceRodux)

local NavigatedToDeepLinkCatalogFilter = require(Modules.AvatarExperience.Catalog.Actions.NavigatedToDeepLinkCatalogFilter)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local GetCatalogCategoriesFromStore = require(Modules.AvatarExperience.Catalog.GetCatalogCategoriesFromStore)
local FFlagAXCatalogCategoriesSDUILinks = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUILinks
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local GetCatalogCategoriesStore = require(Modules.AvatarExperience.Catalog.Stores.GetCatalogCategoriesStore)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local FFlagAXFixPrefetchMarketplaceStartupCrash = AvatarExperienceFlags.FFlagAXFixPrefetchMarketplaceStartupCrash
local t1 = {
	subcategoryId = nil,
	categoryId = Constants.DefaultCatalogCategoryId
}

return Rodux.createReducer(t1, {
	[NavigatedToDeepLinkCatalogFilter.name] = function(p1, p2) -- line: 40
		-- upvalues: FFlagAXCatalogCategoriesSDUILinks (copy), GetCatalogCategoriesStore (copy), GetCatalogCategoriesFromStore (copy), CatalogUtils (copy), FFlagAXFixPrefetchMarketplaceStartupCrash (copy)
		if FFlagAXCatalogCategoriesSDUILinks then
			local v16 = GetCatalogCategoriesStore.getCatalogCategoriesStore()

			if not v16.getHasFetchedCategories(false) then
				if v16.setPendingDeepLinkAction then
					v16.setPendingDeepLinkAction(p2)
				end

				return p1
			end
		end

		local v17 = GetCatalogCategoriesStore.getCatalogSelectionStore()
		local taxonomy = p2.taxonomy

		if taxonomy then
			local v19 = GetCatalogCategoriesFromStore()
			local v20, v21 = CatalogUtils.findCategoryIdsByTaxonomy(taxonomy, v19)

			if v20 and not FFlagAXFixPrefetchMarketplaceStartupCrash then
				v17.changeCategory(v20, v21)
			end

			return p1
		end

		local v23

		if p2.category then
			local v22 = GetCatalogCategoriesFromStore()

			v23 = CatalogUtils.findCategoryByCategoryId(p2.category, v22)
		else
			local v24 = v17.selectedCategoryId(false)

			v23 = CatalogUtils.getCategoryId(v24)
		end

		if v23 == nil then
			return p1
		end

		local Id = v23.Id
		local Id2 = nil

		if p2.subcategory and v23 and v23.Subcategories then
			local v27 = CatalogUtils.findSubcategoryBySubcategoryId(p2.subcategory, v23.Subcategories)

			if v27 then
				Id2 = v27.Id
			end
		end

		if not FFlagAXFixPrefetchMarketplaceStartupCrash then
			v17.changeCategory(Id, Id2)
		end

		return p1
	end
})
