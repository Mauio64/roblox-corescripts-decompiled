local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
require("@luauforge/bundled/dHL")

local module = require("@luauforge/bundled/dMn")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local module3 = require("@luauforge/bundled/dPF")
local fFlagAXCatalogCategoriesSDUILinks = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUILinks
local fFlagAXMigrateAllTabToSduiDev = AvatarExperienceFlags.FFlagAXMigrateAllTabToSduiDev

local module4 = require("@luauforge/bundled/dRQ")
local module5 = require("@luauforge/bundled/dPG")

local module6 = require("@luauforge/bundled/dMx")
local fFlagAXFixPrefetchMarketplaceStartupCrash = AvatarExperienceFlags.FFlagAXFixPrefetchMarketplaceStartupCrash

local v5 = { categoryId = module6.DefaultCatalogCategoryId, subcategoryId = nil }

return Rodux.createReducer(v5, {
	[module.name] = function(p2, data)
		if fFlagAXCatalogCategoriesSDUILinks or fFlagAXMigrateAllTabToSduiDev then
			local catalogCategoriesStore = module5.getCatalogCategoriesStore()

			if not catalogCategoriesStore.getHasFetchedCategories(false) then
				if catalogCategoriesStore.setPendingDeepLinkAction then
					catalogCategoriesStore.setPendingDeepLinkAction(data)
				end

				return p2
			end
		end

		local catalogSelectionStore = module5.getCatalogSelectionStore()

		local taxonomy = data.taxonomy

		if taxonomy then
			local v7 = module3()

			local categoryIdsByTaxonomy, v8 = module4.findCategoryIdsByTaxonomy(taxonomy, v7)

			if categoryIdsByTaxonomy and not fFlagAXFixPrefetchMarketplaceStartupCrash then
				catalogSelectionStore.changeCategory(categoryIdsByTaxonomy, v8)
			end

			return p2
		else
			local v7

			if data.category then
				local v8 = module3()

				v7 = module4.findCategoryByCategoryId(data.category, v8)
			else
				local selectedCategoryId = catalogSelectionStore.selectedCategoryId(false)
				v7 = module4.getCategoryId(selectedCategoryId)
			end

			if v7 == nil then
				return p2
			end

			local id = v7.Id
			local id2 = nil

			if data.subcategory and v7 and v7.Subcategories then
				local subcategoryBySubcategoryId = module4.findSubcategoryBySubcategoryId(
					data.subcategory,
					v7.Subcategories
				)

				if subcategoryBySubcategoryId then
					id2 = subcategoryBySubcategoryId.Id
				end
			end

			if not fFlagAXFixPrefetchMarketplaceStartupCrash then
				catalogSelectionStore.changeCategory(id, id2)
			end

			return p2
		end
	end
})
